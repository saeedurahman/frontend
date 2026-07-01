import 'package:flutter/material.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

Future<bool?> openBomForm(
  BuildContext context, {
  String? bomId,
}) {
  if (bomId == null) {
    return context.push<bool>(RouteNames.manufacturingBomNew);
  }
  return context.push<bool>(RouteNames.manufacturingBomDetailPath(bomId));
}

void openBomsList(BuildContext context) {
  context.push(RouteNames.manufacturingBoms);
}

void openManufacturingHome(BuildContext context) {
  context.go(RouteNames.manufacturing);
}
