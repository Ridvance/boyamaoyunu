# Phase 1B - Child Home And Coloring SLC

## Amaç

İlk dar SLC'yi oynanabilir yapmak: çocuk ana ekrandan bir boyama sayfası seçer, renk seçer, boyar, siler, temizler ve geri döner.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/UX_ARCHITECTURE.md`
- `brain/FIELD_RESEARCH.md`
- `brain/TESTING.md`

## Scope

- 3 hazır boyama sayfası.
- Çocuk ana ekranı.
- Basit çizim/boyama ekranı.
- Renk paleti.
- Silgi.
- Temizle.
- Geri dön.
- Widget testleri.

## Scope Dışı

- Mini oyun.
- Ödeme, reklam, abonelik veya mağaza entegrasyonu.
- Fotoğrafı çizime çeviren AI entegrasyonu.
- Kamera, galeri, dosya veya çocuk verisi erişimi.
- Karakter/ad nihai kararı.
- İçerik mağazası veya uzaktan içerik.

## Beklenen Dosya Etki Alanı

- `lib/main.dart`
- `test/widget_test.dart`
- `brain/STATE.md`
- `brain/CURRENT_PHASE.md`
- `brain/PHASES.md`
- `brain/HANDOFF.md`

## Çıkış Kriterleri

- Ana ekranda 3 boyama sayfası görünür.
- Sayfa seçimi çizim ekranına geçer.
- Renk, silgi, temizle ve geri dön çalışır.
- `flutter test` başarılı.
- `flutter analyze` başarılı.
- `git diff --check` temiz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```
