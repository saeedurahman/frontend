import 'dart:convert';

import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/uuid_utils.dart';

/// The `Idempotency-Key` of a money write.
///
/// The same request keeps its key while its outcome is unknown (the answer was
/// lost), so trying again can never book it twice. A changed request, a success
/// or a clear refusal starts afresh.
class RetryKey {
  String? _key;
  String? _fingerprint;

  String keyFor(Object? request) {
    final fingerprint = jsonEncode(request);
    if (fingerprint != _fingerprint || _key == null) {
      _fingerprint = fingerprint;
      _key = UuidUtils.v4();
    }
    return _key!;
  }

  /// Call with the failure, or null after a success.
  void settle(Failure? failure) {
    final unknown = failure != null &&
        (failure is NetworkFailure ||
            (failure is ServerFailure && failure.code == null));
    if (!unknown) {
      _key = null;
      _fingerprint = null;
    }
  }
}
