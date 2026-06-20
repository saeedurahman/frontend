import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReceiptPreviewPage extends StatefulWidget {
  const ReceiptPreviewPage({super.key, required this.sale});

  final SaleResponseModel sale;

  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () => _newSale(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sale Completed!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.sale.saleNumber ?? widget.sale.id.substring(0, 8),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ReceiptCard(sale: widget.sale),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () =>
                            SaleReceiptService.printReceipt(widget.sale),
                        icon: const Icon(Icons.print),
                        label: const Text('Print Receipt'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final file = await SaleReceiptService.downloadPdf(
                            context,
                            widget.sale,
                          );
                          if (context.mounted && file != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saved to ${file.path}')),
                            );
                          }
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download PDF'),
                      ),
                      FilledButton.icon(
                        onPressed: () => _newSale(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('New Sale'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _newSale(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.go('/pos');
  }
}

class _ReceiptCard extends StatefulWidget {
  const _ReceiptCard({required this.sale});

  final SaleResponseModel sale;

  @override
  State<_ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<_ReceiptCard> {
  ReceiptDisplaySettings? _display;
  BusinessProfileModel? _business;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReceiptContext();
  }

  Future<void> _loadReceiptContext() async {
    final display = await SaleReceiptService.resolveDisplaySettings(
      branchId: widget.sale.branchId,
    );
    final business = await SaleReceiptService.resolveBusinessProfile();
    if (mounted) {
      setState(() {
        _display = display;
        _business = business;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sale = widget.sale;
    final dateStr = sale.soldAt ?? sale.createdAt;
    final date = dateStr != null
        ? DateFormat.yMMMd().add_jm().format(DateTime.parse(dateStr))
        : DateFormat.yMMMd().add_jm().format(DateTime.now());

    return Container(
      width: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _business?.name ?? 'PakPOS',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          if (_business?.addressLine1?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              _business!.addressLine1!,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
          if (_business?.phone?.isNotEmpty == true)
            Text(
              _business!.phone!,
              style: const TextStyle(fontSize: 11),
            ),
          if (_business?.taxId?.isNotEmpty == true)
            Text(
              'NTN: ${_business!.taxId}',
              style: const TextStyle(fontSize: 11),
            ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 12)),
          Text(
            'Sale: ${sale.saleNumber ?? sale.id.substring(0, 8)}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Customer: ${sale.customer?.name ?? 'Walk-in'}',
            style: const TextStyle(fontSize: 12),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          ...sale.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${line.productName ?? 'Item'} x ${line.qty}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    formatPKR(SaleCalculations.lineTotal(line).toDouble()),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _Row('Subtotal', sale.subtotal),
          _Row('Discount', sale.totalDiscount),
          _Row('Tax', sale.totalTax),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(
                formatPKR(double.tryParse(sale.totalAmount) ?? 0),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          ...sale.payments.map(
            (p) => _Row(
              p.paymentMethod,
              p.amount,
            ),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              _display?.footerText ?? 'Thank you for shopping with us!',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            formatPKR(double.tryParse(value!) ?? 0),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
