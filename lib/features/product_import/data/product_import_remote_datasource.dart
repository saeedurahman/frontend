import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';

/// The product import endpoints. Throws [DioException] on any failure; the
/// repository turns it into a plain-words failure.
class ProductImportRemoteDataSource {
  ProductImportRemoteDataSource(this._client);

  final DioClient _client;

  /// Checking or saving thousands of rows is not a counter sale: give the
  /// server time, and never repeat an upload on our own.
  static const runTimeout = Duration(seconds: 180);

  static const _xlsxType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  /// `POST /products/import/upload` (multipart). The same call does the dry
  /// run (`dry_run: true`) and the apply.
  Future<ImportReport> run(
    ImportFile file,
    ImportOptions options, {
    required bool dryRun,
  }) async {
    final fields = options.toFields(dryRun: dryRun);
    final form = FormData();
    for (final e in fields.entries) {
      final v = e.value;
      form.fields.add(MapEntry(e.key, v is Map ? jsonEncode(v) : '$v'));
    }
    form.files.add(
      MapEntry(
        'file',
        MultipartFile.fromBytes(
          file.bytes,
          filename: file.name,
          contentType: DioMediaType.parse(
            file.kind == ImportFileKind.xlsx ? _xlsxType : 'text/csv',
          ),
        ),
      ),
    );
    final response = await _client.dio.post<dynamic>(
      ApiConstants.productsImportUpload,
      data: form,
      options: Options(
        sendTimeout: runTimeout,
        receiveTimeout: runTimeout,
        extra: const {'no_retry': true},
      ),
    );
    final data = response.data;
    if (data is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Unexpected answer from the server',
      );
    }
    return ImportReport.fromJson(Map<String, dynamic>.from(data));
  }

  /// `GET /products/import/template?format=csv|xlsx`.
  Future<ImportTemplate> template(ImportFileKind kind) async {
    final response = await _client.dio.get<List<int>>(
      ApiConstants.productsImportTemplate,
      queryParameters: {'format': kind.extension},
      options: Options(
        responseType: ResponseType.bytes,
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    final bytes = Uint8List.fromList(response.data ?? const []);
    if (bytes.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'The template was empty',
      );
    }
    return ImportTemplate(
      fileName:
          _fileName(response.headers.value('content-disposition')) ??
          'products_template.${kind.extension}',
      bytes: bytes,
      kind: kind,
    );
  }

  /// `GET /products/import/batches`: the last 20 applied imports.
  Future<List<ImportBatch>> batches() async {
    final response = await _client.dio.get<dynamic>(
      ApiConstants.productsImportBatches,
    );
    final data = response.data;
    final list = data is List
        ? data
        : (data is Map ? (data['items'] as List? ?? const []) : const []);
    return [
      for (final e in list)
        if (e is Map) ImportBatch.fromJson(Map<String, dynamic>.from(e)),
    ];
  }

  /// `POST /products/import/{id}/undo`.
  Future<UndoResult> undo(String batchId) async {
    final response = await _client.dio.post<dynamic>(
      ApiConstants.productsImportUndo(batchId),
      options: Options(
        sendTimeout: runTimeout,
        receiveTimeout: runTimeout,
        extra: const {'no_retry': true},
      ),
    );
    final data = response.data;
    return data is Map
        ? UndoResult.fromJson(Map<String, dynamic>.from(data))
        : const UndoResult();
  }

  static String? _fileName(String? contentDisposition) {
    if (contentDisposition == null) return null;
    final m = RegExp(
      r'filename\*?=(?:UTF-8\x27\x27)?"?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(contentDisposition);
    final name = m?.group(1)?.trim();
    return name == null || name.isEmpty ? null : Uri.decodeComponent(name);
  }
}
