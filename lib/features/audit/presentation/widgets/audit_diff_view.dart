import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

/// Generic key-value diff for audit log old_values / new_values JSONB.
class AuditDiffView extends StatelessWidget {
  const AuditDiffView({
    super.key,
    this.oldValues,
    this.newValues,
  });

  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;

  @override
  Widget build(BuildContext context) {
    final oldMap = oldValues ?? const {};
    final newMap = newValues ?? const {};
    if (oldMap.isEmpty && newMap.isEmpty) {
      return const SizedBox.shrink();
    }

    final keys = {...oldMap.keys, ...newMap.keys}.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: keys.map((key) => _DiffRow(
            field: key,
            oldValue: oldMap[key],
            newValue: newMap[key],
          )).toList(),
    );
  }
}

class _DiffRow extends StatelessWidget {
  const _DiffRow({
    required this.field,
    required this.oldValue,
    required this.newValue,
  });

  final String field;
  final dynamic oldValue;
  final dynamic newValue;

  @override
  Widget build(BuildContext context) {
    final oldStr = _formatValue(oldValue);
    final newStr = _formatValue(newValue);
    final hadOld = oldValue != null;
    final hasNew = newValue != null;

    if (!hadOld && hasNew) {
      return _line(
        icon: Icons.add_circle_outline,
        color: AppColors.success,
        text: 'Set $field: $newStr',
      );
    }
    if (hadOld && !hasNew) {
      return _line(
        icon: Icons.remove_circle_outline,
        color: AppColors.error,
        text: 'Removed $field: $oldStr',
      );
    }
    if (oldStr == newStr) {
      return _line(
        icon: Icons.check_circle_outline,
        color: AppColors.textSecondary,
        text: '$field: $newStr (unchanged)',
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.swap_horiz, size: 16, color: AppColors.info),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '$field: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: oldStr,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const TextSpan(text: ' → '),
                  TextSpan(
                    text: newStr,
                    style: const TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: color, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatValue(dynamic value) {
    if (value == null) return '—';
    if (value is Map || value is List) return value.toString();
    return value.toString();
  }
}
