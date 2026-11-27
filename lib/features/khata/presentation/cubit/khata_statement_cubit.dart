import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/file_share_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart'
    show khataIsoDay;
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/retry_key.dart';
import 'package:frantend/features/khata/domain/statement_period.dart';
import 'package:frantend/features/khata/domain/text/statement_text.dart';

enum StatementAction { share, save, print, copyLink }

/// What to tell the user after an action.
class StatementNotice {
  const StatementNotice(this.message, {this.isError = false, this.savedPath});

  final String message;
  final bool isError;

  /// A saved file whose folder can be opened.
  final String? savedPath;
}

class StatementViewState {
  const StatementViewState({
    this.period = StatementPeriod.thisMonth,
    this.detail = StatementDetail.summary,
    this.customFrom,
    this.customTo,
    this.loading = true,
    this.data,
    this.failure,
    this.busy,
  });

  final StatementPeriod period;
  final StatementDetail detail;
  final DateTime? customFrom;
  final DateTime? customTo;
  final bool loading;

  /// The statement on screen. While another one loads, the old one stays.
  final KhataData<Statement>? data;
  final Failure? failure;
  final StatementAction? busy;

  StatementViewState copyWith({
    StatementPeriod? period,
    StatementDetail? detail,
    DateTime? customFrom,
    DateTime? customTo,
    bool? loading,
    KhataData<Statement>? data,
    bool clearData = false,
    Failure? failure,
    bool clearFailure = false,
    StatementAction? busy,
    bool clearBusy = false,
  }) =>
      StatementViewState(
        period: period ?? this.period,
        detail: detail ?? this.detail,
        customFrom: customFrom ?? this.customFrom,
        customTo: customTo ?? this.customTo,
        loading: loading ?? this.loading,
        data: clearData ? null : data ?? this.data,
        failure: clearFailure ? null : failure ?? this.failure,
        busy: clearBusy ? null : busy ?? this.busy,
      );
}

class KhataStatementCubit extends Cubit<StatementViewState> {
  KhataStatementCubit({
    required KhataRepository repository,
    required FileSaverService files,
    required PrinterService printer,
    required FileShareService share,
    required this.partyType,
    required this.partyId,
    String? branchId,
    DateTime Function() clock = DateTime.now,
  })  : _repository = repository,
        _files = files,
        _printer = printer,
        _share = share,
        _branchId = branchId,
        _clock = clock,
        super(const StatementViewState());

  final KhataRepository _repository;
  final FileSaverService _files;
  final PrinterService _printer;
  final FileShareService _share;
  final PartyType partyType;
  final String partyId;
  final DateTime Function() _clock;
  String? _branchId;

  int _read = 0;

  /// The PDF of the statement on screen, fetched once for save, share and
  /// print.
  ({String request, Uint8List bytes})? _pdf;
  final _linkKey = RetryKey();

  String? get branchId => _branchId;
  bool get isOnline => _repository.isOnline;
  bool get canShareFiles => _share.canShareFiles;

  ({DateTime? from, DateTime? to}) get range => state.period.range(
        _clock(),
        customFrom: state.customFrom,
        customTo: state.customTo,
      );

  String _requestId() {
    final r = range;
    return '${r.from == null ? '' : khataIsoDay(r.from!)}|'
        '${r.to == null ? '' : khataIsoDay(r.to!)}|'
        '${state.detail.name}|${_branchId ?? 'all'}';
  }

  /// Finds the branch on screen, then loads.
  Future<void> start([Future<String?> Function()? resolveBranch]) async {
    if (_branchId == null && resolveBranch != null) {
      _branchId = await resolveBranch();
    }
    if (!isClosed) await load();
  }

  Future<void> load() async {
    final read = ++_read;
    _pdf = null;
    emit(state.copyWith(loading: true, clearFailure: true));
    final r = range;
    final result = await _repository.statement(
      partyType,
      partyId,
      from: r.from,
      to: r.to,
      detail: state.detail.name,
      branchId: _branchId,
    );
    // A newer choice is already loading.
    if (isClosed || read != _read) return;
    result.fold(
      (failure) => emit(
        state.copyWith(loading: false, clearData: true, failure: failure),
      ),
      (data) => emit(state.copyWith(loading: false, data: data)),
    );
  }

  Future<void> setPeriod(
    StatementPeriod period, {
    DateTime? from,
    DateTime? to,
  }) {
    if (period == state.period && period != StatementPeriod.custom) {
      return Future.value();
    }
    emit(state.copyWith(period: period, customFrom: from, customTo: to));
    return load();
  }

  Future<void> setDetail(StatementDetail detail) {
    if (detail == state.detail) return Future.value();
    emit(state.copyWith(detail: detail));
    return load();
  }

