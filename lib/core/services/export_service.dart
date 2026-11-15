import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

abstract final class ExportService {
  /// Fetches export bytes from backend GET /export/{dataset} and saves them via FileSaverService.
  ///
  /// The user selects the save location up-front so network requests never run if cancelled.
  /// A cancelable progress dialog shows live download progress with a visible Cancel button.
  static Future<bool> runExport({
    required BuildContext context,
    required String dataset,
    String format = 'xlsx', // 'csv', 'xlsx', or 'pdf'
    DateTime? dateFrom,
    DateTime? dateTo,
    String? branchId,
    String? suggestedName,
    String? preselectedPath,
    CancelToken? externalCancelToken,
  }) async {
    final dio = sl<DioClient>().dio;
    final fileSaver = sl<FileSaverService>();

    final normalizedFormat = format.toLowerCase().trim();
    final dateStamp = DateFormat('yyyyMMdd').format(dateTo ?? DateTime.now());
    final defaultFileName = suggestedName ?? '${dataset}_$dateStamp.$normalizedFormat';

    debugPrint('[ExportFlow] Starting export: dataset=$dataset, format=$normalizedFormat, dateFrom=$dateFrom, dateTo=$dateTo, branchId=$branchId');
    debugPrint('[ExportFlow] Default file name: "$defaultFileName"');

    // 1. Pick save location upfront if not provided
    final rawSavePath = preselectedPath ??
        await fileSaver.chooseSavePath(
          defaultFileName,
          extensions: [normalizedFormat],
        );

    debugPrint('[ExportFlow] Save path returned by file picker: raw="$rawSavePath" (runtimeType=${rawSavePath.runtimeType})');

    // If user cancelled save file dialog, exit cleanly without making network calls.
    if (rawSavePath == null) {
      debugPrint('[ExportFlow] User cancelled file picker (rawSavePath is null). Aborting export.');
      return false;
    }

    final savePath = FileSaverService.normalizeFilePath(rawSavePath, defaultExtension: normalizedFormat);
    final parentDir = Directory(p.dirname(savePath));
    final parentExists = parentDir.existsSync();
    debugPrint('[ExportFlow] Normalized save path: "$savePath", parentDir="${parentDir.path}", parentFolderExists=$parentExists');

    if (!parentExists) {
      try {
        await parentDir.create(recursive: true);
        debugPrint('[ExportFlow] Created missing parent directory: "${parentDir.path}"');
      } catch (e, st) {
        debugPrint('[ExportFlow] Exception creating parent directory: $e\n$st');
      }
    }

    final query = <String, dynamic>{
      'format': normalizedFormat,
      if (dateFrom != null)
        'date_from': DateFormat('yyyy-MM-dd').format(dateFrom),
      if (dateTo != null)
        'date_to': DateFormat('yyyy-MM-dd').format(dateTo),
      if (branchId != null && branchId.isNotEmpty)
        'branch_id': branchId,
    };

    final endpoint = ApiConstants.exportDataset(dataset);
    final fullUrl = '${dio.options.baseUrl}$endpoint';
    debugPrint('[ExportFlow] Request start: GET $endpoint | fullUrl=$fullUrl | query=$query');

    final cancelToken = externalCancelToken ?? CancelToken();
    final progressNotifier = ValueNotifier<({int received, int total})>(
      (received: 0, total: 0),
    );

    var dialogOpen = false;

    // Show cancelable progress dialog if context is still mounted
    if (context.mounted) {
      dialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.file_download_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Exporting ${dataset.toUpperCase()} ($normalizedFormat)'),
                ],
              ),
              content: ValueListenableBuilder<({int received, int total})>(
                valueListenable: progressNotifier,
                builder: (ctx, progress, _) {
                  final hasTotal = progress.total > 0;
                  final ratio = hasTotal
                      ? (progress.received / progress.total).clamp(0.0, 1.0)
                      : null;
                  final percent = hasTotal ? (ratio! * 100).toStringAsFixed(0) : null;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasTotal
                            ? 'Downloading export... $percent% (${_formatBytes(progress.received)} of ${_formatBytes(progress.total)})'
                            : 'Generating $dataset export from server...',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(value: ratio),
                    ],
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    debugPrint('[ExportFlow] User tapped Cancel button in progress dialog');
                    cancelToken.cancel('Export cancelled by user');
                    if (dialogOpen && dialogCtx.mounted) {
                      Navigator.of(dialogCtx, rootNavigator: true).pop();
                      dialogOpen = false;
                    }
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ).then((_) => dialogOpen = false);
    }

    Uint8List? fileBytes;
    String? errorMsg;
    bool wasCancelled = false;

    try {
      final res = await dio.get<List<int>>(
        endpoint,
        queryParameters: query,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          debugPrint('[ExportFlow] Dio onReceiveProgress: received=$received, total=$total');
          progressNotifier.value = (received: received, total: total);
        },
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      final statusCode = res.statusCode ?? 0;
      final contentType = res.headers.value(Headers.contentTypeHeader) ?? '';
      final respLength = res.data?.length ?? 0;
      debugPrint('[ExportFlow] Response received: status=$statusCode, content-type="$contentType", length=$respLength bytes');

      if (contentType.toLowerCase().contains('application/json')) {
        String? jsonDetail;
        if (res.data != null) {
          try {
            final decoded = jsonDecode(utf8.decode(res.data!));
            if (decoded is Map) {
              jsonDetail = decoded['detail']?.toString() ?? decoded['message']?.toString();
            }
          } catch (_) {}
        }
        debugPrint('[ExportFlow] Server returned JSON instead of binary export: $jsonDetail');
        errorMsg = jsonDetail ?? 'Server returned error message instead of $normalizedFormat export.';
      } else if (res.data != null) {
        fileBytes = Uint8List.fromList(res.data!);
      }
    } on DioException catch (e, st) {
      debugPrint('[ExportFlow] DioException caught: type=${e.type}, message=${e.message}, status=${e.response?.statusCode}\n$st');
      if (CancelToken.isCancel(e) || e.type == DioExceptionType.cancel) {
        wasCancelled = true;
      } else if (e.response?.statusCode == 413) {
        String? detail;
        final rawData = e.response?.data;
        if (rawData is List<int>) {
          try {
            final parsed = jsonDecode(utf8.decode(rawData));
            if (parsed is Map) detail = parsed['detail']?.toString();
          } catch (_) {}
        } else if (rawData is Map) {
          detail = rawData['detail']?.toString();
        }

        if (detail != null && detail.isNotEmpty) {
          errorMsg = detail;
        } else if (normalizedFormat == 'pdf') {
          errorMsg =
              'PDF export row limit reached. Please narrow the date range or choose Excel / CSV format.';
        } else {
          errorMsg =
              'Export too large: more than 50,000 rows. Narrow the date range or select a branch and try again.';
        }
      } else if (e.response?.statusCode == 403) {
        errorMsg = 'You do not have permission to export this report (reports.export required).';
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMsg =
            'Export timed out after 60 seconds. The dataset might be large; try selecting CSV format or a narrower date range.';
      } else {
        String? detail;
        final rawData = e.response?.data;
        if (rawData is List<int>) {
          try {
            final parsed = jsonDecode(utf8.decode(rawData));
            if (parsed is Map) detail = parsed['detail']?.toString() ?? parsed['message']?.toString();
          } catch (_) {}
        } else if (rawData is Map) {
          detail = rawData['detail']?.toString() ?? rawData['message']?.toString();
        }
        errorMsg = detail ?? 'Export failed. Please check your network and try again.';
      }
    } catch (e, st) {
      debugPrint('[ExportFlow] Unexpected exception: $e\n$st');
      errorMsg = 'Export error: $e';
    } finally {
      if (dialogOpen && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        dialogOpen = false;
      }
    }

    if (wasCancelled) {
      debugPrint('[ExportFlow] Export was cancelled.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export cancelled'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return false;
    }

    if (errorMsg != null) {
      debugPrint('[ExportFlow] Export error: $errorMsg');
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, errorMsg);
      }
      return false;
    }

    if (fileBytes == null || fileBytes.isEmpty) {
      debugPrint('[ExportFlow] fileBytes is null or empty');
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, 'No data was returned for this export.');
      }
      return false;
    }

    debugPrint('[ExportFlow] Writing ${fileBytes.length} bytes to "$savePath"');
    String finalPath;
    try {
      finalPath = await fileSaver.saveBytesToPath(savePath, fileBytes);
    } catch (e, st) {
      debugPrint('[ExportFlow] Exception in saveBytesToPath: $e\n$st');
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, 'Failed to save export file: $e');
      }
      return false;
    }

    final writtenFile = File(finalPath);
    final fileExists = writtenFile.existsSync();
    final fileLength = fileExists ? writtenFile.lengthSync() : 0;
    debugPrint('[ExportFlow] Verification: finalPath="$finalPath", exists=$fileExists, length=$fileLength bytes');

    if (!fileExists || fileLength == 0) {
      debugPrint('[ExportFlow] Verification failed! File does not exist or has length 0.');
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, 'Export failed: file is missing or empty at $finalPath');
      }
      return false;
    }

    debugPrint('[ExportFlow] SUCCESS! Export completed: $finalPath ($fileLength bytes)');

    if (context.mounted) {
      final fileName = savePath.split(RegExp(r'[\\/]')).last;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  'Export saved: $fileName ($fileLength bytes)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => fileSaver.openFile(finalPath),
                child: const Text('Open file', style: TextStyle(color: Colors.amberAccent)),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => fileSaver.openFolder(finalPath),
                child: const Text('Open folder', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
      return true;
    }

    return true;
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
