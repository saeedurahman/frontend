import 'package:flutter/widgets.dart';

/// Screen size buckets used by [Responsive] and [ResponsivePageScaffold].
enum ScreenSizeClass {
  compact,
  medium,
  expanded,
}

/// Canonical width thresholds for responsive layout decisions.
abstract final class ScreenBreakpoints {
  static const double compactMaxWidth = 600;
  static const double expandedMinWidth = 1024;

  static ScreenSizeClass fromWidth(double width) {
    if (width < compactMaxWidth) {
      return ScreenSizeClass.compact;
    }
    if (width <= expandedMinWidth) {
      return ScreenSizeClass.medium;
    }
    return ScreenSizeClass.expanded;
  }

  static ScreenSizeClass of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }
}
