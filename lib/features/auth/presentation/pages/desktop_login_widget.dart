import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/auth/presentation/pages/buisness_logo.dart';
import 'package:frantend/features/auth/presentation/widgets/login_form_widget.dart';

class DesktopLoginWidget extends StatelessWidget {
  const DesktopLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: ColoredBox(
            color: AppColors.loginBackground,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 40,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: const LoginFormWidget(),
                ),
              ),
            ),
          ),
        ),
        const Expanded(
          flex: 6,
          child: BusinessLogo(),
        ),
      ],
    );
  }
}
