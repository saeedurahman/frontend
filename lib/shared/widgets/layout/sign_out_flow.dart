import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/session/session_services.dart';
import 'package:go_router/go_router.dart';

/// Signs out from any screen. If unsent local work exists the sign-out is
/// refused and a dialog shows exactly what would be lost; the owner can still
/// sign out after a second, explicit confirmation.
Future<void> signOutWithGuard(BuildContext context) async {
  final blocked = await SessionServices.logout();
  if (!context.mounted) return;
  if (blocked != null) {
    final force = await showPendingWorkDialog(
      context,
      blocked,
      canForce: sl<AccessCubit>().state.access.isOwner,
    );
    if (force != true || !context.mounted) return;
    await SessionServices.logout(force: true);
    if (!context.mounted) return;
  }
  context.go(RouteNames.login);
}

/// "3 sales and 1 customer waiting to send, 1 rejected, 2 parked orders".
String pendingWorkBreakdown(PendingWorkFailure f) {
  final parts = <String>[
    if (f.unsynced > 0) '${f.unsynced} change(s) waiting to be sent',
    if (f.failed > 0) '${f.failed} rejected by the server',
    if (f.held > 0) '${f.held} parked order(s) (kept on this device only)',
  ];
  return parts.isEmpty ? '${f.pendingCount} item(s)' : parts.join('\n');
}

/// Wording of the "cannot sign out" dialog (separate for tests).
String pendingWorkMessage(PendingWorkFailure f) =>
    'Signing out now would delete work that is not safely on the server:\n\n'
    '${pendingWorkBreakdown(f)}\n\n'
    'Connect to the internet and let it finish sending, then sign out again.';

/// Returns true when the owner chose to sign out anyway.
Future<bool?> showPendingWorkDialog(
  BuildContext context,
  PendingWorkFailure failure, {
  bool canForce = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      key: const Key('pending-work-dialog'),
      title: const Text("Can't sign out yet"),
      content: Text(pendingWorkMessage(failure)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop(false);
            context.go(RouteNames.sync);
          },
          child: const Text('View sync status'),
        ),
        if (canForce)
          TextButton(
            key: const Key('force-sign-out'),
            onPressed: () async {
              final sure = await showDialog<bool>(
                context: dialogContext,
                builder: (confirmContext) => AlertDialog(
                  key: const Key('force-confirm'),
                  title: const Text('Sign out and lose this work?'),
                  content: const Text(
                    'This permanently deletes the unsent items listed above. '
                    'They will never reach the server.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(confirmContext).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(confirmContext).pop(true),
                      child: const Text('Delete and sign out'),
                    ),
                  ],
                ),
              );
              if (sure == true && dialogContext.mounted) {
                Navigator.of(dialogContext).pop(true);
              }
            },
            child: const Text(
              'Sign out anyway',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    ),
  );
}
