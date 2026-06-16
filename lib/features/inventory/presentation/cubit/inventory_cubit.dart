import 'package:flutter_bloc/flutter_bloc.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(const InventoryInitial());
}
