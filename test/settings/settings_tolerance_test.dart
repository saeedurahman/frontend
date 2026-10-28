import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';

Map<String, dynamic> _setting(String key, Object? value) => {
      'id': key,
      'business_id': 'b1',
      'setting_key': key,
      'setting_value': value,
    };

void main() {
  test('cashier-filtered settings parse and missing keys read as null', () {
    final parsed = SettingsRemoteDataSourceImpl.parseSettingsList([
      _setting('receipt.footer_text', {'value': 'Thanks'}),
      _setting('tax.default_rate_id', {'value': 'tax-1'}),
      _setting('business.logo_url', {'value': 'http://x/logo.png'}),
    ]);

    expect(parsed, hasLength(3));
    expect(
      SettingsValueUtils.valueForKey(parsed, SettingKeys.taxDefaultRateId),
      'tax-1',
    );
    // Keys the role cannot see simply resolve to null.
    expect(SettingsValueUtils.valueForKey(parsed, 'inventory.low_stock'), isNull);
  });

  test('one malformed entry does not fail the whole read', () {
    final parsed = SettingsRemoteDataSourceImpl.parseSettingsList([
      _setting('receipt.show_tax', {'value': true}),
      _setting('sale.broken', 'not-a-map'),
      'junk',
      _setting('receipt.paper_size', {'value': '58mm'}),
    ]);

    expect(parsed.map((s) => s.settingKey),
        ['receipt.show_tax', 'receipt.paper_size']);
  });

  test('non-list payload yields an empty list', () {
    expect(SettingsRemoteDataSourceImpl.parseSettingsList({'detail': 'x'}),
        isEmpty);
    expect(SettingsRemoteDataSourceImpl.parseSettingsList(null), isEmpty);
  });
}
