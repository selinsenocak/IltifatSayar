import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_controller.dart';
import '../theme/palette.dart';
import '../widgets/segmented_control.dart';
import '../widgets/toggle_switch.dart';

/// Ayarlar ekranı — "Benlik" atmosferi (design.md §7.3): bildirim
/// tercihleri, moral e-postası periyodu, karanlık mod ve hesap yönetimi.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller, required this.c});

  final AppController controller;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    final s = controller;
    return Container(
      color: c.settingsBg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: s.backToHome,
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: c.text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('ayarlar', style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontSize: 22, color: c.text)),
                ],
              ),
              const SizedBox(height: 18),
              _Card(
                color: c.settingsCardBg,
                children: [
                  _SectionLabel('bildirimler', c: c),
                  const SizedBox(height: 14),
                  _ToggleRow(
                    label: 'e-posta bildirimleri',
                    value: s.notifyEmail,
                    onChanged: (_) => s.toggleEmailNotify(),
                    c: c,
                  ),
                  const SizedBox(height: 14),
                  _ToggleRow(
                    label: 'push bildirimleri',
                    value: s.notifyPush,
                    onChanged: (_) => s.togglePushNotify(),
                    c: c,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Card(
                color: c.settingsCardBg,
                children: [
                  _SectionLabel('moral e-postası periyodu', c: c),
                  const SizedBox(height: 12),
                  SegmentedControl<int>(
                    trackColor: c.iconBg,
                    stretch: true,
                    dark: s.dark,
                    value: s.moralPeriod,
                    onChanged: s.setMoralPeriod,
                    options: const [(1, '1 gün'), (3, '3 gün'), (7, '7 gün')],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Card(
                color: c.settingsCardBg,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('karanlık mod', style: TextStyle(fontSize: 15, color: c.text)),
                      ToggleSwitch(value: s.dark, onColor: c.toggleOn, offColor: c.toggleOff, onChanged: (_) => s.toggleDark()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Card(
                color: c.settingsCardBg,
                children: [
                  _SectionLabel('hesap', c: c),
                  const SizedBox(height: 10),
                  Text(s.accountStatus, style: TextStyle(fontSize: 14, color: c.text)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Text('verilerini indir', style: TextStyle(fontSize: 14, color: c.histBorder)),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Text('hesabı sil', style: TextStyle(fontSize: 14, color: c.danger)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.color, required this.children});

  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.c});

  final String text;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: TextStyle(fontSize: 12, color: c.sub, letterSpacing: 0.4));
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.label, required this.value, required this.onChanged, required this.c});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: c.text)),
        ToggleSwitch(value: value, onColor: c.toggleOn, offColor: c.toggleOff, onChanged: onChanged),
      ],
    );
  }
}
