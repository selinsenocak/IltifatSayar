import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'state/app_controller.dart';
import 'theme/palette.dart';
import 'widgets/add_sheet.dart';
import 'widgets/toast_banner.dart';

/// Root widget — owns the single [AppController], loads persisted state
/// once, then hands control to [_RootShell].
class IltifatSayarApp extends StatefulWidget {
  const IltifatSayarApp({super.key});

  @override
  State<IltifatSayarApp> createState() => _IltifatSayarAppState();
}

class _IltifatSayarAppState extends State<IltifatSayarApp> {
  final AppController _controller = AppController();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller.load().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İltifatSayar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: GoogleFonts.inter().fontFamily),
      home: _ready ? _RootShell(controller: _controller) : const _Splash(),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Color(0xFFF3EEE6));
  }
}

/// Switches between the three screens and layers the toast + add-sheet
/// overlays on top — mirrors the `sc-if` screen switch and absolute-
/// positioned toast/sheet in the .dc.html template.
class _RootShell extends StatelessWidget {
  const _RootShell({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final s = controller;
        final c = s.dark ? AppPalette.dark : AppPalette.light;
        return Scaffold(
          backgroundColor: c.bg,
          body: Stack(
            children: [
              Positioned.fill(
                child: switch (s.screen) {
                  AppScreen.auth => AuthScreen(controller: s, c: c),
                  AppScreen.settings => SettingsScreen(controller: s, c: c),
                  AppScreen.home => HomeScreen(controller: s, c: c),
                },
              ),
              if (s.toast.isNotEmpty)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: ToastBanner(text: s.toast, c: c),
                ),
              if (s.showAddSheet) AddSheet(controller: s, c: c),
            ],
          ),
        );
      },
    );
  }
}
