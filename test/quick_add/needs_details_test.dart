// "Needs details": the local filter (works offline), the Complete details
// walk-through, the Products list chip and the Quick Add entry points.
import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/complete_details/complete_details_cubit.dart';
import 'package:frantend/features/products/presentation/complete_details/complete_details_page.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:frantend/features/products/presentation/pages/products_list_page.dart';

import '../helpers/session_fixtures.dart';

ProductModel _product(String id, {String? categoryId, String? image}) => ProductModel(
      id: id,
      businessId: 'b1',
      name: 'Product $id',
      productType: 'standard',
      trackingType: 'none',
      imageUrl: image,
      createdAt: '2026-01-01T00:00:00Z',
      updatedAt: '2026-01-01T00:00:00Z',
      category: categoryId == null ? null : CategoryModel(id: categoryId, name: 'Cat'),
      variations: [
        VariationModel(id: 'v-$id', productId: id, name: 'Product $id', isDefault: true),
      ],
    );

ProductListItemModel _item(String id, List<String> missing, {String? categoryId}) =>
    ProductListItemModel(
      id: id,
      name: 'Product $id',
      productType: 'standard',
      trackingType: 'none',
      categoryId: categoryId,
      needsAttention: true,
      missing: missing,
    );

class _Repo extends Fake implements ProductsRepository {
  _Repo({this.items = const []});

  List<ProductListItemModel> items;
  final updates = <(String, Map<String, dynamic>)>[];
  final variationUpdates = <(String, String, Map<String, dynamic>)>[];
  final prices = <(String, String, Map<String, dynamic>)>[];
  final needsAttentionCalls = <bool?>[];
  Failure? updateFails;

  @override
  Future<Either<Failure, PaginatedProductsModel>> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    bool? needsAttention,
    int skip = 0,
    int limit = 50,
  }) async {
    needsAttentionCalls.add(needsAttention);
    final list = needsAttention == true ? items : const <ProductListItemModel>[];
    return Right(PaginatedProductsModel(total: list.length, skip: 0, limit: limit, items: list));
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories({String? parentId}) async =>
      const Right([CategoryModel(id: 'c1', name: 'Soap')]);

  @override
  Future<Either<Failure, List<BrandModel>>> getBrands() async => const Right([]);

  @override
  Future<Either<Failure, List<UnitModel>>> getUnits() async => const Right([
        UnitModel(id: 'u-piece', name: 'Piece', symbol: 'pc'),
        UnitModel(id: 'u-kg', name: 'Kg', symbol: 'kg'),
      ]);

  @override
  Future<Either<Failure, List<PriceListModel>>> getPriceLists() async => const Right([
        PriceListModel(id: 'pl1', businessId: 'b1', name: 'Retail', listType: 'retail', isDefault: true),
      ]);

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async => Right(
        _product(id).copyWith(
          variations: [
            VariationModel(id: 'v-$id', productId: id, name: 'P', unitId: 'u-piece', isDefault: true),
          ],
        ),
      );

  @override
  Future<Either<Failure, ProductModel>> updateProduct(String id, Map<String, dynamic> body) async {
    updates.add((id, body));
    final f = updateFails;
    return f == null ? Right(_product(id)) : Left(f);
  }

  @override
  Future<Either<Failure, VariationModel>> updateVariation(
    String productId,
    String variationId,
    Map<String, dynamic> body,
  ) async {
    variationUpdates.add((productId, variationId, body));
    return Right(VariationModel(id: variationId, productId: productId, name: 'P'));
  }

  @override
  Future<Either<Failure, ProductPriceModel>> setProductPrice(
    String productId,
    String priceListId,
    Map<String, dynamic> body,
  ) async {
    prices.add((productId, priceListId, body));
    return Right(ProductPriceModel.fromJson({
      'id': 'x',
      'price_list_id': priceListId,
      'product_id': productId,
      'unit_price': body['unit_price'],
    }));
  }
}

