# İltifatSayar — intent.md

## 1. Proje Özeti

İltifatSayar, kullanıcının gerçek hayatta sözlü olarak aldığı iltifatları kaydedip/saydığı bir mobil ve web uygulamasıdır. Amaç, kullanıcının pozitif anları fark etmesini ve hatırlamasını sağlamak. Kullanıcı belirli bir süre iltifat kaydetmezse, uygulama kendisi kullanıcıya moral verici bir e-posta gönderir. Tek Flutter kod tabanından hem mobil (iOS/Android) hem web olarak yayınlanır.

**Değer önerisi:** Hayatındaki küçük pozitif anları fark et, kaydet, biriktir — hiç olmasa bile yalnız kalma.

---

## 2. Hedef Kitle

Kendini iyi hissetmek isteyen, günlük hayatında aldığı iltifatları/pozitif geri bildirimleri fark edip biriktirmek isteyen kullanıcılar.

---

## 3. Kapsam

### 3.1 MVP (İlk Sürüm)

| # | Özellik | Not |
|---|---|---|
| 1 | Gecikmeli kayıt (ilk 2 kullanım hesapsız) | 3. kullanımda basit kayıt istenir — bkz. 5.1 |
| 2 | İltifat kaydetme | Kısa metin + **opsiyonel** "kim söyledi" alanı |
| 3 | İltifat listesi / geçmişi | Kronolojik, basit liste |
| 4 | Sayaç / toplam gösterimi | Bu hafta / bu ay / toplam gibi basit sayılar |
| 5 | Bildirim tercihleri | E-posta/push aç-kapa + moral e-postası periyodu seçimi |
| 6 | İnaktivite durumunda moral e-postası | Varsayılan 3 gün, kullanıcı 1/3/7 gün olarak değiştirebilir |

**Tek ekran ilkesi:** 2-3-4-5 numaralı özellikler tek bir ana ekranda toplanır: üstte sayaç, ortada büyük "iltifat ekle" aksiyonu, altta kısa geçmiş listesi, bir kenarda bildirim aç/kapa anahtarı. Kullanıcı ekran değiştirmeden akışta kalır; sayaç güncellemesinde küçük bir animasyonla anlık geri bildirim verilir.

Toplam ekran sayısı: **Ana ekran, Kayıt/Giriş (gecikmeli), Ayarlar (bildirim periyodu + hesap tercihleri).**

### 3.2 MVP Sonrası (Gelecek Sürüm)

- İltifat kategorisi (görünüm, başarı, karakter vb.)
- İstatistik/grafik görünümü (haftalık/aylık trend)
- Başkasına iltifat gönderme özelliği — opsiyonel, çekirdek akışın dışında tutulmalı
- Sosyal paylaşım

### 3.3 Gelir Modeli

**Ücretsiz + tek seferlik satın alma.** Temel özellikler (kaydetme, sayaç, geçmiş, moral e-postası) her zaman ücretsiz kalır — bu, "kendini iyi hissetme" amacına ücret duvarı koymamak için önemli. İleri düzey özellikler (ör. istatistik grafiği, sınırsız geçmiş, özel temalar) tek seferlik bir "destek ol / tam sürüm" satın alımı arkasında sunulabilir. Abonelik modeli önerilmez — düzenli ödeme hatırlatması, uygulamanın sakin/baskısız doğasıyla çelişir.

---

## 4. Teknik Mimari

- **Frontend:** Flutter (iOS, Android, Web)
- **Backend/DB:** Supabase (PostgreSQL + auth + edge functions) — düşük vendor lock-in, hızlı kurulum
- **E-posta:** Resend (küçük ölçekte hızlı entegrasyon)
- **Push bildirim:** Firebase Cloud Messaging
- **Zamanlanmış görevler:** Supabase Edge Functions + cron — her gün kullanıcının son kayıt tarihini ve seçtiği periyodu kontrol edip eşik aşıldıysa moral e-postası tetikler
- **Mimari prensip:** Repository pattern ile backend/e-posta servisi soyutlanmalı, ileride sağlayıcı değişebilsin
- **Misafir modu ve cihaz kimliği:** İlk 2 kayıt cihazda yerel olarak (Hive/SharedPreferences) tutulur. Cihaz kimliğinin uygulama silinip yeniden yüklense bile korunması istendi — bu platforma göre farklı çözülmeli:
  - **iOS:** Keychain, uygulama silinse bile veriyi korur (varsayılan davranış) — cihaz kimliği ve misafir verisi Keychain'de tutulmalı.
  - **Android:** Uygulama silindiğinde yerel depolama tamamen temizlenir; Keychain eşdeğeri yok. Bunun için ya (a) kullanıcıya "yedeklemek ister misin" diye kayıt eşiğinden önce nazikçe sorulmalı, ya da (b) bu platform farkı kabul edilip yalnızca iOS'ta tam kalıcılık, Android'de en iyi çaba (best-effort, ör. Google Auto Backup) sağlanmalı. **Bu, ekiple netleştirilmesi gereken bir teknik kısıt.**

---

## 5. Kullanıcı Akışları

**Akış 1 — İlk kullanım (hesapsız)**
1. Uygulama ilk açıldığında kayıt istenmez, kullanıcı doğrudan ana ekrana düşer.
2. Kullanıcı 1. ve 2. iltifatını cihaza yerel olarak kaydeder (misafir modu).
3. 3. kayıt denemesinde basit bir kayıt ekranı çıkar. Kayıt tamamlanınca cihazda biriken kayıtlar hesaba aktarılır — veri kaybı olmaz.

