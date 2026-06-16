import 'package:flutter/material.dart';

import 'responsive.dart';

/// A [Scaffold] that applies adaptive horizontal padding, optional max width,
/// safe area, and scroll behavior.
///
/// ```dart
/// return ResponsivePageScaffold(
///   appBar: AppBar(title: Text('Page')),
///   maxContentWidth: 1200,
///   child: MyContent(),
/// );
/// ```
class ResponsivePageScaffold extends StatelessWidget {
  const ResponsivePageScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.maxContentWidth,
    this.padding,
    this.useSafeArea = true,
    this.enableScroll = true,
    this.primary = true,
    this.physics,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final double? maxContentWidth;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;
  final bool enableScroll;
  final bool primary;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue<double>(
      compact: 12,
      medium: 20,
      expanded: 28,
    );

    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth ?? double.infinity,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: content,
        ),
      ),
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    if (enableScroll) {
      content = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            primary: primary,
            physics: physics,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: content,
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: content,
    );
  }
}
