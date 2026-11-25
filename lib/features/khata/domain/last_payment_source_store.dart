import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:injectable/injectable.dart';

/// Remembers where the owner last paid a supplier from, on this device.
abstract class LastPaymentSourceStore {
  PaymentSource? read();
  Future<void> write(PaymentSource source);
}

@LazySingleton(as: LastPaymentSourceStore)
class PrefsLastPaymentSourceStore implements LastPaymentSourceStore {
  PrefsLastPaymentSourceStore(this._prefs);

  final PreferencesStorage _prefs;

  @override
  PaymentSource? read() => PaymentSource.fromApi(_prefs.getLastPaymentSource());

  @override
  Future<void> write(PaymentSource source) async {
    await _prefs.setLastPaymentSource(source.apiValue);
  }
}
