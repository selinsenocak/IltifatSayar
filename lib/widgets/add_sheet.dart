import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_controller.dart';
import '../theme/palette.dart';
import 'underline_field.dart';

/// Bottom sheet overlay for adding a new compliment — slides up from the
/// bottom over a translucent scrim (mirrors the `isSlideUp` 220ms entrance
/// on the `showAddSheet` panel).
class AddSheet extends StatefulWidget {
  const AddSheet({super.key, required this.controller, required this.c});

  final AppController controller;
  final AppPalette c;

  @override
  State<AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(duration: const Duration(milliseconds: 220), vsync: this)..forward();
  late final CurvedAnimation _curved = CurvedAnimation(parent: _anim, curve: Curves.easeOut);

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.controller;
    final c = widget.c;
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: s.closeAdd,
              child: Container(color: const Color(0x6B000000)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _curved,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 24 * (1 - _curved.value)),
                child: Opacity(opacity: _curved.value, child: child),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                decoration: BoxDecoration(
                  color: c.sheetBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: c.sub.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'iltifat ekle',
                        style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontSize: 18, color: c.text),
                      ),
                      const SizedBox(height: 12),
                      UnderlineField(
                        hint: 'ne dediler?',
                        maxLines: 2,
                        onChanged: s.setAddText,
                        textColor: c.text,
                        hintColor: c.sub,
                        borderColor: c.inputBorder,
                        focusColor: c.histBorder,
                      ),
                      const SizedBox(height: 12),
                      UnderlineField(
                        hint: 'kim söyledi? (opsiyonel)',
                        onChanged: s.setAddWho,
                        textColor: c.text,
                        hintColor: c.sub,
                        borderColor: c.inputBorder,
                        focusColor: c.histBorder,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: s.closeAdd,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: c.iconBg,
                                foregroundColor: c.text,
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                              ),
                              child: const Text('vazgeç', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: s.saveCompliment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: c.fabBg,
                                foregroundColor: c.fabIcon,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                              ),
                              child: const Text('kaydet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
