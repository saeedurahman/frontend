/// Central static validators for auth and registration forms.
abstract final class AppFormFieldValidator {
  AppFormFieldValidator._();

  static String? emptyFieldValidator(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? passwordValidator(String? password, [String? message]) {
    if (password == null || password.trim().isEmpty) {
      return message ?? 'Please enter the password';
    }
    return null;
  }

  /// Registration password rules (matches backend policy).
  static String? registerPasswordValidator(String? password, [String? message]) {
    final empty = passwordValidator(password, message);
    if (empty != null) return empty;

    final value = password!;
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must have at least 1 uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must have at least 1 lowercase letter (a-z)';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Enter valid email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Enter valid email address';
    }
    return null;
  }

  /// Pakistan mobile: `923XXXXXXXXX` (12 digits, no + prefix).
  static String? mobileValidator(String? mobile) {
    if (mobile == null || mobile.trim().isEmpty) {
      return 'Please enter mobile number';
    }
    final normalized = mobile.replaceAll(RegExp(r'[\s\-+]'), '');
    final digits = normalized.startsWith('92')
        ? normalized
        : normalized.startsWith('0')
            ? '92${normalized.substring(1)}'
            : '92$normalized';

    final regex = RegExp(r'^923[0-9]{9}$');
    if (!regex.hasMatch(digits) || digits.length != 12) {
      return 'Enter valid mobile number';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (password == null || password.isEmpty) {
      return 'Please enter the password first';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
