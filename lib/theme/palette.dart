import 'package:flutter/widgets.dart';

/// One immutable color set — mirrors the `LIGHT` / `DARK` maps in the
/// original .dc.html prototype, itself built from the "10 ana renk" system
/// in design.md (Zümrüt/Safir/Ametist/Sitrin/İnci/Gece Kadifesi ...).
class AppPalette {
  const AppPalette({
    required this.bg,
    required this.text,
    required this.sub,
    required this.counterBg,
    required this.counterNum,
    required this.fabBg,
    required this.fabIcon,
    required this.histBg,
    required this.histBorder,
    required this.histText,
    required this.sheetBg,
    required this.inputBorder,
    required this.iconBg,
    required this.authBg,
    required this.authCardBg,
    required this.authBtnBg,
    required this.authBtnText,
    required this.settingsBg,
    required this.settingsCardBg,
    required this.toggleOn,
    required this.toggleOff,
    required this.danger,
  });

  final Color bg;
  final Color text;
  final Color sub;
  final Color counterBg;
  final Color counterNum;
  final Color fabBg;
  final Color fabIcon;
  final Color histBg;
  final Color histBorder;
  final Color histText;
  final Color sheetBg;
  final Color inputBorder;
  final Color iconBg;
  final Color authBg;
  final Color authCardBg;
  final Color authBtnBg;
  final Color authBtnText;
  final Color settingsBg;
  final Color settingsCardBg;
  final Color toggleOn;
  final Color toggleOff;
  final Color danger;

  static const light = AppPalette(
    bg: Color(0xFFF3EEE6),
    text: Color(0xFF221F26),
    sub: Color(0xFF7C7A82),
    counterBg: Color(0xFFFBF9F5),
    counterNum: Color(0xFF124732),
    fabBg: Color(0xFFD9A430),
    fabIcon: Color(0xFF221F26),
    histBg: Color.fromRGBO(140, 169, 212, 0.12),
    histBorder: Color(0xFF2C4F86),
    histText: Color(0xFF221F26),
    sheetBg: Color(0xFFFBF9F5),
    inputBorder: Color(0xFFC9C6C0),
    iconBg: Color.fromRGBO(34, 31, 38, 0.06),
    authBg: Color(0xFF8CA9D4),
    authCardBg: Color(0xFFFBF9F5),
    authBtnBg: Color(0xFF1A3159),
    authBtnText: Color(0xFFF3EEE6),
    settingsBg: Color(0xFFB79BD9),
    settingsCardBg: Color(0xFFFFFFFF),
    toggleOn: Color(0xFF1E7A56),
    toggleOff: Color(0xFFADABB3),
    danger: Color(0xFFA8354A),
  );

  static const dark = AppPalette(
    bg: Color(0xFF100E13),
    text: Color(0xFFF3EEE6),
    sub: Color(0xFFADABB3),
    counterBg: Color(0xFF221F26),
    counterNum: Color(0xFF7FC4A3),
    fabBg: Color(0xFFF0CE85),
    fabIcon: Color(0xFF100E13),
    histBg: Color.fromRGBO(140, 169, 212, 0.14),
    histBorder: Color(0xFF8CA9D4),
    histText: Color(0xFFF3EEE6),
    sheetBg: Color(0xFF221F26),
    inputBorder: Color(0xFF4E4C54),
    iconBg: Color.fromRGBO(255, 255, 255, 0.08),
    authBg: Color(0xFF1A3159),
    authCardBg: Color(0xFF221F26),
    authBtnBg: Color(0xFF8CA9D4),
    authBtnText: Color(0xFF100E13),
    settingsBg: Color(0xFF45266B),
    settingsCardBg: Color(0xFF221F26),
    toggleOn: Color(0xFF7FC4A3),
    toggleOff: Color(0xFF4E4C54),
    danger: Color(0xFFD98A97),
  );
}

/// Fixed colors the segmented control always uses for its *active* segment,
/// regardless of the screen's own palette — mirrors `seg()` in the
/// prototype, which flips between İnci and Gece Kadifesi rather than the
/// current theme's bg/text.
class SegColors {
  static const pearl = Color(0xFFF3EEE6);
  static const nightVelvet = Color(0xFF221F26);
  static const subLight = Color(0xFF7C7A82);
  static const subDark = Color(0xFFADABB3);
}
