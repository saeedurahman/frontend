// Product save with variations and barcodes (regression).
//
// 1. The product response now embeds a slim CategoryBrief {id, name, parent_id}
//    (no business_id, no slug, no children). Parsing it used to throw
//    "type 'Null' is not a subtype of type 'String' in type cast" AFTER the
//    server had created the product, so the form showed an error, never
//    popped, and the list was never refreshed.
// 2. The create request carries variations[].barcodes and barcodes in one body.
import 'dart:convert';

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
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/products/presentation/utils/variation_utils.dart';

import '../helpers/fake_http.dart';

/// What `POST /products` returns today (captured from the running backend).
Map<String, dynamic> productResponse({Object? stockMin = '10.0000'}) => {
      'created_at': '2026-11-17T16:12:19.763436Z',
      'updated_at': '2026-11-17T16:12:19.750975Z',
      'id': 'p1',
      'business_id': 'b1',
      'name': 'Panadol',
      'sku': null,
      'product_type': 'standard',
      'tracking_type': 'expiry',
      'is_sellable': true,
      'is_purchasable': true,
      'is_active': true,
      'tax_rate_id': null,
      'tax_rate': null,
      'is_tax_exempt': false,
      'description': null,
      'image_url': null,
      'shelf_life_days': 730,
      'track_expiry': true,
      'name_secondary': null,
      'min_stock_level': stockMin,
      'max_stock_level': null,
      // CategoryBrief: nothing but id, name and parent_id.
      'category': {'id': 'c1', 'name': 'Painkillers', 'parent_id': null},
      'brand': {
        'created_at': '2026-11-17T16:12:19.708390Z',
        'updated_at': '2026-11-17T16:12:19.708390Z',
        'id': 'br1',
        'business_id': 'b1',
        'name': 'GSK',
        'is_active': true,
      },
      'base_unit': {
        'created_at': '2026-11-17T16:12:19.708390Z',
        'updated_at': '2026-11-17T16:12:19.708390Z',
        'id': 'u1',
        'business_id': 'b1',
        'name': 'Piece',
        'symbol': 'pc',
        'is_base_unit': true,
        'allows_decimal': false,
        'is_active': true,
      },
      'variations': [
        {
          'created_at': '2026-11-17T16:12:19.763436Z',
          'updated_at': '2026-11-17T16:12:19.763436Z',
          'id': 'v1',
          'business_id': 'b1',
          'product_id': 'p1',
          'name': 'Strip of 10',
          'sku': null,
          'unit_id': null,
          'is_default': true,
          'is_active': true,
          'weight_grams': '12.5000',
          'barcodes': [
            {
              'id': 'bc1',
              'product_id': 'p1',
              'variation_id': 'v1',
              'barcode': '6281001',
              'barcode_type': 'EAN13',
              'is_primary': true,
            },
          ],
          'unit': null,
        },
      ],
      'barcodes': [
        {
          'id': 'bc2',
          'product_id': 'p1',
          'variation_id': null,
          'barcode': '6281002',
          'barcode_type': 'EAN13',
          'is_primary': false,
        },
      ],
    };

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Local extends Fake implements ProductsLocalDataSource {}

class _Probe extends Fake implements ConnectivityProbe {
  @override
  bool get isReachable => true;
}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => null;
}

class _Images extends Fake implements ImageUploadService {}

