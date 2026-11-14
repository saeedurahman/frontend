import 'dart:convert';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/price_list_detail_models.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/presentation/cubit/price_lists_cubit.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';

// ── 1. Create / Edit Price List Dialog ───────────────────────────────────────

class PriceListFormDialog extends StatefulWidget {
  const PriceListFormDialog({
    super.key,
    this.initialList,
    required this.onSave,
  });

  final PriceListModel? initialList;
  final Future<bool> Function({
    required String name,
    required String listType,
    bool isDefault,
    bool isActive,
    String? validFrom,
    String? validTo,
  }) onSave;

  static Future<bool?> show(
    BuildContext context, {
    PriceListModel? initialList,
    required Future<bool> Function({
      required String name,
      required String listType,
      bool isDefault,
      bool isActive,
      String? validFrom,
      String? validTo,
    }) onSave,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => PriceListFormDialog(
        initialList: initialList,
        onSave: onSave,
      ),
    );
  }

  @override
  State<PriceListFormDialog> createState() => _PriceListFormDialogState();
}

class _PriceListFormDialogState extends State<PriceListFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _validFromController;
  late final TextEditingController _validToController;
  late String _listType;
  late bool _isDefault;
  late bool _isActive;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final l = widget.initialList;
    _nameController = TextEditingController(text: l?.name ?? '');
    _validFromController = TextEditingController(text: l?.validFrom?.split('T').first ?? '');
    _validToController = TextEditingController(text: l?.validTo?.split('T').first ?? '');
    _listType = l?.listType ?? 'retail';
    _isDefault = l?.isDefault ?? false;
    _isActive = l?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _validFromController.dispose();
    _validToController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      controller.text = '$y-$m-$d';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final success = await widget.onSave(
      name: _nameController.text.trim(),
      listType: _listType,
      isDefault: _isDefault,
      isActive: _isActive,
      validFrom: _validFromController.text.trim().isEmpty ? null : _validFromController.text.trim(),
      validTo: _validToController.text.trim().isEmpty ? null : _validToController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialList != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(isEdit ? Icons.edit : Icons.add_circle_outline, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      isEdit ? 'Edit Price List' : 'Create Price List',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppDimensions.spacingSm),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'List Name *',
                    hintText: 'e.g. Retail, Wholesale, Ramadan Discount',
                  ),
                  validator: (v) => v == null || v.trim().length < 2 ? 'Name must be at least 2 characters' : null,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                DropdownButtonFormField<String>(
                  value: _listType,
                  decoration: const InputDecoration(labelText: 'List Type'),
                  items: const [
                    DropdownMenuItem(value: 'retail', child: Text('Retail')),
                    DropdownMenuItem(value: 'wholesale', child: Text('Wholesale')),
                    DropdownMenuItem(value: 'custom', child: Text('Custom')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _listType = v);
                  },
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _validFromController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Valid From (optional)',
                          hintText: 'YYYY-MM-DD',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () => _pickDate(_validFromController),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Clear',
                      onPressed: () => _validFromController.clear(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _validToController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Valid To (optional)',
                          hintText: 'YYYY-MM-DD',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            onPressed: () => _pickDate(_validToController),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Clear',
                      onPressed: () => _validToController.clear(),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Default Price List'),
                  subtitle: const Text('Used for walk-in customers and unassigned accounts'),
                  value: _isDefault,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => setState(() => _isDefault = v),
                ),
                if (isEdit)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active'),
                    subtitle: const Text('Inactive lists fall back to the default list'),
                    value: _isActive,
                    activeThumbColor: AppColors.primary,
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                const SizedBox(height: AppDimensions.spacingLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SecondaryButton(
                      label: 'Cancel',
                      onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    PrimaryButton(
                      label: isEdit ? 'Save Changes' : 'Create List',
                      isLoading: _isSaving,
                      onPressed: _isSaving ? null : _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 2. Copy Price List Dialog ───────────────────────────────────────────────

class PriceListCopyDialog extends StatefulWidget {
  const PriceListCopyDialog({
    super.key,
    required this.sourceList,
    required this.onCopy,
  });

  final PriceListModel sourceList;
  final Future<bool> Function({
    required String name,
    Decimal? percent,
    String? listType,
    String? validFrom,
    String? validTo,
  }) onCopy;

  static Future<bool?> show(
    BuildContext context, {
    required PriceListModel sourceList,
    required Future<bool> Function({
      required String name,
      Decimal? percent,
      String? listType,
      String? validFrom,
      String? validTo,
    }) onCopy,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => PriceListCopyDialog(
        sourceList: sourceList,
        onCopy: onCopy,
      ),
    );
  }

  @override
  State<PriceListCopyDialog> createState() => _PriceListCopyDialogState();
}

class _PriceListCopyDialogState extends State<PriceListCopyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _percentController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '${widget.sourceList.name} (Copy)');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    Decimal? pct;
    if (_percentController.text.trim().isNotEmpty) {
      pct = Decimal.tryParse(_percentController.text.trim());
    }

    final success = await widget.onCopy(
      name: _nameController.text.trim(),
      percent: pct,
      listType: widget.sourceList.listType,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.copy, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      'Copy Price List "${widget.sourceList.name}"',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppDimensions.spacingSm),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'New List Name *'),
                  validator: (v) => v == null || v.trim().length < 2 ? 'Required' : null,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                TextFormField(
                  controller: _percentController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    labelText: 'Price Adjustment % (optional)',
                    hintText: 'e.g. 10 for +10%, -5 for -5%',
                    helperText: 'Adjust all copied prices by this percentage',
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SecondaryButton(
                      label: 'Cancel',
                      onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    PrimaryButton(
                      label: 'Copy Price List',
                      isLoading: _isSaving,
                      onPressed: _isSaving ? null : _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 3. Bulk Percent Adjust Dialog (with Preview) ────────────────────────────

class PriceListAdjustDialog extends StatefulWidget {
  const PriceListAdjustDialog({
    super.key,
    required this.cubit,
  });

  final PriceListsCubit cubit;

  static Future<void> show(BuildContext context, PriceListsCubit cubit) {
    return showDialog(
      context: context,
      builder: (ctx) => PriceListAdjustDialog(cubit: cubit),
    );
  }

  @override
  State<PriceListAdjustDialog> createState() => _PriceListAdjustDialogState();
}

class _PriceListAdjustDialogState extends State<PriceListAdjustDialog> {
  final _percentController = TextEditingController();
  final _roundToController = TextEditingController();
  String? _selectedCategoryId;
  List<CategoryModel> _categories = [];
  bool _isPreviewing = false;
  bool _isApplying = false;
  AdjustPricesResponseModel? _previewResult;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _percentController.dispose();
    _roundToController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    if (sl.isRegistered<ProductsRepository>()) {
      final res = await sl<ProductsRepository>().getCategories();
      res.fold((_) {}, (cats) {
        if (mounted) setState(() => _categories = cats);
      });
    }
  }

  Future<void> _runPreview() async {
    final pct = _percentController.text.trim();
    if (pct.isEmpty) {
      AppAlerts.showErrorMessage(context, 'Please enter a percentage to adjust (e.g. 5 or -10).');
      return;
    }
    setState(() {
      _isPreviewing = true;
      _previewResult = null;
    });

    final preview = await widget.cubit.previewAdjust(
      percent: pct,
      categoryId: _selectedCategoryId,
      roundTo: _roundToController.text.trim().isEmpty ? null : _roundToController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isPreviewing = false;
        _previewResult = preview;
      });
    }
  }

  Future<void> _runApply() async {
    final pct = _percentController.text.trim();
    if (pct.isEmpty) return;

    setState(() => _isApplying = true);
    final ok = await widget.cubit.applyAdjust(
      percent: pct,
      categoryId: _selectedCategoryId,
      roundTo: _roundToController.text.trim().isEmpty ? null : _roundToController.text.trim(),
    );

    if (mounted) {
      setState(() => _isApplying = false);
      if (ok) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.percent, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.spacingSm),
                  const Text(
                    'Bulk Price Adjustment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _percentController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      decoration: const InputDecoration(
                        labelText: 'Percentage (%) *',
                        hintText: 'e.g. 10 or -5',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String?>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Category (optional)'),
                      items: [
                        const DropdownMenuItem<String?>(value: null, child: Text('All Categories')),
                        ..._categories.map((c) => DropdownMenuItem<String?>(value: c.id, child: Text(c.name))),
                      ],
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _roundToController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Round to',
                        hintText: 'e.g. 5, 10',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton.icon(
                      icon: _isPreviewing
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.visibility),
                      label: const Text('Preview'),
                      onPressed: _isPreviewing || _isApplying ? null : _runPreview,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _previewResult == null
                    ? Center(
                        child: Text(
                          _isPreviewing
                              ? 'Calculating preview...'
                              : 'Enter an adjustment percentage and click "Preview" to see sample price changes before applying.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'Preview summary: ${_previewResult!.updated} items to update, ${_previewResult!.unchanged} unchanged.',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sample Changes:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _previewResult!.sample.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, idx) {
                                final s = _previewResult!.sample[idx];
                                return ListTile(
                                  dense: true,
                                  title: Text('Item ${s.itemId.substring(0, 8)}...'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Rs ${s.oldPrice}',
                                        style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                                      ),
                                      const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                                      Text(
                                        ' Rs ${s.newPrice}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    label: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(
                    label: 'Apply Adjustment',
                    isLoading: _isApplying,
                    onPressed: _previewResult == null || _isApplying ? null : _runApply,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 4. CSV Import Dialog ───────────────────────────────────────────────────

class PriceListImportDialog extends StatefulWidget {
  const PriceListImportDialog({
    super.key,
    required this.cubit,
  });

  final PriceListsCubit cubit;

  static Future<void> show(BuildContext context, PriceListsCubit cubit) {
    return showDialog(
      context: context,
      builder: (ctx) => PriceListImportDialog(cubit: cubit),
    );
  }

  @override
  State<PriceListImportDialog> createState() => _PriceListImportDialogState();
}

class _PriceListImportDialogState extends State<PriceListImportDialog> {
  String? _selectedFilePath;
  String? _csvContent;
  bool _isValidating = false;
  bool _isApplying = false;
  String _onErrorMode = 'abort'; // 'abort' or 'skip'
  Map<String, dynamic>? _importReport;
  String? _errorMessage;

  static const String _templateCsv =
      'sku,price,min_qty\n'
      'RICE-5KG,1050.00,1\n'
      'RICE-5KG,980.00,10\n'
      'OIL-1L,520.00,1\n'
      'TEA-400G,480.00,1\n';

  Future<void> _downloadTemplate() async {
    final bytes = Uint8List.fromList(utf8.encode(_templateCsv));
    final savedPath = await sl<FileSaverService>().saveFileWithDialog(
      'price_list_template.csv',
      bytes,
    );
    if (savedPath != null && mounted) {
      AppAlerts.showSuccessMessage(context, 'Template saved: $savedPath');
    }
  }

  Future<void> _pickFile() async {
    final path = await sl<FileSaverService>().pickFile(
      extensions: ['csv'],
      label: 'Select Price List CSV file',
    );
    if (path == null) return;

    try {
      final file = sl<FileSaverService>().readFile(path);
      final text = await file.readAsString();
      setState(() {
        _selectedFilePath = path;
        _csvContent = text;
        _importReport = null;
        _errorMessage = null;
      });
      await _runValidation();
    } catch (e) {
      setState(() => _errorMessage = 'Failed to read file: $e');
    }
  }

  Future<void> _runValidation() async {
    if (_csvContent == null) return;
    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    final report = await widget.cubit.importCsv(
      csvContent: _csvContent!,
      dryRun: true,
      onError: _onErrorMode,
    );

    if (mounted) {
      setState(() {
        _isValidating = false;
        _importReport = report;
      });
    }
  }

  Future<void> _applyImport() async {
    if (_csvContent == null) return;
    setState(() {
      _isApplying = true;
      _errorMessage = null;
    });

    final report = await widget.cubit.importCsv(
      csvContent: _csvContent!,
      dryRun: false,
      onError: _onErrorMode,
    );

    if (mounted) {
      setState(() => _isApplying = false);
      if (report != null) {
        AppAlerts.showSuccessMessage(context, 'Price list imported successfully.');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _importReport?['summary'] as Map<String, dynamic>?;
    final rowErrors = (_importReport?['rows'] as List<dynamic>? ?? const [])
        .where((r) => r is Map && r['status'] == 'error')
        .toList();
    final hasErrors = rowErrors.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 650),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.file_upload_outlined, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.spacingSm),
                  const Text(
                    'Import Prices from CSV',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download Template'),
                    onPressed: _downloadTemplate,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.attach_file, size: 18),
                    label: Text(_selectedFilePath == null ? 'Select CSV File' : 'Change File'),
                    onPressed: _isValidating || _isApplying ? null : _pickFile,
                  ),
                  if (_selectedFilePath != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFilePath!.split(r'\').last,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('On Row Error:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'abort', label: Text('Abort all on error')),
                      ButtonSegment(value: 'skip', label: Text('Skip invalid rows')),
                    ],
                    selected: {_onErrorMode},
                    onSelectionChanged: (set) {
                      setState(() => _onErrorMode = set.first);
                      if (_csvContent != null) _runValidation();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  color: AppColors.error.withValues(alpha: 0.1),
                  child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
                ),
              Expanded(
                child: _isValidating
                    ? const Center(child: CircularProgressIndicator())
                    : _importReport == null
                        ? Center(
                            child: Text(
                              _selectedFilePath == null
                                  ? 'Download the CSV template or select an existing CSV file with sku, price, min_qty.'
                                  : 'Click validate to check your CSV file.',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: hasErrors
                                      ? AppColors.error.withValues(alpha: 0.08)
                                      : AppColors.success.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Summary: ${summary?['total_rows'] ?? 0} total rows | '
                                  '${summary?['create'] ?? 0} created | '
                                  '${summary?['update'] ?? 0} updated | '
                                  '${summary?['unchanged'] ?? 0} unchanged | '
                                  '${summary?['errors'] ?? 0} errors',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: hasErrors ? AppColors.error : AppColors.success,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (hasErrors) ...[
                                const Text('Errors found:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: rowErrors.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (context, idx) {
                                      final err = rowErrors[idx] as Map;
                                      return ListTile(
                                        dense: true,
                                        leading: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: AppColors.error.withValues(alpha: 0.2),
                                          child: Text('${err['row_index'] ?? idx + 1}', style: const TextStyle(fontSize: 10, color: AppColors.error)),
                                        ),
                                        title: Text('Row ${err['row_index']}: ${err['errors'] ?? err['error']}'),
                                      );
                                    },
                                  ),
                                ),
                              ] else
                                const Expanded(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle, color: AppColors.success),
                                        SizedBox(width: 8),
                                        Text('No errors detected! Ready to apply.'),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(
                    label: 'Apply Import',
                    isLoading: _isApplying,
                    onPressed: (_importReport == null || _isApplying || (hasErrors && _onErrorMode == 'abort'))
                        ? null
                        : _applyImport,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 5. Add / Edit Price Item Dialog ────────────────────────────────────────

class PriceItemFormDialog extends StatefulWidget {
  const PriceItemFormDialog({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  final PriceListItemDetailModel? initialItem;
  final Future<bool> Function({
    required String productId,
    String? variationId,
    required String price,
    required String minQty,
  }) onSave;

  static Future<bool?> show(
    BuildContext context, {
    PriceListItemDetailModel? initialItem,
    required Future<bool> Function({
      required String productId,
      String? variationId,
      required String price,
      required String minQty,
    }) onSave,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => PriceItemFormDialog(
        initialItem: initialItem,
        onSave: onSave,
      ),
    );
  }

  @override
  State<PriceItemFormDialog> createState() => _PriceItemFormDialogState();
}

class _PriceItemFormDialogState extends State<PriceItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _minQtyController = TextEditingController(text: '1');
  final _searchController = TextEditingController();

  List<ProductListItemModel> _searchResults = [];
  ProductListItemModel? _selectedProduct;
  bool _isSearching = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      _priceController.text = widget.initialItem!.unitPrice;
      _minQtyController.text = widget.initialItem!.minQty;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _minQtyController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    if (sl.isRegistered<ProductsRepository>()) {
      final res = await sl<ProductsRepository>().getProducts(search: query.trim());
      res.fold((_) {}, (paged) {
        if (mounted) setState(() => _searchResults = paged.items);
      });
    }
    if (mounted) setState(() => _isSearching = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final productId = widget.initialItem?.productId ?? _selectedProduct?.id;
    if (productId == null) {
      AppAlerts.showErrorMessage(context, 'Please select a product.');
      return;
    }

    setState(() => _isSaving = true);
    final ok = await widget.onSave(
      productId: productId,
      variationId: widget.initialItem?.variationId,
      price: _priceController.text.trim(),
      minQty: _minQtyController.text.trim().isEmpty ? '1' : _minQtyController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (ok) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(isEdit ? Icons.edit : Icons.add_circle, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      isEdit ? 'Edit Price Tier' : 'Add Product Price',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
                const Divider(),
                if (isEdit) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(widget.initialItem!.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'SKU: ${widget.initialItem!.sku ?? "-"} | Variation: ${widget.initialItem!.variationName ?? "Standard"}',
                    ),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Product (Name, SKU, Barcode)',
                      suffixIcon: _isSearching
                          ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () => _searchProducts(_searchController.text),
                            ),
                    ),
                    onFieldSubmitted: _searchProducts,
                  ),
                  if (_searchResults.isNotEmpty)
                    Container(
                      height: 140,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(4)),
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, idx) {
                          final p = _searchResults[idx];
                          final isSel = _selectedProduct?.id == p.id;
                          return ListTile(
                            dense: true,
                            selected: isSel,
                            selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                            title: Text(p.name),
                            subtitle: Text('SKU: ${p.sku ?? "-"}'),
                            onTap: () => setState(() => _selectedProduct = p),
                          );
                        },
                      ),
                    ),
                  if (_selectedProduct != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Selected: ${_selectedProduct!.name}',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
                const SizedBox(height: AppDimensions.spacingMd),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Unit Price *', prefixText: 'Rs '),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final d = Decimal.tryParse(v.trim());
                          if (d == null || d < Decimal.zero) return 'Invalid price';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _minQtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Min Qty *',
                          helperText: 'Tier threshold',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final d = Decimal.tryParse(v.trim());
                          if (d == null || d <= Decimal.zero) return '> 0';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SecondaryButton(
                      label: 'Cancel',
                      onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    PrimaryButton(
                      label: 'Save Price',
                      isLoading: _isSaving,
                      onPressed: _isSaving ? null : _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
