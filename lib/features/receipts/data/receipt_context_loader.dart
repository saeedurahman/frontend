import 'dart:io';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/receipt_branding_source.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:path_provider/path_provider.dart';

/// The public receipt link of a sale (`POST /sales/{id}/receipt-link`),
/// remembered on the device so a later offline print can still draw the QR.
class ReceiptLinkSource {
  ReceiptLinkSource({required SyncStore store, Dio? dio})
      : _store = store,
        _dio = dio;

  final SyncStore _store;
  final Dio? _dio;

  static String _key(String saleId) => 'receipt_link:$saleId';

  Future<String?> cached(String saleId) async {
    final v = await _store.meta(_key(saleId));
    return v == null || v.isEmpty ? null : v;
  }

  /// Asks the server (short timeout, never throws). Null when offline or the
  /// sale has no link yet.
  Future<String?> fetch(String saleId) async {
    final dio = _dio;
    if (dio == null) return null;
    try {
      final res = await dio.post<Map<String, dynamic>>(
        ApiConstants.saleReceiptLink(saleId),
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          extra: const {'no_retry': true},
        ),
      );
      final url = res.data?['url'] as String?;
      if (url == null || url.isEmpty) return null;
      await _store.setMeta(_key(saleId), url);
      return url;
    } catch (_) {
      return null;
    }
  }
}

/// The business logo as bytes: memory, then a file on disk, then the network
/// (short timeout). Never throws; a missing logo just means no logo.
class ReceiptLogoSource {
  ReceiptLogoSource({Dio? dio, Future<Directory> Function()? cacheDir})
      : _dio = dio,
        _cacheDir = cacheDir ?? getApplicationSupportDirectory;

  final Dio? _dio;
  final Future<Directory> Function() _cacheDir;
  final Map<String, Uint8List> _memory = {};

  Future<File?> _file(String url) async {
    try {
      final dir = await _cacheDir();
      final name = url.hashCode.toUnsigned(32);
      return File('${dir.path}${Platform.pathSeparator}receipt_logo_$name.bin');
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> bytes(String? url, {bool allowNetwork = true}) async {
    if (url == null || url.trim().isEmpty) return null;
    final hit = _memory[url];
    if (hit != null) return hit;
    final file = await _file(url);
    try {
      if (file != null && await file.exists()) {
        final data = await file.readAsBytes();
        if (data.isNotEmpty) return _memory[url] = data;
      }
    } catch (_) {}
    final dio = _dio;
    if (dio == null || !allowNetwork) return null;
    try {
      final res = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          extra: const {'no_retry': true},
        ),
      );
      final data = res.data;
      if (data == null || data.isEmpty) return null;
      final out = Uint8List.fromList(data);
      _memory[url] = out;
      try {
        await file?.writeAsBytes(out, flush: true);
      } catch (_) {}
      return out;
    } catch (_) {
      return null;
    }
  }
}

/// Collects everything a receipt needs besides the sale and the layout, from
/// the device's own data. The only network use is the optional public link
/// and logo, each with a short timeout and a silent fallback.
class ReceiptContextLoader {
  ReceiptContextLoader({
    required SyncStore store,
    required ReceiptBrandingSource branding,
    required LocalCatalog catalog,
    ReceiptLinkSource? links,
    ReceiptLogoSource? logos,
  })  : _store = store,
        _branding = branding,
        _catalog = catalog,
        _links = links,
        _logos = logos;

  final SyncStore _store;
  final ReceiptBrandingSource _branding;
  final LocalCatalog _catalog;
  final ReceiptLinkSource? _links;
  final ReceiptLogoSource? _logos;

  static String? _s(Object? v) {
    final t = v?.toString().trim();
    return t == null || t.isEmpty ? null : t;
  }

  Future<ReceiptContext> load(
    SaleResponseModel sale,
    ReceiptLayout layout, {
    bool isReturn = false,
    bool allowNetwork = true,
  }) async {
    final row = sale.id.isEmpty ? null : await _store.sale(sale.id);
    final synced = row != null ? row['sync_state'] == 'synced' : !sale.offline;

    final profile = await _branding.businessProfile();
    final settings = await _catalog.settings();
    final logoUrl = _s(settings?['logo_url']) ?? profile?.logoUrl;
    final logo = layout.config.header.showLogo && _logos != null
        ? await _logos.bytes(logoUrl, allowNetwork: allowNetwork)
        : null;

    final register = _s(row?['receipt_no']) ?? _s(sale.clientReceiptNo);
    var official = _s(row?['official_number']);
    // Without a local row the sale came from the server, so its own sale
    // number is the official one.
    if (official == null && row == null) official = _s(sale.saleNumber);

    final balances = await _balances(sale, layout);

    return ReceiptContext(
      business: ReceiptBusiness(
        name: profile?.name,
        address: profile?.addressLine1,
        phone: profile?.phone,
        taxId: profile?.taxId,
        logoUrl: logoUrl,
        logoBytes: logo,
      ),
      registerNumber: register,
      officialNumber: official,
      synced: synced,
      publicLink: await _link(sale, layout, synced, allowNetwork),
      cashierName: await _cashier(sale, row),
      branchName: await _name('branch', sale.branchId),
      registerName: await _registerName(sale, row),
      customerPhone: sale.customer?.phone ?? await _customerPhone(sale.customerId),
      products: await _products(sale, layout),
      previousBalance: balances.$1,
      balanceAfter: balances.$2,
      accentColor: _accent(settings),
      isReturn: isReturn,
    );
  }

