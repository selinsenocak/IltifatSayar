# İltifatSayar

Aldığın iltifatları kaydet, biriktir, hatırla. `project/İltifatSayar.dc.html`
tasarımının (Claude Design'dan alınan interaktif prototip) Flutter'a
uygulanmış hâli — bkz. `project/uploads/intent.md` ve `design-2.md` for ürün
kapsamı ve görsel sistem.

## Proje durumu

Bu depoda **Dart kaynak kodu tam**, ama platform iskeletleri (android/ios/
web/ macos/... klasörleri) henüz oluşturulmadı — bu ortamda Flutter SDK'sı
kurulu olmadığı için `flutter create` çalıştırılamadı. Devam etmek için:

```bash
cd /Users/selinsenocak/Desktop/iltifatsayar
flutter create . --project-name iltifat_sayar --org com.selinsenocak
flutter pub get
flutter run            # ya da: flutter run -d chrome
```

`flutter create .` mevcut `lib/`, `pubspec.yaml` gibi dosyalara dokunmadan
sadece eksik platform klasörlerini ekler.

## Yapı

```
lib/
  models/compliment.dart       İltifat modeli + dateLabel() (bugün/dün/N gün önce)
  theme/palette.dart           Açık/koyu renk paletleri (design.md §2-3)
  state/app_controller.dart    Tüm state + davranış (ChangeNotifier), shared_preferences ile kalıcılık
  screens/home_screen.dart     Ana ekran: sayaç, ekle FAB'ı, geçmiş listesi
  screens/auth_screen.dart     Gecikmeli kayıt/giriş ekranı
  screens/settings_screen.dart Ayarlar: bildirimler, moral e-postası periyodu, karanlık mod, hesap
  widgets/                     Segmented control, toggle switch, sparkle patlaması, slide-up giriş, breathing metin, alt-çizgili input, toast, ekle sayfası
  app.dart                     Kök widget: ekran geçişi + toast/ekle-sayfası overlay'leri
  main.dart                    Giriş noktası
project/                       Orijinal Claude Design tasarım paketi (referans, dokunulmadı)
```

## Tasarıma sadakat notları

- Renkler, tipografi (Fraunces/Inter/JetBrains Mono — `google_fonts` ile),
  ekran akışı (ana ekran → 3. iltifatta kayıt ekranına yönlendirme → ayarlar)
  `İltifatSayar.dc.html` ile birebir eşleşir.
- `localStorage` karşılığı olarak `shared_preferences` kullanıldı; anahtar
  isimleri prototipteki gibi (`is-compliments`, `is-dark`, ...).
- `ios-frame.jsx`'teki telefon çerçevesi yalnızca tasarım mockup'ıydı,
  gerçek uygulamaya taşınmadı — Flutter zaten gerçek bir cihazda/pencerede
  çalışıyor.
- Prototipte bildirim toggle'ları (`notifyEmail`/`notifyPush`) hiç
  kalıcılaştırılmıyordu (muhtemelen prototip eksikliği); bu sürümde diğer
  ayarlar gibi kalıcı yapıldı çünkü gerçek bir ayarlar ekranında bu daha
  doğru davranış.
- Moral e-postası gönderimi, Supabase/Resend entegrasyonu gibi backend
  parçaları (`intent.md` §4) bu iş kapsamının dışında — bu teslimat yalnızca
  istemci tarafı arayüz + yerel kalıcılıktır.

## Açık noktalar (intent.md §8)

- Android'de misafir verisinin uygulama silinse bile korunması için
  yedekleme isteği mi, best-effort mi kullanılacağı netleşmedi.
- Tek seferlik satın alma fiyatı/kapsamı netleşmedi.
