// The new purchase order screen, driven the way a person drives it, with the
// REAL cubit, use cases and repositories over a fake HTTP layer (the live
// version of the same flow is test/live/purchase_live_test.dart).
//
//  * picking a product and typing quantity / cost key by key keeps what was
//    typed, and the product dropdown shows what the cubit holds;
//  * "Save & Submit" sends the product that was picked ("Product is required"
//    appeared although the product was added);
//  * the product stays on the line even when its details cannot be loaded;
//  * a draft that was created but not submitted is not created twice, and
//    Cancel after it still tells the list to refresh.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_form_cubit.dart';
import 'package:frantend/features/purchases/presentation/pages/purchase_order_form_page.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fake_http.dart';
import '../helpers/form_typing.dart';
import '../products/product_save_regression_test.dart' show productResponse;

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Local extends Fake implements ProductsLocalDataSource {
  @override
  Future<void> cacheProducts(List<dynamic> products) async {}
}

class _Probe extends Fake implements ConnectivityProbe {}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async =>
      const UserModel(id: 'u', name: 'Owner', branchId: 'br1', role: 'owner');
}

/// The quick-add-supplier dialog is not used here; the page only needs the
/// cubit to exist.
class _SuppliersCubit extends Cubit<SuppliersListState> implements SuppliersListCubit {
  _SuppliersCubit() : super(const SuppliersListState.initial());
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Map<String, dynamic> _supplier() => {
      'id': 's1',
      'business_id': 'b1',
      'name': 'Al Shifa',
      'payment_terms_days': 15,
      'is_active': true,
    };

Map<String, dynamic> _listItem(String id, String name) => {
      'id': id,
      'business_id': 'b1',
      'name': name,
      'product_type': 'standard',
      'tracking_type': 'none',
      'is_active': true,
      // The full product carries the slim CategoryBrief (no business_id/slug).
      'category_id': 'c1',
    };

Map<String, dynamic> _order({String status = 'draft'}) => {
      'id': 'po1',
      'business_id': 'b1',
      'branch_id': 'br1',
      'supplier_id': 's1',
      'po_number': 'PO-1',
      'status': status,
      'lines': <dynamic>[],
    };

void main() {
  late FakeAdapter adapter;
  late PurchaseOrderFormCubit cubit;
  var productDetailsFail = false;
  var statusFails = false;

  List<RequestOptions> posts() =>
      adapter.requests.where((r) => r.method == 'POST' && r.path.endsWith('/purchases/orders')).toList();

  setUp(() {
    productDetailsFail = false;
    statusFails = false;
    adapter = FakeAdapter((o) {
      final path = o.path;
      if (o.method == 'GET' && path.endsWith('/suppliers')) {
        return jsonResponse([_supplier()]);
      }
      if (o.method == 'GET' && path.endsWith('/products')) {
        final items = [_listItem('p1', 'Panadol'), _listItem('p2', 'Amoxil')];
        return jsonResponse({'total': items.length, 'skip': 0, 'limit': 200, 'items': items});
      }
      if (o.method == 'GET' && path.contains('/products/')) {
        if (productDetailsFail) return jsonResponse({'detail': 'boom'}, status: 500);
        final id = path.split('/').last;
        return jsonResponse({...productResponse(), 'id': id, 'name': id == 'p1' ? 'Panadol' : 'Amoxil'});
      }
      if (o.method == 'POST' && path.endsWith('/purchases/orders')) {
        return jsonResponse(_order(), status: 201);
      }
      if (o.method == 'PUT' && path.endsWith('/status')) {
        if (statusFails) return jsonResponse({'detail': 'cannot submit'}, status: 400);
        return jsonResponse(_order(status: 'ordered'));
      }
      return jsonResponse(<String, dynamic>{});
    });
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
    final client = _Dio(dio);
    final products = ProductsRepositoryImpl(
      remoteDataSource: ProductsRemoteDataSourceImpl(client),
      localDataSource: _Local(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
    );
    final suppliers = SuppliersRepositoryImpl(
      remoteDataSource: SuppliersRemoteDataSourceImpl(client),
      errorHandler: const ErrorHandler(),
    );
    final getProductById = GetProductByIdUseCase(products);
    final purchases = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(client),
      errorHandler: const ErrorHandler(),
      lineEnricher: PurchaseOrderLineEnricher(getProductById),
    );
    // The page owns (and closes) the cubit it asks for, so every open gets a new one.
    PurchaseOrderFormCubit build() => cubit = PurchaseOrderFormCubit(
          authLocalDataSource: _Auth(),
          getSuppliersUseCase: GetSuppliersUseCase(suppliers),
          getProductsUseCase: GetProductsUseCase(products),
          getProductByIdUseCase: getProductById,
          createPurchaseOrderUseCase: CreatePurchaseOrderUseCase(purchases),
          updatePurchaseOrderStatusUseCase: UpdatePurchaseOrderStatusUseCase(purchases),
        );
    for (final reg in <void Function()>[
      () {
        if (sl.isRegistered<PurchaseOrderFormCubit>()) sl.unregister<PurchaseOrderFormCubit>();
        sl.registerFactory<PurchaseOrderFormCubit>(build);
      },
      () {
        if (sl.isRegistered<SuppliersListCubit>()) sl.unregister<SuppliersListCubit>();
        sl.registerFactory<SuppliersListCubit>(_SuppliersCubit.new);
      },
    ]) {
      reg();
    }
  });

  /// "/" shows a button that opens the form like the list page does; what the
  /// form pops with is stored in [popped].
  Future<void> open(WidgetTester t, {required List<Object?> popped}) async {
    ignoreOverflowErrors();
    t.view.physicalSize = const Size(1400, 1800);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (c, _) => Scaffold(
          body: TextButton(
            onPressed: () async => popped.add(await c.push<bool>('/new')),
            child: const Text('open'),
          ),
        ),
      ),
      GoRoute(path: '/new', builder: (_, __) => const Scaffold(body: PurchaseOrderFormPage())),
    ]);
    await t.pumpWidget(MaterialApp.router(routerConfig: router));
    await t.tap(find.text('open'));
    await t.pumpAndSettle();
  }

  Finder productDropdown() => find.widgetWithText(DropdownButtonFormField<String?>, 'Product');

  Future<void> pickProduct(WidgetTester t, String name) async {
    await t.tap(productDropdown());
    await t.pumpAndSettle();
    await t.tap(find.text(name).last);
    await t.pumpAndSettle();
  }

  Future<void> pickSupplier(WidgetTester t) async {
    await t.tap(find.widgetWithText(DropdownButtonFormField<String?>, 'Supplier *'));
    await t.pumpAndSettle();
    await t.tap(find.text('Al Shifa').last);
    await t.pumpAndSettle();
  }

  testWidgets('add a product, type quantity and cost key by key, Save & Submit sends it',
      (t) async {
    final popped = <Object?>[];
    await open(t, popped: popped);
    await pickSupplier(t);

    await pickProduct(t, 'Panadol');
    expect(cubit.state.lines[0].productId, 'p1');
    expect(cubit.state.errors, isEmpty);
    // The dropdown shows the product the cubit holds.
    expect(find.descendant(of: productDropdown(), matching: find.text('Panadol')), findsOneWidget);
    expect(cubit.state.lines[0].variations, isNotEmpty);

    final fields = find.byType(EditableText);
    final qty = find.widgetWithText(TextField, 'Ordered Qty');
    final cost = find.widgetWithText(TextField, 'Cost/Unit');
    expect(fields, findsWidgets);
    await typeCharByChar(t, qty, '25', afterEach: (_, typed) {
      expect(cubit.state.lines[0].orderedQty, typed);
      expect(cubit.state.lines[0].productId, 'p1', reason: 'typing must not drop the product');
    });
    await typeCharByChar(t, cost, '12.50', afterEach: (_, typed) {
      expect(cubit.state.lines[0].costPerUnit, typed);
    });
    expect(shownIn(t, qty), '25');
    expect(shownIn(t, cost), '12.50');

    await t.tap(find.text('Save & Submit'));
    await t.pumpAndSettle();

    expect(find.text('Product is required'), findsNothing);
    final body = posts().single.data as Map;
    final line = (body['lines'] as List).single as Map;
    expect(line['product_id'], 'p1');
    expect(double.parse('${line['ordered_qty']}'), 25.0);
    expect(double.parse('${line['cost_per_unit']}'), 12.5);
    expect(adapter.requests.any((r) => r.method == 'PUT' && r.path.endsWith('/status')), isTrue);
    expect(popped, [true], reason: 'the form pops with true so that the list refreshes');
  });

  testWidgets('the dropdown follows the cubit when the product is set from outside', (t) async {
    await open(t, popped: []);
    unawaited(cubit.selectProduct(0, 'p2'));
    await t.pumpAndSettle();
    expect(find.descendant(of: productDropdown(), matching: find.text('Amoxil')), findsOneWidget);
    unawaited(cubit.selectProduct(0, 'p1'));
    await t.pumpAndSettle();
    expect(find.descendant(of: productDropdown(), matching: find.text('Panadol')), findsOneWidget);
    expect(cubit.state.lines[0].productId, 'p1');
  });

  testWidgets('a product whose details cannot be loaded stays on the line; no "Product is required"',
      (t) async {
    productDetailsFail = true;
    await open(t, popped: []);
    await pickSupplier(t);
    await pickProduct(t, 'Panadol');

    // The failure is reported, but the line still holds the product.
    expect(cubit.state.lines[0].productId, 'p1');
    expect(cubit.state.errors['_general'], isNotNull);

    await typeCharByChar(t, find.widgetWithText(TextField, 'Ordered Qty'), '3');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Cost/Unit'), '9');
    expect(cubit.validate(), isTrue, reason: '${cubit.state.errors}');
    expect(cubit.state.errors.containsKey('line_0'), isFalse);
  });

  testWidgets('quantity and cost already typed survive picking another product', (t) async {
    await open(t, popped: []);
    await pickProduct(t, 'Panadol');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Ordered Qty'), '8');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Cost/Unit'), '4');
    await pickProduct(t, 'Amoxil');
    expect(cubit.state.lines[0].productId, 'p2');
    expect(cubit.state.lines[0].orderedQty, '8');
    expect(cubit.state.lines[0].costPerUnit, '4');
  });

  testWidgets('submit fails after the order was created: retry only submits (no duplicate), Cancel refreshes',
      (t) async {
    final popped = <Object?>[];
    await open(t, popped: popped);
    await pickSupplier(t);
    await pickProduct(t, 'Panadol');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Ordered Qty'), '5');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Cost/Unit'), '2');

    statusFails = true;
    await t.tap(find.text('Save & Submit'));
    await t.pumpAndSettle();
    expect(posts(), hasLength(1));
    expect(cubit.state.createdOrderId, 'po1');
    expect(popped, isEmpty, reason: 'the form stays open on a failed submit');

    statusFails = false;
    await t.tap(find.text('Save & Submit'));
    await t.pumpAndSettle();
    expect(posts(), hasLength(1), reason: 'the retry must not create a second order');
    expect(popped, [true]);
  });

  testWidgets('Cancel after a draft was created pops with true; plain Cancel pops with null',
      (t) async {
    final popped = <Object?>[];
    await open(t, popped: popped);
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    expect(popped, [null]);

    await t.tap(find.text('open'));
    await t.pumpAndSettle();
    await pickSupplier(t);
    await pickProduct(t, 'Panadol');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Ordered Qty'), '5');
    await typeCharByChar(t, find.widgetWithText(TextField, 'Cost/Unit'), '2');
    statusFails = true;
    await t.tap(find.text('Save & Submit'));
    await t.pumpAndSettle();
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    expect(popped, [null, true]);
  });
}
