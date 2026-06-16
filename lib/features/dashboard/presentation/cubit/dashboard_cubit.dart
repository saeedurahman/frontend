import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
}
