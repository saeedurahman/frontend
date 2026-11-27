/// The building blocks shared by the khata screens: cards, aging bar,
/// animated money, chips, skeletons, empty states and entry motion.
///
/// Spacing stays on the 4 / 8 / 12 / 16 / 24 grid; motion is 200 to 300 ms.
library;

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:shimmer/shimmer.dart';

abstract final class KhataStyle {
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 250);
  static const counter = Duration(milliseconds: 300);
  static const curve = Curves.easeOutCubic;

  static const radius = 12.0;

  static const shadow = [
    BoxShadow(
      color: Color(0x0F101828),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// Money coming in is green, money going out is a warm red.
  static Color side(PartyType type) =>
      type.isCustomer ? AppColors.primary : const Color(0xFFB4442F);

  /// Calm to urgent, youngest to oldest.
  static Color bucket(AgeBucket bucket) => switch (bucket) {
        AgeBucket.upTo30 => AppColors.success,
        AgeBucket.upTo60 => const Color(0xFFD69E2E),
        AgeBucket.upTo90 => AppColors.warning,
        AgeBucket.over90 => AppColors.error,
      };

  /// The colour of an age in a bar or its key. Money to receive runs green,
  /// amber, orange, red; money to pay stays warm, light orange to dark red,
  /// so it never looks like good news.
  static Color agingColor(PartyType type, AgeBucket age) => type.isCustomer
      ? bucket(age)
      : switch (age) {
          AgeBucket.upTo30 => const Color(0xFFF6AD55),
          AgeBucket.upTo60 => const Color(0xFFE8751A),
          AgeBucket.upTo90 => const Color(0xFFD13F0F),
          AgeBucket.over90 => const Color(0xFF9B1C1C),
        };

  /// A darker shade of the bucket colour that stays readable as text.
  static Color bucketText(AgeBucket bucket) => switch (bucket) {
        AgeBucket.upTo30 => const Color(0xFF22633F),
        AgeBucket.upTo60 => const Color(0xFF7A5A0A),
        AgeBucket.upTo90 => const Color(0xFF9C4410),
        AgeBucket.over90 => const Color(0xFFA11D1D),
      };

  /// Digits that line up in columns.
  static const money = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

/// The white surface everything sits on.
class KhataCard extends StatelessWidget {
  const KhataCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.spacingMd),
    this.borderColor,
    this.onTap,
    this.tooltip,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(KhataStyle.radius);
    Widget card = AnimatedContainer(
      duration: KhataStyle.fast,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: shape,
        boxShadow: KhataStyle.shadow,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: borderColor == null ? 1 : 2,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: shape,
          mouseCursor:
              onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    if (tooltip != null) card = Tooltip(message: tooltip!, child: card);
    return card;
  }
}

/// Money that counts up to its value.
class AnimatedMoney extends StatelessWidget {
  const AnimatedMoney(
    this.amount, {
    super.key,
    this.style,
    this.textAlign,
  });

  final Decimal amount;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final target = amount.toDouble();
    return Semantics(
      label: formatPKR(amount),
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: target),
        duration: KhataStyle.counter,
        curve: KhataStyle.curve,
        builder: (context, value, _) => Text(
          // The exact figure once it has arrived (no float rounding).
          formatPKR(value == target ? amount : value),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
          textAlign: textAlign,
          style: style,
        ),
      ),
    );
  }
}

/// How old the money is, as one thin bar; pointing at it lists the amounts.
class AgingBar extends StatelessWidget {
  const AgingBar({
    super.key,
    required this.type,
    required this.buckets,
    this.height = 8,
    this.hoverPadding = 0,
  });

  /// Whose money it is, which picks the colours.
  final PartyType type;
  final AgingBuckets buckets;
  final double height;

  /// Space above and below that also shows the tooltip: a thin bar is hard to
  /// point at.
  final double hoverPadding;

  /// "0-30 days: Rs. 500.00", one line per age.
  static String summary(AgingBuckets buckets) => [
        for (final b in AgeBucket.values)
          '${KhataUiText.bucketLabel(b.apiValue)}: ${formatPKR(buckets[b])}',
      ].join('\n');

