import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Natural pixel size of assets/app_logos/smart_pak.png.
  static const double _imageWidth = 1024;
  static const double _imageHeight = 683;

  void _watchDemo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo video coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = width * _imageHeight / _imageWidth;

          return SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/app_logos/smart_pak.png',
                    fit: BoxFit.fill,
                  ),
                  // Navbar: Login
                  _Hotspot(
                    rect: const Rect.fromLTWH(0.790, 0.030, 0.058, 0.040),
                    width: width,
                    height: height,
                    onTap: () => context.go(RouteNames.login),
                  ),
                  // Navbar: Start Free Trial
                  _Hotspot(
                    rect: const Rect.fromLTWH(0.860, 0.030, 0.090, 0.040),
                    width: width,
                    height: height,
                    onTap: () => context.go(RouteNames.register),
                  ),
                  // Hero: Start Free Trial
                  _Hotspot(
                    rect: const Rect.fromLTWH(0.036, 0.455, 0.150, 0.055),
                    width: width,
                    height: height,
                    onTap: () => context.go(RouteNames.register),
                  ),
                  // Hero: Watch Demo
                  _Hotspot(
                    rect: const Rect.fromLTWH(0.193, 0.455, 0.110, 0.055),
                    width: width,
                    height: height,
                    onTap: () => _watchDemo(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A transparent, clickable area placed over a region of the landing image.
/// [rect] uses fractional values (0..1) of the image width/height so the
/// hotspot scales together with the image.
class _Hotspot extends StatelessWidget {
  const _Hotspot({
    required this.rect,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final Rect rect;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left * width,
      top: rect.top * height,
      width: rect.width * width,
      height: rect.height * height,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
