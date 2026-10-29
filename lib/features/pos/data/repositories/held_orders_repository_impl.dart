import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';

/// Drift-backed [HeldOrdersRepository].
class HeldOrdersRepositoryImpl implements HeldOrdersRepository {
  const HeldOrdersRepositoryImpl(this._dao);

  final HeldOrdersDao _dao;

  @override
  Future<List<HeldOrderModel>> list(HeldOrderScope scope) =>
      _dao.getHeldOrdersFor(scope);

  @override
  Future<HeldOrderModel?> find(String id, HeldOrderScope scope) =>
      _dao.getHeldOrderForScope(id, scope);

  @override
  Future<void> save(HeldOrderModel order, HeldOrderScope scope) =>
      _dao.saveHeldOrder(order, scope: scope);

  @override
  Future<void> delete(String id) => _dao.deleteHeldOrder(id);
}