  /// Every part stays visible, however small it is.
  static const _minPart = 4.0;

  @override
  Widget build(BuildContext context) {
    final total = buckets.total.toDouble();
    final empty = total <= 0 ||
        AgeBucket.values.every((b) => buckets[b] <= Decimal.zero);
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: empty
            ? const ColoredBox(
                color: AppColors.border,
                child: SizedBox.expand(),
              )
            // Shares are animated, not pixels, so the parts always fill the
            // bar exactly, even while the bar itself changes width.
            : TweenAnimationBuilder<_Shares>(
                tween: _SharesTween(_Shares([
                  for (final b in AgeBucket.values)
                    buckets[b] > Decimal.zero
                        ? buckets[b].toDouble() / total
                        : 0,
                  for (final b in AgeBucket.values)
                    buckets[b] > Decimal.zero ? 1 : 0,
                ])),
                duration: KhataStyle.counter,
                curve: KhataStyle.curve,
                builder: (context, shares, _) => LayoutBuilder(
                  builder: (context, box) =>
                      _bar(shares.values, box.maxWidth),
                ),
              ),
      ),
    );
    return Tooltip(
      message: summary(buckets),
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: hoverPadding),
          child: bar,
        ),
      ),
    );
  }

  /// [values]: each bucket's share, then how present each bucket is.
  Widget _bar(List<double> values, double width) {
    final count = AgeBucket.values.length;
    final present = values.skip(count).fold(0.0, (a, b) => a + b);
    // A hair less than the full width absorbs rounding.
    final full = (width - 0.001).clamp(0.0, double.maxFinite);
    final minimum = (_minPart * present).clamp(0.0, full);
    final each = present > 0 ? minimum / present : 0.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < count; i++)
          SizedBox(
            key: ValueKey('aging-${AgeBucket.values[i].apiValue}'),
            width: each * values[count + i] + (full - minimum) * values[i],
            child: ColoredBox(
              color: KhataStyle.agingColor(type, AgeBucket.values[i]),
            ),
          ),
      ],
    );
  }
}

/// The numbers behind an [AgingBar]; equal numbers don't restart its motion.
@immutable
class _Shares {
  const _Shares(this.values);

  final List<double> values;

  @override
  bool operator ==(Object other) =>
      other is _Shares && listEquals(other.values, values);

  @override
  int get hashCode => Object.hashAll(values);
}

class _SharesTween extends Tween<_Shares> {
  _SharesTween(_Shares end) : super(end: end);

  @override
  _Shares lerp(double t) {
    final from = begin!.values;
    final to = end!.values;
    return _Shares([
      for (var i = 0; i < to.length; i++) from[i] + (to[i] - from[i]) * t,
    ]);
  }
}

/// A round avatar with the party's initials.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: CircleAvatar(
          radius: 20,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Text(
            KhataFormat.initials(name),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      );
}

/// A small coloured label: age of a bill, a promise, a status.
class KhataChip extends StatelessWidget {
  const KhataChip({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.icon,
    this.tooltip,
  });

  /// The age of an open bill, coloured by how old it is.
  factory KhataChip.age(int days, {Key? key, String? label}) {
    final bucket = AgeBucket.of(days);
    return KhataChip(
      key: key,
      label: label ?? KhataUiText.oldestBill(KhataFormat.days(days)),
      color: KhataStyle.bucket(bucket),
      textColor: KhataStyle.bucketText(bucket),
      icon: Icons.schedule_outlined,
      tooltip: KhataUiText.bucketLabel(bucket.apiValue),
    );
  }

  final String label;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final foreground = textColor ?? color;
    final Widget chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.spacingLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: AppDimensions.spacingXs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
    return tooltip == null ? chip : Tooltip(message: tooltip!, child: chip);
  }
}

/// A new row sliding gently into place, each a beat after the one above.
class StaggeredEntry extends StatefulWidget {
  const StaggeredEntry({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<StaggeredEntry>
    with SingleTickerProviderStateMixin {
  static const _step = 30;
  static const _enter = 240;

  /// Only the first screenful is staggered; later rows arrive together.
  static const _maxSteps = 8;

  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    final delay = widget.index.clamp(0, _maxSteps) * _step;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: delay + _enter),
    )..forward();
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay / (delay + _enter), 1, curve: KhataStyle.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _progress,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.12), end: Offset.zero)
            .animate(_progress),
        child: widget.child,
      ),
    );
  }
}

