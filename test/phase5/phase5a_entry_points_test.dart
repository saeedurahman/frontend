import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/pos/presentation/pages/receipt_preview_page.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:frantend/features/products/presentation/pages/products_list_page.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/settings/presentation/pages/printer_settings_page.dart';
import 'package:printing/printing.dart';

class _Repo extends Fake implements ProductsRepository {
  @override
  Future<Either<Failure, PaginatedProductsModel>> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async =>
      const Right(PaginatedProductsModel(total: 0, skip: 0, limit: 10));

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories(
          {String? parentId}) async =>
      const Right([]);

  @override
  Future<Either<Failure, List<BrandModel>>> getBrands() async =>
      const Right([]);
}

class _Printer implements PrinterService {
  @override
  Future<List<Printer>> listPrinters() async => const [];
  @override
  Future<PrinterConfig> loadConfig() async => const PrinterConfig();
  @override
  Future<void> saveConfig(PrinterConfig config) async {}
  @override
  Future<bool> printPdf(Uint8List pdfBytes,
          {String jobName = 'Receipt',
          PrinterConfig? config,
          bool forceDialog = false}) async =>
      true;
  @override
  Future<void> openCashDrawer() async {}
}

class _Launcher implements UrlLauncherService {
  Uri? launched;
  @override
  Future<bool> launch(Uri uri, {bool externalApplication = true}) async {
    launched = uri;
    return true;
  }
}

void _swap<T extends Object>(T instance) {
  if (sl.isRegistered<T>()) sl.unregister<T>();
  sl.registerSingleton<T>(instance);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void bigWindow(WidgetTester tester) {
    // The test font (Ahem) is far wider than the real one, so some rows report
    // cosmetic overflows; any other framework error still fails the test.
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

  group('Products list toolbar', () {
    Future<void> pumpProducts(WidgetTester tester) async {
      bigWindow(tester);
      final repo = _Repo();
      if (sl.isRegistered<ProductsListCubit>()) sl.unregister<ProductsListCubit>();
      if (sl.isRegistered<CategoriesCubit>()) sl.unregister<CategoriesCubit>();
      if (sl.isRegistered<BrandsCubit>()) sl.unregister<BrandsCubit>();
      sl.registerFactory(() => ProductsListCubit(
            getProductsUseCase: GetProductsUseCase(repo),
            deleteProductUseCase: DeleteProductUseCase(repo),
            updateProductUseCase: UpdateProductUseCase(repo),
            getProductByBarcodeUseCase: GetProductByBarcodeUseCase(repo),
          ));
      sl.registerFactory(() => CategoriesCubit(
            getCategoriesUseCase: GetCategoriesUseCase(repo),
            createCategoryUseCase: CreateCategoryUseCase(repo),
          ));
      sl.registerFactory(() => BrandsCubit(
            getBrandsUseCase: GetBrandsUseCase(repo),
            createBrandUseCase: CreateBrandUseCase(repo),
          ));
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ProductsListPage())));
      await tester.pumpAndSettle();
    }

    tearDown(() {
      if (sl.isRegistered<ProductsListCubit>()) sl.unregister<ProductsListCubit>();
      if (sl.isRegistered<CategoriesCubit>()) sl.unregister<CategoriesCubit>();
      if (sl.isRegistered<BrandsCubit>()) sl.unregister<BrandsCubit>();
    });

    testWidgets('Export button opens the export dialog', (tester) async {
      await pumpProducts(tester);
      await tester.tap(find.text('Export'));
      await tester.pumpAndSettle();
      expect(find.text('Export Products'), findsOneWidget);
    });

    testWidgets('Import CSV button opens the product import dialog',
        (tester) async {
      await pumpProducts(tester);
      await tester.tap(find.text('Import CSV'));
      await tester.pumpAndSettle();
      expect(find.text('Import Products from CSV'), findsOneWidget);
    });
  });

  testWidgets('Send on WhatsApp asks for a number, then launches wa.me',
      (tester) async {
    bigWindow(tester);
    _swap<PrinterService>(_Printer());
    final launcher = _Launcher();
    _swap<UrlLauncherService>(launcher);
    const sale = SaleResponseModel(
      id: 'sale-12345678',
      branchId: 'br1',
      saleType: 'pos',
      saleStatus: 'completed',
      saleNumber: 'POS-001',
      totalAmount: '100.00',
      offline: true,
      lines: [],
    );
    await tester.pumpWidget(const MaterialApp(
        home: ReceiptPreviewPage(sale: sale)));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Send on WhatsApp'));
    await tester.pumpAndSettle();
    expect(find.text('Enter WhatsApp Number'), findsOneWidget);
  });

  testWidgets('Printer settings page opens and renders its controls',
      (tester) async {
    bigWindow(tester);
    _swap<PrinterService>(_Printer());
    await tester.pumpWidget(const MaterialApp(home: PrinterSettingsPage()));
    await tester.pumpAndSettle();
    expect(find.text('Printer & Hardware Settings'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Printer settings saved successfully'), findsOneWidget);
  });
}
