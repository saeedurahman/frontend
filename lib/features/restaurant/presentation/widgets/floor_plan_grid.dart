import 'package:flutter/material.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/presentation/widgets/restaurant_table_tile.dart';

class FloorPlanGrid extends StatelessWidget {
  const FloorPlanGrid({
    super.key,
    required this.tables,
    required this.onTableTap,
  });

  final List<DiningTableModel> tables;
  final ValueChanged<DiningTableModel> onTableTap;

  @override
  Widget build(BuildContext context) {
    if (tables.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasPositions = tables.any(
      (table) => table.posX != null && table.posY != null,
    );

    if (hasPositions) {
      return _PositionedFloor(tables: tables, onTableTap: onTableTap);
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final table in tables)
          RestaurantTableTile(
            table: table,
            onTap: () => onTableTap(table),
          ),
      ],
    );
  }
}

class _PositionedFloor extends StatelessWidget {
  const _PositionedFloor({
    required this.tables,
    required this.onTableTap,
  });

  final List<DiningTableModel> tables;
  final ValueChanged<DiningTableModel> onTableTap;

  @override
  Widget build(BuildContext context) {
    const tileSize = 112.0;
    const padding = 16.0;

    var maxX = tileSize;
    var maxY = tileSize;

    for (final table in tables) {
      final x = double.tryParse(table.posX ?? '') ?? 0;
      final y = double.tryParse(table.posY ?? '') ?? 0;
      maxX = maxX > x + tileSize ? maxX : x + tileSize;
      maxY = maxY > y + tileSize ? maxY : y + tileSize;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: SizedBox(
          width: maxX + padding * 2,
          height: maxY + padding * 2,
          child: Stack(
            children: [
              for (final table in tables)
                Positioned(
                  left: padding + (double.tryParse(table.posX ?? '') ?? 0),
                  top: padding + (double.tryParse(table.posY ?? '') ?? 0),
                  width: tileSize,
                  height: tileSize,
                  child: RestaurantTableTile(
                    table: table,
                    onTap: () => onTableTap(table),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
