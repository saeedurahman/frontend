import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(
    [super.message = 'Validation failed', this.fieldErrors = const {}]
  );

  /// Per-field messages keyed by the field path (e.g. `phone`, `lines.0.qty`).
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// HTTP 403: the session is valid but the user lacks the permission.
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure(
    [super.message = "You don't have permission to do this."]
  );
}

/// HTTP 429, with the cool-down taken from the `Retry-After` header.
class RateLimitFailure extends Failure {
  const RateLimitFailure({this.retryAfterSeconds = 60})
      : super('Too many attempts');

  final int retryAfterSeconds;

  @override
  String get message =>
      'Too many attempts, try again in $retryAfterSeconds seconds';

  @override
  List<Object?> get props => [retryAfterSeconds];
}

/// HTTP 409.
class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'This record already exists']);
}

/// HTTP 404.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

class SyncFailure extends Failure {
  const SyncFailure([super.message = 'Sync failed']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}
