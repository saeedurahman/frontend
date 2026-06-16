import 'package:flutter/material.dart';
import 'package:frantend/shared/widgets/feature_placeholder_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Dashboard',
      subtitle: 'KPIs, sales trends, and alerts',
    );
  }
}
