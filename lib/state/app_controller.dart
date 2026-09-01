import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/compliment.dart';

enum AppScreen { home, auth, settings }

enum CounterPeriod { week, month, total }

enum AuthMode { email, phone }

/// All app state and behavior in one place — a straight port of the
/// `Component` logic class in İltifatSayar.dc.html, using
/// `shared_preferences` where the prototype used `localStorage`.
class AppController extends ChangeNotifier {
  AppController({this.darkModeDefault = false, this.moralPeriodDefault = 3});

  /// Design-canvas props (`darkModeDefault` / `moralPeriodDefault`).
  final bool darkModeDefault;
  final int moralPeriodDefault;

  late SharedPreferences _prefs;

  bool dark = false;
  bool registered = false;
  List<Compliment> compliments = [];
  AppScreen screen = AppScreen.home;
  CounterPeriod period = CounterPeriod.total;

  bool showAddSheet = false;
  String addText = '';
  String addWho = '';
  Compliment? pendingCompliment;

  bool showBurst = false;
  double fabScale = 1;

  AuthMode authMode = AuthMode.email;
  String authId = '';
  String authPassword = '';

  bool notifyEmail = true;
  bool notifyPush = true;
  int moralPeriod = 3;

  String toast = '';

  Timer? _toastTimer;
  Timer? _fabTimer;
  Timer? _burstTimer;

  static const _kCompliments = 'is-compliments';
  static const _kDark = 'is-dark';
  static const _kRegistered = 'is-registered';
  static const _kMoralPeriod = 'is-moral-period';
  static const _kNotifyEmail = 'is-notify-email';
  static const _kNotifyPush = 'is-notify-push';

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    final raw = _prefs.getString(_kCompliments);
    if (raw != null) {
      try {
        compliments = (jsonDecode(raw) as List)
            .map((e) => Compliment.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        compliments = [];
      }
    }
    if (compliments.isEmpty) {
      compliments = [
        Compliment(
          id: 1,
          text: 'Bugünkü sunumun çok etkileyiciydi.',
          who: 'iş arkadaşım',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    }

    final savedDark = _prefs.getString(_kDark);
    dark = savedDark != null ? savedDark == '1' : darkModeDefault;
    registered = _prefs.getString(_kRegistered) == '1';
    final savedPeriod = _prefs.getString(_kMoralPeriod);
    moralPeriod = savedPeriod != null
        ? int.tryParse(savedPeriod) ?? moralPeriodDefault
        : moralPeriodDefault;
    notifyEmail = _prefs.getBool(_kNotifyEmail) ?? true;
    notifyPush = _prefs.getBool(_kNotifyPush) ?? true;

    notifyListeners();
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _kCompliments,
      jsonEncode(compliments.map((c) => c.toJson()).toList()),
    );
    await _prefs.setString(_kRegistered, registered ? '1' : '0');
    await _prefs.setString(_kDark, dark ? '1' : '0');
    await _prefs.setString(_kMoralPeriod, moralPeriod.toString());
    await _prefs.setBool(_kNotifyEmail, notifyEmail);
    await _prefs.setBool(_kNotifyPush, notifyPush);
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _fabTimer?.cancel();
    _burstTimer?.cancel();
    super.dispose();
  }

  // ── navigation & simple toggles ────────────────────────────────────────
  void toggleDark() {
    dark = !dark;
    notifyListeners();
    _persist();
  }

  void openSettings() {
    screen = AppScreen.settings;
    notifyListeners();
  }

  void backToHome() {
    screen = AppScreen.home;
    pendingCompliment = null;
    notifyListeners();
  }

  void openAdd() {
    showAddSheet = true;
    addText = '';
    addWho = '';
    notifyListeners();
  }

  void closeAdd() {
    showAddSheet = false;
    notifyListeners();
  }

  void setAddText(String v) {
    addText = v;
  }

  void setAddWho(String v) {
    addWho = v;
  }

  void setPeriod(CounterPeriod p) {
    period = p;
    notifyListeners();
  }

  void setAuthMode(AuthMode m) {
    authMode = m;
    authId = '';
    notifyListeners();
  }

  void setAuthId(String v) {
    authId = v;
  }

  void setAuthPassword(String v) {
    authPassword = v;
  }

  void toggleEmailNotify() {
    notifyEmail = !notifyEmail;
    notifyListeners();
    _persist();
  }

  void togglePushNotify() {
    notifyPush = !notifyPush;
    notifyListeners();
    _persist();
  }

  void setMoralPeriod(int days) {
    moralPeriod = days;
    notifyListeners();
    _persist();
  }

  // ── compliment flow ─────────────────────────────────────────────────────
  void _commitCompliment(Compliment item) {
    compliments = [...compliments, item];
    showAddSheet = false;
    showBurst = true;
    fabScale = 1.08;
    notifyListeners();
    _persist();

    _fabTimer?.cancel();
    _fabTimer = Timer(const Duration(milliseconds: 150), () {
      fabScale = 1;
      notifyListeners();
    });
    _burstTimer?.cancel();
    _burstTimer = Timer(const Duration(milliseconds: 700), () {
      showBurst = false;
      notifyListeners();
    });
  }

  /// Gecikmeli kayıt kuralı: hesapsız kullanıcı ilk 2 iltifatı cihazda
  /// biriktirir, 3. denemede kayıt ekranına yönlendirilir (bkz. intent.md §5).
  void saveCompliment() {
    final text = addText.trim();
    if (text.isEmpty) return;
    final item = Compliment(
      id: DateTime.now().millisecondsSinceEpoch,
      text: text,
      who: addWho.trim(),
      date: DateTime.now(),
    );
    if (!registered && compliments.length >= 2) {
      pendingCompliment = item;
      showAddSheet = false;
      screen = AppScreen.auth;
      notifyListeners();
      return;
    }
    _commitCompliment(item);
  }

  void authSubmit() {
    registered = true;
    screen = AppScreen.home;
    toast = 'hesabın oluşturuldu, iltifatların aktarıldı.';
    notifyListeners();
    _persist();

    final pending = pendingCompliment;
    if (pending != null) {
      pendingCompliment = null;
      _commitCompliment(pending);
    }

    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(milliseconds: 2600), () {
      toast = '';
      notifyListeners();
    });
  }

  // ── derived values (mirrors renderVals() in the prototype) ─────────────
  List<Compliment> get sortedCompliments {
    final list = [...compliments];
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  int get weekCount => compliments
      .where((c) => DateTime.now().difference(c.date) <= const Duration(days: 7))
      .length;

  int get monthCount => compliments
      .where((c) => DateTime.now().difference(c.date) <= const Duration(days: 30))
      .length;

  int get totalCount => compliments.length;

  int get periodCount => switch (period) {
        CounterPeriod.week => weekCount,
        CounterPeriod.month => monthCount,
        CounterPeriod.total => totalCount,
      };

  String get periodLabel => switch (period) {
        CounterPeriod.week => 'bu hafta',
        CounterPeriod.month => 'bu ay',
        CounterPeriod.total => 'toplam',
      };

  String get accountStatus => registered
      ? 'kayıtlı hesap'
      : 'misafir modu — kaydın 2 iltifata kadar geçerli';
}
