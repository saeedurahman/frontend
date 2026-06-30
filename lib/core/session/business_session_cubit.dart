import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/session/business_session_state.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BusinessSessionCubit extends Cubit<BusinessSessionState> {
  BusinessSessionCubit() : super(const BusinessSessionState());

  void setFlags(BusinessFeatureFlags flags) {
    emit(BusinessSessionState(flags: flags, isLoaded: true));
  }

  void reset() {
    emit(const BusinessSessionState());
  }
}
