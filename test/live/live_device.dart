// One computer of the app against a REAL backend, for the supplier live tests:
// a device store with its outbox, the real sync engine, the offline suppliers
// repository, the khata repository and a network cable that can be pulled.
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/data_change_interceptor.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/local_suppliers.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/repos/offline_suppliers_repository.dart';
import 'package:frantend/core/sync/http_sync_api.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';

import 'live_backend.dart';

/// The network cable: unplugged, every request ends like a refused connection.
class LiveCable implements HttpClientAdapter {
  LiveCable(this._real);

  final HttpClientAdapter _real;
  bool plugged = true;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    if (plugged) return _real.fetch(options, requestStream, cancelFuture);
    throw DioException.connectionError(
      requestOptions: options,
      reason: 'refused',
      error: const SocketException(
        'refused',
        osError: OSError('refused', 1225),
      ),
    );
  }

  @override
  void close({bool force = false}) => _real.close(force: force);
}

class LiveDevice {
  LiveDevice._({
    required this.ids,
    required this.store,
    required this.writer,
    required this.catalog,
    required this.suppliers,
    required this.khata,
    required SyncEngine engine,
    required LiveCable cable,
    required FixedConnectivityProbe probe,
  })  : _engine = engine,
        _cable = cable,
        _probe = probe;

  final IdGenerator ids;
  final SyncStore store;
  final OfflineWriter writer;
  final LocalCatalog catalog;
  final OfflineSuppliersRepository suppliers;
  final KhataRepository khata;
  final SyncEngine _engine;
  final LiveCable _cable;
  final FixedConnectivityProbe _probe;

  Future<void> sync() async {
    await _engine.syncNow(manual: true);
    expect(_engine.state.lastError, isNull, reason: 'sync failed');
  }

  void unplug() {
    _cable.plugged = false;
    _probe.set(ReachabilityStatus.offline);
  }

  void plugIn() {
    _cable.plugged = true;
    _probe.set(ReachabilityStatus.online);
  }

  /// A new computer signed in as [tenant]'s owner, online and not yet synced.
  /// [tenant]'s client sends this device's headers from now on.
  static Future<LiveDevice> start(LiveTenant tenant) async {
    final me = await tenant.get('/auth/me');
    final userId = '${me['id'] ?? (me['user'] as Map)['id']}';

    final ids = UuidIdGenerator();
    final deviceId = ids.newId();
    final cable = LiveCable(tenant.dio.httpClientAdapter);
    tenant.dio.httpClientAdapter = cable;
    tenant.dio.interceptors
      ..add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Device-ID'] = deviceId;
          options.headers['X-App-Version'] = '1.0.0';
          handler.next(options);
        },
      ))
      ..add(DataChangeInterceptor());

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final store = SyncStore(db);
    final writer = OfflineWriter(
      store: store,
      ids: ids,
      deviceId: () async => deviceId,
      actingUser: () async => ActingUser(
        id: userId,
        name: 'Live Owner',
        businessId: tenant.businessId,
        branchId: tenant.branchId,
      ),
    );
    final catalog =
        LocalCatalog(store, businessId: () async => tenant.businessId);
    final probe = FixedConnectivityProbe();
    final api = HttpSyncApi(
      dio: tenant.dio,
      deviceId: () async => deviceId,
      deviceName: () async => 'Live test PC',
      appVersion: '1.0.0',
    );
    const config = SyncConfig();
    final engine = SyncEngine(
      store: store,
      push: PushService(store: store, api: api, ids: ids, config: config),
      pull: PullService(
        store: store,
        api: api,
        config: config,
        currentUserId: () async => userId,
      ),
      probe: probe,
      config: config,
    );
    addTearDown(() async {
      engine.dispose();
      store.dispose();
      await db.close();
    });

    return LiveDevice._(
      ids: ids,
      store: store,
      writer: writer,
      catalog: catalog,
      suppliers: OfflineSuppliersRepository(
        remoteDataSource: SuppliersRemoteDataSourceImpl(tenant.client),
        errorHandler: const ErrorHandler(),
        writer: writer,
        book: LocalSupplierBook(store),
        isReachable: () => probe.isReachable,
      ),
      khata: KhataRepository(
        remote: KhataRemoteDataSource(tenant.dio),
        store: store,
        writer: writer,
        catalog: catalog,
        settingsRemote: SettingsRemoteDataSourceImpl(tenant.client),
        isReachable: () => probe.isReachable,
      ),
      engine: engine,
      cable: cable,
      probe: probe,
    );
  }
}
