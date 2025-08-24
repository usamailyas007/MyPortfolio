import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimateOnVisible extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;
  final double triggerFraction;

  const AnimateOnVisible({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.offsetY = 0.2,
    this.triggerFraction = 0.3,
  });

  @override
  State<AnimateOnVisible> createState() => _AnimateOnVisibleState();
}

class _AnimateOnVisibleState extends State<AnimateOnVisible> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > widget.triggerFraction && !_visible) {
          setState(() {
            _visible = true;
          });
        }
      },
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: _visible ? 1.0 : 0.0,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : Offset(0, widget.offsetY),
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
