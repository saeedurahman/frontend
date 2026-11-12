import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
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
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';

import '../helpers/fake_http.dart';

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

class _Get extends Fake implements GetProductByIdUseCase {}

class _Create extends Fake implements CreateProductUseCase {}

class _Update extends Fake implements UpdateProductUseCase {}

class _AddVar extends Fake implements AddVariationUseCase {}

class _AddBar extends Fake implements AddBarcodeUseCase {}

const _list = {
  'id': 'list-1',
  'business_id': 'b1',
  'name': 'Retail',
  'list_type': 'retail',
  'is_default': true,
  'is_active': true,
};

const _item = {
  'id': 'item-1',
  'price_list_id': 'list-1',
  'product_id': 'p1',
  'variation_id': null,
  'unit_price': '100.00',
  'min_qty': '1.0000',
};

ResponseBody _error(int status, String detail) =>
    jsonResponse({'detail': detail}, status: status);

class _Rig {
  _Rig(FakeHandler handler, {Future<String?> Function()? local}) {
    adapter = FakeAdapter(handler);
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = adapter;
    final repo = ProductsRepositoryImpl(
      remoteDataSource: ProductsRemoteDataSourceImpl(_Dio(dio)),
      localDataSource: _Local(),
      connectivityProbe: _Probe(),
      errorHandler: const ErrorHandler(),
    );
    cubit = ProductFormCubit(
      getProductByIdUseCase: _Get(),
      createProductUseCase: _Create(),
      updateProductUseCase: _Update(),
      addVariationUseCase: _AddVar(),
      addBarcodeUseCase: _AddBar(),
      getPriceListsUseCase: GetPriceListsUseCase(repo),
      getProductPriceUseCase: GetProductPriceUseCase(repo),
      setProductPriceUseCase: SetProductPriceUseCase(repo),
      imageUploadService: _Images(),
      authLocalDataSource: _Auth(),
      localDefaultPriceListId: local,
      onPriceSaved: (item) async {
        refreshed++;
        savedItems.add(item);
      },
    );
    // ignore: invalid_use_of_visible_for_testing_member
    cubit.emit(const ProductFormState(mode: 'edit', productId: 'p1'));
  }

  late final FakeAdapter adapter;
  late final ProductFormCubit cubit;
  int refreshed = 0;
  final savedItems = <Map<String, dynamic>>[];

  List<String> get calls =>
      adapter.requests.map((r) => '${r.method} ${r.path}').toList();
}

void main() {
  test('price set with the list present locally: no list lookup, saved via POST',
      () async {
    final rig = _Rig(
      (o) => jsonResponse(_item, status: 201),
      local: () async => 'list-1',
    );

    final ok = await rig.cubit.saveProductPrice(unitPrice: '100', minQty: '2');

    expect(ok, isTrue);
    expect(rig.calls, ['POST /prices/lists/list-1/items']);
    expect(rig.adapter.requests.single.data, {
      'unit_price': '100',
      'min_qty': '2',
      'product_id': 'p1',
    });
    expect(rig.cubit.state.priceSaveSuccess, isTrue);
    expect(rig.cubit.state.retailUnitPrice, '100.00');
    expect(rig.cubit.state.defaultPriceListId, 'list-1');
    expect(rig.refreshed, 1, reason: 'local data is refreshed after a save');
    expect(rig.savedItems.single, {
      'id': 'item-1',
      'price_list_id': 'list-1',
      'product_id': 'p1',
      'variation_id': null,
      'unit_price': '100.00',
      'min_qty': '1.0000',
    }, reason: 'the saved item is handed over in the sync-feed shape');
  });

  test('list missing locally: falls back to GET /prices/lists then saves', () async {
    final rig = _Rig(
      (o) => o.method == 'GET'
          ? jsonResponse([_list])
          : jsonResponse(_item, status: 201),
      local: () async => null,
    );

    final ok = await rig.cubit.saveProductPrice(unitPrice: '100');

    expect(ok, isTrue);
    expect(rig.calls, ['GET /prices/lists', 'POST /prices/lists/list-1/items']);
    expect(rig.refreshed, 1);
  });

  test('no list anywhere: asks the backend to create the default, then saves',
      () async {
    final rig = _Rig(
      (o) {
        if (o.method == 'GET') return jsonResponse([]);
        if (o.path == '/prices/lists') return jsonResponse(_list, status: 201);
        return jsonResponse(_item, status: 201);
      },
    );

    final ok = await rig.cubit.saveProductPrice(unitPrice: '100');

    expect(ok, isTrue);
    expect(rig.calls, [
      'GET /prices/lists',
      'POST /prices/lists',
      'POST /prices/lists/list-1/items',
    ]);
    expect(rig.adapter.requests[1].data,
        {'name': 'Retail', 'list_type': 'retail', 'is_default': true});
  });

  test('backend error on save is shown verbatim, never a generic Not Found',
      () async {
    final rig = _Rig(
      (o) => o.method == 'GET'
          ? jsonResponse([_list])
          : _error(400, 'Price cannot be negative'),
    );

    final ok = await rig.cubit.saveProductPrice(unitPrice: '100');

    expect(ok, isFalse);
    expect(rig.cubit.state.priceError, 'Price cannot be negative');
    expect(rig.cubit.state.priceSaveSuccess, isFalse);
    expect(rig.refreshed, 0, reason: 'nothing to refresh when the save failed');
  });

  test('list lookup failure surfaces the server message, not "No price list"',
      () async {
    final rig = _Rig((o) => _error(500, 'Database unavailable'));

    final ok = await rig.cubit.saveProductPrice(unitPrice: '100');

    expect(ok, isFalse);
    expect(rig.cubit.state.priceError, 'Database unavailable');
    expect(rig.calls, ['GET /prices/lists'], reason: 'no price POST without a list');
  });

  test('failure to create the default list surfaces the server message', () async {
    final rig = _Rig(
      (o) => o.method == 'GET'
          ? jsonResponse([])
          : _error(409, 'Price list name already exists'),
    );

    final ok = await rig.cubit.saveProductPrice(unitPrice: '100');

    expect(ok, isFalse);
    expect(rig.cubit.state.priceError, 'Price list name already exists');
  });

  test('invalid price is rejected before any lookup or request', () async {
    final rig = _Rig((o) => jsonResponse(_item), local: () async => 'list-1');
    expect(await rig.cubit.saveProductPrice(unitPrice: '0'), isFalse);
    expect(rig.adapter.requests, isEmpty);
  });
}
