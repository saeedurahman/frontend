import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/shared/widgets/layout/sidebar.dart';
import 'package:frantend/shared/widgets/layout/top_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              children: [
                TopBar(title: title, actions: actions),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
