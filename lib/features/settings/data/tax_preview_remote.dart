import 'package:decimal/decimal.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/settings/presentation/cubit/tax_prices_cubit.dart';

/// `GET /settings/tax-preview?price&qty&rate` (needs `sales.create`): what the
/// server would charge for one example line under the settings in force.
/// Returns null on any failure so the screen falls back to the local engine.
class TaxPreviewRemote {
  TaxPreviewRemote(this._dioClient);

  final DioClient _dioClient;

  Future<TaxExample?> fetch({
    required Decimal price,
    required Decimal qty,
    required Decimal rate,
    required bool inclusive,
  }) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        '/settings/tax-preview',
        queryParameters: {
          'price': price.toString(),
          'qty': qty.toString(),
          'rate': rate.toString(),
        },
      );
      final data = response.data;
      if (data == null) return null;
      Decimal d(Object? v) => Decimal.tryParse('${v ?? ''}') ?? Decimal.zero;
      final tax = d(data['total_tax'] ?? data['tax_amount']);
      final total = d(data['total_amount'] ?? data['line_total']);
      if (total == Decimal.zero) return null;
      return TaxExample(
        price: price,
        rate: rate,
        tax: tax,
        total: total,
        inclusive: inclusive,
        fromServer: true,
      );
    } catch (_) {
      return null;
    }
  }
}