  Future<String?> _link(
    SaleResponseModel sale,
    ReceiptLayout layout,
    bool synced,
    bool allowNetwork,
  ) async {
    final links = _links;
    if (!synced || sale.id.isEmpty || links == null) return null;
    final saved = await links.cached(sale.id);
    if (saved != null) return saved;
    // Only worth a request when the layout actually prints a QR.
    if (!allowNetwork || !layout.config.footer.showQr) return null;
    return links.fetch(sale.id);
  }

  Future<String?> _name(String entity, String? id) async {
    if (id == null || id.isEmpty) return null;
    final row = await _store.entity(entity, id);
    return _s(row?['name']) ?? _s(row?['full_name']);
  }

  Future<String?> _cashier(SaleResponseModel sale, Map<String, Object?>? row) async {
    final userId = _s(row?['user_id']);
    if (userId != null) {
      final u = await _store.entity('user', userId);
      final name = _s(u?['full_name']) ?? _s(u?['name']);
      if (name != null) return name;
    }
    final summary = await _store.entity('sale_summary', sale.id);
    return _s(summary?['cashier_name']) ?? _s(summary?['cashier']);
  }

  Future<String?> _registerName(SaleResponseModel sale, Map<String, Object?>? row) async {
    final shiftId = _s(row?['shift_id']) ?? _s(sale.registerShiftId);
    if (shiftId == null) return null;
    final local = await _store.shift(shiftId);
    final named = _s(local?['register_name']);
    if (named != null) return named;
    var registerId = _s(local?['register_id']) ?? _s(local?['cash_register_id']);
    if (registerId == null) {
      final pulled = await _store.entity('register_shift', shiftId);
      registerId = _s(pulled?['cash_register_id']);
    }
    return _name('cash_register', registerId);
  }

  Future<String?> _customerPhone(String? customerId) async {
    if (customerId == null) return null;
    final c = await _store.entity('customer', customerId);
    return _s(c?['phone']);
  }

  Future<Map<String, ReceiptProductInfo>> _products(
    SaleResponseModel sale,
    ReceiptLayout layout,
  ) async {
    final out = <String, ReceiptProductInfo>{};
    final units = <String, Map<String, dynamic>?>{};
    final wantsBarcode = layout.config.items.showBarcode;
    for (final line in sale.lines) {
      final pid = line.productId;
      if (out.containsKey(pid)) continue;
      final p = await _store.entity('product', pid);
      if (p == null) continue;
      final unitId = _s(p['unit_id']) ?? _s(p['base_unit_id']);
      Map<String, dynamic>? unit;
      if (unitId != null) {
        unit = units.containsKey(unitId) ? units[unitId] : await _store.entity('unit', unitId);
        units[unitId] = unit;
      }
      String? barcode;
      if (wantsBarcode) {
        final codes = await _store.entities(
          'barcode',
          where: 'parent_id = ?',
          args: [pid],
          limit: 1,
        );
        barcode = codes.isEmpty ? null : _s(codes.first['barcode']);
      }
      out[pid] = ReceiptProductInfo(
        sku: _s(p['sku']),
        barcode: barcode ?? _s(p['barcode']),
        nameSecondary: _s(p['name_secondary']),
        unitSymbol: _s(unit?['symbol']) ?? _s(p['unit_symbol']),
        allowsDecimal: unit?['allows_decimal'] == true,
      );
    }
    return out;
  }

  /// (previous balance, balance after) as "owed" amounts, only when the sale
  /// has a customer. The balance is what the customer owes when printing;
  /// "previous" removes this sale's own credit.
  Future<(String?, String?)> _balances(SaleResponseModel sale, ReceiptLayout layout) async {
    final totals = layout.config.totals;
    final id = sale.customerId;
    if (id == null || id.isEmpty || !(totals.showPreviousBalance || totals.showBalanceAfter)) {
      return (null, null);
    }
    final balance = await _catalog.customerBalance(id); // negative = owes us
    final owedAfter = balance < Decimal.zero ? -balance : Decimal.zero;
    var credit = Decimal.zero;
    for (final p in sale.payments) {
      if (p.paymentMethod == 'credit') {
        credit += Decimal.tryParse(p.amount) ?? Decimal.zero;
      }
    }
    var owedBefore = owedAfter - credit;
    if (owedBefore < Decimal.zero) owedBefore = Decimal.zero;
    return (formatPKR(owedBefore.toDouble()), formatPKR(owedAfter.toDouble()));
  }

  /// The A4 accent colour, when the business set one.
  static int? _accent(Map<String, dynamic>? settings) {
    final app = settings?['app_settings'];
    final raw = _s(settings?['accent_color']) ??
        (app is Map ? _s(app['receipt.accent_color']) ?? _s(app['accent_color']) : null);
    if (raw == null) return null;
    var hex = raw.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.tryParse(hex, radix: 16);
  }
}
