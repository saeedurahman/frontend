import 'package:flutter/material.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

Future<bool?> openCoaForm(
  BuildContext context, {
  String? accountId,
}) {
  if (accountId == null) {
    return context.push<bool>(RouteNames.accountingCoaNew);
  }
  return context.push<bool>(RouteNames.accountingCoaDetailPath(accountId));
}

void openCoaList(BuildContext context) {
  context.push(RouteNames.accountingCoaList);
}

void openAccountingHome(BuildContext context) {
  context.go(RouteNames.accounting);
}

Future<bool?> openJournalEntryForm(
  BuildContext context, {
  String? entryId,
}) {
  if (entryId == null) {
    return context.push<bool>(RouteNames.accountingJournalNew);
  }
  return context.push<bool>(RouteNames.accountingJournalEditPath(entryId));
}
