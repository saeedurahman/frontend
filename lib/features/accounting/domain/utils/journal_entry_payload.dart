import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';

/// API-ready journal lines — account set and positive amount on one side.
List<Map<String, dynamic>> journalLinesForApi(List<JournalLineDraft> lines) {
  return lines
      .where((line) => line.accountId != null && line.hasPositiveAmount)
      .map(journalLineDraftToJson)
      .toList();
}

Map<String, dynamic> buildJournalEntryPayload({
  required String entryDate,
  String? description,
  required List<JournalLineDraft> lines,
}) {
  return {
    'entry_date': entryDate,
    if (description != null && description.trim().isNotEmpty)
      'description': description.trim(),
    'lines': journalLinesForApi(lines),
  };
}

/// Returns per-line validation errors keyed as `line_0`, etc.
Map<String, String> validateJournalLineDrafts(List<JournalLineDraft> lines) {
  final errors = <String, String>{};
  var validCount = 0;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final hasAccount = line.accountId != null;
    final hasAmount = line.hasPositiveAmount;

    if (hasAccount && hasAmount) {
      validCount++;
      continue;
    }
    if (!hasAccount && !hasAmount) continue;

    if (!hasAccount) {
      errors['line_$i'] = 'Select an account';
    } else if (!hasAmount) {
      errors['line_$i'] = 'Enter an amount';
    }
  }

  if (validCount == 0) {
    errors['lines'] = 'Add at least one line with an account and amount';
  }

  return errors;
}
