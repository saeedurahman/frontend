import 'package:flutter_bloc/flutter_bloc.dart';
import 'suppliers_state.dart';

class SuppliersCubit extends Cubit<SuppliersState> {
  SuppliersCubit() : super(const SuppliersInitial());
}