void main() {
  group('models parse the current backend response', () {
    test('a product with a slim category, brand, unit, nested barcodes', () {
      final p = ProductModel.fromJson(productResponse());
      expect(p.category?.id, 'c1');
      expect(p.category?.name, 'Painkillers');
      expect(p.category?.businessId, '');
      expect(p.category?.slug, isNull);
      expect(p.category?.children, isEmpty);
      expect(p.brand?.name, 'GSK');
      expect(p.baseUnit?.symbol, 'pc');
      expect(p.variations.single.barcodes.single.barcode, '6281001');
      expect(p.variations.single.weightGrams, '12.5000');
      expect(p.barcodes.single.variationId, isNull);
      expect(p.shelfLifeDays, 730);
      expect(p.trackExpiry, isTrue);
    });

    test('numbers where text is expected, nulls and missing keys do not throw', () {
      final json = productResponse(stockMin: 10)
        ..['category'] = null
        ..['brand'] = null
        ..['base_unit'] = null
        ..remove('barcodes')
        ..['shelf_life_days'] = '730'
        ..['tax_rate'] = 15;
      final v = (json['variations'] as List).first as Map<String, dynamic>;
      v['weight_grams'] = 12.5;
      final p = ProductModel.fromJson(json);
      expect(p.minStockLevel, '10');
      expect(p.shelfLifeDays, 730);
      expect(p.taxRate, '15');
      expect(p.variations.single.weightGrams, '12.5');
      expect(p.barcodes, isEmpty);
      expect(p.category, isNull);
    });

    test('a full category (list endpoint) still parses, children included', () {
      final c = CategoryModel.fromJson({
        'id': 'c1',
        'business_id': 'b1',
        'parent_id': null,
        'name': 'Drugs',
        'slug': 'drugs',
        'sort_order': 0,
        'is_active': true,
        'created_at': 'x',
        'updated_at': 'x',
        'children': [
          {'id': 'c2', 'business_id': 'b1', 'name': 'Syrups', 'slug': null, 'parent_id': 'c1'},
        ],
      });
      expect(c.children.single.name, 'Syrups');
      expect(c.slug, 'drugs');
    });
  });

  group('createBarcodePayload', () {
    const v0 = VariationFormItem(name: 'Strip', isDefault: true);
    const v1 = VariationFormItem(name: 'Box', sku: 'B-1', weightGrams: '5');
    const unnamed = VariationFormItem();

    test('variation barcodes go inside their variation, the rest to the product', () {
      final out = createBarcodePayload(
        [v0, v1],
        const [
          BarcodeFormItem(barcode: '1111', variationId: 'local:0', isPrimary: true),
          BarcodeFormItem(barcode: '2222', variationId: 'local:1'),
          BarcodeFormItem(barcode: '3333'),
          BarcodeFormItem(barcode: ''),
        ],
      );
      final vars = out['variations'] as List;
      expect((vars[0] as Map)['barcodes'], [
        {'barcode': '1111', 'barcode_type': 'EAN13', 'is_primary': true},
      ]);
      expect((vars[1] as Map)['barcodes'], [
        {'barcode': '2222', 'barcode_type': 'EAN13', 'is_primary': false},
      ]);
      expect((vars[1] as Map)['sku'], 'B-1');
      expect((vars[1] as Map)['weight_grams'], '5');
      expect(out['barcodes'], [
        {'barcode': '3333', 'barcode_type': 'EAN13', 'is_primary': false},
      ]);
    });

    test('a barcode on an unnamed (unsent) row falls back to the product', () {
      final out = createBarcodePayload(
        [v0, unnamed],
        const [BarcodeFormItem(barcode: '4444', variationId: 'local:1')],
      );
      expect((out['variations'] as List), hasLength(1));
      expect(((out['variations'] as List).single as Map).containsKey('barcodes'), isFalse);
      expect((out['barcodes'] as List).single['barcode'], '4444');
    });

    test('only the first primary stays primary; no variations, no keys', () {
      final out = createBarcodePayload(
        const [],
        const [
          BarcodeFormItem(barcode: '5555', isPrimary: true),
          BarcodeFormItem(barcode: '6666', isPrimary: true),
        ],
      );
      expect(out.containsKey('variations'), isFalse);
      expect((out['barcodes'] as List).map((b) => (b as Map)['is_primary']), [true, false]);
      expect(createBarcodePayload(const [], const []), isEmpty);
    });
  });

  group('form cubit, real use cases + repository over the current response', () {
    late List<RequestOptions> requests;
    late ProductFormCubit cubit;

    setUp(() {
      requests = [];
      final adapter = FakeAdapter((o) {
        requests.add(o);
        if (o.method == 'POST' && o.path.endsWith('/products')) {
          return jsonResponse(productResponse(), status: 201);
        }
        return jsonResponse(<String, dynamic>{});
      });
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
    });
    tearDown(() => cubit.close());

    test('save returns the id (no "Null is not a subtype") and posts ONE request', () async {
      cubit
        ..initCreate()
        ..updateName('Panadol')
        ..updateBaseUnitId('u1')
        ..updateCategoryId('c1')
        ..addVariationRow()
        ..addVariationRow();
      cubit
        ..updateVariationRow(0, cubit.state.variations[0].copyWith(name: 'Strip of 10'))
        ..updateVariationRow(1, cubit.state.variations[1].copyWith(name: 'Box'))
        ..addBarcodeRow()
        ..addBarcodeRow();
      cubit
        ..updateBarcodeRow(0, const BarcodeFormItem(barcode: '6281001', variationId: 'local:0'))
        ..updateBarcodeRow(1, const BarcodeFormItem(barcode: '6281002'));

      final id = await cubit.submit();

      expect(id, 'p1', reason: 'errors: ${cubit.state.errors}');
      expect(cubit.state.errors, isEmpty);
      expect(cubit.state.isSubmitting, isFalse);
      // One atomic POST: nothing is added to the product afterwards.
      expect(requests.where((r) => r.method == 'POST').length, 1);
      final body = jsonDecode(jsonEncode(requests.single.data)) as Map<String, dynamic>;
      expect(body['category_id'], 'c1');
      final vars = body['variations'] as List;
      expect((vars[0] as Map)['barcodes'], [
        {'barcode': '6281001', 'barcode_type': 'EAN13', 'is_primary': true},
      ]);
      expect((vars[1] as Map).containsKey('barcodes'), isFalse);
      expect(body['barcodes'], [
        {'barcode': '6281002', 'barcode_type': 'EAN13', 'is_primary': false},
      ]);
    });
  });
}
