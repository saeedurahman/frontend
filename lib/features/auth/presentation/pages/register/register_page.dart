import 'package:flutter/material.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(RouteNames.registerStep1);
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
