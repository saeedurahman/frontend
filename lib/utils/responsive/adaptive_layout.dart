import 'package:flutter/widgets.dart';

/// Width classes the whole app agrees on.
///
/// - [compact]: phones (bottom navigation + drawer)
/// - [medium]: small tablets / narrow desktop windows (drawer, no sidebar)
/// - [expanded]: desktop (permanent sidebar)
enum LayoutClass { compact, medium, expanded }

/// Canonical width thresholds. Screens must not hard-code their own.
abstract final class Breakpoints {
  /// Below this the app is "phone sized".
  static const double compact = 600;

  /// From this width on the permanent sidebar fits.
  static const double expanded = 1024;

  static LayoutClass classify(double width) {
    if (width < compact) return LayoutClass.compact;
    if (width < expanded) return LayoutClass.medium;
    return LayoutClass.expanded;
  }

  /// Wide enough for the permanent sidebar.
  static bool usesSidebar(double width) => width >= expanded;

  /// Narrow enough that bottom navigation replaces the sidebar rail.
  static bool usesBottomNav(double width) => width < compact;

  static LayoutClass of(BuildContext context) =>
      classify(MediaQuery.sizeOf(context).width);
}

/// Picks a builder by available width (the parent's constraints, not the
/// screen's, so it also works inside panes).
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.compact,
    this.medium,
    required this.expanded,
  });

  final WidgetBuilder compact;

  /// Falls back to [compact] when omitted.
  final WidgetBuilder? medium;
  final WidgetBuilder expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return switch (Breakpoints.classify(constraints.maxWidth)) {
          LayoutClass.compact => compact(context),
          LayoutClass.medium => (medium ?? compact)(context),
          LayoutClass.expanded => expanded(context),
        };
      },
    );
  }
}
