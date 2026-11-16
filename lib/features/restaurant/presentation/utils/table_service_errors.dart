import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';

/// Words for a failed table-service call (tables, tabs, kitchen).
///
/// Those features need the server by design, so "could not reach it" is not
/// an error to show: it is the plain [OfflineMessages.tableService] notice.
/// Everything else goes through [UserErrorMessage] so transport-library text
/// never reaches a screen.
abstract final class TableServiceErrors {
  static String message(Failure failure) =>
      failure is NetworkFailure || UserErrorMessage.looksRaw(failure.message)
          ? OfflineMessages.tableService
          : UserErrorMessage.clean(failure.message);

  static String from(Object? error) => UserErrorMessage.isConnectionError(error)
      ? OfflineMessages.tableService
      : error is Failure
          ? message(error)
          : UserErrorMessage.from(error);
}