**Akış 1b — Basit kayıt**
1. Tek ekran: e-posta **veya** telefon numarası + şifre.
2. E-posta seçildiyse doğrulama linki, telefon seçildiyse SMS OTP gönderilir.
3. Doğrulama sonrası ana ekrana dönülür, misafir verileri hesaba bağlanır.

**Akış 2 — İltifat kaydetme (ana ekran içinde)**
1. Kullanıcı ana ekrandaki "İltifat ekle" butonuna dokunur.
2. Kısa metin girer, "kim söyledi" alanını isterse boş bırakır.
3. Kaydet → sayaç anında güncellenir, geçmiş listesine eklenir — sayfa değişmez.

**Akış 3 — İnaktivite / moral e-postası**
1. Sistem her gün kullanıcının son kayıt tarihini ve seçtiği periyodu (1/3/7 gün) kontrol eder.
2. Eşik aşılırsa, **"İltifatSayar'dan sana"** başlıklı, net şekilde uygulamadan geldiği belli olan bir moral e-postası gönderilir.
3. Bu e-posta asla üçüncü bir kişiden geliyormuş gibi sunulmaz — şeffaf ve dürüst bir dil kullanılır.

**Akış 4 — Bildirim tercihleri**
1. Ayarlar'dan e-posta/push bağımsız açılıp kapatılır, moral e-postası periyodu seçilir.

---

## 6. Psikolojik Çerçeve

Ürünün davranışsal tasarımı üç farklı teorik pencereden besleniyor. Bunlar birbirini tamamlayan katmanlar olarak düşünülmeli — her biri farklı bir tasarım kararına karşılık geliyor.

**Aaron Beck — Bilişsel terapi ve düşünce kalıpları:** Beck'in çalışması, insanların olumsuz "otomatik düşünceler" ve bilişsel çarpıtmalarla (ör. "mental filtre" — yalnızca olumsuzu görme, ya da "olumluyu diskalifiye etme" — iyi şeyleri önemsizleştirme) dünyayı yanlış yorumlayabileceğini gösterir. İltifat kaydı, bu çarpıtmalara karşı **somut kanıt biriktirme** işlevi görür: kullanıcı "kimse beni takdir etmiyor" gibi bir otomatik düşünceyle karşılaştığında, geçmiş listesi elle tutulur bir karşı-kanıt sunar. Tasarım kararı: geçmiş listesi kolay erişilir olmalı, kullanıcı kötü hissettiği anda "kanıtına" hızlıca bakabilmeli.

**Jean Piaget — Bilişsel gelişim ve şema oluşumu:** Piaget'e göre öğrenme, tekrar eden deneyimlerin zihinsel şemalara **asimile edilmesi** ve gerektiğinde şemanın **uyum sağlaması (accommodation)** yoluyla gerçekleşir. Kullanıcının "ben değerli/takdir edilen biriyim" şemasını güçlendirmesi, tek seferlik bir bilgiyle değil, **tekrarlanan somut kayıtlarla** olur. Tasarım kararı: uygulama tek büyük bir "sen harikasın" mesajı vermek yerine, küçük ve sık tekrarlanan kayıt anlarını kolaylaştırmalı — şema, tekrarla inşa edilir.

**Carl Jung — Arketipler ve bireyleşme (individuation):** Jung'un bireyleşme süreci, kişinin dağınık deneyimlerini bütünleşik bir "Self" (Benlik) etrafında toplamasıdır. İltifat biriktirme eylemi, sembolik olarak bir **"toplayıcı" arketipine** karşılık gelir — dağınık, unutulmaya mahkûm anları anlamlı bir bütüne dönüştürme. Tasarım kararı: geçmiş listesi yalnızca bir "log" değil, zamanla büyüyen kişisel bir **anlatı/koleksiyon** hissi vermeli (ör. "bu ay biriktirdiklerin" gibi bütünleştirici bir çerçeveleme), böylece kayıt eylemi kimlik inşasının bir parçası gibi hissettirilir.

**Ortak tasarım ilkesi:** Bu üç çerçeve birlikte şunu söylüyor — uygulama; kanıt biriktiren (Beck), tekrarla şema kuran (Piaget) ve bu birikimi anlamlı bir bütüne dönüştüren (Jung) bir araç olarak tasarlanmalı. Bu nedenle "0 iltifat" günü asla olumsuz/utandırıcı bir dille sunulmaz; kayıtlar somut ve spesifik olmaya teşvik edilir; moral e-postası şeffaf olmalı ve kullanıcıyı yanıltmamalı.

---

## 7. Güvenlik ve Gizlilik

- E-posta ve kişisel veriler TLS ile taşınır.
- JWT access + refresh token; access token kısa ömürlü (~15 dk).
- Auth endpoint'lerinde rate limiting ve brute-force koruması.
- Tüm kullanıcı girdileri (iltifat metni dahil) client + backend'de doğrulanır, XSS/injection'a karşı sanitize edilir.
- KVKK/GDPR: açık rıza metni, gizlilik politikası, hesap silme/veri dışa aktarma imkanı MVP'de bulunmalı.

---

## 8. Açık Sorular

- Android'de cihaz kimliğinin uygulama silinse bile korunması için hangi yöntem seçilecek (yedekleme isteği mi, best-effort mü)? (bkz. 4)
- Tek seferlik satın alma fiyatı ve içeriği (hangi özellikler kilit arkasında olacak) netleştirilmeli.
