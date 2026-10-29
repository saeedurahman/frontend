import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';

/// Parked ("held") carts, stored on this device only.
///
/// Every read and write is scoped to one business + branch + cashier
/// ([HeldOrderScope]); a cashier can never see or resume another's parked order.
abstract class HeldOrdersRepository {
  Future<List<HeldOrderModel>> list(HeldOrderScope scope);

  Future<HeldOrderModel?> find(String id, HeldOrderScope scope);

  Future<void> save(HeldOrderModel order, HeldOrderScope scope);

  Future<void> delete(String id);
}
