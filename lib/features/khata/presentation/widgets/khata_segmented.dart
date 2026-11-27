import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';

/// Tabs with a thumb that glides to the chosen one.
class KhataSegmented<T> extends StatelessWidget {
  const KhataSegmented({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.maxWidth = 440,
  });

  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double maxWidth;

  static const _height = 40.0;
  static const _pad = AppDimensions.spacingXs;

  @override
  Widget build(BuildContext context) {
    final index = options.indexWhere((o) => o.$1 == selected);
    final count = options.length;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        height: _height,
        padding: const EdgeInsets.all(_pad),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EEF3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Stack(
          children: [
            if (index >= 0)
              AnimatedAlign(
                duration: KhataStyle.normal,
                curve: KhataStyle.curve,
                alignment: Alignment(
                  count == 1 ? 0 : -1 + 2 * index / (count - 1),
                  0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1 / count,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                      boxShadow: KhataStyle.shadow,
                    ),
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (value, label) in options)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: value == selected,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () => onChanged(value),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSm,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingSm,
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: KhataStyle.fast,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: value == selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: value == selected
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A filter chip that fills with colour when chosen.
class KhataFilterPill extends StatelessWidget {
  const KhataFilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.value,
    this.color = AppColors.primary,
    this.showDot = true,
  });

  final String label;

  /// A figure shown after the label.
  final String? value;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  /// The colour dot before the label.
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppDimensions.spacingLg);
    return Semantics(
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: KhataStyle.fast,
        curve: KhataStyle.curve,
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: shape,
          border: Border.all(color: selected ? color : AppColors.border),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: shape,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacingSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showDot) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      value!,
                      style: KhataStyle.money.copyWith(
                        fontSize: 12,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
