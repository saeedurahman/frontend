import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

/// SnackBar helpers for submit and API feedback.
abstract final class AppAlerts {
  AppAlerts._();

  static void showErrorMessage(BuildContext context, [String? message]) {
    _show(
      context,
      message: message ?? 'Something went wrong',
      backgroundColor: AppColors.error,
    );
  }

  static void showSuccessMessage(BuildContext context, [String? message]) {
    _show(
      context,
      message: message ?? 'Success',
      backgroundColor: AppColors.success,
    );
  }

  static void showInfoMessage(BuildContext context, [String? message]) {
    _show(
      context,
      message: message ?? 'Info',
      backgroundColor: AppColors.info,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }
}
