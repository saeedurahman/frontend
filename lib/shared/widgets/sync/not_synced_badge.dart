import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/local_catalog.dart';

/// Small "Not synced yet" marker for a record that only exists on this
/// device so far. [compact] shows the icon alone (with a tooltip).
class NotSyncedBadge extends StatelessWidget {
  const NotSyncedBadge({super.key, this.compact = false});

  final bool compact;

  static const icon = Icons.cloud_off_outlined;

  @override
  Widget build(BuildContext context) {
    const mark = Icon(icon, size: 14, color: AppColors.warning);
    if (compact) {
      return const Tooltip(message: UserErrorMessage.notSyncedYet, child: mark);
    }
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: 4),
        Text(
          UserErrorMessage.notSyncedYet,
          style: TextStyle(fontSize: 12, color: AppColors.warning),
        ),
      ],
    );
  }
}

/// Shows [NotSyncedBadge] while [customerId] is waiting to reach the server,
/// and removes it by itself once the sync has delivered it.
class CustomerSyncBadge extends StatefulWidget {
  const CustomerSyncBadge({
    super.key,
    required this.customerId,
    this.compact = true,
    this.unsyncedIds,
    this.changes,
  });

  final String customerId;
  final bool compact;

  /// Defaults to the local catalog (overridable for tests).
  final Future<Set<String>> Function()? unsyncedIds;
  final Stream<void>? changes;

  @override
  State<CustomerSyncBadge> createState() => _CustomerSyncBadgeState();
}

class _CustomerSyncBadgeState extends State<CustomerSyncBadge> {
  StreamSubscription<void>? _sub;
  bool _unsynced = false;

  LocalCatalog? get _catalog =>
      sl.isRegistered<LocalCatalog>() ? sl<LocalCatalog>() : null;

  @override
  void initState() {
    super.initState();
    _sub = (widget.changes ?? _catalog?.changes)?.listen((_) => _check());
    _check();
  }

  @override
  void didUpdateWidget(CustomerSyncBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customerId != widget.customerId) _check();
  }

  Future<void> _check() async {
    final id = widget.customerId;
    Set<String> ids;
    try {
      ids = await (widget.unsyncedIds?.call() ??
          _catalog?.unsyncedCustomerIds() ??
          Future.value(const <String>{}));
    } catch (_) {
      ids = const {};
    }
    if (!mounted || id != widget.customerId) return;
    final unsynced = ids.contains(id);
    if (unsynced != _unsynced) setState(() => _unsynced = unsynced);
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _unsynced
      ? NotSyncedBadge(compact: widget.compact)
      : const SizedBox.shrink();
}
