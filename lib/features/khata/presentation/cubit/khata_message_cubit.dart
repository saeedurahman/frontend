import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/message_template.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/statement_period.dart';
import 'package:frantend/features/khata/domain/text/reminder_text.dart';
import 'package:frantend/features/khata/domain/whatsapp_link.dart';

enum MessageKind { reminder, statement }

/// What the message is about.
class MessageRequest {
  const MessageRequest({
    required this.partyType,
    required this.partyId,
    required this.name,
    this.phone,
    this.kind = MessageKind.reminder,
    this.branchId,
    this.from,
    this.to,
    this.detail = StatementDetail.summary,
    this.knownDue,
    this.withLink = true,
  });

  final PartyType partyType;
  final String partyId;
  final String name;
  final String? phone;
  final MessageKind kind;
  final String? branchId;

  /// The statement period (a statement message and its link).
  final DateTime? from;
  final DateTime? to;
  final StatementDetail detail;

  /// The amount shown on the screen that opened this, used when nothing
  /// fuller can be loaded.
  final Decimal? knownDue;

  /// A statement message starts with its link added (when it can be made).
  final bool withLink;
}

enum MessageStage { loading, unavailable, editing, confirming, done }

class MessageState {
  const MessageState({
    this.stage = MessageStage.loading,
    this.text = '',
    this.edited = false,
    this.phone = '',
    this.phoneNeeded = false,
    this.phoneProblem,
    this.includeLink = false,
    this.link,
    this.linkBusy = false,
    this.notice,
    this.error,
    this.offline = false,
    this.busy = false,
    this.logged = false,
    this.revision = 0,
  });

  final MessageStage stage;
  final String text;

  /// The user changed the text: it is no longer rewritten for them.
  final bool edited;
  final String phone;

  /// No usable number is saved for this party.
  final bool phoneNeeded;
  final String? phoneProblem;
  final bool includeLink;
  final StatementLink? link;
  final bool linkBusy;

  /// Good-to-know (a long message was copied, the number wasn't saved).
  final String? notice;
  final String? error;

  /// The figures come from the copy on this device.
  final bool offline;
  final bool busy;

  /// The reminder was written down.
  final bool logged;

  /// Grows when [text] is rewritten by the app, so the field takes it.
  final int revision;

  MessageState copyWith({
    MessageStage? stage,
    String? text,
    bool? edited,
    String? phone,
    bool? phoneNeeded,
    String? phoneProblem,
    bool clearPhoneProblem = false,
    bool? includeLink,
    StatementLink? link,
    bool? linkBusy,
    String? notice,
    bool clearNotice = false,
    String? error,
    bool clearError = false,
    bool? offline,
    bool? busy,
    bool? logged,
    bool rewritten = false,
  }) =>
      MessageState(
        stage: stage ?? this.stage,
        text: text ?? this.text,
        edited: edited ?? this.edited,
        phone: phone ?? this.phone,
        phoneNeeded: phoneNeeded ?? this.phoneNeeded,
        phoneProblem:
            clearPhoneProblem ? null : phoneProblem ?? this.phoneProblem,
        includeLink: includeLink ?? this.includeLink,
        link: link ?? this.link,
        linkBusy: linkBusy ?? this.linkBusy,
        notice: clearNotice ? null : notice ?? this.notice,
        error: clearError ? null : error ?? this.error,
        offline: offline ?? this.offline,
        busy: busy ?? this.busy,
        logged: logged ?? this.logged,
        revision: rewritten ? revision + 1 : revision,
      );
}

class KhataMessageCubit extends Cubit<MessageState> {
  KhataMessageCubit({
    required KhataRepository repository,
    required UrlLauncherService launcher,
    required this.request,
    this.canLink = true,
    this.canLog = true,
  })  : _repository = repository,
        _launcher = launcher,
        super(const MessageState());

  final KhataRepository _repository;
  final UrlLauncherService _launcher;
  final MessageRequest request;

  /// The user may create statement links.
  final bool canLink;

  /// The user may write follow-ups.
  final bool canLog;

  KhataSettings _settings = const KhataSettings();
  MessageFacts? _facts;
  final String _linkKey = UuidUtils.v4();

  bool get isOnline => _repository.isOnline;

  String get _dialCode => WhatsAppLink.dialCodeFor(_settings.countryCode);

