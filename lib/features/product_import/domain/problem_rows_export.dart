import 'dart:convert';
import 'dart:typed_data';

import 'package:frantend/features/product_import/domain/import_models.dart';

/// "Download rows with problems": a CSV of only the failing rows, with an
/// extra `Reason` column, so the owner can fix them and import that file.
///
/// For a CSV file the original cells are kept as they were typed. An Excel
/// file is not opened on the device, so its rows come from the server's report
/// (row, name, sku, barcode).
///
/// The server's report lists the first 200 rows in full and up to 10 sample
/// rows per kind of problem; a failing row outside both is counted but cannot
/// be listed. [ProblemRowsExport.missing] says how many.
class ProblemRowsExport {
  const ProblemRowsExport({
    required this.csv,
    required this.rows,
    required this.missing,
  });

  final String csv;

  /// How many failing rows are in the file.
  final int rows;

  /// Failing rows the report counts but could not name.
  final int missing;

  Uint8List get bytes =>
      Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]);

  static ProblemRowsExport build(ImportFile file, ImportReport report) {
    final reasons = <int, List<String>>{};
    for (final r in report.rows) {
      if (!r.hasError) continue;
      reasons[r.row] = r.errors.isNotEmpty
          ? [...r.errors]
          : ['This row has a problem'];
    }
    for (final g in report.groups) {
      for (final line in g.sampleRows) {
        final list = reasons.putIfAbsent(line, () => []);
        if (!list.any((e) => e.toLowerCase() == g.message.toLowerCase()))
          list.add(g.message);
      }
    }
    final lines = reasons.keys.toList()..sort();
    final missing = (report.summary.errors - lines.length).clamp(0, 1 << 30);

    final text = file.csvText;
    final out = StringBuffer();
    if (text != null) {
      final table = CsvTable.parse(text);
      out.writeln(_line([...table.header, 'Reason']));
      for (final line in lines) {
        final cells = table.recordAtLine(line);
        if (cells == null) continue;
        out.writeln(_line([...cells, reasons[line]!.join('; ')]));
      }
    } else {
      out.writeln(_line(['Row', 'Name', 'SKU', 'Barcode', 'Reason']));
      for (final line in lines) {
        final r = report.rowAt(line);
        out.writeln(
          _line([
            '$line',
            r?.name ?? '',
            r?.sku ?? '',
            r?.barcode ?? '',
            reasons[line]!.join('; '),
          ]),
        );
      }
    }
    return ProblemRowsExport(
      csv: out.toString(),
      rows: lines.length,
      missing: missing,
    );
  }

  static String fileNameFor(ImportFile file) {
    final base = file.name.replaceAll(
      RegExp(r'\.(csv|xlsx)$', caseSensitive: false),
      '',
    );
    return '$base - rows with problems.csv';
  }

  static String _line(List<String> cells) => cells.map(_cell).join(',');

  static String _cell(String v) {
    if (v.contains(',') ||
        v.contains('"') ||
        v.contains('\n') ||
        v.contains('\r')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }
}

/// A small CSV reader: quoted cells, doubled quotes, line breaks inside quotes,
/// and comma / semicolon / tab as the separator. It remembers the file line
/// each record starts on, because the server numbers rows by file line.
class CsvTable {
  CsvTable._(this.header, this._records, this._lines);

  final List<String> header;
  final List<List<String>> _records;
  final List<int> _lines;

  static CsvTable parse(String text) {
    final delimiter = _delimiterOf(text);
    final records = <List<String>>[];
    final startLines = <int>[];
    var row = <String>[];
    final cell = StringBuffer();
    var inQuotes = false;
    var line = 1;
    var recordStart = 1;
    var any = false;

    void endCell() {
      row.add(cell.toString());
      cell.clear();
    }

    void endRecord() {
      endCell();
      if (row.length == 1 && row.first.trim().isEmpty) {
        // A blank line: not a record.
      } else {
        records.add(row);
        startLines.add(recordStart);
      }
      row = <String>[];
      any = false;
    }

    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (inQuotes) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          if (c == '\n') line++;
          cell.write(c);
        }
        continue;
      }
      if (c == '"' && cell.isEmpty) {
        inQuotes = true;
        any = true;
      } else if (c == delimiter) {
        endCell();
        any = true;
      } else if (c == '\r') {
        // handled with the \n
      } else if (c == '\n') {
        endRecord();
        line++;
        recordStart = line;
      } else {
        cell.write(c);
        any = true;
      }
    }
    if (any || cell.isNotEmpty || row.isNotEmpty) endRecord();

    if (records.isEmpty) return CsvTable._(const [], const [], const []);
    return CsvTable._(records.first, records.sublist(1), startLines.sublist(1));
  }

  /// The data record that starts on [line] (header = line 1), or null.
  List<String>? recordAtLine(int line) {
    final i = _lines.indexOf(line);
    if (i < 0) return null;
    final r = _records[i];
    if (r.length >= header.length) return r;
    return [...r, ...List.filled(header.length - r.length, '')];
  }

  int get length => _records.length;

  static String _delimiterOf(String text) {
    final firstLine = text.split('\n').first;
    final commas = ','.allMatches(firstLine).length;
    final semis = ';'.allMatches(firstLine).length;
    final tabs = '\t'.allMatches(firstLine).length;
    if (tabs > commas && tabs > semis) return '\t';
    if (semis > commas) return ';';
    return ',';
  }
}
