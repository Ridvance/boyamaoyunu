# Phase 2E - Values And Habits Mini Tasks

## Amaç

Günlük yaşam değerlerini ve alışkanlıklarını 4-5 yaş çocuğa uygun kısa etkileşim görevleriyle denemek.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/VALIDATION.md`
- `brain/UX_ARCHITECTURE.md`
- `brain/PHASES.md`

## Scope

- 3 mikro görev prototipi oluştur.
- Aday görevler: oyuncakları yerine koy, dişleri fırçala, çöpü kutuya at.
- Her görev tek ana eylemle anlaşılır olmalı.
- Doğru eylemde kısa görsel veya sesli geri bildirim ver.
- Görevleri ana çocuk akışından kolay seçilebilir yap.

## Scope Dışı

- Metin ağırlıklı öğüt ekranları.
- Puan ekonomisi.
- Ceza sistemi.
- Uzun görev zinciri.
- Okul/öğretmen paneli.
- Ticari özellik.

## Beklenen Dosya Etki Alanı

- `lib/main.dart`
- `lib/games/*`
- `test/widget_test.dart`
- Gerekirse `brain/STATE.md`

## Çıkış Kriterleri

- En az 3 görev oynanabilir.
- Çocuk görev hedefini görsel olarak anlayabilir.
- Her görev 30-60 saniyede tamamlanabilir.
- Ana akış karışmaz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```

## Scope Locked Prompt

```text
Sadece 3 kısa değer/alışkanlık görevini prototip olarak ekle; metin ağırlıklı eğitim, karmaşık seviye veya ticari özellik ekleme.
```