  String get _template {
    final reminder = request.kind == MessageKind.reminder;
    if (!request.partyType.isCustomer) {
      return reminder
          ? MessageTemplate.supplierReminder
          : MessageTemplate.supplierStatement;
    }
    return reminder
        ? _settings.reminderTemplate
        : _settings.statementTemplate;
  }

  String _compose(String? link) =>
      MessageTemplate.render(_template, _facts!.values(link: link ?? ''));

  Future<void> load() async {
    emit(const MessageState());
    _settings = await _repository.settings();
    final isStatement = request.kind == MessageKind.statement;
    var offline = false;
    final statement = await _repository.statement(
      request.partyType,
      request.partyId,
      from: request.from,
      to: request.to,
      detail: request.detail.name,
      branchId: request.branchId,
    );
    _facts = statement.fold((_) => null, (data) {
      offline = data.offline;
      return MessageFacts.fromStatement(data.value);
    });
    _facts ??= await _factsFromBills();
    if (isClosed) return;
    if (_facts == null) {
      emit(
        MessageState(
          stage: MessageStage.unavailable,
          error: statement.fold((f) => f.message, (_) => null),
        ),
      );
      return;
    }
    offline = offline || !isOnline;
    final phone = request.phone?.trim() ?? '';
    final wantsLink =
        isStatement && request.withLink && canLink && isOnline;
    emit(
      MessageState(
        stage: MessageStage.editing,
        text: _compose(null),
        phone: phone,
        phoneNeeded: WhatsAppLink.digits(phone, dialCode: _dialCode) == null,
        offline: offline,
        revision: 1,
      ),
    );
    if (wantsLink) await setIncludeLink(true);
  }

  /// When no statement is available: the pending bills kept on this device,
  /// or at least the amount the user is looking at.
  Future<MessageFacts?> _factsFromBills() async {
    final bills = await _repository.openItems(
      request.partyType,
      request.partyId,
      branchId: request.branchId,
    );
    final items = bills.fold((_) => null, (data) => data.value);
    final due = items == null
        ? request.knownDue
        : items.balanceOwed > Decimal.zero
            ? items.balanceOwed
            : -items.advance;
    if (due == null) return null;
    // A statement message needs figures only a statement has.
    if (request.kind == MessageKind.statement) return null;
    return MessageFacts(
      partyType: request.partyType,
      party: items?.name ?? request.name,
      business: _settings.businessName,
      due: due,
      bills: [
        for (final i in items?.items ?? const <OpenItem>[])
          (
            name: i.number ?? MessageFacts.documentLabel(i.documentType),
            date: i.date,
            remaining: i.remaining,
            ageDays: i.ageDays,
          ),
      ],
      payMethods: request.partyType.isCustomer
          ? _settings.paymentInstructions
          : const [],
      businessPhone: _settings.businessPhone,
    );
  }

  void editText(String text) {
    if (text == state.text) return;
    emit(state.copyWith(text: text, edited: true, clearError: true));
  }

  void editPhone(String phone) => emit(
        state.copyWith(phone: phone, clearPhoneProblem: true, clearError: true),
      );

  /// Back to the message as the template writes it.
  void resetText() => emit(
        state.copyWith(
          text: _compose(state.includeLink ? state.link?.url : null),
          edited: false,
          rewritten: true,
        ),
      );

  Future<void> setIncludeLink(bool include) async {
    if (state.stage != MessageStage.editing || state.linkBusy) return;
    if (!include) {
      final url = state.link?.url;
      emit(
        state.copyWith(
          includeLink: false,
          text: state.edited
              ? _withoutLinkLines(state.text, url)
              : _compose(null),
          rewritten: true,
          clearError: true,
        ),
      );
      return;
    }
    if (!canLink) return;
    var link = state.link;
    if (link == null) {
      emit(state.copyWith(includeLink: true, linkBusy: true, clearError: true));
      final made = await _repository.createLink(
        request.partyType,
        request.partyId,
        from: request.from,
        to: request.to,
        detail: request.detail.name,
        branchId: request.branchId,
        idempotencyKey: _linkKey,
      );
      if (isClosed) return;
      link = made.fold((failure) {
        emit(
          state.copyWith(
            includeLink: false,
            linkBusy: false,
            error: failure.message,
          ),
        );
        return null;
      }, (l) => l);
      if (link == null) return;
    }
    emit(
      state.copyWith(
        includeLink: true,
        linkBusy: false,
        link: link,
        text: state.edited
            ? _appendLink(state.text, link.url)
            : _withLink(link.url),
        rewritten: true,
      ),
    );
  }

