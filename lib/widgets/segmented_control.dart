import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';

/// Pill-shaped segmented control — mirrors `seg()` in the prototype: the
/// active segment always flips between İnci/Gece Kadifesi, independent of
/// the screen's own light/dark palette.
///
/// Set [stretch] to true where the source markup let the control's parent
/// flex column stretch it full-width (settings' period picker, the auth
/// tabs); leave it false where the parent centers it to content size (the
/// home counter card).
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.trackColor,
    this.dark = false,
    this.stretch = false,
  });

  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final Color trackColor;
  final bool dark;
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final o in options)
            stretch ? Expanded(child: _segment(o)) : _segment(o),
        ],
      ),
    );
  }

  Widget _segment((T, String) o) {
    return _Segment(
      label: o.$2,
      active: o.$1 == value,
      dark: dark,
      onTap: () => onChanged(o.$1),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.active,
    required this.dark,
    required this.onTap,
  });

  final String label;
  final bool active;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = active ? (dark ? SegColors.pearl : SegColors.nightVelvet) : Colors.transparent;
    final fg = active
        ? (dark ? SegColors.nightVelvet : SegColors.pearl)
        : (dark ? SegColors.subDark : SegColors.subLight);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: fg)),
      ),
    );
  }
}
