import 'package:flutter/material.dart';

/// Fade + 14px slide-up entrance, matching `@keyframes isSlideUp` (250ms) —
/// plays once when a history card first mounts.
class SlideUpIn extends StatefulWidget {
  const SlideUpIn({super.key, required this.child});

  final Widget child;

  @override
  State<SlideUpIn> createState() => _SlideUpInState();
}

class _SlideUpInState extends State<SlideUpIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(duration: const Duration(milliseconds: 250), vsync: this)..forward();
  late final CurvedAnimation _curved = CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curved,
      child: AnimatedBuilder(
        animation: _curved,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 14 * (1 - _curved.value)),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
