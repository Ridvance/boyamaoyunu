# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-04

## Active Phase

Phase 2E - Values And Habits Mini Tasks

## Neden Bu Faz

Phase 2D renk karışımı mini oyunu mevcut Renk Laboratuvarı üzerinden doğrulandı ve testle kilitlendi. Sıradaki iş değer ve alışkanlık mini görevleri.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PHASES.md`
4. `brain/PROMPTS/phase-02E-values-and-habits-mini-tasks.md`
5. `brain/UX_ARCHITECTURE.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece 3 kısa değer/alışkanlık görevini prototip olarak ekle; metin ağırlıklı eğitim, karmaşık seviye veya ticari özellik ekleme.
```

## Exit Criteria

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
