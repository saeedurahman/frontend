import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/presentation/pages/landing_page.dart';
import 'package:frantend/features/auth/presentation/pages/login_page.dart';
import 'package:frantend/features/auth/presentation/pages/pin_login_page.dart';
import 'package:frantend/features/auth/presentation/pages/register/register_page.dart';
import 'package:frantend/features/auth/presentation/pages/register/register_success.dart';
import 'package:frantend/features/auth/presentation/pages/register/step1_business_info.dart';
import 'package:frantend/features/auth/presentation/pages/register/step2_business_type.dart';
import 'package:frantend/features/auth/presentation/pages/register/step3_branch.dart';
import 'package:frantend/features/auth/presentation/pages/register/step4_owner.dart';
import 'package:frantend/features/register/presentation/widgets/register_flow_shell.dart';
import 'package:frantend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/pages/pos_page.dart';
import 'package:frantend/features/pos/presentation/pages/receipt_preview_page.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/returns/presentation/pages/process_return_page.dart';
import 'package:frantend/features/sales/presentation/pages/sale_detail_page.dart';
import 'package:frantend/features/sales/presentation/pages/sales_list_page.dart';
import 'package:frantend/features/inventory/presentation/pages/inventory_stock_page.dart';
import 'package:frantend/features/inventory/presentation/pages/stock_movements_page.dart';
import 'package:frantend/features/products/presentation/pages/product_form_page.dart';
import 'package:frantend/features/products/presentation/pages/products_list_page.dart';
import 'package:frantend/features/purchases/presentation/pages/goods_receipt_page.dart';
import 'package:frantend/features/purchases/presentation/pages/purchase_order_detail_page.dart';
import 'package:frantend/features/purchases/presentation/pages/purchase_order_form_page.dart';
import 'package:frantend/features/purchases/presentation/pages/purchase_orders_list_page.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/presentation/pages/close_shift_page.dart';
import 'package:frantend/features/cash_register/presentation/pages/current_shift_page.dart';
import 'package:frantend/features/cash_register/presentation/pages/shift_detail_page.dart';
import 'package:frantend/features/cash_register/presentation/pages/shift_history_page.dart';
import 'package:frantend/features/customers/presentation/pages/customer_form_page.dart';
import 'package:frantend/features/customers/presentation/pages/customer_ledger_page.dart';
import 'package:frantend/features/customers/presentation/pages/customers_list_page.dart';
import 'package:frantend/features/suppliers/presentation/pages/supplier_form_page.dart';
import 'package:frantend/features/suppliers/presentation/pages/suppliers_list_page.dart';
import 'package:frantend/features/expenses/presentation/pages/expense_detail_page.dart';
import 'package:frantend/features/expenses/presentation/pages/expense_form_page.dart';
import 'package:frantend/features/expenses/presentation/pages/expenses_list_page.dart';
import 'package:frantend/features/settings/presentation/pages/settings_page.dart';
import 'package:frantend/features/notifications/presentation/pages/notifications_page.dart';
import 'package:frantend/features/audit/presentation/pages/audit_logs_page.dart';
import 'package:frantend/features/reports/presentation/pages/reports_page.dart';
import 'package:frantend/features/roles/presentation/pages/role_form_page.dart';
import 'package:frantend/features/roles/presentation/pages/roles_list_page.dart';
import 'package:frantend/shared/widgets/feature_placeholder_page.dart';
import 'package:frantend/shared/widgets/layout/app_shell.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter(this._authGuard);

  final AuthGuard _authGuard;

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.root,
    refreshListenable: _authGuard,
    redirect: (context, state) {
      if (state.matchedLocation == RouteNames.root) {
        return _authGuard.isAuthenticated
            ? RouteNames.dashboard
            : RouteNames.landing;
      }
      return _authGuard.redirect(state.matchedLocation);
    },
    routes: [
      GoRoute(
        path: RouteNames.landing,
        builder: (_, __) => const LandingPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.pinLogin,
        builder: (_, __) => const PinLoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => RegisterFlowShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.register,
            builder: (_, __) => const RegisterPage(),
          ),
          GoRoute(
            path: RouteNames.registerStep1,
            builder: (_, __) => const Step1BusinessInfoPage(),
          ),
          GoRoute(
            path: RouteNames.registerStep2,
            builder: (_, __) => const Step2BusinessTypePage(),
          ),
          GoRoute(
            path: RouteNames.registerStep3,
            builder: (_, __) => const Step3BranchPage(),
          ),
          GoRoute(
            path: RouteNames.registerStep4,
            builder: (_, __) => const Step4OwnerPage(),
          ),
          GoRoute(
            path: RouteNames.registerSuccess,
            builder: (_, __) => const RegisterSuccessPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          final meta = _metaForPath(state.uri.path);
          return AppShell(
            title: meta.$1,
            breadcrumb: meta.$2,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            builder: (_, __) => const DashboardPage(),
          ),
          GoRoute(
            path: RouteNames.pos,
            builder: (_, __) => BlocProvider(
              create: (_) => sl<PosCubit>()..init(),
              child: const PosPage(),
            ),
            routes: [
              GoRoute(
                path: 'receipt',
                builder: (_, state) => ReceiptPreviewPage(
                  sale: state.extra as SaleResponseModel,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.products,
            builder: (_, __) => const ProductsListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const ProductFormPage(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) => ProductFormPage(
                  productId: state.pathParameters['id'],
                ),
              ),
              GoRoute(
                path: ':id',
                redirect: (_, state) =>
                    '${RouteNames.products}/${state.pathParameters['id']}/edit',
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.inventory,
            builder: (_, __) => const InventoryStockPage(),
            routes: [
              GoRoute(
                path: 'movements/:productId',
                builder: (_, state) => StockMovementsPage(
                  productId: state.pathParameters['productId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.purchases,
            builder: (_, __) => const PurchaseOrdersListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const PurchaseOrderFormPage(),
              ),
              GoRoute(
                path: ':id/receive',
                builder: (_, state) => GoodsReceiptPage(
                  purchaseOrderId: state.pathParameters['id']!,
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) => PurchaseOrderDetailPage(
                  orderId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.sales,
            builder: (_, __) => const SalesListPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => SaleDetailPage(
                  saleId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'return',
                    builder: (_, state) => ProcessReturnPage(
                      saleId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.returns,
            builder: (_, __) => const FeaturePlaceholderPage(title: 'Returns'),
          ),
          GoRoute(
            path: RouteNames.customers,
            builder: (_, __) => const CustomersListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const CustomerFormPage(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) => CustomerFormPage(
                  customerId: state.pathParameters['id'],
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) => CustomerLedgerPage(
                  customerId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.suppliers,
            builder: (_, __) => const SuppliersListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const SupplierFormPage(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) => SupplierFormPage(
                  supplierId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.expenses,
            builder: (_, __) => const ExpensesListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const ExpenseFormPage(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (_, state) => ExpenseFormPage(
                  expenseId: state.pathParameters['id'],
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) => ExpenseDetailPage(
                  expenseId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.cashRegister,
            builder: (_, __) => const CurrentShiftPage(),
            routes: [
              GoRoute(
                path: 'history',
                builder: (_, __) => const ShiftHistoryPage(),
                routes: [
                  GoRoute(
                    path: ':shiftId',
                    builder: (_, state) => ShiftDetailPage(
                      shiftId: state.pathParameters['shiftId']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'close',
                builder: (_, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return CloseShiftPage(
                    shiftId: extra?['shiftId'] as String? ?? '',
                    summary: extra?['summary'] as ShiftSummaryModel? ??
                        const ShiftSummaryModel(),
                    registerName: extra?['registerName'] as String? ?? '',
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.analytics,
            builder: (_, __) => const ReportsPage(),
          ),
          GoRoute(
            path: RouteNames.reports,
            redirect: (_, __) => RouteNames.analytics,
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (_, __) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'business',
                redirect: (_, __) => RouteNames.settings,
              ),
              GoRoute(
                path: 'receipt',
                redirect: (_, __) => RouteNames.settings,
              ),
              GoRoute(
                path: 'tax',
                redirect: (_, __) => RouteNames.settings,
              ),
              GoRoute(
                path: 'roles',
                builder: (_, __) => const RolesListPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (_, __) => const RoleFormPage(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    builder: (_, state) => RoleFormPage(
                      roleId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.notifications,
            builder: (_, __) => const NotificationsPage(),
          ),
          GoRoute(
            path: RouteNames.auditLogs,
            builder: (_, __) => const AuditLogsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );

  static GoRouter create() => AppRouter(sl<AuthGuard>()).router;
}

(String, String) _metaForPath(String path) {
  if (path.startsWith(RouteNames.dashboard)) return ('Dashboard', 'Home / Dashboard');
  if (path.startsWith(RouteNames.pos)) return ('Point of Sale', 'Home / Point of Sale');
  if (path.startsWith(RouteNames.products)) return ('Products', 'Home / Catalog / Products');
  if (path.startsWith(RouteNames.inventory)) return ('Inventory', 'Home / Inventory');
  if (path.startsWith(RouteNames.purchases)) return ('Purchases', 'Home / Inventory / Purchases');
  if (path.startsWith(RouteNames.sales)) return ('Sales', 'Home / Sales');
  if (path.startsWith(RouteNames.returns)) return ('Returns', 'Home / Sales / Returns');
  if (path.startsWith(RouteNames.customers)) return ('Customers', 'Home / Sales / Customers');
  if (path.startsWith(RouteNames.expenses)) return ('Expenses', 'Home / Finance / Expenses');
  if (path.startsWith(RouteNames.suppliers)) return ('Suppliers', 'Home / Finance / Suppliers');
  if (path.startsWith(RouteNames.cashRegister)) return ('Cash Register', 'Home / Finance / Cash Register');
  if (path.startsWith(RouteNames.analytics)) return ('Analytics', 'Home / Reports / Analytics');
  if (path.startsWith(RouteNames.reports)) return ('Reports', 'Home / Reports');
  if (path.startsWith(RouteNames.settings)) {
    if (path.startsWith(RouteNames.settingsRoles)) {
      return ('Roles & Permissions', 'Home / System / Settings / Roles');
    }
    return ('Settings', 'Home / System / Settings');
  }
  if (path.startsWith(RouteNames.notifications)) {
    return ('Notifications', 'Home / System / Notifications');
  }
  if (path.startsWith(RouteNames.auditLogs)) return ('Audit Logs', 'Home / System / Audit Logs');
  return ('PakPOS', 'Home');
}
