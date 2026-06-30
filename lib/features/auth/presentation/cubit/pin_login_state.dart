import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';

part 'pin_login_state.freezed.dart';

@freezed
sealed class PinLoginState with _$PinLoginState {
  const factory PinLoginState.initial() = PinLoginInitial;

  const factory PinLoginState.loading() = PinLoginLoading;

  const factory PinLoginState.needsSetup() = PinLoginNeedsSetup;

  const factory PinLoginState.ready({
    required String businessSlug,
    required List<PinStaffEntry> staff,
    required String selectedStaffId,
  }) = PinLoginReady;
}
