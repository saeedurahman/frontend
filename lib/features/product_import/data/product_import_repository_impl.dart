import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/features/product_import/data/product_import_remote_datasource.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/domain/import_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';

/// Product import over the offline-first data layer: the check and the apply
/// need the server, then the server's changes are pulled into the local
/// catalog so every screen shows them at once.
class ProductImportRepositoryImpl implements ProductImportRepository {
  ProductImportRepositoryImpl({
    required ProductImportRemoteDataSource remote,
    required LocalCatalog catalog,
    required ConnectivityProbe probe,
    required ErrorHandler errorHandler,
    required String? Function() branchId,
    required Future<void> Function() syncNow,
  }) : _remote = remote,
       _catalog = catalog,
       _probe = probe,
       _errors = errorHandler,
       _branchId = branchId,
       _syncNow = syncNow;

  final ProductImportRemoteDataSource _remote;
  final LocalCatalog _catalog;
  final ConnectivityProbe _probe;
  final ErrorHandler _errors;
  final String? Function() _branchId;
  final Future<void> Function() _syncNow;

  @override
  bool get isOnline => _probe.isReachable;

  @override
  Stream<bool> get onlineChanges =>
      _probe.status.map((s) => s != ReachabilityStatus.offline).distinct();

  @override
  String? get branchId => _branchId();

  @override
  Future<ImportPickOptions> options() async {
    final units = <PickOption>[];
    final categories = <PickOption>[];
    try {
      for (final u in await _catalog.units()) {
        units.add(PickOption(u.id, u.name));
      }
      for (final c in await _catalog.categories()) {
        categories.add(PickOption(c.id, c.name));
        for (final child in await _catalog.categories(parentId: c.id)) {
          categories.add(PickOption(child.id, '${c.name} › ${child.name}'));
        }
      }
    } catch (e) {
      debugPrint('[Import] could not read units / categories: $e');
    }
    return ImportPickOptions(units: units, categories: categories);
  }

  @override
  Future<Either<Failure, ImportReport>> run(
    ImportFile file,
    ImportOptions options, {
    required bool dryRun,
  }) async {
    try {
      return Right(await _remote.run(file, options, dryRun: dryRun));
    } catch (e) {
      return Left(_fail(e));
    }
  }

  @override
  Future<Either<Failure, ImportTemplate>> template(ImportFileKind kind) async {
    try {
      return Right(await _remote.template(kind));
    } catch (e) {
      return Left(_fail(e));
    }
  }

  @override
  Future<Either<Failure, List<ImportBatch>>> batches() async {
    try {
      return Right(await _remote.batches());
    } catch (e) {
      return Left(_fail(e));
    }
  }

  @override
  Future<Either<Failure, UndoResult>> undo(String batchId) async {
    try {
      return Right(await _remote.undo(batchId));
    } catch (e) {
      return Left(_fail(e));
    }
  }

  @override
  Future<void> refreshCatalog() async {
    try {
      await _syncNow();
    } catch (e) {
      // The server already has the data; the periodic sync brings it in.
      debugPrint('[Import] sync after import failed: $e');
    }
  }

  // ── failures ─────────────────────────────────────────────────────────

  Failure _fail(Object e) {
    if (e is! DioException || e.type != DioExceptionType.badResponse) {
      return _errors.mapExceptionToFailure(e);
    }
    final status = e.response?.statusCode;
    final data = e.response?.data;
    final detail = data is Map ? data['detail'] : null;
    final detailMap = detail is Map ? Map<String, dynamic>.from(detail) : null;
    final message =
        detailMap?['message']?.toString() ?? (detail is String ? detail : null);

    switch (status) {
      case 422:
        if (detailMap?['code'] == 'import_has_errors') {
          final r = detailMap!['report'];
          return ImportBlockedFailure(
            message ?? 'Some rows have problems.',
            r is Map
                ? ImportReport.fromJson(Map<String, dynamic>.from(r))
                : null,
          );
        }
        return ImportFileFailure(
          message ??
              'We could not read this file. Check that it is a .csv or .xlsx table.',
        );
      case 413:
        return const ImportFileFailure(
          'This file is too big. Split it into smaller files (up to 5,000 products each) and import them one by one.',
        );
      case 415:
        return const ImportFileFailure(
          'Old Excel files (.xls) are not supported. Open the file in Excel, choose '
          'Save As, pick "Excel Workbook (.xlsx)" or "CSV", and choose that file instead.',
        );
      case 409:
        final code = detailMap?['code']?.toString();
        if (code != null) {
          return UndoRefusedFailure(
            message ?? '',
            code: code,
            blocked: [
              for (final p in (detailMap?['products'] as List? ?? const []))
                if (p is Map)
                  BlockedProduct(
                    name: '${p['name'] ?? 'A product'}',
                    reasons: [
                      for (final r in (p['reasons'] as List? ?? const [])) '$r',
                    ],
                  ),
            ],
          );
        }
    }
    return _errors.mapStatus(status, data, headers: e.response?.headers);
  }
}