class _Upload extends Fake implements ImageUploadService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('local "needs details" filter (offline)', () {
    late AppDatabase db;
    late SyncStore store;
    late LocalCatalog catalog;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      store = SyncStore(db);
      catalog = LocalCatalog(store, businessId: () async => 'b1');
      await catalog.rememberPriceList({
        'id': 'pl1',
        'name': 'Retail',
        'list_type': 'retail',
        'is_default': true,
        'is_active': true,
      });
      await catalog.rememberProduct(_product('complete', categoryId: 'c1', image: 'http://x/i.png'));
      await catalog.rememberProduct(_product('no-image', categoryId: 'c1'));
      await catalog.rememberProduct(_product('nothing'));
      await catalog.rememberProduct(_product('zero-price', categoryId: 'c1', image: 'http://x/z.png'));
      await catalog.rememberPrice(listId: 'pl1', productId: 'complete', price: '50');
      await catalog.rememberPrice(listId: 'pl1', productId: 'no-image', price: '50');
      await catalog.rememberPrice(listId: 'pl1', productId: 'nothing', price: '0');
      await catalog.rememberPrice(listId: 'pl1', productId: 'zero-price', price: '0');
    });

    tearDown(() async {
      store.dispose();
      await db.close();
    });

    test('flags missing category, picture or price, and says which', () async {
      final page = await catalog.products(needsAttention: true);
      final byId = {for (final p in page.items) p.id: p};
      expect(byId.keys.toSet(), {'no-image', 'nothing', 'zero-price'});
      expect(byId['no-image']!.missing, ['image']);
      expect(byId['nothing']!.missing, ['category', 'image', 'price']);
      expect(byId['zero-price']!.missing, ['price']);
      expect(byId['no-image']!.needsAttention, isTrue);
      expect(page.total, 3);
    });

    test('the normal list is not affected and paging works', () async {
      expect((await catalog.products()).total, 4);
      final first = await catalog.products(needsAttention: true, limit: 2);
      final second = await catalog.products(needsAttention: true, skip: 2, limit: 2);
      expect(first.items, hasLength(2));
      expect(second.items, hasLength(1));
      expect(first.total, 3);
    });

    test('search narrows the flagged list', () async {
      final page = await catalog.products(needsAttention: true, search: 'nothing');
      expect(page.items.map((p) => p.id), ['nothing']);
    });
  });

  group('Complete details walk-through', () {
    late _Repo repo;
    late CompleteDetailsCubit cubit;

    setUp(() async {
      repo = _Repo(items: [
        _item('a', ['category', 'price']),
        _item('b', ['image']),
        _item('c', ['category']),
      ]);
      cubit = CompleteDetailsCubit(repository: repo, imageUpload: _Upload());
      await cubit.load();
    });

    tearDown(() => cubit.close());

    test('starts at 1 of 3 and loads the pickers', () {
      expect(cubit.state.total, 3);
      expect(cubit.state.index, 0);
      expect(cubit.state.current!.id, 'a');
      expect(cubit.state.categories, hasLength(1));
      expect(cubit.state.units, hasLength(2));
      expect(cubit.state.needsPrice, isTrue);
      expect(cubit.state.unitId, 'u-piece');
    });

    test('Save and next sends only what changed and moves on', () async {
      cubit
        ..setCategory('c1')
        ..setMinStock('5')
        ..setPrice('120');
      await cubit.saveAndNext();

      expect(repo.updates, hasLength(1));
      expect(repo.updates.single.$2, {'category_id': 'c1', 'min_stock_level': '5'});
      expect(repo.prices.single.$2, 'pl1');
      expect(repo.prices.single.$3['unit_price'], '120');
      expect(repo.variationUpdates, isEmpty);
      expect(cubit.state.done, 1);
      expect(cubit.state.index, 1);
      expect(cubit.state.current!.id, 'b');
    });

    test('a unit change goes through the variation', () async {
      cubit.setUnit('u-kg');
      await cubit.saveAndNext();
      expect(repo.variationUpdates.single.$3, {'unit_id': 'u-kg'});
      expect(repo.updates, isEmpty);
    });

    test('Skip moves on without saving', () async {
      await cubit.skip();
      expect(cubit.state.index, 1);
      expect(cubit.state.done, 0);
      expect(repo.updates, isEmpty);
    });

    test('a server error stays on the product with a message', () async {
      repo.updateFails = const ServerFailure('Could not save');
      cubit.setCategory('c1');
      await cubit.saveAndNext();
      expect(cubit.state.index, 0);
      expect(cubit.state.error, 'Could not save');
      expect(cubit.state.saving, isFalse);
    });

    test('after the last product it is finished with the count of completed ones', () async {
      cubit.setCategory('c1');
      await cubit.saveAndNext();
      await cubit.skip();
      cubit.setCategory('c1');
      await cubit.saveAndNext();
      expect(cubit.state.finished, isTrue);
      expect(cubit.state.done, 2);
    });

    test('nothing to complete: finished at once', () async {
      final empty = CompleteDetailsCubit(repository: _Repo(), imageUpload: _Upload());
      await empty.load();
      expect(empty.state.finished, isTrue);
      expect(empty.state.total, 0);
      await empty.close();
    });
  });

  group('screens', () {
    void bigWindow(WidgetTester tester) {
      final prev = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.exceptionAsString().contains('overflowed')) return;
        prev?.call(d);
      };
      addTearDown(() => FlutterError.onError = prev);
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Future<_Repo> pumpProducts(
      WidgetTester tester, {
      List<String> keys = const [],
      String role = 'owner',
    }) async {
      bigWindow(tester);
      final repo = _Repo(items: [_item('a', ['image'])]);
      for (final t in [ProductsListCubit, CategoriesCubit, BrandsCubit]) {
        if (t == ProductsListCubit && sl.isRegistered<ProductsListCubit>()) sl.unregister<ProductsListCubit>();
        if (t == CategoriesCubit && sl.isRegistered<CategoriesCubit>()) sl.unregister<CategoriesCubit>();
        if (t == BrandsCubit && sl.isRegistered<BrandsCubit>()) sl.unregister<BrandsCubit>();
      }
      sl.registerFactory(() => ProductsListCubit(
            getProductsUseCase: GetProductsUseCase(repo),
            deleteProductUseCase: DeleteProductUseCase(repo),
            updateProductUseCase: UpdateProductUseCase(repo),
            getProductByBarcodeUseCase: GetProductByBarcodeUseCase(repo),
            getProductByIdUseCase: GetProductByIdUseCase(repo),
          ));
      sl.registerFactory(() => CategoriesCubit(
            getCategoriesUseCase: GetCategoriesUseCase(repo),
            createCategoryUseCase: CreateCategoryUseCase(repo),
          ));
      sl.registerFactory(() => BrandsCubit(
            getBrandsUseCase: GetBrandsUseCase(repo),
            createBrandUseCase: CreateBrandUseCase(repo),
          ));
      final user = makeUser(role: role, keys: keys);
      final access = AccessCubit(
        fetchCurrentUser: () async => user,
        loadCachedUser: () async => user,
      )..apply(user);
      await tester.pumpWidget(BlocProvider<AccessCubit>.value(
        value: access,
        child: const MaterialApp(home: Scaffold(body: ProductsListPage())),
      ));
      await tester.pumpAndSettle();
      return repo;
    }

    tearDown(() {
      if (sl.isRegistered<ProductsListCubit>()) sl.unregister<ProductsListCubit>();
      if (sl.isRegistered<CategoriesCubit>()) sl.unregister<CategoriesCubit>();
      if (sl.isRegistered<BrandsCubit>()) sl.unregister<BrandsCubit>();
    });

    testWidgets('Products list: Quick Add button is there for someone who may add products',
        (tester) async {
      await pumpProducts(tester);
      expect(find.byKey(const ValueKey('products-quick-add-button')), findsOneWidget);
      expect(find.text('Quick Add (Scan)'), findsOneWidget);
    });

    testWidgets('Products list: a cashier does not see Quick Add', (tester) async {
      await pumpProducts(tester, role: 'cashier', keys: cashierKeys);
      expect(find.byKey(const ValueKey('products-quick-add-button')), findsNothing);
    });

    testWidgets('Products list: the Needs details chip filters on the server and offers Complete details',
        (tester) async {
      final repo = await pumpProducts(tester);
      expect(find.byKey(const ValueKey('products-complete-details-button')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('products-needs-details-chip')));
      await tester.pumpAndSettle();
      expect(repo.needsAttentionCalls.last, isTrue);
      expect(find.byKey(const ValueKey('products-complete-details-button')), findsOneWidget);
      expect(find.text('Product a'), findsWidgets);

      await tester.tap(find.byKey(const ValueKey('products-needs-details-chip')));
      await tester.pumpAndSettle();
      expect(repo.needsAttentionCalls.last, isNull);
      expect(find.byKey(const ValueKey('products-complete-details-button')), findsNothing);
    });

    testWidgets('Products list: a new business sees "Add your products by scanning"', (tester) async {
      await pumpProducts(tester); // the fake returns an empty list without the filter
      expect(find.byKey(const ValueKey('products-empty-scan-cta')), findsOneWidget);
      expect(find.text('Add your products by scanning'), findsOneWidget);
    });

    testWidgets('Complete details page shows the progress and saves', (tester) async {
      bigWindow(tester);
      final repo = _Repo(items: [
        _item('a', ['category']),
        _item('b', ['category']),
      ]);
      final cubit = CompleteDetailsCubit(repository: repo, imageUpload: _Upload());
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: CompleteDetailsPage(cubit: cubit))));
      // load() awaits fake futures: run it inside the test zone.
      cubit.load();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('1 of 2'), findsOneWidget);
      expect(find.text('Product a'), findsOneWidget);
      cubit.setCategory('c1');
      await tester.tap(find.text('Save and next'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.text('2 of 2'), findsOneWidget);
      expect(repo.updates.single.$2['category_id'], 'c1');
      await cubit.close();
    });
  });
}
