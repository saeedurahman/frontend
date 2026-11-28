/// What the app says about suppliers, and the server's rules for them, so a
/// supplier saved on this device is not refused later.
abstract final class SupplierText {
  static const nameTooShort = 'Enter a name of at least 2 characters.';
  static const invalidEmail = 'Enter a valid email address.';
  static const invalidTerms =
      'Payment terms must be a whole number of days from 0 to 3650.';

  static const deleteNeedsInternet = 'Deleting a supplier needs internet.';
  static const statusNeedsInternet =
      'Activating or deactivating a supplier needs internet.';
  static const notSyncedYet =
      'This supplier has not synced yet. Try again after it has synced.';
  static const notOnDevice =
      'This supplier is not saved on this device. Editing it needs internet.';
  static const notSaved = 'Could not be saved on this device.';

  static const duplicateCode = 'duplicate_supplier';

  static const useExisting = 'Use existing supplier';
  static const theExistingOne = 'the existing supplier';

  static String existingIs(String name) => 'Existing supplier: $name';

  static String useExistingBody(String newName, String existing) =>
      'Payments, expenses and notes recorded for "$newName" will be sent for '
      '"$existing" instead. The new supplier, its details and its opening '
      'balance will not be added.';

  static const discardNewSupplier =
      'The supplier is removed from this device, together with the payments, '
      'edits and notes recorded for it here. Expenses recorded for it are '
      'kept and sent without a supplier.';

  static const discardEdit =
      'The supplier goes back to how it was before this change.';

  /// [field] is `name` or `phone`.
  static String duplicate(String field, String otherName) =>
      'Another supplier already has this '
      '${field == 'phone' ? 'phone number' : 'name'}: $otherName.';
}

abstract final class SupplierRules {
  /// Longest value of each text field.
  static const _limits = {
    'name': 255,
    'phone': 50,
    'email': 255,
    'contact_person': 255,
    'address': 255,
    'city': 100,
    'tax_id': 100,
    'notes': 2000,
  };

  static const _labels = {
    'name': 'Name',
    'phone': 'Phone',
    'email': 'Email',
    'contact_person': 'Contact person',
    'address': 'Address',
    'city': 'City',
    'tax_id': 'Tax ID',
    'notes': 'Notes',
  };

  /// The supplier fields of a request body as the sync feed names them
  /// (`address_line1` is `address` there), text trimmed. Only keys the body
  /// has; "" means "clear this".
  static Map<String, dynamic> fields(Map<String, dynamic> body) {
    final out = <String, dynamic>{};
    for (final key in _limits.keys) {
      final from = key == 'address' && !body.containsKey(key)
          ? 'address_line1'
          : key;
      final value = body[from];
      if (body.containsKey(from) && value != null) {
        out[key] = '$value'.trim();
      }
    }
    final terms = body['payment_terms_days'];
    if (terms != null) {
      out['payment_terms_days'] = int.tryParse('$terms'.trim()) ?? terms;
    }
    return out;
  }

  /// A plain message per field the server would refuse.
  static Map<String, String> problems(Map<String, dynamic> fields) {
    final out = <String, String>{};
    for (final MapEntry(:key, value: limit) in _limits.entries) {
      final value = fields[key];
      if (value != null && '$value'.length > limit) {
        out[key] = '${_labels[key]} can be at most $limit characters.';
      }
    }
    final name = fields['name'];
    if (name != null && '$name'.length < 2) {
      out['name'] = SupplierText.nameTooShort;
    }
    final email = '${fields['email'] ?? ''}';
    if (email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      out['email'] = SupplierText.invalidEmail;
    }
    final terms = fields['payment_terms_days'];
    if (terms != null && (terms is! int || terms < 0 || terms > 3650)) {
      out['payment_terms_days'] = SupplierText.invalidTerms;
    }
    return out;
  }

  /// Names are compared ignoring case and extra spaces.
  static String nameKey(Object? name) => '${name ?? ''}'
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .toLowerCase();

  /// Phones are compared by their digits; null when there are none.
  static String? phoneKey(Object? phone) {
    final digits = '${phone ?? ''}'.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? null : digits;
  }
}

/// A value the server would refuse.
class SupplierInputException implements Exception {
  const SupplierInputException(this.problems);
  final Map<String, String> problems;
}

/// Another supplier on this device already has the name or the phone.
class DuplicateSupplierException implements Exception {
  const DuplicateSupplierException({
    required this.field,
    required this.existingId,
    required this.existingName,
  });

  final String field;
  final String existingId;
  final String existingName;

  String get message => SupplierText.duplicate(field, existingName);
}

/// An edit of a supplier this device holds no row of.
class SupplierNotOnDeviceException implements Exception {
  const SupplierNotOnDeviceException();
}
