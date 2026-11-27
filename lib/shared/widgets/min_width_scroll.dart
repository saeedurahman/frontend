import 'package:flutter/material.dart';

/// Keeps [child] at least [minWidth] wide: on a narrower window it scrolls
/// sideways, instead of squeezing columns until they overflow.
class MinWidthScroll extends StatefulWidget {
  const MinWidthScroll({
    super.key,
    required this.minWidth,
    required this.child,
  });

  final double minWidth;
  final Widget child;

  @override
  State<MinWidthScroll> createState() => _MinWidthScrollState();
}

class _MinWidthScrollState extends State<MinWidthScroll> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) {
          if (box.maxWidth >= widget.minWidth) return widget.child;
          return Scrollbar(
            controller: _controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: widget.minWidth, child: widget.child),
            ),
          );
        },
      );
}
