import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_state.dart';

const auditActionOptions = <String?, String>{
  null: 'All actions',
  'create': 'Create',
  'update': 'Update',
  'delete': 'Delete',
  'restore': 'Restore',
  'login': 'Login',
  'logout': 'Logout',
  'sync': 'Sync',
};

class AuditFilterBar extends StatefulWidget {
  const AuditFilterBar({
    super.key,
    required this.filters,
    required this.onApply,
    required this.onClear,
  });

  final AuditLogsFilters filters;
  final ValueChanged<AuditLogsFilters> onApply;
  final VoidCallback onClear;

  @override
  State<AuditFilterBar> createState() => _AuditFilterBarState();
}

class _AuditFilterBarState extends State<AuditFilterBar> {
  late TextEditingController _tableController;
  late TextEditingController _userController;

  @override
  void initState() {
    super.initState();
    _tableController = TextEditingController(text: widget.filters.tableName);
    _userController = TextEditingController(text: widget.filters.userId);
  }

  @override
  void didUpdateWidget(covariant AuditFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.tableName != oldWidget.filters.tableName) {
      _tableController.text = widget.filters.tableName ?? '';
    }
    if (widget.filters.userId != oldWidget.filters.userId) {
      _userController.text = widget.filters.userId ?? '';
    }
  }

  @override
  void dispose() {
    _tableController.dispose();
    _userController.dispose();
    super.dispose();
  }

  void _applyPreset(AuditDatePreset preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final (from, to) = switch (preset) {
      AuditDatePreset.today => (today, today),
      AuditDatePreset.last7Days =>
        (today.subtract(const Duration(days: 6)), today),
      AuditDatePreset.last30Days =>
        (today.subtract(const Duration(days: 29)), today),
      AuditDatePreset.custom => (
          widget.filters.dateFrom ?? today,
          widget.filters.dateTo ?? today,
        ),
    };
    widget.onApply(
      widget.filters.copyWith(
        dateFrom: from,
        dateTo: to,
        datePreset: preset,
      ),
    );
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: widget.filters.dateFrom ?? now.subtract(const Duration(days: 6)),
        end: widget.filters.dateTo ?? now,
      ),
    );
    if (range == null || !mounted) return;
    widget.onApply(
      widget.filters.copyWith(
        dateFrom: DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
        ),
        dateTo: DateTime(range.end.year, range.end.month, range.end.day),
        datePreset: AuditDatePreset.custom,
      ),
    );
  }

  void _applyAction(String? action) {
    widget.onApply(
      widget.filters.copyWith(
        action: action,
        clearAction: action == null,
      ),
    );
  }

  void _applyTable(String? value) {
    final trimmed = value?.trim();
    widget.onApply(
      widget.filters.copyWith(
        tableName: trimmed?.isEmpty == true ? null : trimmed,
        clearTableName: trimmed == null || trimmed.isEmpty,
      ),
    );
  }

  void _applyUser(String? value) {
    final trimmed = value?.trim();
    widget.onApply(
      widget.filters.copyWith(
        userId: trimmed?.isEmpty == true ? null : trimmed,
        clearUserId: trimmed == null || trimmed.isEmpty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _presetChip('Today', AuditDatePreset.today),
            _presetChip('Last 7 Days', AuditDatePreset.last7Days),
            _presetChip('Last 30 Days', AuditDatePreset.last30Days),
            ActionChip(
              label: const Text('Custom'),
              backgroundColor: widget.filters.datePreset == AuditDatePreset.custom
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : null,
              onPressed: _pickCustomRange,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<String?>(
                value: widget.filters.action,
                decoration: const InputDecoration(
                  labelText: 'Action',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: auditActionOptions.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
                onChanged: _applyAction,
              ),
            ),
            SizedBox(
              width: 180,
              child: TextField(
                controller: _tableController,
                decoration: const InputDecoration(
                  labelText: 'Table name',
                  hintText: 'e.g. products',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _applyTable,
                onEditingComplete: () => _applyTable(_tableController.text),
              ),
            ),
            SizedBox(
              width: 220,
              child: TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Optional UUID filter',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _applyUser,
                onEditingComplete: () => _applyUser(_userController.text),
              ),
            ),
            if (widget.filters.hasActiveFilters)
              TextButton(onPressed: widget.onClear, child: const Text('Clear filters')),
          ],
        ),
      ],
    );
  }

  Widget _presetChip(String label, AuditDatePreset preset) {
    final selected = widget.filters.datePreset == preset;
    return ActionChip(
      label: Text(label),
      backgroundColor:
          selected ? AppColors.primary.withValues(alpha: 0.12) : null,
      onPressed: () => _applyPreset(preset),
    );
  }
}
