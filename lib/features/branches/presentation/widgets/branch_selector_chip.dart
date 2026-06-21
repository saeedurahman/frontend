import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';

class BranchSelectorChip extends StatelessWidget {
  const BranchSelectorChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchSelectorCubit, BranchSelectorState>(
      bloc: sl<BranchSelectorCubit>(),
      builder: (context, state) {
        if (state.isLoading) {
          return _pill(
            child: const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final label = state.selectedBranchName;

        if (!state.canSwitch) {
          return _pill(
            child: Text(
              label,
              style: _labelStyle,
            ),
          );
        }

        return PopupMenuButton<String>(
          tooltip: 'Switch branch',
          onSelected: sl<BranchSelectorCubit>().selectBranch,
          itemBuilder: (context) => state.availableBranches
              .map(
                (branch) => PopupMenuItem<String>(
                  value: branch.id,
                  child: Row(
                    children: [
                      if (branch.id == state.selectedBranchId)
                        const Icon(Icons.check, size: 16, color: AppColors.primary)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(branch.name)),
                    ],
                  ),
                ),
              )
              .toList(),
          child: _pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: _labelStyle),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static const _labelStyle = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  Widget _pill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
