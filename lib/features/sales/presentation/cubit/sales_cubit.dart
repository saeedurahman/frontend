import 'package:flutter_bloc/flutter_bloc.dart';
import 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit() : super(const SalesInitial());
}
