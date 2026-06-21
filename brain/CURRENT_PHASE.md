# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-21

## Active Phase

Phase 2L - Unified Progress Journey And Parent Controls

## Durum

Active.

## Neden Bu Faz

Phase 2K yayın engelleri kapandı. Mevcut `SharedPreferences` ilerleme altyapısı oyunlar arasında tutarlı kimlik, yıldız, çocuk yolculuğu ve ebeveyn kontrolü sunmuyor. Mağaza kapalı testinden önce ilerleme davranışı birleştirilmeli ve ebeveyn tarafından yönetilebilir olmalı.

## Scope

- Her oyun için benzersiz chapter/level kimlikleri kullan.
- Tamamlanan bölüm ve yıldızları restart sonrası koru.
- Çocuk ana ekranında sade görsel ilerleme göster.
- Ebeveyn alanına ilerleme özeti ekle.
- Ebeveyn kapısı arkasında bilinçli/onaylı ilerleme sıfırlama ekle.
- Kalıcı ses ve titreşim kontrolleri ekle.

## Scope Dışı

- Hesap veya bulut senkronizasyonu.
- Analitik ve liderlik tablosu.
- Ceza/puan ekonomisi veya satın alma.
- Yeni oyun, level veya içerik genişletme.
- Büyük navigasyon ya da görsel yeniden tasarım.

## Beklenen Dosya Etki Alanı

- `lib/services/progress_service.dart`
- Ses/titreşim tercih servisi
- `lib/main.dart`
- Mevcut oyun tamamlama noktaları
- `test/progress_service_test.dart`
- `test/widget_test.dart`
- `brain/*`

## Exit Criteria

- Tüm oyunlar doğru ve çakışmayan ilerleme anahtarları kullanır.
- Tamamlanma ve yıldızlar uygulama yeniden başlatıldığında korunur.
- Çocuk ana ekranında sade ilerleme görünür.
- Ebeveyn ilerleme özetini görür ve onay sonrası sıfırlayabilir.
- Ses/titreşim tercihleri kalıcıdır.
- `flutter analyze`, `flutter test` ve `git diff --check` temiz geçer.

## Scope Locked Prompt

```text
Sadece yerel ve birleşik ilerleme sistemini uygula: tüm oyunlara benzersiz chapter/level kimliği ver, tamamlanma ve yıldızları restart sonrası koru, çocuk ana ekranında sade görsel ilerleme göster, ebeveyn alanına ilerleme özeti, onaylı sıfırlama ve ses/titreşim kontrolleri ekle. Hesap, bulut, analitik, liderlik tablosu, ödeme veya içerik genişletme ekleme.
```

## Test

```bash
flutter analyze
flutter test
git diff --check
```
