import 'package:flutter/material.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/session_services.dart';
import 'package:go_router/go_router.dart';

/// Signs out from any screen. If unsent local work exists the sign-out is
/// refused and a dialog explains why; otherwise the app returns to login.
Future<void> signOutWithGuard(BuildContext context) async {
  final blocked = await SessionServices.logout();
  if (!context.mounted) return;
  if (blocked != null) {
    await showPendingWorkDialog(context, blocked);
    return;
  }
  context.go(RouteNames.login);
}

/// Wording of the "cannot sign out" dialog (separate for tests).
String pendingWorkMessage(int count) =>
    '$count change(s) have not been sent to the server yet. Signing out now '
    'would delete them from this device.\n\n'
    'Reconnect to the internet and wait for them to finish sending, then '
    'sign out again.';

Future<void> showPendingWorkDialog(
  BuildContext context,
  PendingWorkFailure failure,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      key: const Key('pending-work-dialog'),
      title: const Text("Can't sign out yet"),
      content: Text(pendingWorkMessage(failure.pendingCount)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('OK'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            context.go(RouteNames.syncFailed);
          },
          child: const Text('View sync status'),
        ),
      ],
    ),
  );
}
