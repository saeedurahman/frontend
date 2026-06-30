import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';

class FloorPlanSelectorBar extends StatelessWidget {
  const FloorPlanSelectorBar({
    super.key,
    required this.floorPlans,
    required this.selectedFloorPlanId,
    required this.onSelected,
  });

  final List<FloorPlanWithTablesModel> floorPlans;
  final String? selectedFloorPlanId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (floorPlans.length <= 1) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final plan in floorPlans)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(plan.name),
                selected: plan.id == selectedFloorPlanId,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: plan.id == selectedFloorPlanId
                      ? Colors.white
                      : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (_) => onSelected(plan.id),
              ),
            ),
        ],
      ),
    );
  }
}
