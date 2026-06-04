# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-04

## Active Phase

Phase 2F - Preschool Learning Packs

## Neden Bu Faz

Phase 2E değer ve alışkanlık mini görevleri tamamlandı. Sıradaki iş okul öncesi kazanım paketleri için içerik yapısı ve 1 örnek paket oluşturmak.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PHASES.md`
4. `brain/PROMPTS/phase-02F-preschool-learning-packs.md`
5. `brain/UX_ARCHITECTURE.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece okul öncesi kazanım paketleri için içerik yapısı ve 1 örnek paket oluştur; ödeme, resmi müfredat iddiası veya geniş katalog ekleme.
```

## Exit Criteria

- En az 1 paket uçtan uca seçilip oynanır.
- İçerikler yeni paket eklenebilecek şekilde ayrışır.
- Doğrulama olmadan resmi eğitim iddiası yazılmaz.
- Mevcut oyunlar paket yapısı içinde kaybolmaz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```
