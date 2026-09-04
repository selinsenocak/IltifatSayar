import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/compliment.dart';
import '../state/app_controller.dart';
import '../theme/palette.dart';
import '../widgets/breathing_text.dart';
import '../widgets/segmented_control.dart';
import '../widgets/slide_up_in.dart';
import '../widgets/sparkle_burst.dart';

/// Ana ekran — sayaç, "iltifat ekle" FAB'ı ve bu ayki geçmiş listesi. Tüm
/// MVP özelliklerini (sayaç, ekleme, geçmiş, tema) tek ekranda toplar,
/// bkz. intent.md §3.1 "tek ekran ilkesi".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller, required this.c});

  final AppController controller;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    final s = controller;
    final items = s.sortedCompliments;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İltifatSayar',
                style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontSize: 19, color: c.text),
              ),
              Row(
                children: [
                  _IconButton(
                    bg: c.iconBg,
                    onTap: s.toggleDark,
                    child: Text(s.dark ? '☾' : '☀', style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 8),
                  _IconButton(
                    bg: c.iconBg,
                    onTap: s.openSettings,
                    child: Icon(Icons.settings_outlined, size: 18, color: c.text),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          _CounterCard(controller: s, c: c),
          SizedBox(
            height: 106,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(top: 26, child: SparkleBurst(active: s.showBurst)),
                Positioned(
                  top: 26,
                  child: GestureDetector(
                    onTap: s.openAdd,
                    child: AnimatedScale(
                      scale: s.fabScale,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: c.fabBg,
                          shape: BoxShape.circle,
                          boxShadow: const [BoxShadow(color: Color(0x2E000000), blurRadius: 24, offset: Offset(0, 10))],
                        ),
                        child: Icon(Icons.add, size: 30, color: c.fabIcon),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'bu ay biriktirdiklerin',
            style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontSize: 15, color: c.text),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            _EmptyState(c: c)
          else
            Column(
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(context, c),
                      onDismissed: (_) => s.deleteCompliment(item.id),
                      background: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(color: c.danger, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      child: SlideUpIn(child: _HistoryCard(item: item, c: c)),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Kaydırarak silmeden önce sorulan onay — Beck'in "kanıt biriktirme"
/// çerçevesinde bu kayıtlar kıymetli olduğundan yanlışlıkla silinmesin diye.
Future<bool> _confirmDelete(BuildContext context, AppPalette c) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: c.sheetBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('iltifatı sil?', style: TextStyle(color: c.text)),
      content: Text('bu kayıt geri getirilemez.', style: TextStyle(color: c.sub)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('vazgeç', style: TextStyle(color: c.sub)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text('sil', style: TextStyle(color: c.danger, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.bg, required this.onTap, required this.child});

  final Color bg;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 36, height: 36, child: Center(child: child)),
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({required this.controller, required this.c});

  final AppController controller;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    final s = controller;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: c.counterBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          SegmentedControl<CounterPeriod>(
            trackColor: c.iconBg,
            dark: s.dark,
            value: s.period,
            onChanged: s.setPeriod,
            options: const [
              (CounterPeriod.week, 'bu hafta'),
              (CounterPeriod.month, 'bu ay'),
              (CounterPeriod.total, 'toplam'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${s.periodCount}',
                style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w600, fontSize: 56, height: 1, color: c.counterNum),
              ),
              const SizedBox(width: 8),
              const Text('💎', style: TextStyle(fontSize: 30)),
            ],
          ),
          const SizedBox(height: 14),
          Text(s.periodLabel, style: TextStyle(fontSize: 13, color: c.sub)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.c});

  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      child: Column(
        children: [
          BreathingText(
            child: Text(
              'Henüz iltifat biriktirmemişsin.',
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(fontStyle: FontStyle.italic, fontSize: 16, color: c.text),
            ),
          ),
          const SizedBox(height: 8),
          Text('Yukarıdaki taşa dokunarak ilkini ekle', style: TextStyle(fontSize: 13, color: c.sub)),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.c});

  final Compliment item;
  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.histBg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: c.histBorder, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.text, style: TextStyle(color: c.histText, fontSize: 14.5, height: 1.45)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.who, style: TextStyle(color: c.sub, fontSize: 12)),
              Text(dateLabel(item.date), style: TextStyle(color: c.sub, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
