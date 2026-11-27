// The purchase order paper: figures, the PDF, save / print / share, and the
// Download button.
import 'dart:convert' show latin1;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/services/purchase_order_pdf_service.dart';
import 'package:frantend/features/purchases/presentation/widgets/purchase_order_pdf_actions.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';

import '../helpers/sample_output.dart';

/// A real picture file, standing for the shop's logo.
final _logo = File('assets/app_logos/businessstar.png').readAsBytesSync();

const _business = BusinessProfileModel(
  id: 'b1',
  name: 'City Mart',
  addressLine1: '12 Mall Road',
  city: 'Lahore',
  phone: '0300 1112223',
  taxId: '1234567-8',
);

PurchaseOrderModel _order({int items = 2, String? notes = 'Deliver before noon'}) =>
    PurchaseOrderModel.fromJson({
      'id': 'po-1',
      'business_id': 'b1',
      'branch_id': 'br1',
      'supplier_id': 's1',
      'po_number': 'PO-0042',
      'status': 'ordered',
      'ordered_at': '2026-11-20T09:00:00',
      'expected_at': '2026-11-30T09:00:00',
      'notes': notes,
      'supplier': {
        'id': 's1',
        'business_id': 'b1',
        'name': 'Hamid Traders',
        'contact_person': 'Hamid',
        'phone': '0321 7654321',
      },
      'lines': [
        for (var i = 0; i < items; i++)
          {
            'id': 'l$i',
            'business_id': 'b1',
            'purchase_order_id': 'po-1',
            'product_id': 'p$i',
            'ordered_qty': i == 0 ? '10.0000' : '2.5',
            'received_qty': '0',
            'qty_remaining': '0',
            'cost_per_unit': i == 0 ? '100.00' : '40.10',
            'tax_rate': i == 0 ? '17' : '0',
            'product_name': i == 1 ? 'چینی (Sugar)' : 'Rice $i',
            'sku': 'SKU-$i',
          },
      ],
    });

class _Files extends Fake implements FileSaverService {
  String? name;
  Uint8List? bytes;
  String? answer = r'C:\out\PO-0042.pdf';

  @override
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  }) async {
    name = suggestedName;
    this.bytes = bytes;
    return answer;
  }
}

class _Printer extends Fake implements PrinterService {
  String? job;
  bool? dialog;
  Uint8List? bytes;

  @override
  Future<bool> printPdf(
    Uint8List pdfBytes, {
    String jobName = 'Receipt',
    PrinterConfig? config,
    bool forceDialog = false,
  }) async {
    bytes = pdfBytes;
    job = jobName;
    dialog = forceDialog;
    return true;
  }
}

class _Launcher extends Fake implements UrlLauncherService {
  Uri? uri;
  bool opens = true;

  @override
  Future<bool> launch(Uri uri, {bool externalApplication = true}) async {
    this.uri = uri;
    return opens;
  }
}

