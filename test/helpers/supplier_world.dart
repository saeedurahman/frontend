// The supplier side of the app as `foundation_module.dart` wires it, on top of
// [OfflineWorld]: the real repositories, outbox and sync engine against a fake
// sync server and an HTTP server that refuses every connection.

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_suppliers.dart';
import 'package:frantend/core/offline/repos/offline_suppliers_repository.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_cubit.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';

import '../sync/sync_rig.dart';
import 'fake_rest.dart';
import 'khata_fakes.dart';
import 'offline_world.dart';

Decimal d(String v) => Decimal.parse(v);

const _errors = ErrorHandler();

/// The khata endpoints can't be reached either: a call would fail the test.
class NoKhataRemote extends Fake implements KhataRemoteDataSource {}

class NoSettingsRemote extends Fake implements SettingsRemoteDataSource {}

/// One supplier we owe 1000 on two bills, as the sync feed sends it.
void seedSupplier(SyncRig rig) {
  rig.server.put('supplier', 's1', {
    'id': 's1',
    'name': 'Haji Traders',
    'phone': '03001234567',
    'payment_terms_days': 14,
    'is_active': true,
  });
  const position = {
    'id': 's1',
    'supplier_id': 's1',
    'balance_owed': '1000.00',
    'advance_amount': '0.00',
  };
  rig.server.put('supplier_balance', 's1', position);
  Map<String, dynamic> bill(String id, String day, String due, String amount) =>
      {
        'document_type': 'grn',
        'document_id': id,
        'number': 'GRN-$id',
        'date': day,
        'due_date': due,
        'total': amount,
        'allocated': '0.00',
        'remaining': amount,
      };
  rig.server.put('supplier_open_items', 's1', {
    ...position,
    'terms_days': 14,
    'items': [
      bill('d1', '2026-10-01', '2026-10-15', '600.00'),
      bill('d2', '2026-10-20', '2026-11-03', '400.00'),
    ],
  });
  void line(String id, String at, String amount, String running) =>
      rig.server.put('supplier_ledger', id, {
        'id': id,
        'supplier_id': 's1',
        'branch_id': kBranch,
        'entry_type': 'purchase',
        'amount': amount,
        'reference_type': 'grn',
        'entry_at': at,
        'running_balance': running,
      });
  line('l1', '2026-10-01T09:00:00+00:00', '-600.00', '-600.00');
  line('l2', '2026-10-20T09:00:00+00:00', '-400.00', '-1000.00');
}

class SupplierWorld {
  SupplierWorld({UnreachableAdapter? adapter})
      : world = OfflineWorld(adapter: adapter) {
    book = LocalSupplierBook(rig.store);
    suppliers = _repository(
      SuppliersRemoteDataSourceImpl(FakeDioClient(world.dio)),
    );
    khata = KhataRepository(
      remote: NoKhataRemote(),
      store: rig.store,
      writer: rig.writer,
      catalog: rig.catalog,
      settingsRemote: NoSettingsRemote(),
      isReachable: () => false,
    );
  }

  final OfflineWorld world;
  SyncRig get rig => world.rig;

  late final LocalSupplierBook book;
  late final OfflineSuppliersRepository suppliers;
  late final KhataRepository khata;
  final events = CountingKhataEvents();

  OfflineSuppliersRepository _repository(SuppliersRemoteDataSource remote) =>
      OfflineSuppliersRepository(
        remoteDataSource: remote,
        errorHandler: _errors,
        writer: rig.writer,
        book: book,
        isReachable: () => rig.probe.isReachable,
      );

  /// The same device in front of a server that does answer its screens.
  OfflineSuppliersRepository onlineWith(FakeRest server) =>
      _repository(SuppliersRemoteDataSourceImpl(server.client));

  Future<void> seed() async {
    await world.seed();
    seedSupplier(rig);
    await rig.sync();
  }

  Future<String> openShift() async {
    final shift = await rig.writer.openShift(
      registerId: 'reg-1',
      openingFloat: d('5000'),
    );
    return '${shift['id']}';
  }

  Future<Either<Failure, SupplierPaymentResult>> pay(
    String amount, {
    String source = 'bank',
    String? key,
  }) =>
      suppliers.paySupplier(
        {
          'supplier_id': 's1',
          'amount': amount,
          'payment_source': source,
          'branch_id': kBranch,
        },
        idempotencyKey: key,
      );

  Future<List<OutboxOp>> queued() => rig.store.ops(
        statuses: OutboxStatus.unfinished,
      );

  Future<Decimal> balance() async => d(
        (await suppliers.getSupplierBalance('s1'))
            .getOrElse(() => throw StateError('no balance'))
            .balance,
      );

  Future<SupplierLedgerPage> ledger() async => (await suppliers.getLedger('s1'))
      .getOrElse(() => throw StateError('no ledger'));

  Future<OpenItems> bills() async =>
      (await khata.openItems(PartyType.supplier, 's1'))
          .getOrElse(() => throw StateError('no bills'))
          .value;

  Future<HubPage> hub([String search = '']) async => (await khata.hub(
        HubQuery(party: PartyType.supplier, search: search),
      ))
          .getOrElse(() => throw StateError('no hub'))
          .value;

  Future<KhataData<KhataOverview>> overview() async =>
      (await khata.overview()).getOrElse(() => throw StateError('no overview'));

  SupplierLedgerCubit ledgerCubit() => SupplierLedgerCubit(
        GetSupplierUseCase(suppliers),
        GetSupplierLedgerUseCase(suppliers),
        ReverseSupplierPaymentUseCase(suppliers),
        FakeBranchResolver(kBranch),
        events,
      );

  SuppliersListCubit listCubit() => SuppliersListCubit(
        getSuppliersUseCase: GetSuppliersUseCase(suppliers),
        getSupplierBalanceUseCase: GetSupplierBalanceUseCase(suppliers),
        updateSupplierUseCase: UpdateSupplierUseCase(suppliers),
        deleteSupplierUseCase: DeleteSupplierUseCase(suppliers),
        createSupplierUseCase: CreateSupplierUseCase(suppliers),
      );

  SupplierPaymentCubit paymentCubit(FakeShiftGuard shifts) =>
      SupplierPaymentCubit(
        GetSupplierBalanceUseCase(suppliers),
        GetSupplierUseCase(suppliers),
        PaySupplierUseCase(suppliers),
        shifts,
        FakeBranchResolver(kBranch),
        MemoryPaymentSourceStore(),
        events,
      );
}
