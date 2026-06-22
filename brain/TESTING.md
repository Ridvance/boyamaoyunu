# TESTING.md - Test ve Doğrulama

> Son güncelleme: 2026-06-21

## Her Kod Değişikliğinde

```bash
git diff --check
flutter analyze
flutter test
```

Davranış değişen oyun için hedefli widget/unit testi eklenmeden faz tamamlanmaz.

## Release Build Kapısı

```bash
flutter build appbundle --release
flutter build ios --release --no-codesign
```

- Android release yalnız upload keystore ile imzalı AAB üretilirse geçer.
- iOS no-codesign build yalnız CocoaPods çözümü ve Xcode derlemesi tamamlanırsa geçer.
- Public release öncesi gerçek imzalı iOS archive/TestFlight ayrıca doğrulanır.

## Cihaz Matrisi

- En az 2 güncel Android telefon; biri kısa yatay ekran.
- En az 1 Android tablet.
- En az 1 iPhone.
- Mümkünse 1 iPad.
- Mobil Chrome PWA ve Safari web smoke.

## Kritik Akışlar

- İlk açılış ve yataya yönlendirme.
- Her ana oyun kartını açma/geri dönme.
- Boyama, çiz takip, balon, şekil, ses, renk, alışkanlık ve paket tamamlama.
- Uygulama restart sonrası ilerleme.
- Offline ilk açılış ve oyun oynama.
- Ebeveyn kapısı, gizlilik linki ve ilerleme sıfırlama.
- Ses/titreşim açık-kapalı davranışı.
- Küçük ekranda taşma, çakışma ve erişilemeyen kontrol olmaması.

## Çocuk/Ebeveyn Gözlemi

- 2-5 çocuk/ebeveyn oturumu.
- Çocuk ilk hedefi sözlü yardım olmadan anlayabiliyor mu?
- 15-20 dakika içinde oyunlar arası geçiş ve tekrar isteği var mı?
- Yanlış geri bildirim korkutmuyor veya kilitlemiyor mu?
- Ebeveyn güvenlik ve offline/reklamsız vaadini anlayabiliyor mu?

## Go/No-Go

Public release için P0/P1 hata sıfır, cihaz matrisi tamam, kapalı test değerlendirilmiş ve `brain/RELEASE.md` içinde `GO` kararı yazılmış olmalı.

## Son Otomatik Doğrulama - Phase 2K

- `git diff --check`: PASS.
- `flutter analyze`: PASS, sorun yok.
- `flutter test --reporter expanded`: PASS, 29 test.
- Balon ilerleme regresyonu: `balloon` seviye 1 kaydedildi, mevcut `tracing` kaydı değişmedi.
- `flutter build appbundle --release`: PASS, 23.5 MB.
- `flutter build ios --release --no-codesign`: PASS, 26.5 MB.
- Gerçek iOS imzalı archive/TestFlight ve cihaz matrisi sonraki release kapılarında bekliyor.

## Son Otomatik Doğrulama - Phase 2L

- `git diff --check`: PASS.
- `flutter analyze`: PASS, sorun yok.
- `flutter test --reporter expanded`: PASS, 33 test.
- Chapter kimlik benzersizliği: PASS, 8/8 benzersiz.
- Tamamlanma ve yıldız depolama yeniden başlatma testi: PASS.
- Ses/titreşim tercih kalıcılığı: PASS.
- Çocuk ilerleme rozetleri ve ebeveyn özet/ayar/sıfırlama widget testleri: PASS.
- Kısa yatay ekran taşma regresyonu: PASS.
- Gerçek cihaz restart smoke Phase 2P cihaz matrisinde ayrıca doğrulanacak.

## Son Otomatik Doğrulama - Phase 2M

- `git diff --check`: PASS.
- `flutter analyze`: PASS, sorun yok.
- `flutter test --reporter expanded`: PASS, 34 test.
- Sekiz alışkanlık görevi/dört kategori tamamlama testi: PASS.
- Üç paket ve paket içi mikro etkinlik kalıcı ilerleme testi: PASS.
- Mevcut inactivity, kutlama ve kompakt yatay ekran regresyonları: PASS.

## Son Otomatik Doğrulama - Phase 2N

- `git diff --check`: PASS.
- `flutter analyze`: PASS.
- `flutter test`: PASS, 37 test.
- 10 boyama sayfası ve 10 çiz takip yolu widget testi: PASS.
- Balon bölüm tipi ve Sinek Avı kalıcı rozet regresyonları: PASS.

## Son Otomatik Doğrulama - Phase 2O

- `git diff --check`: PASS.
- `flutter analyze`: PASS.
- `flutter test`: PASS, 37 test.
- `flutter build web --release`: PASS.
- Metadata alan uzunlukları: Google Play başlık 22/30, kısa açıklama 58/80; App Store ad 22/30, subtitle 22/30, promotional text 66/170, keywords 75/100.
- Görsel boyut/kanal doğrulaması: PASS; tüm mağaza PNG'leri 8-bit RGB ve beklenen ölçülerde.
- Telefon ve iPad contact sheet görsel QA: PASS; taşma veya kırpılma bulunmadı.
- Canlı privacy/support URL: HTTP 200; ayrı `support.html` deployment'ı release checklist'te izleniyor.
