import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

class CrescentLoader extends StatelessWidget {
  const CrescentLoader({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
