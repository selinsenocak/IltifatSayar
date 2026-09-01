import 'package:flutter/material.dart';

/// The three-diamond "kabul edildi" burst that plays around the FAB when a
/// compliment is saved — matches the `isSparkle` keyframes (700ms: fade in
/// by 30%, drift outward, fade back out).
class SparkleBurst extends StatelessWidget {
  const SparkleBurst({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    if (!active) return const SizedBox.shrink();
    return const Stack(
      alignment: Alignment.topCenter,
      children: [
        _Sparkle(dx: -38, dy: -30, size: 18),
        _Sparkle(dx: 34, dy: -38, size: 14),
        _Sparkle(dx: 4, dy: -46, size: 12, startTop: 6),
      ],
    );
  }
}

class _Sparkle extends StatefulWidget {
  const _Sparkle({required this.dx, required this.dy, required this.size, this.startTop = 0});

  final double dx;
  final double dy;
  final double size;
  final double startTop;

  @override
  State<_Sparkle> createState() => _SparkleState();
}

class _SparkleState extends State<_Sparkle> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(duration: const Duration(milliseconds: 700), vsync: this)..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        final opacity = t < 0.3 ? t / 0.3 : (1 - (t - 0.3) / 0.7).clamp(0.0, 1.0);
        final scale = 0.4 + 0.6 * t;
        return Transform.translate(
          offset: Offset(widget.dx * t, widget.startTop + widget.dy * t),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Text('💎', style: TextStyle(fontSize: widget.size)),
            ),
          ),
        );
      },
    );
  }
}
