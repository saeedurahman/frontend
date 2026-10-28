import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.isSubmitting = false,
    this.succeeded = false,
    this.error,
    this.fieldErrors = const {},
  });

  final bool isSubmitting;
  final bool succeeded;
  final String? error;
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [isSubmitting, succeeded, error, fieldErrors];
}

/// Validates and submits a password change (current + new password).
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._repository) : super(const ChangePasswordState());

  final AuthRepository _repository;

  static const minPasswordLength = 8;

  /// Client-side rules; returns field -> message (empty when valid).
  static Map<String, String> validate({
    required String current,
    required String next,
    required String confirm,
  }) {
    final errors = <String, String>{};
    if (current.isEmpty) {
      errors['current_password'] = 'Enter your current password';
    }
    if (next.length < minPasswordLength) {
      errors['new_password'] =
          'Password must be at least $minPasswordLength characters';
    } else if (!RegExp(r'[A-Z]').hasMatch(next) ||
        !RegExp(r'[a-z]').hasMatch(next)) {
      errors['new_password'] =
          'Password needs an uppercase and a lowercase letter';
    } else if (next == current) {
      errors['new_password'] = 'New password must differ from the current one';
    }
    if (confirm != next) {
      errors['confirm_password'] = 'Passwords do not match';
    }
    return errors;
  }

  Future<void> submit({
    required String current,
    required String next,
    required String confirm,
  }) async {
    if (state.isSubmitting) return;
    final errors = validate(current: current, next: next, confirm: confirm);
    if (errors.isNotEmpty) {
      emit(ChangePasswordState(fieldErrors: errors));
      return;
    }

    emit(const ChangePasswordState(isSubmitting: true));
    final result = await _repository.changePassword(
      currentPassword: current,
      newPassword: next,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        ChangePasswordState(
          error: failure.message,
          fieldErrors: failure is ValidationFailure
              ? _mapServerFields(failure.fieldErrors)
              : const {},
        ),
      ),
      (_) => emit(const ChangePasswordState(succeeded: true)),
    );
  }

  Map<String, String> _mapServerFields(Map<String, String> fields) {
    const known = {'current_password', 'new_password'};
    return {
      for (final entry in fields.entries)
        if (known.contains(entry.key)) entry.key: entry.value,
    };
  }
}
