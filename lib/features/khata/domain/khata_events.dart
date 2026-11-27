import 'dart:async';

import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:injectable/injectable.dart';

/// Tells the open screens that money moved on a customer or supplier account
/// (a payment, a reversal, a bill paid at receiving), so supplier lists,
/// purchases and the dashboard refresh their numbers.
@lazySingleton
class KhataEvents {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get changes => _controller.stream;

  void notifyChanged() {
    if (!_controller.isClosed) _controller.add(null);
    // The same news for every list and ledger that watches its data.
    DataChangeBus.instance.publish(const {
      DataTopic.customers,
      DataTopic.customerLedger,
      DataTopic.suppliers,
      DataTopic.supplierLedger,
      DataTopic.purchases,
      DataTopic.shifts,
      DataTopic.cashMovements,
    });
  }
}
