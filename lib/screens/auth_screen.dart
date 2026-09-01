import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_controller.dart';
import '../theme/palette.dart';
import '../widgets/segmented_control.dart';
import '../widgets/underline_field.dart';

/// Gecikmeli kayıt ekranı — "Güven" atmosferi (design.md §7.2): Safir açık
/// ton zemin, sıcak Sitrin burada bilinçli olarak kullanılmaz çünkü bu an
/// "taahhüt" anıdır, "davet" değil.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.controller, required this.c});

  final AppController controller;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    final s = controller;
    return Container(
      color: c.authBg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.white.withValues(alpha: 0.25),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: s.backToHome,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: c.authBtnBg),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'hesabını oluştur',
                style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontSize: 24, color: c.authBtnBg),
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.75,
                child: Text(
                  'biriktirdiğin iltifatlar bu hesaba aktarılacak, hiçbir kayıt kaybolmayacak.',
                  style: TextStyle(fontSize: 13.5, color: c.authBtnBg, height: 1.5),
                ),
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: c.authCardBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedControl<AuthMode>(
                      trackColor: c.iconBg,
                      stretch: true,
                      value: s.authMode,
                      onChanged: s.setAuthMode,
                      options: const [
                        (AuthMode.email, 'e-posta'),
                        (AuthMode.phone, 'telefon'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    UnderlineField(
                      // Recreated when the tab switches so the field clears,
                      // matching `setAuthEmail/Phone` resetting `authId`.
                      key: ValueKey(s.authMode),
                      hint: s.authMode == AuthMode.email ? 'e-posta adresin' : 'telefon numaran',
                      onChanged: s.setAuthId,
                      textColor: c.text,
                      hintColor: c.sub,
                      borderColor: c.inputBorder,
                      focusColor: c.histBorder,
                    ),
                    const SizedBox(height: 14),
                    UnderlineField(
                      hint: 'şifre',
                      obscureText: true,
                      onChanged: s.setAuthPassword,
                      textColor: c.text,
                      hintColor: c.sub,
                      borderColor: c.inputBorder,
                      focusColor: c.histBorder,
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: s.authSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.authBtnBg,
                        foregroundColor: c.authBtnText,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: const Text('kayıt ol / giriş yap', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
