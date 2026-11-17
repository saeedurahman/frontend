// The product form, typed into one key at a time with the REAL cubit (real
// use cases and repository over a fake HTTP layer). Regression for numeric
// fields turning "730" into "037": a field must keep its caret while the cubit
// emits and the page rebuilds.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_unit_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_units_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/units_cubit.dart';
import 'package:frantend/features/products/presentation/pages/product_form_page.dart';

import '../helpers/fake_http.dart';
import '../helpers/form_typing.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Local extends Fake implements ProductsLocalDataSource {}

class _Probe extends Fake implements ConnectivityProbe {}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => null;
}

class _Images extends Fake implements ImageUploadService {}

void _swap<T extends Object>(T Function() make) {
  if (sl.isRegistered<T>()) sl.unregister<T>();
  sl.registerFactory<T>(make);
}

void main() {
  late ProductFormCubit cubit;

  setUp(() {
    final adapter = FakeAdapter((o) => jsonResponse(<dynamic>[]));
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
    final repo = ProductsRepositoryImpl(
      remoteDataSource: ProductsRemoteDataSourceImpl(_Dio(dio)),
      localDataSource: _Local(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
    );
    cubit = ProductFormCubit(
      getProductByIdUseCase: GetProductByIdUseCase(repo),
      createProductUseCase: CreateProductUseCase(repo),
      updateProductUseCase: UpdateProductUseCase(repo),
      addVariationUseCase: AddVariationUseCase(repo),
      addBarcodeUseCase: AddBarcodeUseCase(repo),
      getPriceListsUseCase: GetPriceListsUseCase(repo),
      getProductPriceUseCase: GetProductPriceUseCase(repo),
      setProductPriceUseCase: SetProductPriceUseCase(repo),
      imageUploadService: _Images(),
      authLocalDataSource: _Auth(),
    );
    _swap<ProductFormCubit>(() => cubit);
    _swap<CategoriesCubit>(() => CategoriesCubit(
          getCategoriesUseCase: GetCategoriesUseCase(repo),
          createCategoryUseCase: CreateCategoryUseCase(repo),
        ));
    _swap<BrandsCubit>(() => BrandsCubit(
          getBrandsUseCase: GetBrandsUseCase(repo),
          createBrandUseCase: CreateBrandUseCase(repo),
        ));
    _swap<UnitsCubit>(() => UnitsCubit(
          getUnitsUseCase: GetUnitsUseCase(repo),
          createUnitUseCase: CreateUnitUseCase(repo),
        ));
  });

  Future<void> open(WidgetTester t) async {
    ignoreOverflowErrors();
    t.view.physicalSize = const Size(1400, 2600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(
      home: Scaffold(body: ProductFormPage(taxRatesLoader: () async => const [])),
    ));
    await t.pumpAndSettle();
  }

  Future<void> chooseTracking(WidgetTester t, String label) async {
    await t.tap(find.widgetWithText(DropdownButtonFormField<String>, 'Tracking Type *'));
    await t.pumpAndSettle();
    await t.tap(find.text(label).last);
    await t.pumpAndSettle();
  }

  testWidgets('Tracking = Expiry, then "730" in Shelf Life stays "730"', (t) async {
    await open(t);
    await chooseTracking(t, 'Expiry');
    expect(cubit.state.trackingType, 'expiry');

    final field = find.byKey(const Key('product-shelf-life'));
    await typeCharByChar(t, field, '730', afterEach: (i, typed) {
      expect(cubit.state.shelfLifeDays, int.parse(typed), reason: 'cubit after "$typed"');
    });
    expect(shownIn(t, field), '730');
    expect(cubit.state.shelfLifeDays, 730);
  });

  testWidgets('Min Stock "10" and Max Stock "100" stay as typed', (t) async {
    await open(t);
    final min = find.byKey(const Key('product-min-stock'));
    final max = find.byKey(const Key('product-max-stock'));

    await typeCharByChar(t, min, '10', afterEach: (_, typed) {
      expect(cubit.state.minStockLevel, typed);
    });
    await typeCharByChar(t, max, '100', afterEach: (_, typed) {
      expect(cubit.state.maxStockLevel, typed);
    });
    expect(shownIn(t, min), '10');
    expect(shownIn(t, max), '100');
    // Typing in the second field did not disturb the first.
    expect(cubit.state.minStockLevel, '10');
  });

  testWidgets('a decimal "12.50" types through; leading zeros and letters are not kept', (t) async {
    await open(t);
    final min = find.byKey(const Key('product-min-stock'));
    await typeCharByChar(t, min, '12.50', afterEach: (_, typed) {
      expect(cubit.state.minStockLevel, typed);
    });
    expect(shownIn(t, min), '12.50');

    // "007" is shown as "7", and a letter is dropped.
    final max = find.byKey(const Key('product-max-stock'));
    await focusField(t, max);
    await typeKey(t, max, '0');
    await typeKey(t, max, '0');
    await typeKey(t, max, '7');
    expect(shownIn(t, max), '7');
    await typeKey(t, max, 'x');
    expect(shownIn(t, max), '7');
    expect(cubit.state.maxStockLevel, '7');
  });

  testWidgets('name and SKU keep their caret when typing in the middle', (t) async {
    await open(t);
    final name = find.byKey(const Key('product-name'));
    await typeCharByChar(t, name, 'Panadol', afterEach: (_, typed) {
      expect(cubit.state.name, typed);
    });
    // Put the caret after "Pan" and type "-": it must land there, not at the end.
    editableState(t, name).userUpdateTextEditingValue(
      const TextEditingValue(text: 'Panadol', selection: TextSelection.collapsed(offset: 3)),
      SelectionChangedCause.tap,
    );
    await t.pump();
    await typeKey(t, name, '-');
    expect(shownIn(t, name), 'Pan-adol');
    await typeKey(t, name, '-');
    expect(shownIn(t, name), 'Pan--adol');
    expect(cubit.state.name, 'Pan--adol');

    final sku = find.byKey(const Key('product-sku'));
    await typeCharByChar(t, sku, 'PAN-01', afterEach: (_, typed) {
      expect(cubit.state.sku, typed);
    });
  });

  testWidgets('the field follows the cubit when it is not being typed in', (t) async {
    await open(t);
    final name = find.byKey(const Key('product-name'));
    cubit.updateName('From cubit');
    await settle(t);
    expect(shownIn(t, name), 'From cubit');
  });

  testWidgets('variation and barcode rows keep what is typed', (t) async {
    await open(t);
    cubit.addVariationRow();
    await settle(t);
    // The Variations tab.
    await t.tap(find.text('Variations'));
    await t.pumpAndSettle();
    final vname = find.byKey(const Key('variation-name-0'));
    await typeCharByChar(t, vname, 'Strip of 10', afterEach: (_, typed) {
      expect(cubit.state.variations.first.name, typed);
    });
    final weight = find.byKey(const Key('variation-weight-0'));
    await typeCharByChar(t, weight, '12.5', afterEach: (_, typed) {
      expect(cubit.state.variations.first.weightGrams, typed);
    });

    await t.tap(find.text('Barcodes'));
    await t.pumpAndSettle();
    cubit.addBarcodeRow();
    await settle(t);
    final code = find.byKey(const Key('barcode-value-0'));
    await typeCharByChar(t, code, '6281234567890', afterEach: (_, typed) {
      expect(cubit.state.barcodes.first.barcode, typed);
    });
  });
}
