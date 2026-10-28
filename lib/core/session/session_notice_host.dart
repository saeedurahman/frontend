import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';

/// Shows short, friendly notices for session events:
/// - a write refused in read-only mode (402 grace) -> snackbar, not an error;
/// - the user's permissions changed mid-session;
/// - a branch the user may not use.
///
/// Place it inside `MaterialApp.builder` so a `ScaffoldMessenger` exists.
class SessionNoticeHost extends StatelessWidget {
  const SessionNoticeHost({
    super.key,
    required this.child,
    this.branchSelector,
  });

  final Widget child;

  /// Optional; the branch notice is skipped when not provided.
  final BranchSelectorCubit? branchSelector;

  void _show(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SubscriptionCubit, SubscriptionState>(
          listenWhen: (a, b) => a.graceNoticeSeq != b.graceNoticeSeq,
          listener: (context, state) {
            final message = state.graceNotice;
            if (message != null) _show(context, message);
          },
        ),
        BlocListener<AccessCubit, AccessState>(
          listenWhen: (a, b) => a.noticeSeq != b.noticeSeq,
          listener: (context, state) {
            final message = state.notice;
            if (message != null) _show(context, message);
          },
        ),
        if (branchSelector != null)
          BlocListener<BranchSelectorCubit, BranchSelectorState>(
            bloc: branchSelector,
            listenWhen: (a, b) => a.noticeSeq != b.noticeSeq,
            listener: (context, state) {
              final message = state.notice;
              if (message != null) _show(context, message);
            },
          ),
      ],
      child: child,
    );
  }
}
