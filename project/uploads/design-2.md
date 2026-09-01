# İltifatSayar — design.md

## 1. Tasarım Felsefesi

Konsept: **mücevher kutusu.** Biriktirdiğin her iltifat, kişisel bir taş gibi düşünülür — Jung'un "toplayıcı" arketipini kelimenin tam anlamıyla görselleştirir. Üç arketip yine üç ayrı taşa ve görsel atmosfere karşılık gelir: **Piaget (büyüme) → Zümrüt**, **Beck (kanıt) → Safir**, **Jung (benlik) → Ametist**. Önceki sıcak fildişi/amber paletinden bilinçli olarak uzaklaşıldı; bu sürüm daha doygun, mücevher benzeri tonlar ve nötr olarak sıcak krem yerine soft "inci" ve "gece kadifesi" kullanıyor.

**İmza öğe:** Sayaç rakamları mono fontla (odometre hissi) yazılmaya devam eder. **İmza emoji artık 💎 (mücevher)** — ✨ yerine, çünkü "biriktirdiğin taşlar" fikrini doğrudan taşıyor.

---

## 2. Renk Sistemi — 10 Ana Renk

| # | Ad | Arketip/Anlam | Hex |
|---|---|---|---|
| 1 | Zümrüt | Piaget — büyüme, tekrarla inşa | `#1E7A56` |
| 2 | Safir | Beck — kanıt, netlik, güven | `#2C4F86` |
| 3 | Ametist | Jung — benlik, bireyleşme | `#6A3FA0` |
| 4 | Sitrin | Vurgu — sıcak eylem çağrısı | `#D9A430` |
| 5 | İnci | Zemin (açık, nötr) | `#F3EEE6` |
| 6 | Gece Kadifesi | Zemin/metin (koyu, nötr) | `#221F26` |
| 7 | Zümrüt Onayı | Semantik başarı | `#2F9A6E` |
| 8 | Topaz | Semantik uyarı | `#C97A2E` |
| 9 | Yakut | Semantik hata | `#A8354A` |
| 10 | Sedef Grisi | İkincil metin/pasif durum | `#7C7A82` |

## 3. Ara Renkler — Açık/Koyu Ton (20)

| Ana Renk | Açık Ton | Koyu Ton |
|---|---|---|
| Zümrüt | `#7FC4A3` | `#124732` |
| Safir | `#8CA9D4` | `#1A3159` |
| Ametist | `#B79BD9` | `#45266B` |
| Sitrin | `#F0CE85` | `#A67418` |
| İnci | `#FBF9F5` | `#E4DCCB` |
| Gece Kadifesi | `#4A4550` | `#100E13` |
| Zümrüt Onayı | `#8FDDBB` | `#1C6B4C` |
| Topaz | `#E5B072` | `#7E4F1B` |
| Yakut | `#D98A97` | `#6E2233` |
| Sedef Grisi | `#ADABB3` | `#4E4C54` |

Toplam: 10 ana + 20 ara = 30 ton, sınırın içinde.

## 4. Renk–Alan Eşleştirmesi

| Alan / Bileşen | Ana Renk | Kullanım |
|---|---|---|
| Ana ekran zemini | İnci | Açık, nötr taban |
| Sayaç rakamı | Zümrüt (koyu ton) | Büyüme/ilerleme hissi |
| "İltifat ekle" butonu | Sitrin | Sıcak, davetkâr eylem çağrısı |
| Geçmiş liste kartları | Safir (açık ton zemin, koyu ton metin) | Kanıt/güven hissi |
| Kayıt/Giriş ekranı | Safir | Güven, taahhüt anı |
| Ayarlar / Hesap ekranı | Ametist | Benlik, kişisel alan |
| Bildirim toggle (açık) | Zümrüt | Aktif/büyüyen durum |
| Bildirim toggle (kapalı) | Sedef Grisi | Nötr, pasif durum |
| Başarı mesajı | Zümrüt Onayı | Onay |
| Hata mesajı | Yakut | Uyarı |
| İkincil/yardımcı metin | Sedef Grisi | Hiyerarşi |

---

## 5. Tipografi

- **Gövde/UI:** Inter — yüksek okunabilirlik, sade.
- **Başlıklar / boş durum metinleri:** Fraunces — sıcak, editoryal ton; kısıtlı kullanılır.
- **Sayaç rakamları:** JetBrains Mono — odometre hissi, "İltifatSayar" adını görsel olarak destekler.
- Ölçek: 12 / 14 / 16 / 20 / 28 / 40px. Ağırlıklar: 400 (gövde), 500 (vurgulu), 600 (yalnızca sayaç ve büyük başlık).
- Her zaman cümle içi büyük/küçük harf; BÜYÜK HARF kullanılmaz.