/// Wraps grey placeholder blocks in the shimmer used across the app.
class KhataShimmer extends StatelessWidget {
  const KhataShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF3F4F6),
        child: child,
      );
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = AppDimensions.spacingSm,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

/// Placeholder rows shaped like the list that is loading.
class SkeletonRows extends StatelessWidget {
  const SkeletonRows({super.key, this.count = 6, this.height = 72});

  final int count;
  final double height;

  @override
  Widget build(BuildContext context) => KhataShimmer(
        child: Column(
          children: [
            for (var i = 0; i < count; i++)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.spacingSm),
                child: SkeletonBox(height: height, radius: KhataStyle.radius),
              ),
          ],
        ),
      );
}

/// A friendly "nothing here" with what to do next.
class KhataEmptyState extends StatelessWidget {
  const KhataEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;
  final Color color;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(
            compact ? AppDimensions.spacingMd : AppDimensions.spacingLg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1),
                  duration: KhataStyle.counter,
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Container(
                    width: compact ? 48 : 80,
                    height: compact ? 48 : 80,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: compact ? 24 : 40, color: color),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: compact ? 14 : 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (actionLabel != null) ...[
                  const SizedBox(height: AppDimensions.spacingMd),
                  OutlinedButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

/// "Offline · as of 10:42": the figures are the last ones from the server.
class AsOfLabel extends StatelessWidget {
  const AsOfLabel({super.key, required this.asOf, this.now});

  final DateTime asOf;
  final DateTime? now;

  @override
  Widget build(BuildContext context) => KhataChip(
        label: KhataUiText.asOf(KhataFormat.asOf(asOf, now: now)),
        color: AppColors.warning,
        textColor: const Color(0xFF9C4410),
        icon: Icons.cloud_off_outlined,
      );
}

/// One of the two big figures: money to receive or to pay.
class KhataTotalCard extends StatelessWidget {
  const KhataTotalCard({
    super.key,
    required this.type,
    required this.side,
    this.selected = false,
    this.onTap,
    this.dense = false,
  });

  final PartyType type;
  final KhataSide side;
  final bool selected;
  final VoidCallback? onTap;

  /// The smaller dashboard version.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = KhataStyle.side(type);
    // The thicker border of the chosen card must not move what is inside.
    final inset = AppDimensions.spacingMd - (selected ? 1 : 0);
    // Room around the bar where pointing at it still shows the amounts.
    const hover = AppDimensions.spacingXs;
    return KhataCard(
      borderColor: selected ? color : null,
      padding: EdgeInsets.fromLTRB(inset, inset, inset, inset - hover),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.spacingSm),
                ),
                child: Icon(
                  type.isCustomer
                      ? Icons.south_west_rounded
                      : Icons.north_east_rounded,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.isCustomer
                          ? KhataUiText.toReceive
                          : KhataUiText.toPay,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      type.isCustomer
                          ? KhataUiText.toReceiveHint
                          : KhataUiText.toPayHint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                type.isCustomer
                    ? KhataUiText.customerCount(side.count)
                    : KhataUiText.supplierCount(side.count),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: dense ? AppDimensions.spacingSm : AppDimensions.spacing12,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedMoney(
              side.total,
              style: KhataStyle.money.copyWith(
                fontSize: dense ? 24 : 32,
                color: color,
              ),
            ),
          ),
          SizedBox(
            height:
                (dense ? AppDimensions.spacingSm : AppDimensions.spacing12) -
                    hover,
          ),
          AgingBar(
            type: type,
            buckets: side.buckets,
            height: dense ? 4 : 8,
            hoverPadding: hover,
          ),
        ],
      ),
    );
  }
}

/// The skeleton of a [KhataTotalCard].
class KhataTotalCardSkeleton extends StatelessWidget {
  const KhataTotalCardSkeleton({super.key, this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context) => KhataShimmer(
        child: SkeletonBox(height: dense ? 128 : 144, radius: KhataStyle.radius),
      );
}
