import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/presentation/cubit/pin_login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PinLoginCubit extends Cubit<PinLoginState> {
  PinLoginCubit({required PinDeviceCache pinDeviceCache})
      : _pinDeviceCache = pinDeviceCache,
        super(const PinLoginState.initial());

  final PinDeviceCache _pinDeviceCache;

  Future<void> init() async {
    emit(const PinLoginState.loading());
    final cache = await _pinDeviceCache.read();
    if (cache == null ||
        cache.businessSlug.trim().isEmpty ||
        cache.staff.isEmpty) {
      emit(const PinLoginState.needsSetup());
      return;
    }

    emit(
      PinLoginState.ready(
        businessSlug: cache.businessSlug,
        staff: cache.staff,
        selectedStaffId: cache.staff.first.id,
      ),
    );
  }

  void selectStaff(String staffId) {
    final current = state;
    if (current is! PinLoginReady) return;
    emit(current.copyWith(selectedStaffId: staffId));
  }
}
