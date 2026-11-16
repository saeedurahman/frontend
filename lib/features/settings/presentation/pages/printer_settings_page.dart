import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  bool _isLoading = true;
  bool _isPrintingTest = false;
  List<Printer> _printers = [];
  PrinterConfig _config = const PrinterConfig();

  @override
  void initState() {
    super.initState();
    _loadPrintersAndConfig();
  }

  Future<void> _loadPrintersAndConfig() async {
    setState(() => _isLoading = true);
    final printerService = sl<PrinterService>();
    final config = await printerService.loadConfig();
    final printers = await printerService.listPrinters();

    if (mounted) {
      setState(() {
        _config = config;
        _printers = printers;
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    await sl<PrinterService>().saveConfig(_config);
    if (mounted) {
      AppAlerts.showSuccessMessage(context, 'Printer settings saved successfully');
    }
  }

  Future<void> _previewReceipt() async {
    try {
      final doc = await SaleReceiptService.buildTestPdf(
        paperSize: _config.paperSize,
        urduStyle: _config.urduStyle,
      );
      final bytes = await doc.save();
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550, maxHeight: 700),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'Receipt Preview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: PdfPreview(
                    build: (format) => bytes,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    allowPrinting: true,
                    allowSharing: false,
                    initialPageFormat: _config.paperSize == '58mm'
                        ? PdfPageFormat.roll57
                        : PdfPageFormat.roll80,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        AppAlerts.showErrorMessage(context, 'Unable to preview receipt: $e');
      }
    }
  }

  Future<void> _testPrint() async {
    if (_printers.isEmpty && _config.printerName == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'No printer found. You can still preview or save the receipt as PDF',
            ),
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Preview',
              onPressed: _previewReceipt,
            ),
          ),
        );
      }
      return;
    }

    setState(() => _isPrintingTest = true);
    try {
      final doc = await SaleReceiptService.buildTestPdf(
        paperSize: _config.paperSize,
        urduStyle: _config.urduStyle,
      );
      final bytes = await doc.save();
      final success = await sl<PrinterService>().printPdf(
        bytes,
        jobName: 'Test Receipt',
        config: _config,
      );

      if (mounted) {
        if (success) {
          AppAlerts.showSuccessMessage(context, 'Test print sent successfully');
        } else if (_printers.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'No printer found. You can still preview or save the receipt as PDF',
              ),
              duration: const Duration(seconds: 6),
              action: SnackBarAction(
                label: 'Preview',
                onPressed: _previewReceipt,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Test print failed or was cancelled'),
              action: SnackBarAction(
                label: 'Print again',
                onPressed: _testPrint,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        if (_printers.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'No printer found. You can still preview or save the receipt as PDF',
              ),
              duration: const Duration(seconds: 6),
              action: SnackBarAction(
                label: 'Preview',
                onPressed: _previewReceipt,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Print error: $e'),
              action: SnackBarAction(
                label: 'Print again',
                onPressed: _testPrint,
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isPrintingTest = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer & Hardware Settings'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save Settings'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrinterSelectionCard(),
                const SizedBox(height: AppDimensions.spacingMd),
                _buildPaperAndCopiesCard(),
                const SizedBox(height: AppDimensions.spacingMd),
                _buildAutomationCard(),
                const SizedBox(height: AppDimensions.spacingLg),
                _buildTestPrintButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrinterSelectionCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.print, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Default Receipt Printer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh printer list',
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadPrintersAndConfig,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the thermal or standard printer connected to this computer. '
              'Direct silent printing will use this printer automatically.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              value: _config.printerName,
              decoration: InputDecoration(
                labelText: 'Connected Printer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                prefixIcon: const Icon(Icons.local_printshop_outlined),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    'Always show Windows Print Dialog (No default)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final p in _printers)
                  DropdownMenuItem<String?>(
                    value: p.name,
                    child: Text(
                      '${p.name}${p.isDefault ? ' (System Default)' : ''}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (val) {
                setState(() {
                  _config = _config.copyWith(printerName: val);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperAndCopiesCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paper Size & Copies',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thermal Paper Width',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('80 mm (Standard POS Roll)'),
                    subtitle: const Text('Most common desktop thermal receipt roll'),
                    value: '80mm',
                    groupValue: _config.paperSize,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _config = _config.copyWith(paperSize: val));
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('58 mm (Compact Roll)'),
                    subtitle: const Text('Narrow receipt format for mobile/small printers'),
                    value: '58mm',
                    groupValue: _config.paperSize,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _config = _config.copyWith(paperSize: val));
                      }
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number of Receipt Copies',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        'Print multiple copies per transaction (e.g. customer & merchant copy)',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _config.copies > 1
                          ? () => setState(() =>
                              _config = _config.copyWith(copies: _config.copies - 1))
                          : null,
                    ),
                    Text(
                      '${_config.copies}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _config.copies < 5
                          ? () => setState(() =>
                              _config = _config.copyWith(copies: _config.copies + 1))
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Urdu Style / اسلوب اردو',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Nastaliq (نستعلیق)'),
                    subtitle: const Text('Traditional Urdu Nastaliq calligraphy (recommended for Pakistan)'),
                    value: 'nastaliq',
                    groupValue: _config.urduStyle,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _config = _config.copyWith(urduStyle: val));
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Naskh (نسخ)'),
                    subtitle: const Text('Modern Arabic Naskh style (compact line height)'),
                    value: 'naskh',
                    groupValue: _config.urduStyle,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _config = _config.copyWith(urduStyle: val));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text(
                'Auto-print receipt after sale',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Immediately trigger silent printing when a sale is completed at POS',
              ),
              value: _config.autoPrintAfterSale,
              onChanged: (val) {
                setState(() =>
                    _config = _config.copyWith(autoPrintAfterSale: val));
              },
            ),
            const Divider(height: 16),
            SwitchListTile(
              title: const Text(
                'Open cash drawer on print',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Send ESC/POS kick pulse to connected cash drawer port',
              ),
              value: _config.openCashDrawer,
              onChanged: (val) {
                setState(() => _config = _config.copyWith(openCashDrawer: val));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestPrintButton() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _isPrintingTest ? null : _testPrint,
              icon: _isPrintingTest
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.print_outlined),
              label: Text(_isPrintingTest ? 'Printing...' : 'Print Test Receipt (with Urdu demo)'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 50,
            child: FilledButton.tonalIcon(
              onPressed: _previewReceipt,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Preview Receipt'),
            ),
          ),
        ),
      ],
    );
  }
}

