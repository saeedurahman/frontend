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

/// How to reach support, as sent by the backend on subscription errors.
class SubscriptionContact extends Equatable {
  const SubscriptionContact({this.phone, this.whatsapp, this.email});

  static const empty = SubscriptionContact();

  factory SubscriptionContact.fromJson(dynamic json) {
    if (json is! Map) return empty;
    String? text(dynamic v) {
      final s = v?.toString().trim();
      return s == null || s.isEmpty ? null : s;
    }

    return SubscriptionContact(
      phone: text(json['phone']),
      whatsapp: text(json['whatsapp']),
      email: text(json['email']),
    );
  }

  final String? phone;
  final String? whatsapp;
  final String? email;

  bool get isEmpty => phone == null && whatsapp == null && email == null;

  @override
  List<Object?> get props => [phone, whatsapp, email];
}

/// HTTP 402: the business's subscription does not allow this request.
///
/// The session is valid; tokens must never be cleared because of this.
class SubscriptionFailure extends Failure {
  const SubscriptionFailure({
    required this.code,
    String message = defaultMessage,
    this.expiredAt,
    this.contact = SubscriptionContact.empty,
  }) : super(message);

  static const defaultMessage =
      'Your subscription is not active. Please contact support.';

  static const codeExpired = 'subscription_expired';
  static const codeSuspended = 'subscription_suspended';
  static const codeCancelled = 'subscription_cancelled';
  static const codeGraceReadOnly = 'subscription_grace_readonly';

  /// Reads `{"code","message","expired_at","contact"}`, either at the top level
  /// or wrapped in FastAPI's `detail`.
  factory SubscriptionFailure.fromBody(dynamic data) {
    var body = data;
    if (body is Map && body['detail'] is Map) body = body['detail'];
    if (body is! Map) {
      return const SubscriptionFailure(code: codeExpired);
    }
    final code = body['code'];
    final message = body['message'];
    final expired = DateTime.tryParse('${body['expired_at'] ?? ''}');
    return SubscriptionFailure(
      code: code is String && code.isNotEmpty ? code : codeExpired,
      message: message is String && message.trim().isNotEmpty
          ? message
          : defaultMessage,
      expiredAt: expired,
      contact: SubscriptionContact.fromJson(body['contact']),
    );
  }

  final String code;
  final DateTime? expiredAt;
  final SubscriptionContact contact;

  /// Reads work, writes are refused: the business is in its grace period.
  bool get isGraceReadOnly => code == codeGraceReadOnly;

  @override
  List<Object?> get props => [code, message, expiredAt, contact];
}
