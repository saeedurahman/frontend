import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';

/// Branding panel showing a cinematic, realistically waving Pakistan flag on a
/// tall flagpole against a daylight mountain sky.
///
/// The flag is rendered once to an off-screen texture and then warped every
/// frame with a multi-frequency "cloth" mesh ([Canvas.drawVertices]) plus
/// per-vertex shading for natural folds and ripples — no video or image assets.
///
/// Used as the right-side panel on desktop and a compact header strip on mobile.
class BusinessLogo extends StatefulWidget {
  const BusinessLogo({
    super.key,
    this.compact = false,
    this.compactHeight = 80,
  });

  final bool compact;
  final double compactHeight;

  @override
  State<BusinessLogo> createState() => _BusinessLogoState();
}

class _BusinessLogoState extends State<BusinessLogo>
    with SingleTickerProviderStateMixin {
  // Long, single repeating loop gives a continuous, seamless time source.
  late final AnimationController _controller;
  ui.Image? _flagTexture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3600),
    )..repeat();
    _flagTexture = _buildFlagTexture();
  }

  @override
  void dispose() {
    _controller.dispose();
    _flagTexture?.dispose();
    super.dispose();
  }

  /// Paints the static Pakistan flag (white hoist band, green field, crescent
  /// and star) to an off-screen image used as the waving mesh's texture.
  ui.Image _buildFlagTexture() {
    const w = 900.0;
    const h = 600.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    const white = Color(0xFFFFFFFF);
    const green = Color(0xFF01411C); // Pakistan green

    const stripeW = w * 0.25;
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, w, h),
      Paint()..color = white,
    );
    canvas.drawRect(
      const Rect.fromLTWH(stripeW, 0, w - stripeW, h),
      Paint()..color = green,
    );

    // Crescent + star centered within the green field.
    const fieldCenterX = stripeW + (w - stripeW) / 2;
    const cy = h / 2;
    const r = h * 0.30;

    final outer = Path()
      ..addOval(Rect.fromCircle(
        center: const Offset(fieldCenterX - r * 0.10, cy),
        radius: r,
      ));
    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(fieldCenterX + r * 0.20, cy - r * 0.16),
          radius: r * 0.86,
        ),
      );
    final crescent = Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(crescent, Paint()..color = white..isAntiAlias = true);

    final star = _starPath(
      const Offset(fieldCenterX + r * 0.62, cy - r * 0.42),
      r * 0.42,
    );
    canvas.drawPath(star, Paint()..color = white..isAntiAlias = true);

    return recorder.endRecording().toImageSync(w.toInt(), h.toInt());
  }

  Path _starPath(Offset c, double radius) {
    final path = Path();
    const points = 5;
    final inner = radius * 0.42;
    for (var i = 0; i < points * 2; i++) {
      final rad = i.isEven ? radius : inner;
      final ang = -math.pi / 2 + i * math.pi / points;
      final p = Offset(c.dx + rad * math.cos(ang), c.dy + rad * math.sin(ang));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path..close();
  }

  @override
  Widget build(BuildContext context) {
    final texture = _flagTexture;

    return ClipRect(
      child: SizedBox(
        height: widget.compact ? widget.compactHeight : double.infinity,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (texture != null)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _FlagScenePainter(
                        time: _controller.value * 3600,
                        flag: texture,
                        compact: widget.compact,
                      ),
                    );
                  },
                ),
              ),
              // SizedBox(height: 90),
            if (!widget.compact)
              Align(
                alignment: const Alignment(0, 0.2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: const _HadithBanner(),
                  ),
                ),
              ),
            if (!widget.compact) const _BrandingCaption(),
          ],
        ),
      ),
    );
  }
}
/// Animated Hadith banner shown in the middle of the branding panel:
/// frosted-glass card with gold ornamental dividers, a continuous shimmer
/// sweep across the calligraphy, a soft glow pulse, and a fade/slide entrance.
class _HadithBanner extends StatefulWidget {
  const _HadithBanner();