int _pages(Uint8List pdf) =>
    RegExp(r'/Type\s*/Page(?![s\w])').allMatches(latin1.decode(pdf)).length;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Files files;
  late _Printer printer;
  late _Launcher launcher;

  PurchaseOrderPdfService service({
    Future<BusinessProfileModel?> Function()? business,
    Future<List<int>?> Function()? logo,
  }) =>
      PurchaseOrderPdfService(
        business: business ?? () async => _business,
        logo: logo ?? () async => _logo,
        files: files,
        printer: printer,
        launcher: launcher,
      );

  setUp(() {
    TaxSettingsHolder.current = TaxSettings.defaults;
    files = _Files();
    printer = _Printer();
    launcher = _Launcher();
  });

  test('figures add up and match the order screen', () {
    final order = _order();
    final doc = PurchaseOrderDocument(order, business: _business);
    // 10 x 100 + 17% tax, 2.5 x 40.10
    expect(doc.subtotal.toString(), '1100.25');
    expect(doc.tax.toString(), '170');
    expect(doc.total.toString(), '1270.25');
    expect(doc.total.toDouble(), closeTo(order.grandTotal, 0.005));
    expect(PurchaseOrderDocument.quantity(doc.lines.first.ordered), '10');
    expect(doc.status, 'Submitted');
    expect(doc.fileName, 'PO-0042.pdf');
    expect(doc.businessLines, [
      '12 Mall Road, Lahore',
      'Phone: 0300 1112223',
      'NTN: 1234567-8',
    ]);
    expect(doc.supplierLines.take(2), ['Hamid Traders', 'Contact: Hamid']);
  });

  test('the shared text carries the order', () {
    final text = PurchaseOrderDocument(_order(), business: _business).plainText;
    for (final part in [
      'City Mart',
      'PURCHASE ORDER PO-0042',
      'To: Hamid Traders',
      '1. Rice 0: 10 x 100.00 = 1,000.00',
      'Total: Rs. 1,270.25',
      'Notes: Deliver before noon',
    ]) {
      expect(text, contains(part));
    }
    final long = PurchaseOrderDocument(_order(items: 45)).plainText;
    expect(long, contains('... and 15 more items'));
  });

  test('save writes a one page PDF under the order number', () async {
    final path = await service().save(_order());
    expect(path, files.answer);
    expect(files.name, 'PO-0042.pdf');
    expect(String.fromCharCodes(files.bytes!.take(5)), '%PDF-');
    expect(_pages(files.bytes!), 1);
    File('${sampleOutputDir('purchase_order_samples').path}/purchase_order.pdf')
        .writeAsBytesSync(files.bytes!);
  });

  test('a long order runs over several pages', () async {
    final bytes = await service().pdfBytes(_order(items: 90));
    expect(_pages(bytes), greaterThan(1));
  });

  test('the logo is in the PDF; a broken or missing one is left out', () async {
    // One English item, so the logo is the only possible picture.
    final english = _order(items: 1);
    final picture = RegExp(r'/Subtype\s*/Image');
    expect(latin1.decode(await service().pdfBytes(english)), contains(picture));
    for (final logo in <Future<List<int>?> Function()>[
      () async => null,
      () async => [1, 2, 3],
      // Reads as a PNG, fails while being drawn (a half written file).
      () async => _logo.sublist(0, _logo.length ~/ 2),
      () async => throw const SocketException('offline'),
    ]) {
      final bytes = await service(logo: logo).pdfBytes(english);
      expect(latin1.decode(bytes), isNot(contains(picture)));
      expect(_pages(bytes), 1);
    }
  });

  test('an Urdu name is drawn as a picture so its letters join', () async {
    final bytes = await service(logo: () async => null).pdfBytes(_order());
    expect(latin1.decode(bytes), contains(RegExp(r'/Subtype\s*/Image')));
  });

  test('no saved business details: still saved', () async {
    final s = service(business: () async => throw StateError('no copy'));
    await s.save(_order(notes: null));
    expect(files.bytes, isNotNull);
  });

  test('print opens the printer choice with the order as the job', () async {
    expect(await service().print(_order()), isTrue);
    expect(printer.job, 'Purchase order PO-0042');
    expect(printer.dialog, isTrue);
    expect(printer.bytes, isNotNull);
  });

  test('share opens WhatsApp to the supplier', () async {
    expect(await service().shareOnWhatsApp(_order()), isTrue);
    expect(launcher.uri!.host, 'wa.me');
    expect(launcher.uri!.path, '/923217654321');
    expect(launcher.uri!.queryParameters['text'], contains('PO-0042'));
  });

  group('Download button', () {
    Future<void> open(WidgetTester tester, PurchaseOrderPdfService s) async {
      sl.registerSingleton<PurchaseOrderPdfService>(s);
      addTearDown(() => sl.unregister<PurchaseOrderPdfService>());
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PurchaseOrderDownloadButton(order: _order())),
      ));
      await tester.tap(find.text('Download'));
      await tester.pumpAndSettle();
    }

    testWidgets('offers save, print and share', (tester) async {
      await open(tester, service());
      expect(find.text('Save PDF'), findsOneWidget);
      expect(find.text('Print'), findsOneWidget);
      await tester.tap(find.text('Share on WhatsApp'));
      await tester.pumpAndSettle();
      expect(launcher.uri, isNotNull);
    });

    testWidgets('says so when WhatsApp cannot be opened', (tester) async {
      launcher.opens = false;
      await open(tester, service());
      await tester.tap(find.text('Share on WhatsApp'));
      await tester.pumpAndSettle();
      expect(find.text(PurchaseOrderPdfActions.noWhatsApp), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });
  });
}
