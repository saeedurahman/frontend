import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';

part 'customer_picker_state.freezed.dart';

@freezed
class CustomerPickerState with _$CustomerPickerState {
  const factory CustomerPickerState({
    @Default('') String searchQuery,
    @Default([]) List<CustomerModel> results,
    @Default(false) bool isSearching,
    @Default(false) bool isCreating,
    String? error,
    @Default(false) bool showCreateForm,
  }) = _CustomerPickerState;
}
