# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-05-22 00:18

## Active Phase

Phase-00A - Ürün Keşfi (Discovery)

## Neden Bu Faz

Hedef, pazar ve vizyon tespiti.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/CONTEXT_CAPSULE.md`
5. `brain/MISSION_CONTROL.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece ürün keşif dökümanlarını (VISION.md, PROJECT.md) oluştur. Kod değiştirme.
```

## Exit Criteria

- Vizyon dökümanı onaylandı.

## Test

```bash
git diff --check
```
