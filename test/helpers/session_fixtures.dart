import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';

/// Mirrors backend CASHIER_PERMISSION_KEYS.
const cashierKeys = <String>[
  'auth.login',
  Perm.productsView,
  Perm.inventoryView,
  Perm.salesView,
  Perm.salesCreate,
  Perm.customersView,
  Perm.customersCreate,
  Perm.shiftsOpen,
  Perm.shiftsClose,
  Perm.notificationsView,
  Perm.branchesView,
];

/// A manager: everything except the owner-only keys.
const managerKeys = <String>[
  ...cashierKeys,
  Perm.productsCreate,
  Perm.productsUpdate,
  Perm.productsManagePrices,
  Perm.inventoryAdjust,
  Perm.purchasesView,
  Perm.purchasesCreate,
  Perm.purchasesReceive,
  Perm.salesCancel,
  Perm.salesVoid,
  Perm.salesApplyDiscount,
  Perm.salesOverridePrice,
  Perm.returnsView,
  Perm.returnsCreate,
  Perm.customersUpdate,
  Perm.suppliersView,
  Perm.suppliersCreate,
  Perm.suppliersUpdate,
  Perm.expensesView,
  Perm.expensesCreate,
  Perm.expensesUpdate,
  Perm.shiftsView,
  Perm.reportsView,
  Perm.reportsExport,
  Perm.usersView,
  Perm.usersCreate,
  Perm.usersUpdate,
];

User makeUser({
  String role = 'cashier',
  List<String> keys = const [],
  int? version,
  List<String> branchIds = const [],
  String id = 'u1',
}) =>
    User(
      id: id,
      email: '03000000000',
      name: 'Test User',
      role: role,
      roles: [role],
      permissionKeys: keys,
      permissionsVersion: version,
      branchIds: branchIds,
    );

UserAccess accessOf(User u) => UserAccess(
      role: u.role,
      roles: u.roles,
      permissionKeys: u.permissionKeys,
    );

final ownerAccess = accessOf(makeUser(role: 'owner'));
final managerAccess = accessOf(makeUser(role: 'manager', keys: managerKeys));
final cashierAccess = accessOf(makeUser(role: 'cashier', keys: cashierKeys));
final customAccess = accessOf(
  makeUser(
    role: 'stock_clerk',
    keys: const [Perm.productsView, Perm.inventoryView, Perm.inventoryAdjust],
  ),
);
