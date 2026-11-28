import 'package:equatable/equatable.dart';
import 'package:frantend/core/error/api_error_parser.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  /// Machine code of a `detail: {code, message}` body (e.g. `no_open_shift`).
  String? get code => null;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Server error occurred',
    this.code,
    this.credit,
  ]);

  @override
  final String? code;

  /// The customer's numbers on `credit_limit_exceeded`.
  final CreditNumbers? credit;

  @override
  List<Object?> get props => [message, code, credit];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// A payment was sent but no answer came back: the server may or may not have
/// it, so it is neither queued nor reported as refused.
class UnconfirmedPaymentFailure extends NetworkFailure {
  const UnconfirmedPaymentFailure([
    super.message =
        'The server did not answer, so we could not confirm this payment. '
        'Trying again in this window, with the same details, will not pay '
        'twice. If you close it, check the supplier account first.',
  ]);

  @override
  String get code => 'payment_unconfirmed';
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(
    [super.message = 'Validation failed',
    this.fieldErrors = const {},
    this.code]
  );

  /// Per-field messages keyed by the field path (e.g. `phone`, `lines.0.qty`).
  final Map<String, String> fieldErrors;

  @override
  final String? code;

  @override
  List<Object?> get props => [message, fieldErrors, code];
}

/// HTTP 403: the session is valid but the user lacks the permission.
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([
    super.message = "You don't have permission to do this.",
    this.code,
  ]);

  @override
  final String? code;

  @override
  List<Object?> get props => [message, code];
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
  const ConflictFailure(
    [super.message = 'This record already exists', this.code]
  );

  @override
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// HTTP 404.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

/// Logout refused: [pendingCount] local changes have not reached the server.
class PendingWorkFailure extends Failure {
  const PendingWorkFailure(
    this.pendingCount, {
    this.unsynced = 0,
    this.failed = 0,
    this.held = 0,
  }) : super('Some changes have not been sent to the server yet.');

  final int pendingCount;

  /// Breakdown (0 when unknown): waiting to send, rejected, parked orders.
  final int unsynced;
  final int failed;
  final int held;

  @override
  List<Object?> get props => [message, pendingCount, unsynced, failed, held];
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

  @override
  final String code;
  final DateTime? expiredAt;
  final SubscriptionContact contact;

  /// Reads work, writes are refused: the business is in its grace period.
  bool get isGraceReadOnly => code == codeGraceReadOnly;

  @override
  List<Object?> get props => [code, message, expiredAt, contact];
}
