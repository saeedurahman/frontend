import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

/// Opens POS in dine-in mode for the given table.
Future<void> launchTableOrder(
  BuildContext context,
  DiningTableModel table,
) async {
  var saleId = table.activeSaleId;
  final isAvailable = table.status == 'available';

  if (!isAvailable && (saleId == null || saleId.isEmpty)) {
    final result = await sl<GetKotOrdersByTableUseCase>()(table.id);
    result.fold((_) {}, (orders) {
      for (final order in orders) {
        if (order.saleId != null && order.saleId!.isNotEmpty) {
          saleId = order.saleId;
          break;
        }
      }
    });
  }

  if (!isAvailable && (saleId == null || saleId!.isEmpty)) {
    if (context.mounted) {
      AppAlerts.showErrorMessage(
        context,
        'No open tab found for this table. Try refreshing the floor.',
      );
    }
    return;
  }

  final resolvedSaleId = saleId;
  final query = <String, String>{
    'tableId': table.id,
    'tableNumber': table.tableNumber,
    'tableStatus': table.status,
    if (resolvedSaleId != null && resolvedSaleId.isNotEmpty)
      'saleId': resolvedSaleId,
  };

  if (context.mounted) {
    context.go(Uri(path: RouteNames.pos, queryParameters: query).toString());
  }
}

String tableOrderActionLabel(DiningTableModel table) {
  if (table.status == 'available') {
    return 'Open order';
  }
  return 'Resume order';
}

bool canLaunchTableOrder(DiningTableModel table) {
  return table.status == 'available' ||
      table.status == 'occupied' ||
      table.status == 'billing' ||
      table.status == 'reserved';
}
