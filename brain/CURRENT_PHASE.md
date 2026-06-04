# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-04

## Active Phase

Phase 2D - Color Mix Learning Mini Game

## Neden Bu Faz

Phase 2C hikayeli boyama akışı tamamlandı. Sıradaki iş renk karışımı mini oyununu Phase 2D kapsamına göre doğrulamak ve gerekirse tamamlamak.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PHASES.md`
4. `brain/PROMPTS/phase-02D-color-mix-learning-mini-game.md`
5. `brain/UX_ARCHITECTURE.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece renk karışımı mini oyununu tek ekranlık eğitim/heyecan döngüsü olarak ekle; boyama çekirdeğini bozma; ödeme, dış sistem veya fotoğraf AI ekleme.
```

## Exit Criteria

- Mini oyun 4-5 yaş çocuğun anlayacağı kadar basit.
- Eğitim kazanımı görünür: çocuk karışım sonucunu görür.
- Oyun motivasyonu görünür: doğru karışımda kısa ödül/ilerleme ve heyecan döngüsü vardır.
- Boyama SLC akışı bozulmaz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```
