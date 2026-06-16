import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/auth/presentation/pages/buisness_logo.dart';
import 'package:frantend/features/auth/presentation/widgets/login_form_widget.dart';

class MobileLoginWidget extends StatelessWidget {
  const MobileLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BusinessLogo(compact: true, compactHeight: 140),
        Expanded(
          child: ColoredBox(
            color: AppColors.loginBackground,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.spacingLg),
              child: LoginFormWidget(),
            ),
          ),
        ),
      ],
    );
  }
}
