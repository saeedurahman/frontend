import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';

import 'fake_sync_server.dart';

const kBusiness = 'biz-1';
const kBranch = 'branch-1';
const kUser = 'user-1';

/// Deterministic ids: id-1, id-2 ...
class CountingIds extends IdGenerator {
  int n = 0;
  @override
  String newId() => 'id-${++n}';
}

/// Everything the sync tests need, wired like production but in memory.
class SyncRig {
  SyncRig({DateTime? start, SyncConfig config = const SyncConfig(maxAttempts: 3)})
      : now = start ?? DateTime.utc(2026, 10, 29, 9),
        server = FakeSyncServer(),
        probe = FixedConnectivityProbe(),
        ids = CountingIds() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    this.config = config;
    _build();
  }

  DateTime now;
  final FakeSyncServer server;
  final FixedConnectivityProbe probe;
  final CountingIds ids;
  late AppDatabase db;
  late SyncConfig config;
  late SyncStore store;
  late OfflineWriter writer;
  late LocalCatalog catalog;
  late PushService push;
  late PullService pull;
  late SyncEngine engine;

  final List<PulledAccess> accessEvents = [];
  final List<String> revokedMessages = [];
  final List<List<String>> flagged = [];

  void _build() {
    store = SyncStore(db, clock: () => now);
    writer = OfflineWriter(
      store: store,
      ids: ids,
      deviceId: () async => 'a1b2c3d4-0000-4000-8000-000000000000',
      actingUser: () async => const ActingUser(
        id: kUser,
        name: 'Cashier',
        businessId: kBusiness,
        branchId: kBranch,
      ),
    );
    catalog = LocalCatalog(store, businessId: () async => kBusiness);
    push = PushService(store: store, api: server, ids: ids, config: config);
    pull = PullService(
      store: store,
      api: server,
      config: config,
      currentUserId: () async => kUser,
      onAccess: accessEvents.add,
    );
    engine = SyncEngine(
      store: store,
      push: push,
      pull: pull,
      probe: probe,
      config: config,
      hooks: SyncHooks(
        onDeviceRevoked: (m) async => revokedMessages.add(m),
        onFlaggedSales: flagged.add,
      ),
    );
  }

  /// "App restart": new store/services over the SAME database file.
  void restart() {
    engine.dispose();
    _build();
  }

  Future<void> dispose() async {
    engine.dispose();
    store.dispose();
    await db.close();
  }

  /// Runs one full push-then-pull cycle.
  Future<void> sync({bool manual = true}) => engine.syncNow(manual: manual);

  void advance(Duration d) => now = now.add(d);

  // ── server data ──────────────────────────────────────────────────────

  /// Catalog + register + customer + stock, as the server would deliver it.
  void seedServer({int stock = 10}) {
    server.put('settings', 'biz', {'business_name': 'Demo', 'allow_negative_stock': true});
    server.put('branch', kBranch, {'id': kBranch, 'name': 'Main', 'is_active': true});
    server.put('cash_register', 'reg-1', {
      'id': 'reg-1',
      'branch_id': kBranch,
      'name': 'Front',
      'is_active': true,
    });
    server.put('role', 'role-1', {
      'id': 'role-1',
      'name': 'Cashier',
      'permission_keys': ['sales.create', 'shifts.open'],
    });
    server.put('user', kUser, {
      'id': kUser,
      'name': 'Cashier',
      'role_ids': ['role-1'],
      'branch_ids': [kBranch],
    });
    server.put('category', 'cat-1', {'id': 'cat-1', 'name': 'Grocery', 'slug': 'grocery'});
    server.put('tax_rate', 'tax-1', {
      'id': 'tax-1',
      'name': 'GST',
      'rate': '5.00',
      'is_active': true,
    });
    product('p1', 'Rice 5kg', 'R5', price: '100.00', barcode: '8964000111111', stock: stock);
    server.put('customer', 'c1', {
      'id': 'c1',
      'name': 'Ali Traders',
      'phone': '0300',
      'credit_limit': '5000',
      'is_active': true,
      'balance': '-1000.00', // negative = owes
    });
  }

  void product(
    String id,
    String name,
    String sku, {
    String price = '10.00',
    String? barcode,
    int stock = 10,
    String category = 'cat-1',
  }) {
    server.put('product', id, {
      'id': id,
      'name': name,
      'sku': sku,
      'category_id': category,
      'is_active': true,
      'is_sellable': true,
      'product_type': 'standard',
      'tracking_type': 'none',
    });
    server.put('price_list', 'pl-1', {
      'id': 'pl-1',
      'name': 'Retail',
      'is_default': true,
      'is_active': true,
    });
    server.put('price_list_item', 'pli-$id', {
      'id': 'pli-$id',
      'price_list_id': 'pl-1',
      'product_id': id,
      'variation_id': null,
      'unit_price': price,
      'min_qty': '1',
    });
    if (barcode != null) {
      server.put('barcode', 'bc-$id', {
        'id': 'bc-$id',
        'product_id': id,
        'variation_id': null,
        'barcode': barcode,
      });
    }
    server.setStock(id, kBranch, stock);
  }

  // ── actions ──────────────────────────────────────────────────────────

  Map<String, dynamic> cartBody({
    String productId = 'p1',
    String qty = '2',
    String price = '100.00',
    String? customerId,
    String? shiftId,
    List<Map<String, dynamic>>? payments,
  }) =>
      {
        'branch_id': kBranch,
        'sale_type': 'pos',
        if (shiftId != null) 'register_shift_id': shiftId,
        if (customerId != null) 'customer_id': customerId,
        'lines': [
          {
            'product_id': productId,
            'qty': qty,
            'unit_price': price,
            'discount_pct': '0',
            'discount_amount': '0',
            'tax_rate': '5',
          },
        ],
        'payments': payments ??
            [
              {'payment_method': 'cash', 'amount': '210.00', 'tendered_amount': '300.00', 'change_given': '90.00'},
            ],
      };

  Future<Map<String, Object?>> sell({
    String qty = '2',
    String? customerId,
    String? shiftId,
    List<Map<String, dynamic>>? payments,
    String? saleId,
  }) =>
      writer.saveSale({
        ...cartBody(qty: qty, customerId: customerId, shiftId: shiftId, payments: payments),
        if (saleId != null) 'id': saleId,
      });

  Future<Decimal> stockOf(String productId) async =>
      (await catalog.availableStock(kBranch, productId)) ?? Decimal.zero;
}
