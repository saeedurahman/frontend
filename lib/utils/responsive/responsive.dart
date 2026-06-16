import 'package:flutter/widgets.dart';

import 'screen_breakpoints.dart';

/// Responsive layout helpers and [BuildContext] extensions.
///
/// ```dart
/// // Check layout
/// if (context.isMobile) { /* mobile UI */ }
/// if (context.isLargeLayout) { /* tablet + desktop UI */ }
///
/// // Responsive values
/// final padding = context.responsiveValue<double>(
///   compact: 12,
///   medium: 20,
///   expanded: 28,
/// );
/// ```
abstract final class Responsive {
  static ScreenSizeClass sizeClassOf(BuildContext context) {
    return ScreenBreakpoints.of(context);
  }

  static bool isMobile(BuildContext context) {
    return sizeClassOf(context) == ScreenSizeClass.compact;
  }

  static bool isTablet(BuildContext context) {
    return sizeClassOf(context) == ScreenSizeClass.medium;
  }

  static bool isDesktop(BuildContext context) {
    return sizeClassOf(context) == ScreenSizeClass.expanded;
  }

  static bool isLargeLayout(BuildContext context) {
    final sizeClass = sizeClassOf(context);
    return sizeClass == ScreenSizeClass.medium ||
        sizeClass == ScreenSizeClass.expanded;
  }

  static T responsiveValue<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
  }) {
    switch (sizeClassOf(context)) {
      case ScreenSizeClass.compact:
        return compact;
      case ScreenSizeClass.medium:
        return medium ?? expanded ?? compact;
      case ScreenSizeClass.expanded:
        return expanded ?? medium ?? compact;
    }
  }
}

extension ResponsiveBuildContextX on BuildContext {
  bool get isMobile => Responsive.isMobile(this);

  bool get isTablet => Responsive.isTablet(this);

  bool get isDesktop => Responsive.isDesktop(this);

  bool get isLargeLayout => Responsive.isLargeLayout(this);

  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
  }) {
    return Responsive.responsiveValue(
      this,
      compact: compact,
      medium: medium,
      expanded: expanded,
    );
  }
}
