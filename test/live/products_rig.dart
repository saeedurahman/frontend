// Real products stack over a real Dio: remote datasource -> the app's offline
// repository decorator -> use cases -> cubits, with a real (in-memory) local
// database and catalog like the app uses. Only the network target is a test
// backend.
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';

import 'live_backend.dart';

class _Probe extends Fake implements ConnectivityProbe {
  @override
  bool get isReachable => true;
}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => null;
}

class _Images extends Fake implements ImageUploadService {}

/// In-memory stand-in for the master-data JSON cache.
class MemoryProductsCache implements ProductsLocalDataSource {
  @override
  Future<void> cacheBrands(List<BrandModel> brands) async {}
  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {}
  @override
  Future<void> cacheProducts(List<ProductListItemModel> products) async {}
  @override
  Future<void> cacheUnits(List<UnitModel> units) async {}
  @override
  Future<List<BrandModel>> getCachedBrands() async => [];
  @override
  Future<List<CategoryModel>> getCachedCategories() async => [];
  @override
  Future<List<ProductListItemModel>> getCachedProducts() async => [];
  @override
  Future<List<UnitModel>> getCachedUnits() async => [];
}

class ProductsRig {
  ProductsRig(this.tenant) {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = SyncStore(db);
    catalog = LocalCatalog(store, businessId: () async => tenant.businessId);
    repo = OfflineProductsRepository(
      remoteDataSource: ProductsRemoteDataSourceImpl(tenant.client),
      localDataSource: MemoryProductsCache(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
      catalog: catalog,
      isReachable: () => true,
      afterWrite: () => afterWrites++,
    );
    form = ProductFormCubit(
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
    list = ProductsListCubit(
      getProductsUseCase: GetProductsUseCase(repo),
      deleteProductUseCase: DeleteProductUseCase(repo),
      updateProductUseCase: UpdateProductUseCase(repo),
      getProductByBarcodeUseCase: GetProductByBarcodeUseCase(repo),
      getProductByIdUseCase: GetProductByIdUseCase(repo),
    );
  }

  final LiveTenant tenant;

  /// How many times the repository asked for a pull after a server write.
  int afterWrites = 0;
  late final AppDatabase db;
  late final SyncStore store;
  late final LocalCatalog catalog;
  late final OfflineProductsRepository repo;
  late final ProductFormCubit form;
  late final ProductsListCubit list;

  Future<void> dispose() async {
    await form.close();
    await list.close();
    store.dispose();
    await db.close();
  }
}
