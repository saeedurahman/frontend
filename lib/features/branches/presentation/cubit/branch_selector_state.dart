import 'package:equatable/equatable.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';

class BranchSelectorState extends Equatable {
  const BranchSelectorState({
    this.availableBranches = const [],
    this.selectedBranchId,
    this.canSwitch = false,
    this.isLoading = false,
    this.isInitialized = false,
  });

  final List<BranchModel> availableBranches;
  final String? selectedBranchId;
  final bool canSwitch;
  final bool isLoading;
  final bool isInitialized;

  String get selectedBranchName {
    if (selectedBranchId == null) return 'Main Branch';
    for (final branch in availableBranches) {
      if (branch.id == selectedBranchId) return branch.name;
    }
    return 'Main Branch';
  }

  BranchSelectorState copyWith({
    List<BranchModel>? availableBranches,
    String? selectedBranchId,
    bool? canSwitch,
    bool? isLoading,
    bool? isInitialized,
  }) {
    return BranchSelectorState(
      availableBranches: availableBranches ?? this.availableBranches,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      canSwitch: canSwitch ?? this.canSwitch,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
        availableBranches,
        selectedBranchId,
        canSwitch,
        isLoading,
        isInitialized,
      ];
}
