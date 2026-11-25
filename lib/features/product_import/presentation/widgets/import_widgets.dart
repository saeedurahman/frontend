import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';

/// "1 Choose file — 2 Review — 3 Done".
class ImportStepper extends StatelessWidget {
  const ImportStepper({super.key, required this.current});

  final ImportStep current;

  static const labels = ['Choose file', 'Review', 'Done'];

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('import-stepper'),
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          _Dot(
            key: ValueKey('import-step-${i + 1}'),
            number: i + 1,
            label: labels[i],
            state: i < current.index
                ? _DotState.done
                : (i == current.index ? _DotState.current : _DotState.todo),
          ),
          if (i < labels.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: i < current.index ? AppColors.primary : AppColors.border,
              ),
            ),
        ],
      ],
    );
  }
}

enum _DotState { done, current, todo }

class _Dot extends StatelessWidget {
  const _Dot({
    super.key,
    required this.number,
    required this.label,
    required this.state,
  });

  final int number;
  final String label;
  final _DotState state;

  @override
  Widget build(BuildContext context) {
    final active = state != _DotState.todo;
    return Semantics(
      label:
          'Step $number of 3: $label${state == _DotState.current ? ', current step' : ''}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.primary : Colors.white,
              border: Border.all(
                color: active ? AppColors.primary : AppColors.border,
                width: 1.5,
              ),
            ),
            child: state == _DotState.done
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: state == _DotState.current
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A rounded white section with a coloured icon and a title.
class ImportCard extends StatelessWidget {
  const ImportCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          // A Material of its own, so the switches, radios and expanding rows
          // inside show their tap effects on the white card.
          Material(
            type: MaterialType.transparency,
            child: Padding(padding: const EdgeInsets.all(16), child: child),
          ),
        ],
      ),
    );
  }
}

/// A coloured message bar ("You are offline", "This file is empty").
class ImportNotice extends StatelessWidget {
  const ImportNotice({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    this.action,
  });

  final IconData icon;
  final Color color;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13.5))),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}

/// "Will add  24".
class ImportChip extends StatelessWidget {
  const ImportChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12.5)),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
