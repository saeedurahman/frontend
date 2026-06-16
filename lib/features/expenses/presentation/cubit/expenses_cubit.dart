import 'package:flutter_bloc/flutter_bloc.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit() : super(const ExpensesInitial());
}
