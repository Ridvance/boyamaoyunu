# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-05-19

## Active Phase

Phase 1B - Child Home And Coloring SLC

## Neden Bu Faz

Flutter proje iskeleti kuruldu ve default sayaç demosu kaldırıldı. Bu fazın amacı ilk SLC'nin çekirdeğini çalışır hale getirmek: çocuk ana ekrandan güvenli bir boyama sayfası seçer, renk seçer, boyar, siler, temizler ve geri döner. Mini oyun, ödeme, reklam, fotoğraf AI ve karakter/ad kesin kararı bu fazın dışındadır.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/PHASES.md`
5. `brain/TESTING.md`
6. `brain/UX_ARCHITECTURE.md`
7. `brain/FIELD_RESEARCH.md`
8. `brain/PROMPTS/phase-01B-child-home-and-coloring-slc.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece ilk boyama SLC çekirdeğini yap. Çocuk ana ekranında 3 güvenli boyama sayfası göster; çocuk bir sayfa seçip renk paletiyle boyayabilsin, silgi, temizle ve geri dön aksiyonları çalışsın. Basit local state kullan; veri saklama, reklam, ödeme, mini oyun, fotoğraf AI, kamera/galeri erişimi ve dış link ekleme. Karakter/ad kesinleştirme yapma; saha doğrulama adaylarını geçici tema olarak kullan. Kod değişirse `flutter test` ve `flutter analyze` çalıştır, `git diff --check` temiz olsun.
```

## Çıkış Kriterleri

- 3 boyama sayfası ana ekranda görünür.
- Çocuk bir sayfa seçip çizim ekranına geçer.
- Renk seçimi, silgi, temizle ve geri dön çalışır.
- `flutter test` başarılı.
- `flutter analyze` başarılı.
- `git diff --check` temiz.

## Test

```bash
git diff --check
```

## Sonraki Faz

Phase 1C - Parent Safety Shell
