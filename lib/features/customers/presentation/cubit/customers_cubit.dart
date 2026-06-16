import 'package:flutter_bloc/flutter_bloc.dart';
import 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit() : super(const CustomersInitial());
}
