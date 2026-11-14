import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/receipt_share_service.dart';

import '../helpers/fake_http.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class FakeUrlLauncherService implements UrlLauncherService {
  Uri? launchedUri;

  @override
  Future<bool> launch(Uri uri, {bool externalApplication = true}) async {
    launchedUri = uri;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReceiptShareService WhatsApp sharing and E.164 formatting', () {
    test('formatE164 converts local Pakistani and international numbers to E.164 digits', () {
      expect(ReceiptShareService.formatE164('03001234567'), '923001234567');
      expect(ReceiptShareService.formatE164('0321-9876543'), '923219876543');
      expect(ReceiptShareService.formatE164('3001234567'), '923001234567');
      expect(ReceiptShareService.formatE164('+92 300 1234567'), '923001234567');
      expect(ReceiptShareService.formatE164('00923001234567'), '923001234567');
      expect(ReceiptShareService.formatE164('+447123456789'), '447123456789');
    });

    test('buildPlainTextReceipt formats plain text receipt with items and totals', () async {
      const sale = SaleResponseModel(
        id: 'sale-1',
        branchId: 'br1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'POS-001',
        totalAmount: '1250.00',
        offline: true,
        lines: [
          SaleLineModel(
            id: 'line-1',
            productId: 'p1',
            productName: 'Basmati Rice 5kg',
            qty: '1',
            unitPrice: '1050.00',
          ),
          SaleLineModel(
            id: 'line-2',
            productId: 'p2',
            productName: 'Mineral Water 1.5L',
            qty: '2',
            unitPrice: '100.00',
          ),
        ],
      );

      final text = await ReceiptShareService.buildPlainTextReceipt(sale);
      expect(text, contains('Basmati Rice 5kg'));
      expect(text, contains('Mineral Water 1.5L'));
      expect(text, contains('TOTAL:'));
      expect(text, contains('POS-001'));
    });

    test('getOnlineReceiptLink fetches link from POST /sales/{id}/receipt-link when online', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test'));
      dio.httpClientAdapter = FakeAdapter((options) {
        if (options.path == ApiConstants.saleReceiptLink('s-123') && options.method == 'POST') {
          return jsonResponse({
            'url': 'http://test/r/token-abc-123',
            'expires_at': '2026-06-20T12:00:00Z',
          }, status: 201);
        }
        return jsonResponse({}, status: 404);
      });

      if (sl.isRegistered<DioClient>()) sl.unregister<DioClient>();
      sl.registerSingleton<DioClient>(_Dio(dio));

      const sale = SaleResponseModel(
        id: 's-123',
        branchId: 'br1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'REC-123',
        totalAmount: '500.00',
        offline: false,
      );

      final link = await ReceiptShareService.getOnlineReceiptLink(sale);
      expect(link, 'http://test/r/token-abc-123');
    });

    test('getOnlineReceiptLink silently falls back to null when offline without throwing', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test'));
      dio.httpClientAdapter = FakeAdapter((options) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      });

      if (sl.isRegistered<DioClient>()) sl.unregister<DioClient>();
      sl.registerSingleton<DioClient>(_Dio(dio));

      const sale = SaleResponseModel(
        id: 's-offline',
        branchId: 'br1',
        saleType: 'pos',
        saleStatus: 'completed',
        saleNumber: 'OFF-001',
        totalAmount: '500.00',
        offline: true,
      );

      final link = await ReceiptShareService.getOnlineReceiptLink(sale);
      expect(link, isNull); // Silent fallback to plain text!
    });
  });
}
