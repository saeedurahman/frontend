import 'package:frantend/features/dashboard/domain/entities/dashboard_data.dart';

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.data, {required this.trendDays});

  final DashboardData data;
  final int trendDays;
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);

  final String message;
}
