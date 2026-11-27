// Who may open what in the khata.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/route_permissions.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

import '../helpers/khata_p1_fakes.dart';

void main() {
  bool open(String route, List<String> keys) =>
      RoutePermissions.isAllowed(route, keys.contains);

  test('the hub and statements need khata.view', () {
    for (final route in [
      RouteNames.khata,
      '${RouteNames.khata}?tab=supplier',
      RouteNames.statement('customer', 'c1'),
      RouteNames.statement('supplier', 's1'),
    ]) {
      expect(open(route, [Perm.khataView]), isTrue, reason: route);
      expect(open(route, [Perm.customersView]), isFalse, reason: route);
    }
  });

  test('payment details and khata messages need settings.manage', () {
    for (final route in [
      RouteNames.settingsPaymentDetails,
      RouteNames.settingsKhataMessages,
    ]) {
      expect(open(route, [Perm.settingsManage]), isTrue, reason: route);
      expect(open(route, [Perm.khataView]), isFalse, reason: route);
    }
  });

  test('each side has its own ledger and payment permissions', () {
    expect(
      PartyType.customer.ledgerManagePermission,
      Perm.customersLedgerManage,
    );
    expect(
      PartyType.supplier.ledgerManagePermission,
      Perm.suppliersLedgerManage,
    );
    expect(
      PartyType.customer.paymentPermission,
      isNot(PartyType.supplier.paymentPermission),
    );
  });

  testWidgets('asked from a tap, the answer is the same as on screen',
      (tester) async {
    bool? inBuild;
    bool? inTap;
    bool? literal;
    await pumpKhata(
      tester,
      Builder(
        builder: (context) {
          inBuild = hasPermission(context, Perm.khataStatementCreate);
          return TextButton(
            onPressed: () {
              inTap = hasPermission(context, Perm.khataStatementCreate);
              literal = holdsPermissionKey(context, Perm.khataView);
            },
            child: const Text('ask'),
          );
        },
      ),
      user: userWith([Perm.khataView]),
    );
    await tester.pump();
    await tester.tap(find.text('ask'));
    expect(inBuild, isFalse);
    expect(inTap, isFalse);
    expect(literal, isTrue);
  });
}
