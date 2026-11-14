import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/utils/app_alerts.dart';

class ProductImportDialog extends StatefulWidget {
  const ProductImportDialog({super.key, this.branchId, this.onSuccess});

  final String? branchId;
  final VoidCallback? onSuccess;

  static Future<void> show(
    BuildContext context, {
    String? branchId,
    VoidCallback? onSuccess,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ProductImportDialog(
        branchId: branchId,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<ProductImportDialog> createState() => _ProductImportDialogState();
}

class _ProductImportDialogState extends State<ProductImportDialog> {
  String? _selectedFilePath;
  String? _csvContent;
  bool _isValidating = false;
  bool _isApplying = false;
  String _onErrorMode = 'abort'; // 'abort' or 'skip'

  Map<String, dynamic>? _importReport;
  String? _errorMessage;

  static const String _templateCsv =
      'name,sku,barcode,category,unit,cost,price,opening_stock\n'
      'Basmati Rice 5kg,RICE-5KG,89640001,Groceries,kg,800.00,1050.00,50\n'
      'Cooking Oil 1L,OIL-1L,89640002,Groceries,ltr,450.00,520.00,100\n'
      'Tapal Tea 400g,TEA-400G,89640003,Beverages,pkt,400.00,480.00,25\n';

  Future<void> _downloadTemplate() async {
    final bytes = Uint8List.fromList(utf8.encode(_templateCsv));
    final savedPath = await sl<FileSaverService>().saveFileWithDialog(
      'products_template.csv',
      bytes,
      extensions: ['csv'],
    );
    if (savedPath != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Template downloaded successfully'),
          action: SnackBarAction(
            label: 'Open folder',
            onPressed: () => sl<FileSaverService>().openFolder(savedPath),
          ),
        ),
      );
    }
  }

  Future<void> _pickAndValidateFile() async {
    final path = await sl<FileSaverService>().pickFile(
      extensions: ['csv'],
      label: 'CSV Files',
    );
    if (path == null) return;

    try {
      final file = File(path);
      final text = await file.readAsString();
      if (text.trim().isEmpty) {
        if (mounted) AppAlerts.showErrorMessage(context, 'The chosen CSV file is empty.');
        return;
      }

      setState(() {
        _selectedFilePath = path;
        _csvContent = text;
        _errorMessage = null;
        _importReport = null;
      });

      await _runValidation(text);
    } catch (e) {
      if (mounted) {
        AppAlerts.showErrorMessage(context, 'Could not read CSV file: $e');
      }
    }
  }

  Future<void> _runValidation(String csv) async {
    setState(() => _isValidating = true);
    final dio = sl<DioClient>().dio;

    try {
      final res = await dio.post<Map<String, dynamic>>(
        ApiConstants.productsImport,
        data: {
          'csv': csv,
          'dry_run': true,
          'on_error': _onErrorMode,
          if (widget.branchId != null) 'branch_id': widget.branchId,
        },
      );

      if (mounted) {
        setState(() {
          _importReport = res.data;
          _errorMessage = null;
        });
      }
    } on DioException catch (e) {
      String? msg;
      if (e.response?.statusCode == 413) {
        msg = 'Import file is too large (more rows than maximum allowed).';
      } else if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['detail'] is Map) {
          final detail = data['detail'] as Map;
          if (detail['report'] is Map) {
            setState(() => _importReport = detail['report'] as Map<String, dynamic>);
          }
          msg = detail['message']?.toString();
        }
      }
      msg ??= e.message ?? 'Validation failed';
      if (mounted) setState(() => _errorMessage = msg);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Validation error: $e');
    } finally {
      if (mounted) setState(() => _isValidating = false);
    }
  }

  Future<void> _applyImport() async {
    if (_csvContent == null) return;
    setState(() => _isApplying = true);
    final dio = sl<DioClient>().dio;

    try {
      final res = await dio.post<Map<String, dynamic>>(
        ApiConstants.productsImport,
        data: {
          'csv': _csvContent,
          'dry_run': false,
          'on_error': _onErrorMode,
          if (widget.branchId != null) 'branch_id': widget.branchId,
        },
      );

      final summary = res.data?['summary'] as Map<String, dynamic>?;
      final applied = summary?['applied'] ?? summary?['total_rows'] ?? 0;

      if (mounted) {
        AppAlerts.showSuccessMessage(
          context,
          'Successfully imported $applied products!',
        );
        widget.onSuccess?.call();
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      String? msg;
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['detail'] is Map) {
          final detail = data['detail'] as Map;
          if (detail['report'] is Map) {
            setState(() => _importReport = detail['report'] as Map<String, dynamic>);
          }
          msg = detail['message']?.toString();
        }
      }
      msg ??= e.message ?? 'Import apply failed';
      if (mounted) {
        AppAlerts.showErrorMessage(context, msg);
        setState(() => _errorMessage = msg);
      }
    } catch (e) {
      if (mounted) {
        AppAlerts.showErrorMessage(context, 'Import apply error: $e');
      }
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _importReport?['summary'] as Map<String, dynamic>?;
    final rows = (_importReport?['rows'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final errorCount = summary?['errors'] as int? ?? 0;
    final totalRows = summary?['total_rows'] as int? ?? 0;
    final createCount = summary?['create'] as int? ?? 0;
    final updateCount = summary?['update'] as int? ?? 0;
    final unchangedCount = summary?['unchanged'] as int? ?? 0;

    final canApply = _importReport != null &&
        !_isValidating &&
        !_isApplying &&
        (errorCount == 0 || _onErrorMode == 'skip');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.file_upload_outlined, color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Import Products from CSV',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Upload a spreadsheet to bulk create or update catalog products and opening stock',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _downloadTemplate,
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download Template'),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Step 1: File selection
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: _isValidating || _isApplying ? null : _pickAndValidateFile,
                    icon: const Icon(Icons.folder_open),
                    label: Text(_selectedFilePath == null ? 'Select CSV File' : 'Change File'),
                  ),
                  const SizedBox(width: 12),
                  if (_selectedFilePath != null)
                    Expanded(
                      child: Text(
                        _selectedFilePath!.split(RegExp(r'[\\/]')).last,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (_isValidating)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Validating product rows...'),
                      ],
                    ),
                  ),
                )
              else if (_importReport != null) ...[
                // Summary chips
                Row(
                  children: [
                    _buildSummaryBadge('Total Rows', totalRows, Colors.grey.shade800),
                    const SizedBox(width: 8),
                    _buildSummaryBadge('To Create', createCount, Colors.green),
                    const SizedBox(width: 8),
                    _buildSummaryBadge('To Update', updateCount, Colors.blue),
                    const SizedBox(width: 8),
                    _buildSummaryBadge('Unchanged', unchangedCount, Colors.grey),
                    const SizedBox(width: 8),
                    _buildSummaryBadge('Errors', errorCount, errorCount > 0 ? Colors.red : Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                if (errorCount > 0) ...[
                  Row(
                    children: [
                      const Text('When errors occur:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'abort',
                            groupValue: _onErrorMode,
                            onChanged: (v) {
                              if (v != null) setState(() => _onErrorMode = v);
                            },
                          ),
                          const Text('Abort (Fix file first)'),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'skip',
                            groupValue: _onErrorMode,
                            onChanged: (v) {
                              if (v != null) setState(() => _onErrorMode = v);
                            },
                          ),
                          const Text('Skip invalid rows'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                // Rows table
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final r = rows[i];
                        final rowNum = r['row'] ?? (i + 2);
                        final action = r['action']?.toString() ?? '';
                        final sku = r['sku']?.toString() ?? '';
                        final rowErrors = (r['errors'] as List?)?.cast<String>() ?? [];
                        final warnings = (r['warnings'] as List?)?.cast<String>() ?? [];
                        final hasError = rowErrors.isNotEmpty || action == 'error';

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Text('Row $rowNum', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: hasError
                                      ? Colors.red.shade100
                                      : action == 'create'
                                          ? Colors.green.shade100
                                          : Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  action.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: hasError
                                        ? Colors.red.shade900
                                        : action == 'create'
                                            ? Colors.green.shade900
                                            : Colors.blue.shade900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('SKU: $sku', style: const TextStyle(fontSize: 13)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: hasError
                                    ? Text(
                                        rowErrors.join(', '),
                                        style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                                      )
                                    : warnings.isNotEmpty
                                        ? Text(
                                            warnings.join(', '),
                                            style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                                          )
                                        : const Text('Valid', style: TextStyle(color: Colors.green, fontSize: 13)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ] else
                const Expanded(
                  child: Center(
                    child: Text('Select a CSV file to validate and preview imports'),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isApplying ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: canApply ? _applyImport : null,
                    icon: _isApplying
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isApplying ? 'Applying Import...' : 'Apply Import'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

