# Phase 2A - Child Playtest Feedback Loop

## Amaç

İlk oynanabilir boyama SLC'yi gerçek cihazda çocuk/ebeveyn gözlemiyle denemek ve hızlı düzeltme listesini çıkarmak.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/FIELD_RESEARCH.md`
- `brain/TESTING.md`

## Scope

- Güncel uygulama akışına göre playtest gözlem formu.
- 2-5 çocuk veya ebeveyn/çocuk gözlemi için not şablonu.
- Başarı ve başarısızlık sinyalleri.
- Hızlı düzeltme listesi formatı.

## Scope Dışı

- Kod değişikliği.
- Yeni özellik.
- Mini oyun.
- Ödeme, reklam, abonelik veya mağaza entegrasyonu.
- Fotoğrafı çizime çeviren AI entegrasyonu.

## Beklenen Dosya Etki Alanı

- `brain/FIELD_RESEARCH.md`
- `brain/STATE.md`
- `brain/HANDOFF.md`

## Çıkış Kriterleri

- Playtest formu güncel app akışını ölçer.
- Kullanıcıdan APK/gerçek cihaz testi kararı alınır.
- `git diff --check` temiz.

## Test

```bash
git diff --check
```
