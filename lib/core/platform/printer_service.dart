import 'dart:typed_data';

import 'package:printing/printing.dart';

/// Sends a rendered document to a printer.
abstract class PrinterService {
  /// Prints [pdfBytes]. Windows opens the system print dialog; a later mobile
  /// implementation can target a Bluetooth/ESC-POS printer instead.
  Future<void> printPdf(Uint8List pdfBytes, {String jobName = 'Receipt'});
}

class WindowsPrinterService implements PrinterService {
  const WindowsPrinterService();

  @override
  Future<void> printPdf(Uint8List pdfBytes, {String jobName = 'Receipt'}) async {
    await Printing.layoutPdf(onLayout: (_) async => pdfBytes, name: jobName);
  }
}
