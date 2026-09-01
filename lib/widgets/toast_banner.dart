import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// The dark pill notice that appears under the status bar ("hesabın
/// oluşturuldu, iltifatların aktarıldı.") for 2.6s after registering.
class ToastBanner extends StatelessWidget {
  const ToastBanner({super.key, required this.text, required this.c});

  final String text;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.text,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: c.bg, fontSize: 13)),
    );
  }
}
