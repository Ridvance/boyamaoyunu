# Phase 1C - Parent Safety Shell

## Amaç

İlk boyama SLC'de çocuk akışını güvenli tutmak ve ebeveyn alanını çocuk alanından ayırmak.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/UX_ARCHITECTURE.md`
- `brain/TESTING.md`

## Scope

- Çocuk akışında reklam, ödeme, dış link, hesap, kamera/galeri erişimi olmadığını korumak.
- Ebeveyn alanını çocuk ana ekranından ayrılmış bir kapıyla açmak.
- Ebeveyn alanında güvenlik durumunu sade göstermek.
- Widget testleri.

## Scope Dışı

- Gerçek ödeme, reklam, abonelik veya mağaza entegrasyonu.
- Dış link açma.
- Kamera, galeri, dosya veya çocuk verisi erişimi.
- Fotoğrafı çizime çeviren AI entegrasyonu.
- Mini oyun.

## Beklenen Dosya Etki Alanı

- `lib/main.dart`
- `test/widget_test.dart`
- `brain/STATE.md`
- `brain/CURRENT_PHASE.md`
- `brain/PHASES.md`
- `brain/HANDOFF.md`

## Çıkış Kriterleri

- Çocuk akışından ödeme/reklam/dış link yolu yok.
- Ebeveyn alanı çocuk akışından ayrılmış.
- `flutter test` başarılı.
- `flutter analyze` başarılı.
- `git diff --check` temiz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```