  /// The template's own link line, or one added at the end when the saved
  /// template has no place for a link.
  String _withLink(String url) {
    final text = _compose(url);
    return text.contains(url) ? text : _appendLink(text, url);
  }

  static String _appendLink(String text, String url) => text.contains(url)
      ? text
      : '${text.trimRight()}\n\n${ReminderText.linkLinePrefix}$url';

  static String _withoutLinkLines(String text, String? url) => url == null
      ? text
      : text
          .split('\n')
          .where((line) => !line.contains(url))
          .join('\n')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n')
          .trim();

  /// Saves a typed number on the party. Offline it is only used once.
  Future<void> savePhone() async {
    final digits = WhatsAppLink.digits(state.phone, dialCode: _dialCode);
    if (digits == null) {
      emit(state.copyWith(phoneProblem: ReminderText.phoneInvalid));
      return;
    }
    if (!isOnline) {
      emit(state.copyWith(notice: ReminderText.phoneNotSaved));
      return;
    }
    emit(state.copyWith(busy: true, clearError: true));
    final saved = await _repository.updatePhone(
      request.partyType,
      request.partyId,
      '+$digits',
    );
    if (isClosed) return;
    saved.fold(
      (f) => emit(state.copyWith(busy: false, error: f.message)),
      (_) => emit(
        state.copyWith(
          busy: false,
          phone: '+$digits',
          phoneNeeded: false,
          clearNotice: true,
        ),
      ),
    );
  }

  Future<void> openWhatsApp() async {
    if (state.stage != MessageStage.editing || state.busy || state.linkBusy) {
      return;
    }
    final message = state.text.trim();
    if (message.isEmpty) {
      emit(state.copyWith(error: ReminderText.emptyMessage));
      return;
    }
    final digits = WhatsAppLink.digits(state.phone, dialCode: _dialCode);
    if (digits == null) {
      emit(
        state.copyWith(
          phoneNeeded: true,
          phoneProblem: state.phone.trim().isEmpty
              ? ReminderText.phoneMissing
              : ReminderText.phoneInvalid,
        ),
      );
      return;
    }
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    var url = WhatsAppLink.chat(digits, text: message);
    String? notice;
    if (!WhatsAppLink.fits(url)) {
      await Clipboard.setData(ClipboardData(text: message));
      url = WhatsAppLink.chat(digits);
      notice = ReminderText.tooLongCopied;
    }
    var opened = false;
    try {
      opened = await _launcher.launch(url, externalApplication: true);
    } catch (_) {
      opened = false;
    }
    if (isClosed) return;
    if (!opened) {
      emit(state.copyWith(busy: false, error: ReminderText.couldNotOpen));
      return;
    }
    emit(
      state.copyWith(
        busy: false,
        stage: MessageStage.confirming,
        notice: notice,
      ),
    );
  }

  Future<void> copyText() async {
    await Clipboard.setData(ClipboardData(text: state.text.trim()));
    if (!isClosed) emit(state.copyWith(notice: ReminderText.textCopied));
  }

  /// "No, go back".
  void notSent() => emit(
        state.copyWith(stage: MessageStage.editing, clearNotice: true),
      );

  /// "Yes, I sent it": writes the reminder down (offline too).
  Future<void> confirmSent() async {
    if (state.busy) return;
    if (!canLog) {
      emit(state.copyWith(stage: MessageStage.done, logged: false));
      return;
    }
    emit(state.copyWith(busy: true, clearError: true));
    final saved = await _repository.addFollowup(
      request.partyType,
      request.partyId,
      kind: FollowupKind.reminder,
      channel: 'whatsapp',
      message: state.text.trim(),
      branchId: request.branchId,
    );
    if (isClosed) return;
    saved.fold(
      (f) => emit(state.copyWith(busy: false, error: f.message)),
      (_) => emit(
        state.copyWith(busy: false, stage: MessageStage.done, logged: true),
      ),
    );
  }
}
