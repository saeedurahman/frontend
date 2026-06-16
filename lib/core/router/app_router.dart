import 'package:flutter/material.dart';
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
import 'package:frantend/features/pos/presentation/pages/pos_page.dart';
import 'package:frantend/shared/widgets/feature_placeholder_page.dart';
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
      GoRoute(
        path: RouteNames.dashboard,
        builder: (_, __) => const DashboardPage(),
      ),
      GoRoute(
        path: RouteNames.pos,
        builder: (_, __) => const PosPage(),
      ),
      GoRoute(
        path: RouteNames.products,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Products'),
        routes: [
          GoRoute(
            path: 'new',
            builder: (_, __) =>
                const FeaturePlaceholderPage(title: 'New Product'),
          ),
          GoRoute(
            path: ':id',
            builder: (_, state) => FeaturePlaceholderPage(
              title: 'Product #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.inventory,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Inventory'),
        routes: [
          GoRoute(
            path: 'purchase-orders',
            builder: (_, __) => const FeaturePlaceholderPage(
              title: 'Purchase Orders',
            ),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const FeaturePlaceholderPage(
                  title: 'New Purchase Order',
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'stock-adjustments',
            builder: (_, __) => const FeaturePlaceholderPage(
              title: 'Stock Adjustments',
            ),
          ),
          GoRoute(
            path: 'transfers',
            builder: (_, __) => const FeaturePlaceholderPage(
              title: 'Inventory Transfers',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.sales,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Sales'),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => FeaturePlaceholderPage(
              title: 'Sale #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.returns,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Returns'),
      ),
      GoRoute(
        path: RouteNames.customers,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Customers'),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => FeaturePlaceholderPage(
              title: 'Customer #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.suppliers,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Suppliers'),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => FeaturePlaceholderPage(
              title: 'Supplier #${state.pathParameters['id']}',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.expenses,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Expenses'),
      ),
      GoRoute(
        path: RouteNames.cashRegister,
        builder: (_, __) => const FeaturePlaceholderPage(
          title: 'Cash Register',
        ),
        routes: [
          GoRoute(
            path: 'shifts',
            builder: (_, __) => const FeaturePlaceholderPage(title: 'Shifts'),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.analytics,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Analytics'),
      ),
      GoRoute(
        path: RouteNames.reports,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Reports'),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Settings'),
        routes: [
          GoRoute(
            path: 'business',
            builder: (_, __) => const FeaturePlaceholderPage(
              title: 'Business Settings',
            ),
          ),
          GoRoute(
            path: 'receipt',
            builder: (_, __) => const FeaturePlaceholderPage(
              title: 'Receipt Settings',
            ),
          ),
          GoRoute(
            path: 'tax',
            builder: (_, __) => const FeaturePlaceholderPage(
              title: 'Tax Settings',
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (_, __) => const FeaturePlaceholderPage(
          title: 'Notifications',
        ),
      ),
      GoRoute(
        path: RouteNames.auditLogs,
        builder: (_, __) => const FeaturePlaceholderPage(title: 'Audit Logs'),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );

  static GoRouter create() => AppRouter(sl<AuthGuard>()).router;
}