  @override
  State<_HadithBanner> createState() => _HadithBannerState();
}

class _HadithBannerState extends State<_HadithBanner>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _shimmer;
  late final AnimationController _glow;

  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));

    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _shimmer.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedBuilder(
              animation: _glow,
              builder: (context, child) {
                final glow = 0.6 + 0.4 * _glow.value;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.black.withValues(alpha: 0.22),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.45 * glow),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.22 * glow),
                        blurRadius: 28 * glow,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _Ornament(),
                  const SizedBox(height: 18),
                  _buildShimmerText(),
                  const SizedBox(height: 14),
                  Text(
                    'Earning a lawful livelihood is an act of worship',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.3,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Ornament(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerText() {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        final t = _shimmer.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE8C547),
                Color(0xFFFFF6D6),
                Color(0xFFFFFFFF),
                Color(0xFFFFF6D6),
                Color(0xFFE8C547),
              ],
              stops: [
                (t - 0.30).clamp(0.0, 1.0),
                (t - 0.15).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.15).clamp(0.0, 1.0),
                (t + 0.30).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: const Text(
        'حصولِ رزقِ حلال عبادت ہے',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.7,
          shadows: [
            Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
      ),
    );
  }
}

/// A small gold ornamental divider with a centered diamond.
class _Ornament extends StatelessWidget {
  const _Ornament();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.accent],
                ),
              ),
              child: SizedBox(height: 1.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent, Colors.transparent],
                ),
              ),
              child: SizedBox(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Caption overlaid at the bottom of the (non-compact) branding panel.
class _BrandingCaption extends StatelessWidget {
  const _BrandingCaption();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 36),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xCC012A14)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'کاروبار کو سمجھداری سے چلائیں',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium.copyWith(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.4,
                shadows: const [
                  Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'RUN YOUR BUSINESS INTELLIGENTLY',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                letterSpacing: 1.4,
                fontWeight: FontWeight.w600,
                shadows: const [
                  Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the full cinematic scene: sky, sun, drifting clouds, layered
/// mountains, flagpole, and the warped waving flag.
class _FlagScenePainter extends CustomPainter {
  _FlagScenePainter({
    required this.time,
    required this.flag,
    required this.compact,
  });

  /// Elapsed seconds (continuous).
  final double time;
  final ui.Image flag;
  final bool compact;

  // Deterministic cloud layout: (yFraction, startX 0..1, speed, scale, opacity).
  static const _clouds = <List<double>>[
    [0.16, 0.10, 0.018, 1.1, 0.85],
    [0.28, 0.55, 0.012, 1.6, 0.70],
    [0.12, 0.80, 0.024, 0.8, 0.75],
    [0.34, 0.30, 0.009, 1.3, 0.55],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Subtle cinematic camera drift: slow zoom + pan.
    final zoom = 1.03 + 0.025 * math.sin(time * 0.18);
    final panX = 6 * math.sin(time * 0.10);
    final panY = 4 * math.cos(time * 0.13);
    canvas
      ..translate(size.width / 2 + panX, size.height / 2 + panY)
      ..scale(zoom)
      ..translate(-size.width / 2, -size.height / 2);

    _paintSky(canvas, size);
    _paintSun(canvas, size);
    _paintClouds(canvas, size);
    _paintMountains(canvas, size);
    _paintPoleAndFlag(canvas, size);

    canvas.restore();
  }

  void _paintSky(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sky = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF1C6FB5),
        Color(0xFF4D9BD6),
        Color(0xFF9FCDEA),
        Color(0xFFD8EEF8),
      ],
      stops: [0.0, 0.45, 0.78, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = sky);
  }

  void _paintSun(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.82, size.height * 0.18);
    final radius = size.shortestSide * 0.45;
    final glow = RadialGradient(
      colors: [
        const Color(0xFFFFF8E1).withValues(alpha: 0.95),
        const Color(0xFFFFF1C4).withValues(alpha: 0.35),
        const Color(0xFFFFF1C4).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.35, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, Paint()..shader = glow);
    canvas.drawCircle(
      center,
      size.shortestSide * 0.05,
      Paint()..color = const Color(0xFFFFFDF5),
    );
  }

  void _paintClouds(Canvas canvas, Size size) {
    for (final c in _clouds) {
      final y = c[0] * size.height;
      final travel = size.width * 1.4;
      final x = ((c[1] + time * c[2]) % 1.0) * travel - size.width * 0.2;
      _drawCloud(canvas, Offset(x, y), c[3] * size.shortestSide * 0.06, c[4]);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double s, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    const puffs = <Offset>[
      Offset(0, 0),
      Offset(-1.6, 0.3),
      Offset(1.6, 0.3),
      Offset(-0.7, -0.7),
      Offset(0.8, -0.6),
    ];
    for (final p in puffs) {
      canvas.drawCircle(center + Offset(p.dx * s, p.dy * s), s, paint);
    }
  }

  void _paintMountains(Canvas canvas, Size size) {
    final base = size.height * (compact ? 1.02 : 0.99);

    // Far range — hazy blue.
    _mountainLayer(
      canvas,
      size,
      baseY: base,
      height: size.height * 0.34,
      seed: 11,
      ridges: 7,
      color: const Color(0xFF7FA8C9),
      snow: false,
    );
    // Mid range.
    _mountainLayer(
      canvas,
      size,
      baseY: base,
      height: size.height * 0.46,
      seed: 5,
      ridges: 5,
      color: const Color(0xFF4E7C6B),
      snow: true,
    );
    // Near range — darker, foreground.
    _mountainLayer(
      canvas,
      size,
      baseY: base + size.height * 0.04,
      height: size.height * 0.30,
      seed: 23,
      ridges: 4,
      color: const Color(0xFF3A5A4B),
      snow: false,
    );
  }

  void _mountainLayer(
    Canvas canvas,
    Size size, {
    required double baseY,
    required double height,
    required int seed,
    required int ridges,
    required Color color,
    required bool snow,
  }) {
    final rnd = math.Random(seed);
    final path = Path()..moveTo(0, baseY);
    final peaks = <Offset>[];
    final step = size.width / ridges;
    for (var i = 0; i <= ridges; i++) {
      final x = i * step;
      final peakY = baseY - height * (0.55 + rnd.nextDouble() * 0.45);
      peaks.add(Offset(x, peakY));
      if (i == 0) {
        path.lineTo(x, peakY);
      } else {
        final prev = peaks[i - 1];
        final midX = (prev.dx + x) / 2;
        final valley = baseY - height * (0.10 + rnd.nextDouble() * 0.18);
        path
          ..lineTo(midX, valley)
          ..lineTo(x, peakY);
      }
    }
    path
      ..lineTo(size.width, baseY)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, Color.lerp(color, Colors.black, 0.25)!],
        ).createShader(Offset(0, baseY - height) & Size(size.width, height)),
    );

    if (snow) {
      final snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
      for (final peak in peaks) {
        final cap = Path()
          ..moveTo(peak.dx, peak.dy)
          ..lineTo(peak.dx - height * 0.10, peak.dy + height * 0.14)
          ..lineTo(peak.dx - height * 0.03, peak.dy + height * 0.10)
          ..lineTo(peak.dx + height * 0.02, peak.dy + height * 0.15)
          ..lineTo(peak.dx + height * 0.09, peak.dy + height * 0.11)
          ..close();
        canvas.drawPath(cap, snowPaint);
      }
    }
  }

  void _paintPoleAndFlag(Canvas canvas, Size size) {
    final poleX = size.width * (compact ? 0.09 : 0.14);
    final poleW = math.max(5.0, size.width * 0.013);
    final poleTop = size.height * 0.05;
    final poleBottom = size.height * 0.98;

    // Pole shaft — metallic gradient.
    final poleRect = Rect.fromLTWH(poleX, poleTop, poleW, poleBottom - poleTop);
    canvas.drawRRect(
      RRect.fromRectAndRadius(poleRect, Radius.circular(poleW)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFE8EAED), Color(0xFF9AA0A6), Color(0xFF6B7177)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(poleRect),
    );

    // Finial ball on top.
    final finialC = Offset(poleX + poleW / 2, poleTop);
    canvas.drawCircle(
      finialC,
      poleW * 1.6,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFE9A8), AppColors.accentDark],
          center: Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: finialC, radius: poleW * 1.6)),
    );

    _paintFlag(canvas, size, poleX + poleW * 0.5, poleTop + poleW * 2.4);
  }

  void _paintFlag(Canvas canvas, Size size, double flagLeft, double flagTop) {
    var flagH = compact ? size.height * 0.55 : size.height * 0.40;
    var flagW = flagH * 1.5;
    final maxW = size.width - flagLeft - size.width * 0.05;
    if (flagW > maxW) {
      flagW = maxW;
      flagH = flagW / 1.5;
    }

    const cols = 38;
    const rows = 24;
    final imgW = flag.width.toDouble();
    final imgH = flag.height.toDouble();

    final phase = time * 2.4;
    final gust = 1.0 + 0.25 * math.sin(time * 0.7);
    final amp = flagH * 0.11 * gust;

    final positions = <Offset>[];
    final texCoords = <Offset>[];
    final colors = <Color>[];

    for (var j = 0; j <= rows; j++) {
      final v = j / rows;
      for (var i = 0; i <= cols; i++) {
        final u = i / cols;

        // Travelling cloth wave — amplitude tapers up from the hoist.
        final taper = 0.08 + u;
        final wMain = math.sin(u * 8.0 - phase);
        final wSub = 0.5 * math.sin(u * 4.0 - phase * 0.7 + v * 1.5);
        var dy = (wMain + wSub) * amp * taper;
        dy += math.sin(v * math.pi * 1.5 + phase * 0.4) * amp * 0.14 * u;
        dy += flagH * 0.04 * u; // slight gravity sag toward the fly

        // Foreshortening: fabric pulls back horizontally as it ripples.
        final fore = (1 - math.cos(u * 8.0 - phase)) * 0.5;
        final dx = -fore * flagW * 0.05 * u;

        positions.add(Offset(flagLeft + u * flagW + dx, flagTop + v * flagH + dy));
        texCoords.add(Offset(u * imgW, v * imgH));

        // Per-vertex shading from the wave slope (folds & highlights).
        final shade = math.cos(u * 8.0 - phase);
        final b = (0.68 + 0.32 * ((shade + 1) / 2)).clamp(0.0, 1.0);
        final g = (b * 255).round();
        colors.add(Color.fromARGB(255, g, g, g));
      }
    }

    final indices = <int>[];
    const stride = cols + 1;
    for (var j = 0; j < rows; j++) {
      for (var i = 0; i < cols; i++) {
        final a = j * stride + i;
        final b = a + 1;
        final c = a + stride;
        final d = c + 1;
        indices..addAll([a, c, b])..addAll([b, c, d]);
      }
    }

    final vertices = ui.Vertices(
      VertexMode.triangles,
      positions,
      textureCoordinates: texCoords,
      colors: colors,
      indices: indices,
    );

    final shader = ImageShader(
      flag,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().storage,
    );
    final paint = Paint()
      ..shader = shader
      ..isAntiAlias = true;

    // Soft drop shadow of the waving cloth for depth.
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final shadowVerts = ui.Vertices(
      VertexMode.triangles,
      [for (final p in positions) p.translate(6, 10)],
      indices: indices,
    );
    canvas.drawVertices(shadowVerts, BlendMode.srcOver, shadowPaint);

    // Modulate blends the per-vertex grey shading with the flag texture.
    canvas.drawVertices(vertices, BlendMode.modulate, paint);
  }

  @override
  bool shouldRepaint(covariant _FlagScenePainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.flag != flag;
  }
}
