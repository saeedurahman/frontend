import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract final class SaleReceiptService {
  static Future<BusinessProfileModel?> resolveBusinessProfile() async {
    final useCase = sl<GetBusinessProfileUseCase>();
    final result = await useCase();
    return result.fold((_) => null, (business) => business);
  }

  static Future<ReceiptDisplaySettings> resolveDisplaySettings({
    String? branchId,
  }) async {
    final useCase = sl<GetReceiptDisplaySettingsUseCase>();
    final result = await useCase(branchId: branchId);
    return result.fold(
      (_) => const ReceiptDisplaySettings(
        footerText: 'Thank you for shopping with us!',
        paperSize: '80mm',
      ),
      (settings) => settings,
    );
  }

  static PdfPageFormat pageFormat(String paperSize, {required bool thermal}) {
    if (!thermal) return PdfPageFormat.a4;
    return paperSize == '58mm' ? PdfPageFormat.roll57 : PdfPageFormat.roll80;
  }

  static Future<void> printReceipt(SaleResponseModel sale) async {
    final display = await resolveDisplaySettings(branchId: sale.branchId);
    final doc = await buildPdf(
      sale,
      thermal: true,
      displaySettings: display,
    );
    await sl<PrinterService>().printPdf(
      await doc.save(),
      jobName: sale.saleNumber ?? 'Receipt',
    );
  }

  static Future<File?> downloadPdf(
    BuildContext context,
    SaleResponseModel sale,
  ) async {
    final display = await resolveDisplaySettings(branchId: sale.branchId);
    final doc = await buildPdf(
      sale,
      thermal: false,
      displaySettings: display,
    );
    final bytes = await doc.save();
    final path = await sl<FileSaverService>().saveBytes(
      'receipt_${sale.saleNumber ?? sale.id}.pdf',
      bytes,
    );
    return File(path);
  }

  static Future<pw.Document> buildPdf(
    SaleResponseModel sale, {
    required bool thermal,
    ReceiptDisplaySettings? displaySettings,
  }) async {
    final display =
        displaySettings ?? await resolveDisplaySettings(branchId: sale.branchId);
    final business = await resolveBusinessProfile();
    final doc = pw.Document();
    final date = sale.soldAt ?? sale.createdAt ?? DateTime.now().toIso8601String();

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat(display.paperSize, thermal: thermal),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                business?.name ?? AppBrand.current.appName,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (business?.addressLine1?.isNotEmpty == true)
                pw.Text(
                  business!.addressLine1!,
                  style: const pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.center,
                ),
              if (business?.phone?.isNotEmpty == true)
                pw.Text(
                  business!.phone!,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              if (business?.taxId?.isNotEmpty == true)
                pw.Text(
                  'NTN: ${business!.taxId}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              pw.SizedBox(height: 4),
              pw.Text(
                DateFormat.yMMMd().add_jm().format(DateTime.parse(date)),
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Sale: ${sale.saleNumber ?? sale.id}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Divider(),
              ...sale.lines.map(
                (line) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        '${line.productName ?? 'Item'} x ${line.qty}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                    pw.Text(
                      formatPKR(SaleCalculations.lineTotal(line).toDouble()),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    formatPKR(double.tryParse(sale.totalAmount) ?? 0),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              ...sale.payments.map(
                (p) => pw.Text(
                  '${p.paymentMethod}: ${formatPKR(double.tryParse(p.amount) ?? 0)}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                display.footerText,
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                AppBrand.current.receiptPoweredBy,
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
    return doc;
  }
}
