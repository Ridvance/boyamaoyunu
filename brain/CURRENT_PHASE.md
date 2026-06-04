# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-04

## Active Phase

Phase 2C-2F - İlk 4 Ürün İşi Tamamlandı

## Neden Bu Faz

Kullanıcının onayladığı ilk dört ürün işi tamamlandı: hikayeli boyama, renk karışımı doğrulaması, değer/alışkanlık mini görevleri ve okul öncesi öğrenme paketi.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PHASES.md`
4. `brain/PHASES.md`
5. `brain/UX_ARCHITECTURE.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
İlk dört ürün işi tamamlandı. Sıradaki güvenli adım test/playtest review veya kullanıcının yeni önceliğidir.
```

## Exit Criteria

- Phase 2C tamamlandı.
- Phase 2D tamamlandı.
- Phase 2E tamamlandı.
- Phase 2F tamamlandı.

## Test

```bash
flutter test
dart analyze lib/main.dart lib/games/coloring_game.dart lib/games/magic_colors_game.dart lib/games/habits_game.dart lib/games/learning_packs_game.dart test/widget_test.dart
git diff --check
```