  /// The way out of "too long".
  Future<void> showThisMonthSummary() {
    emit(
      state.copyWith(
        period: StatementPeriod.thisMonth,
        detail: StatementDetail.summary,
      ),
    );
    return load();
  }

  Future<void> onBranchChanged(String? branchId) {
    if (branchId == _branchId) return Future.value();
    _branchId = branchId;
    // Another branch's figures must not stay on screen.
    emit(state.copyWith(clearData: true));
    return load();
  }

  String get _fileName {
    final name = state.data?.value.partyName ?? '';
    final day = khataIsoDay(range.to ?? _clock());
    return 'Statement - ${name.isEmpty ? partyType.apiValue : name} - $day.pdf';
  }

  static String _words(Failure f) => switch (f.code) {
        'statement_too_large' =>
          '${StatementText.tooLongTitle}. ${StatementText.tooLongMessage}',
        'invalid_date_range' => StatementText.badDatesMessage,
        _ => f.message,
      };

  /// Runs one action at a time.
  Future<StatementNotice?> _run(
    StatementAction action,
    Future<StatementNotice?> Function() body,
  ) async {
    if (state.busy != null) return null;
    emit(state.copyWith(busy: action));
    try {
      return await body();
    } catch (_) {
      return const StatementNotice(StatementText.saveFailed, isError: true);
    } finally {
      if (!isClosed) emit(state.copyWith(clearBusy: true));
    }
  }

  Future<StatementNotice?> _withPdf(
    Future<StatementNotice?> Function(Uint8List bytes) use,
  ) async {
    final request = _requestId();
    var pdf = _pdf;
    if (pdf == null || pdf.request != request) {
      final r = range;
      final result = await _repository.statementPdf(
        partyType,
        partyId,
        from: r.from,
        to: r.to,
        detail: state.detail.name,
        branchId: _branchId,
      );
      final failure = result.fold((f) => f, (_) => null);
      if (failure != null) {
        return StatementNotice(_words(failure), isError: true);
      }
      pdf = (request: request, bytes: result.getOrElse(() => Uint8List(0)));
      // Not kept when the choice changed while it was coming.
      if (request == _requestId()) _pdf = pdf;
    }
    return use(pdf.bytes);
  }

  Future<StatementNotice?> savePdf() {
    final name = _fileName;
    return _run(
      StatementAction.save,
      () => _withPdf((bytes) async {
        final path = await _files.saveFileWithDialog(
          name,
          bytes,
          extensions: const ['pdf'],
        );
        // Cancelled.
        if (path == null) return null;
        return StatementNotice(StatementText.savedTo(path), savedPath: path);
      }),
    );
  }

  Future<StatementNotice?> sharePdf() {
    final name = _fileName;
    return _run(
      StatementAction.share,
      () => _withPdf((bytes) async {
        final result = await _share.share(name, bytes);
        final path = result.savedPath;
        if (path != null) {
          return StatementNotice(
            StatementText.savedToAttach(path),
            savedPath: path,
          );
        }
        return result.shared
            ? const StatementNotice(StatementText.sharedDone)
            : null;
      }),
    );
  }

  Future<StatementNotice?> printPdf() {
    final job = _fileName.replaceAll('.pdf', '');
    return _run(
      StatementAction.print,
      () => _withPdf((bytes) async {
        final printed = await _printer.printPdf(
          bytes,
          jobName: job,
          // A4, chosen in the system dialog: never the receipt roll.
          config: const PrinterConfig(paperSize: 'a4'),
          forceDialog: true,
        );
        return printed
            ? const StatementNotice(StatementText.sentToPrinter)
            : const StatementNotice(StatementText.notPrinted, isError: true);
      }),
    );
  }

  Future<StatementNotice?> copyLink() => _run(StatementAction.copyLink, () async {
        final r = range;
        final request = _requestId();
        final result = await _repository.createLink(
          partyType,
          partyId,
          from: r.from,
          to: r.to,
          detail: state.detail.name,
          branchId: _branchId,
          idempotencyKey: _linkKey.keyFor(request),
        );
        _linkKey.settle(result.fold((f) => f, (_) => null));
        final link = result.fold((_) => null, (l) => l);
        if (link == null) {
          return StatementNotice(
            result.fold(_words, (_) => ''),
            isError: true,
          );
        }
        await Clipboard.setData(ClipboardData(text: link.url));
        final until = link.expiresAt;
        return StatementNotice(
          until == null
              ? StatementText.linkCopied
              : StatementText.linkCopiedUntil(
                  KhataFormat.fullDay(until.toLocal()),
                ),
        );
      });

  Future<void> openFolder(String path) => _files.openFolder(path);
}
