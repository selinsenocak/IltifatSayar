import 'package:flutter/material.dart';

/// Opacity 0.82↔1 over 3s, matching `@keyframes isBreathe` — used on the
/// empty-state headline so it feels alive rather than static.
class BreathingText extends StatefulWidget {
  const BreathingText({super.key, required this.child});

  final Widget child;

  @override
  State<BreathingText> createState() => _BreathingTextState();
}

class _BreathingTextState extends State<BreathingText> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(duration: const Duration(milliseconds: 3000), vsync: this)..repeat(reverse: true);
  late final Animation<double> _opacity =
      Tween<double>(begin: 0.82, end: 1).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}
