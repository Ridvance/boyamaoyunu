# Phase 1A - Flutter Scaffold Decision And Setup

## Amaç

Mobil hedef için Flutter proje iskeletini kurmak ve bir sonraki fazdaki boyama SLC geliştirmesine hazır, çalışır bir app shell bırakmak.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/PHASES.md`
- `brain/TESTING.md`
- `brain/UX_ARCHITECTURE.md`

## Scope

- Flutter proje scaffold.
- Proje adı ve paket/org kararı.
- Default sayaç demosunu kaldıran basit app shell.
- Temel testin güncellenmesi.

## Scope Dışı

- Boyama motoru.
- Renk paleti, silgi, temizle veya çizim davranışı.
- Mini oyun.
- Ödeme, reklam, abonelik veya mağaza entegrasyonu.
- Fotoğrafı çizime çeviren AI entegrasyonu.
- Çocuk verisi veya cihaz galeri/kamera erişimi.

## Beklenen Dosya Etki Alanı

- Flutter scaffold dosyaları.
- `lib/main.dart`
- `test/widget_test.dart`
- `brain/STATE.md`
- `brain/CURRENT_PHASE.md`
- `brain/PHASES.md`
- `brain/HANDOFF.md`

## Çıkış Kriterleri

- Flutter app test edilebilir durumda.
- Default counter demo yok.
- `flutter test` başarılı.
- `git diff --check` temiz.

## Test

```bash
flutter test
git diff --check
```
