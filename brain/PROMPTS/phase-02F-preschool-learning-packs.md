# Phase 2F - Preschool Learning Packs

## Amaç

Hikaye, renk karışımı ve mini görevleri okul öncesi kazanım başlıklarına göre paketlenebilir hale getirmek.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/VALIDATION.md`
- `brain/UX_ARCHITECTURE.md`
- `brain/PHASES.md`

## Scope

- Renkler, şekiller, eşleştirme/sıralama ve günlük alışkanlıklar için içerik taksonomisi oluştur.
- Paket seçimi ekranı tasarla veya uygula.
- 1 örnek paket oluştur.
- İçerik yapısını ileride yeni paket eklemeye uygun tut.
- Resmi eğitim iddiaları için doğrulama notunu ayrı tut.

## Scope Dışı

- Resmi müfredat uyumu iddiası.
- Öğretmen paneli.
- Ödeme sistemi.
- Geniş içerik kataloğu.
- Canlı içerik indirme.

## Beklenen Dosya Etki Alanı

- `lib/main.dart`
- İçerik model dosyaları
- `test/widget_test.dart`
- `brain/VALIDATION.md`
- Gerekirse `brain/STATE.md`

## Çıkış Kriterleri

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

## Scope Locked Prompt

```text
Sadece okul öncesi kazanım paketleri için içerik yapısı ve 1 örnek paket oluştur; ödeme, resmi müfredat iddiası veya geniş katalog ekleme.
```
