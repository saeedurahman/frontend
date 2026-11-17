import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';

/// Spacing scale used by every receipt screen: 4 / 8 / 12 / 16 / 24 only.
abstract final class Sp {
  static const double xs = AppDimensions.spacingXs; // 4
  static const double sm = AppDimensions.spacingSm; // 8
  static const double md = 12;
  static const double lg = AppDimensions.spacingMd; // 16
  static const double xl = AppDimensions.spacingLg; // 24
}

/// Soft card used for every block on the receipt screens.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Sp.lg),
    this.selected = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
  }
}

/// A collapsible block of the editor: icon, title, one-line description and
/// the rows inside. Collapsed bodies are not built at all.
class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.children,
    this.initiallyExpanded = false,
  });

  final String id;
  final IconData icon;
  final String title;
  final String description;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ReceiptCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _open,
            label: widget.title,
            child: Tooltip(
              message: _open ? 'Collapse ${widget.title}' : 'Expand ${widget.title}',
              child: InkWell(
                key: Key('section-header-${widget.id}'),
                onTap: () => setState(() => _open = !_open),
                child: Padding(
                  padding: const EdgeInsets.all(Sp.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: Icon(widget.icon, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: Sp.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title, style: AppTextStyles.titleMedium),
                            const SizedBox(height: Sp.xs),
                            Text(
                              widget.description,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Sp.sm),
                      AnimatedRotation(
                        turns: _open ? 0.5 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: const Icon(Icons.expand_more, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_open) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              key: Key('section-body-${widget.id}'),
              padding: const EdgeInsets.fromLTRB(Sp.lg, Sp.xs, Sp.lg, Sp.lg),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widget.children),
            ),
          ],
        ],
      ),
    );
  }
}

/// One setting: title + help text on the left, the control on the right.
/// Every row has the same minimum height and a divider underneath.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.title,
    this.help,
    required this.trailing,
    this.onTap,
    this.divider = true,
  });

  final String title;
  final String? help;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sp.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  if (help != null) ...[
                    const SizedBox(height: Sp.xs),
                    Text(help!, style: AppTextStyles.bodySmall),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Sp.lg),
            trailing,
          ],
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        onTap == null ? content : InkWell(onTap: onTap, child: content),
        if (divider) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

/// Small rounded label (paper size, language, "Default for print").
class InfoBadge extends StatelessWidget {
  const InfoBadge(this.text, {super.key, this.icon, this.color = AppColors.textSecondary});

  final String text;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.sm, vertical: Sp.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: Sp.xs)],
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "you are offline" notice (friendly, not an error).
class OfflineNotice extends StatelessWidget {
  const OfflineNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sp.md),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.amber.shade200),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: Colors.amber.shade900),
          const SizedBox(width: Sp.md),
          Expanded(child: Text(message, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

/// A calm, centred message with an icon and an optional action.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sp.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: Sp.md),
              Text(title, style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
              if (message != null) ...[
                const SizedBox(height: Sp.sm),
                Text(message!, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
              ],
              if (action != null) ...[const SizedBox(height: Sp.lg), action!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Grey placeholder block shown while data loads.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius = AppDimensions.radiusSm});

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.lerp(const Color(0xFFE8EDF3), const Color(0xFFF3F6FA), _c.value),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      );
}

/// Names shown for each language everywhere (segmented buttons, badges).
extension ReceiptLanguageText on ReceiptLanguage {
  String get badge => switch (this) {
        ReceiptLanguage.en => 'English',
        ReceiptLanguage.ur => 'اردو',
        ReceiptLanguage.both => 'English + اردو',
      };
}
