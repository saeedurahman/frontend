part of 'pos_state.dart';

@freezed
class PosSessionState with _$PosSessionState {
  const factory PosSessionState({
    @Default(false) bool accessDenied,
    @Default(false) bool canOpenShift,
    @Default(false) bool canCloseShift,
    String? cashierName,
    String? branchId,
    String? businessName,
    @Default(false) bool isOffline,
    PosDineInContext? dineIn,
  }) = _PosSessionState;
}
