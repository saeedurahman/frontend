part of 'pos_state.dart';

enum DineInTabStatus {
  open,
  fired,
  billRequested,
}

@freezed
class PosDineInContext with _$PosDineInContext {
  const PosDineInContext._();

  const factory PosDineInContext({
    required String saleId,
    required String tableId,
    required String tableLabel,
    @Default(DineInTabStatus.open) DineInTabStatus tabStatus,
    @Default(false) bool isSyncingLine,
    String? syncError,
  }) = _PosDineInContext;

  bool get isActive => true;
}
