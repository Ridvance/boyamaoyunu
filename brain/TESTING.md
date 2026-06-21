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
