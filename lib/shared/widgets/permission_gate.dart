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

/// The state of [C], rebuilding on change when asked from a `build`. Asked
/// from a callback (where listening is not allowed) it is read once, so the
/// answer is the same. Null when there is no [C] above this widget.
S? _scopeState<C extends StateStreamable<S>, S>(BuildContext context) {
  try {
    return context.watch<C>().state;
  } catch (_) {
    try {
      return context.read<C>().state;
    } catch (_) {
      return null;
    }
  }
}

// Without an access scope above this widget there is nothing to enforce.
AccessState? _watchAccess(BuildContext context) =>
    _scopeState<AccessCubit, AccessState>(context);

SubscriptionState? _watchSubscription(BuildContext context) =>
    _scopeState<SubscriptionCubit, SubscriptionState>(context);

/// True when the signed-in user holds [permission] (rebuilds on change).
bool hasPermission(BuildContext context, String permission) =>
    _watchAccess(context)?.can(permission) ?? true;

/// True only when the permission key itself was granted: no role (not even
/// "owner") stands in for it, and unknown access means no. For actions the
/// server refuses without the key, such as passing a credit limit.
bool holdsPermissionKey(BuildContext context, String permission) =>
    _watchAccess(context)?.access.permissionKeys.contains(permission) ?? false;

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
