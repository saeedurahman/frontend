import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/settings/presentation/pages/printer_settings_page.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

class _Printer implements PrinterService {
  @override
  Future<List<Printer>> listPrinters() async => const [];
  @override
  Future<PrinterConfig> loadConfig() async => const PrinterConfig();
  @override
  Future<void> saveConfig(PrinterConfig config) async {}
  @override
  Future<bool> printPdf(Uint8List pdfBytes,
          {String jobName = 'Receipt', PrinterConfig? config, bool forceDialog = false}) async =>
      true;
  @override
  Future<void> openCashDrawer() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> open(WidgetTester t) async {
    final prev = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exceptionAsString().contains('overflowed')) return; // Ahem is wider than the real font
      prev?.call(d);
    };
    addTearDown(() => FlutterError.onError = prev);
    t.view.physicalSize = const Size(1400, 2400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    if (sl.isRegistered<PrinterService>()) sl.unregister<PrinterService>();
    sl.registerSingleton<PrinterService>(_Printer());
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const PrinterSettingsPage()),
      GoRoute(
        path: '/settings/receipt-layouts',
        builder: (_, __) => const Scaffold(body: Text('layouts-list-page')),
      ),
    ]);
    addTearDown(router.dispose);
    await t.pumpWidget(MaterialApp.router(routerConfig: router));
    await t.pumpAndSettle();
  }

  testWidgets('keeps only the printer hardware and behaviour controls', (t) async {
    await open(t);
    expect(find.text('Receipt Printer'), findsOneWidget);
    expect(find.text('Connected Printer'), findsOneWidget);
    expect(find.text('Number of Receipt Copies'), findsOneWidget);
    expect(find.text('Auto-print receipt after sale'), findsOneWidget);
    expect(find.text('Open cash drawer on print'), findsOneWidget);
    expect(find.text('Nastaliq (نستعلیق)'), findsOneWidget);
    expect(find.text('Naskh (نسخ)'), findsOneWidget);
    expect(find.textContaining('Print Test Receipt'), findsOneWidget);
    expect(find.text('Preview Receipt'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('the duplicate look-and-feel controls are gone', (t) async {
    await open(t);
    // Paper size, footer text, tax lines, logo, NTN/address/phone and language
    // live in Receipt Layouts now.
    for (final gone in [
      'Paper Size',
      'Paper size',
      '58 mm',
      '80 mm',
      'Footer',
      'Footer Text',
      'Show Tax',
      'Show tax',
      'Show Logo',
      'Show logo',
      'Show NTN',
      'Show Address',
      'Show Phone',
    ]) {
      expect(find.text(gone), findsNothing, reason: gone);
    }
    // The only radios left are the two Urdu font styles (no paper-size radios).
    expect(find.byType(Radio<String>), findsNWidgets(2));
    expect(find.byType(TextField), findsNothing);
    // Two switches only: auto-print and cash drawer.
    expect(find.byType(SwitchListTile), findsNWidgets(2));
  });

  testWidgets('a note explains where the receipt settings went and links to Receipt Layouts', (t) async {
    await open(t);
    expect(find.byKey(const Key('printer-layouts-note')), findsOneWidget);
    await t.tap(find.byKey(const Key('open-layouts-from-printer')));
    await t.pumpAndSettle();
    expect(find.text('layouts-list-page'), findsOneWidget);
  });
}
