import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/retry_key.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';

class OpeningBalanceState {
  const OpeningBalanceState({
    required this.draft,
    this.amountError,
    this.submitting = false,
  });

  final OpeningBalanceDraft draft;
  final String? amountError;
  final bool submitting;
}

/// The "Opening balance" section of a new customer or supplier form. When an
/// amount is typed, the party and its balance are created in one request.
class OpeningBalanceCubit extends Cubit<OpeningBalanceState> {
  OpeningBalanceCubit(
    this._repository, {
    required this.type,
    Future<String?> Function()? resolveBranch,
    DateTime Function() clock = DateTime.now,
  })  : _resolveBranch = resolveBranch ?? _activeBranch,
        super(
          OpeningBalanceState(
            draft: OpeningBalanceDraft.empty(type, clock()),
          ),
        );

  final KhataRepository? _repository;
  final PartyType type;
  final Future<String?> Function() _resolveBranch;
  final _key = RetryKey();

  static Future<String?> _activeBranch() async =>
      sl.isRegistered<ActiveBranchResolver>()
          ? sl<ActiveBranchResolver>().resolve()
          : null;

  /// False where the khata is not set up: the section is not shown.
  bool get available => _repository != null;

  bool get isFilled => state.draft.isFilled;

  void update(OpeningBalanceDraft draft) =>
      emit(OpeningBalanceState(draft: draft, submitting: state.submitting));

  /// Creates the party in [body] with the typed balance. Null when done,
  /// otherwise the sentence to show.
  Future<String?> create(Map<String, dynamic> body) async {
    final draft = state.draft;
    if (draft.amount == null) {
      emit(
        OpeningBalanceState(draft: draft, amountError: EntryText.amountInvalid),
      );
      return EntryText.amountInvalid;
    }
    final repository = _repository;
    if (repository == null || !repository.isOnline) {
      return EntryText.openingNeedsInternet;
    }
    if (state.submitting) return null;
    emit(OpeningBalanceState(draft: draft, submitting: true));
    final request = {
      ...body,
      'opening_balance': draft.toJson(branchId: await _resolveBranch()),
    };
    final result = await repository.createPartyWithOpening(
      type,
      request,
      idempotencyKey: _key.keyFor(request),
    );
    _key.settle(result.fold((f) => f, (_) => null));
    if (!isClosed) emit(OpeningBalanceState(draft: draft));
    return result.fold(
      (f) => f is NetworkFailure
          ? EntryText.openingNeedsInternet
          : EntryText.forCode(f.code) ?? f.message,
      (_) => null,
    );
  }
}