---

## 6. Bileşenler

- **Büyük ekle butonu (FAB):** Dairesel, Sitrin zemin, Gece Kadifesi ikon. Dokunuşta hafif ölçek büyümesi (1.0 → 1.06 → 1.0, 150ms).
- **Sayaç kartı:** İnci zemin, ortada büyük mono rakam (Zümrüt koyu ton), rakamın hemen yanında küçük 💎, altında küçük etiket ("bu hafta").
- **Geçmiş liste öğesi:** Sol kenarda ince Safir şerit, kart zemini Safir açık ton %8 opaklık, metin Gece Kadifesi.
- **Toggle switch:** Açık durumda Zümrüt, kapalı durumda Sedef Grisi; geçiş 200ms yumuşak renk animasyonu.
- **Giriş alanı (input):** Alt çizgi stili, odakta Safir kenarlık; hata durumunda Yakut kenarlık + küçük ikon.
- **Ayarlar kartı:** Ametist açık ton zemin, köşeler 12px yuvarlatılmış.

---

## 7. Ekranlar

### 7.1 Ana Ekran — "Büyüme" atmosferi
İnci zemin. Üstte ortalanmış sayaç kartı (mono rakam + 💎, count-up animasyonlu). Hemen altında büyük dairesel ekle butonu (Sitrin), ortadaki en baskın öğe. Altında geçmiş listesi (Safir tonlu kartlar), kaydırılabilir. Boş durumda Fraunces ile yazılmış davetkâr bir cümle ve ekle butonuna yönlendiren ince bir ok.

### 7.2 Kayıt/Giriş Ekranı — "Güven" atmosferi
Safir açık ton zemin. Ortada tek kart: e-posta/telefon seçim sekmesi + şifre alanı. Buton Safir koyu ton zemin, İnci metin — ana ekrandaki sıcak Sitrin burada bilinçli olarak kullanılmaz, çünkü bu an "taahhüt" anıdır, "davet" değil.

### 7.3 Ayarlar Ekranı — "Benlik" atmosferi
Ametist açık ton zemin. Kartlar halinde: bildirim periyodu seçici (1/3/7 gün), e-posta/push toggle'ları, hesap bilgisi, veri indirme/hesap silme. Üst başlık Fraunces ile, daha kişisel/samimi bir ton.

---

## 8. Görsel Efektler ve Mikro-etkileşimler

- **Sayaç güncellemesi:** Rakam eski değerden yeni değere 400ms'de "count-up" ile geçer, aynı anda hafif bir ölçek nabzı atar.
- **Kayıt eklenince:** Küçük bir parıltı patlaması (2-3 parçacık, Sitrin renginde, 💎 formunda) buton çevresinde — zarif bir "kabul edildi" hissi, abartısız.
- **Yeni geçmiş kartı:** Alttan hafif kayarak ve solarak (fade + slide-up, 250ms) listeye eklenir.
- **Boş durum:** Fraunces başlık hafifçe nefes alır gibi (opacity 0.85↔1, 3s döngü).
- **Toggle geçişleri:** Renk ve konum birlikte 200ms'de yumuşak geçer.
- **Mobilde haptic:** Ekle butonuna dokunuşta hafif titreşim.
- Tüm animasyonlar `prefers-reduced-motion` ayarına saygı gösterir.

---

## 9. Karanlık Mod — "Gerçek Mücevher Kutusu"

Karanlık mod burada bir ikinci sınıf seçenek değil, konseptin en güçlü hali: Gece Kadifesi (koyu ton `#100E13`) zemin üzerinde Zümrüt, Safir, Ametist ve Sitrin tonları gerçek mücevherler gibi parlar. Her ana rengin koyu tonu zemin/kenarlık için, açık tonu metin/vurgu için kullanılır (roller ters döner). Arketip atmosferleri (ekranlar arası renk farkı) korunur, yalnızca kontrast yönü değişir.

---

## 10. Erişilebilirlik

- Tüm metin/zemin çiftleri WCAG AA kontrastını (4.5:1) karşılamalı — Sitrin üzerinde metin için Gece Kadifesi kullanılmalı, beyaz değil.
- Dokunma hedefleri minimum 44x44px.
- Renk tek başına anlam taşımaz (ör. hata durumunda renk + ikon + metin birlikte kullanılır).
