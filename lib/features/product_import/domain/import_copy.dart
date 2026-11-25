import 'package:frantend/features/product_import/domain/import_models.dart';

/// Plain words for the import screens. No jargon: a shop owner reads these.
abstract final class ImportCopy {
  static String plural(int n, String one, [String? many]) =>
      '$n ${n == 1 ? one : (many ?? '${one}s')}';

  /// "pkt, ltr, kg and 2 more".
  static String names(List<String> items, {int show = 4}) {
    if (items.length <= show) return items.join(', ');
    return '${items.take(show).join(', ')} and ${items.length - show} more';
  }

  /// "Your file uses 4 new units (kg, ltr, pkt, pcs) and 3 new categories. We will create them for you."
  ///
  /// [unitsToCreate] / [categoriesToCreate] / [taxRatesToCreate] are the
  /// inputs the owner has not mapped to an existing one.
  static String setupSentence({
    required List<String> unitsToCreate,
    required List<String> categoriesToCreate,
    required List<String> taxRatesToCreate,
    required bool createAutomatically,
    required bool canCreateTaxRates,
  }) {
    final parts = <String>[];
    if (unitsToCreate.isNotEmpty) {
      parts.add(
        '${plural(unitsToCreate.length, 'new unit')} (${names(unitsToCreate)})',
      );
    }
    if (categoriesToCreate.isNotEmpty) {
      parts.add(
        '${plural(categoriesToCreate.length, 'new category', 'new categories')} '
        '(${names(categoriesToCreate)})',
      );
    }
    final withTax = taxRatesToCreate.isNotEmpty;
    if (withTax) {
      parts.add(
        '${plural(taxRatesToCreate.length, 'new tax rate')} (${names(taxRatesToCreate)})',
      );
    }
    if (parts.isEmpty) {
      return 'Everything in your file already exists in your shop. Nothing new to set up.';
    }
    final uses = 'Your file uses ${_join(parts)}.';
    if (createAutomatically) {
      final tax = withTax && !canCreateTaxRates
          ? ' Only the owner can add tax rates, so your usual tax is used for those rows.'
          : '';
      return '$uses We will create them for you.$tax';
    }
    final hasUnits = unitsToCreate.isNotEmpty;
    final hasCategories = categoriesToCreate.isNotEmpty;
    final what = [
      if (hasUnits) 'Rows with a new unit will be marked as problems.',
      if (hasCategories)
        'Rows with a new category are added without a category.',
    ].join(' ');
    return '$uses We will not create them. $what'.trim();
  }

  static String _join(List<String> parts) {
    if (parts.length == 1) return parts.first;
    return '${parts.sublist(0, parts.length - 1).join(', ')} and ${parts.last}';
  }

  /// "Add 24 products", "Update 3 products", "Add 21, update 3".
  static String applyLabel(ImportSummary s) {
    if (s.create > 0 && s.update > 0)
      return 'Add ${s.create}, update ${s.update}';
    if (s.create > 0) return 'Add ${plural(s.create, 'product')}';
    if (s.update > 0) return 'Update ${plural(s.update, 'product')}';
    return 'Nothing to import';
  }

  /// "24 added, 3 updated, 2 skipped".
  static String resultHeadline(ImportSummary s, {int? skipped}) {
    final parts = <String>[
      if (s.create > 0) '${s.create} added',
      if (s.update > 0) '${s.update} updated',
      if (s.unchanged > 0) '${s.unchanged} unchanged',
      if ((skipped ?? s.errors) > 0) '${skipped ?? s.errors} skipped',
    ];
    if (parts.isEmpty) return 'Nothing was added';
    return parts.join(', ');
  }

  /// A refusal of "Undo this import", in words.
  static String undoRefusal(
    String code,
    String serverMessage,
    List<BlockedProduct> blocked,
  ) {
    switch (code) {
      case 'already_undone':
        return 'This import was already undone.';
      case 'undo_expired':
        return 'This import is more than 24 hours old, so it can no longer be undone. '
            'You can still delete or edit the products one by one.';
      case 'undo_blocked':
        final productNames = [for (final b in blocked) b.name];
        final which = productNames.isEmpty ? '' : ' (${names(productNames)})';
        return 'We cannot undo this import because some of its products were already used$which, '
            'for example sold, bought or moved. Nothing was changed.';
      case 'undo_failed':
        return 'Something went wrong and nothing was changed. Please try again.';
    }
    return serverMessage.isEmpty
        ? 'This import could not be undone.'
        : serverMessage;
  }

  /// Why a product blocks an undo: "sale" -> "sold".
  static String blockerReason(String reason) => switch (reason) {
    'sale' => 'sold',
    'purchase' => 'bought',
    'receipt' => 'received',
    'transfer' => 'moved to another branch',
    'waste' => 'written off',
    _ => reason.replaceAll('_', ' '),
  };

  static String statusLabel(ImportBatchStatus s) => switch (s) {
    ImportBatchStatus.active => 'Can be undone',
    ImportBatchStatus.undone => 'Undone',
    ImportBatchStatus.expired => 'Cannot be undone any more',
  };
}
