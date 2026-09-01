import 'package:flutter/material.dart';

/// Matches `toggleStyle()`/`knobStyle()` in the prototype — a 46×27 pill
/// that slides its knob and crossfades track color over 200ms.
class ToggleSwitch extends StatelessWidget {
  const ToggleSwitch({
    super.key,
    required this.value,
    required this.onColor,
    required this.offColor,
    required this.onChanged,
  });

  final bool value;
  final Color onColor;
  final Color offColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 46,
        height: 27,
        padding: const EdgeInsets.all(2),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? onColor : offColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Container(
          width: 23,
          height: 23,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1))],
          ),
        ),
      ),
    );
  }
}
