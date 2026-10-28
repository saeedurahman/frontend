import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';

/// What a gate does when the user lacks the permission.
enum GateMode {
  /// Render nothing.
  hide,

  /// Render the child greyed out and untappable, with an explanatory tooltip.
  disable,
}

const kReadOnlyTooltip =
    'Read-only mode: renew your subscription to make changes';

String requiresPermissionTooltip(Iterable<String> permissions) =>
    'Requires permission ${permissions.join(' or ')}';

AccessState? _watchAccess(BuildContext context) {
  try {
    return context.watch<AccessCubit>().state;
  } catch (_) {
    return null; // no access scope above this widget: nothing to enforce
  }
}

SubscriptionState? _watchSubscription(BuildContext context) {
  try {
    return context.watch<SubscriptionCubit>().state;
  } catch (_) {
    return null;
  }
}

/// True when the signed-in user holds [permission] (rebuilds on change).
bool hasPermission(BuildContext context, String permission) =>
    _watchAccess(context)?.can(permission) ?? true;

/// True while the subscription is in its read-only grace period.
bool isReadOnlyMode(BuildContext context) =>
    _watchSubscription(context)?.isGraceReadOnly ?? false;

/// Shows, hides or disables its child based on permission and subscription.
///
/// - [permission] / [anyOf]: what the user needs.
/// - [mutating]: the child creates, edits or deletes something, so it is also
///   disabled while the subscription is read-only.
/// - [builder] receives `enabled`; use it for buttons so `onPressed` can be
///   null. Without it, a disabled child is wrapped so it cannot be tapped.
class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    this.permission,
    this.anyOf,
    this.mode = GateMode.hide,
    this.mutating = false,
    this.child,
    this.builder,
  })  : assert(
          (permission != null) != (anyOf != null),
          'Pass either permission or anyOf',
        ),
        assert(
          (child != null) != (builder != null),
          'Pass either child or builder',
        );

  final String? permission;
  final List<String>? anyOf;
  final GateMode mode;
  final bool mutating;
  final Widget? child;
  final Widget Function(BuildContext context, bool enabled)? builder;

  List<String> get _required => permission != null ? [permission!] : anyOf!;

  @override
  Widget build(BuildContext context) {
    final access = _watchAccess(context);
    final subscription = _watchSubscription(context);

    final allowed = access == null || access.canAny(_required);
    final readOnly = mutating && (subscription?.isGraceReadOnly ?? false);

    if (!allowed && mode == GateMode.hide) return const SizedBox.shrink();
    if (allowed && !readOnly) return _build(context, enabled: true);

    final message =
        allowed ? kReadOnlyTooltip : requiresPermissionTooltip(_required);
    return Tooltip(
      message: message,
      child: _build(context, enabled: false),
    );
  }

  Widget _build(BuildContext context, {required bool enabled}) {
    final build = builder;
    if (build != null) return build(context, enabled);
    if (enabled) return child!;
    return IgnorePointer(
      child: Opacity(opacity: 0.45, child: child),
    );
  }
}
