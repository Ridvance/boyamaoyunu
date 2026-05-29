# RELEASE.md - Release Notları

> Son güncelleme: 2026-05-22 00:18
> Rol: Bu projenin Brain OS ürünleştirme ve güvenlik çıkış durumunu özetler.

## Ürün

- Ad: Çocuk Oyun
- Versiyon: 0.1.0
- Aktif Faz: Phase-00A - Ürün Keşfi (Discovery)
- Aktif Rol: Handoff Coordinator

## Phase-07 Scope

- template installer
- migration checks
- audit log
- commit/push automation policy
- release docs

## Release Öncesi Kontrol

```bash
python3 -m py_compile brain.py
python3 brain.py --project /Users/ridvan/Documents/Çocuk Oyun status
python3 brain.py --project /Users/ridvan/Documents/Çocuk Oyun audit --strict
git diff --check
```

## Kapsam Dışı

- Marketplace yayınlama
