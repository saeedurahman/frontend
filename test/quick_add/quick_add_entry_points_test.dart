// Purchases > "Receive by scanning" opens Quick Add in purchase mode, and only
// for someone who may add products, create purchases and receive them.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/purchases/domain/repositories/purchases_repository.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/purchases/presentation/pages/purchase_orders_list_page.dart';
import 'package:frantend/features/suppliers/domain/repositories/suppliers_repository.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:go_router/go_router.dart';

import '../helpers/session_fixtures.dart';

class _PurchasesRepo extends Fake implements PurchasesRepository {}

class _SuppliersRepo extends Fake implements SuppliersRepository {}

/// Never touches the network: the page only needs the toolbar for this test.
class _IdleCubit extends PurchaseOrdersListCubit {
  _IdleCubit()
      : super(
          getPurchaseOrdersUseCase: GetPurchaseOrdersUseCase(_PurchasesRepo()),
          getSuppliersUseCase: GetSuppliersUseCase(_SuppliersRepo()),
        );

  int refreshes = 0;

  @override
  Future<void> load() async {}

  @override
  Future<void> refresh() async => refreshes++;
}

void main() {
  late _IdleCubit cubit;

  Future<List<String>> pump(WidgetTester tester, User user) async {
    final prev = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exceptionAsString().contains('overflowed')) return;
      prev?.call(d);
    };
    addTearDown(() => FlutterError.onError = prev);
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    cubit = _IdleCubit();
    if (sl.isRegistered<PurchaseOrdersListCubit>()) sl.unregister<PurchaseOrdersListCubit>();
    sl.registerFactory<PurchaseOrdersListCubit>(() => cubit);
    addTearDown(() {
      if (sl.isRegistered<PurchaseOrdersListCubit>()) sl.unregister<PurchaseOrdersListCubit>();
    });

    final visited = <String>[];
    final router = GoRouter(
      initialLocation: '/purchases',
      routes: [
        GoRoute(
          path: '/purchases',
          builder: (_, __) => const Scaffold(body: PurchaseOrdersListPage()),
        ),
        GoRoute(
          path: '/products/quick-add',
          builder: (_, state) {
            visited.add(state.uri.toString());
            return const Scaffold(body: Text('quick add screen'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      BlocProvider<AccessCubit>.value(
        value: AccessCubit(
          fetchCurrentUser: () async => user,
          loadCachedUser: () async => user,
        )..apply(user),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.pump();
    return visited;
  }

  final button = find.byKey(const ValueKey('purchases-quick-add-button'));

  testWidgets('owner: the button opens Quick Add in purchase mode', (tester) async {
    final visited = await pump(tester, makeUser(role: 'owner'));
    expect(button, findsOneWidget);
    expect(find.text('Receive by scanning'), findsOneWidget);

    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(visited, ['/products/quick-add?mode=purchase']);
    expect(find.text('quick add screen'), findsOneWidget);
  });

  testWidgets('manager (products.create + purchases create/receive): allowed', (tester) async {
    await pump(tester, makeUser(role: 'manager', keys: managerKeys));
    expect(button, findsOneWidget);
  });

  testWidgets('without purchases.receive the button is not shown', (tester) async {
    await pump(
      tester,
      makeUser(role: 'buyer', keys: [
        Perm.purchasesView,
        Perm.purchasesCreate,
        Perm.productsCreate,
        Perm.productsView,
      ]),
    );
    expect(button, findsNothing);
  });

  testWidgets('without products.create the button is not shown', (tester) async {
    await pump(
      tester,
      makeUser(role: 'buyer', keys: [
        Perm.purchasesView,
        Perm.purchasesCreate,
        Perm.purchasesReceive,
      ]),
    );
    expect(button, findsNothing);
  });
}
