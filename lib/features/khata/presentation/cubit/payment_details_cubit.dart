import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';

class PaymentDetailsState {
  const PaymentDetailsState({
    this.loading = true,
    this.error,
    this.items = const [],
    this.saving = false,
  });

  final bool loading;

  /// Why the list could not be loaded.
  final String? error;
  final List<PaymentInstruction> items;
  final bool saving;

  bool get isFull => items.length >= KhataSettings.maxPaymentInstructions;

  PaymentDetailsState copyWith({
    List<PaymentInstruction>? items,
    bool? saving,
  }) =>
      PaymentDetailsState(
        loading: false,
        items: items ?? this.items,
        saving: saving ?? this.saving,
      );
}

/// How customers can pay. Every change is saved at once; a refused one is
/// taken back.
class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  PaymentDetailsCubit(this._repository) : super(const PaymentDetailsState());

  final KhataRepository _repository;

  bool get isOnline => _repository.isOnline;

  Future<void> load() async {
    emit(const PaymentDetailsState());
    final result = await _repository.settingsForEdit();
    if (isClosed) return;
    emit(
      result.fold(
        (f) => PaymentDetailsState(loading: false, error: f.message),
        (s) => PaymentDetailsState(
          loading: false,
          items: s.paymentInstructions,
        ),
      ),
    );
  }

  /// Each returns null when saved, otherwise the sentence to show.
  Future<String?> add(PaymentInstruction item) =>
      state.isFull ? Future.value() : _save([...state.items, item]);

  Future<String?> replace(int index, PaymentInstruction item) =>
      _save([...state.items]..[index] = item);

  Future<String?> remove(int index) =>
      _save([...state.items]..removeAt(index));

  /// Moves the entry at [from] so that it ends up at [to].
  Future<String?> move(int from, int to) {
    if (from == to || to < 0 || to >= state.items.length) {
      return Future.value();
    }
    final next = [...state.items];
    next.insert(to, next.removeAt(from));
    return _save(next);
  }

  Future<String?> _save(List<PaymentInstruction> next) async {
    // One at a time, so a slow save can't overwrite a newer one.
    if (state.saving || state.loading || state.error != null) return null;
    final before = state.items;
    emit(state.copyWith(items: next, saving: true));
    final result = await _repository.saveSettings({
      KhataSettings.paymentsKey: [for (final i in next) i.toJson()],
    });
    if (isClosed) return null;
    return result.fold(
      (f) {
        emit(state.copyWith(items: before, saving: false));
        return f.message;
      },
      (_) {
        emit(state.copyWith(saving: false));
        return null;
      },
    );
  }
}
