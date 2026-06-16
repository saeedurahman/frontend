import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/network_info.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    sl<NetworkInfo>().onConnectivityChanged.listen((connected) {
      if (mounted) setState(() => _isOnline = connected);
    });
  }

  Future<void> _checkConnectivity() async {
    final connected = await sl<NetworkInfo>().isConnected;
    if (mounted) setState(() => _isOnline = connected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text(widget.title, style: AppTextStyles.headlineMedium),
          const Spacer(),
          if (!_isOnline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.offline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.offline),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off, size: 14, color: AppColors.offline),
                  SizedBox(width: 6),
                  Text(
                    'Offline Mode',
                    style: TextStyle(
                      color: AppColors.offline,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
    );
  }
}
