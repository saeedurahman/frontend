import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:intl/intl.dart';

abstract final class ExportService {
  /// Fetches export bytes from backend GET /export/{dataset} and saves them via FileSaverService.
  static Future<bool> runExport({
    required BuildContext context,
    required String dataset,
    String format = 'xlsx', // 'csv' or 'xlsx'
    DateTime? dateFrom,
    DateTime? dateTo,
    String? branchId,
    String? suggestedName,
  }) async {
    final dio = sl<DioClient>().dio;
    final fileSaver = sl<FileSaverService>();

    final query = <String, dynamic>{
      'format': format.toLowerCase(),
      if (dateFrom != null)
        'date_from': DateFormat('yyyy-MM-dd').format(dateFrom),
      if (dateTo != null)
        'date_to': DateFormat('yyyy-MM-dd').format(dateTo),
      if (branchId != null && branchId.isNotEmpty)
        'branch_id': branchId,
    };

    // Show loading indicator
    var dialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(
                child: Text('Generating $dataset export ($format)...'),
              ),
            ],
          ),
        ),
      ),
    ).then((_) => dialogOpen = false);

    Uint8List? fileBytes;
    String? errorMsg;

    try {
      final res = await dio.get<List<int>>(
        ApiConstants.exportDataset(dataset),
        queryParameters: query,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      if (res.data != null) {
        fileBytes = Uint8List.fromList(res.data!);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        errorMsg =
            'Export too large: more than 50,000 rows. Narrow the date range or select a branch and try again.';
      } else if (e.response?.statusCode == 403) {
        errorMsg = 'You do not have permission to export this report (reports.export required).';
      } else {
        final data = e.response?.data;
        if (data is Map) {
          errorMsg = data['detail']?.toString() ?? data['message']?.toString();
        }
        errorMsg ??= 'Export failed. Please check your network and try again.';
      }
    } catch (e) {
      errorMsg = 'Export error: $e';
    } finally {
      if (dialogOpen && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    if (!context.mounted) return false;

    if (errorMsg != null) {
      AppAlerts.showErrorMessage(context, errorMsg);
      return false;
    }

    if (fileBytes == null || fileBytes.isEmpty) {
      AppAlerts.showErrorMessage(context, 'No data was returned for this export.');
      return false;
    }

    final dateStamp = DateFormat('yyyyMMdd').format(dateTo ?? DateTime.now());
    final defaultFileName = suggestedName ?? '${dataset}_$dateStamp.$format';

    final savedPath = await fileSaver.saveFileWithDialog(
      defaultFileName,
      fileBytes,
      extensions: [format],
    );

    if (savedPath != null && context.mounted) {
      final fileName = savedPath.split(RegExp(r'[\\/]')).last;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export saved: $fileName'),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: 'Open folder',
            onPressed: () => fileSaver.openFolder(savedPath),
          ),
        ),
      );
      return true;
    }

    return false;
  }
}

