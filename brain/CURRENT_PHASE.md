# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-22

## Active Phase

Phase 2P - Real Device QA And Closed Test Gate

## Durum

Active; external QA blocked.

## Neden Bu Faz

Phase 2O sonunda mağaza gönderim paketi hazırlandı. Public yayın kararı öncesinde ürünün gerçek cihaz matrisinde, kapalı testte ve çocuk/ebeveyn gözleminde kararlı ve anlaşılır olduğu kanıtlanmalı.

## Scope

- En az 2 Android telefon, 1 Android tablet, 1 iPhone ve mümkünse 1 iPad üzerinde kritik akışları doğrula.
- Küçük yatay ekran, ses/titreşim, offline açılış ve restart sonrası ilerlemeyi kontrol et.
- Ebeveyn kapısı ve dış link davranışını doğrula.
- 10-20 kişilik Google Play kapalı test sonucunu kaydet.
- 2-5 çocuk/ebeveyn gözlemini anonim olarak değerlendir.
- Final AAB/archive kanıtını ve gerekçeli Go/No-Go kararını yaz.

## Scope Dışı

- Test bulgusu olmadan yeni özellik genişletme.
- Herkese açık mağaza yayını.
- Analitik SDK veya yeni veri toplama ekleme.
- Kanıtlanmamış veya P2/P3 düzeyindeki bulgular için kapsamlı refactor.

## Beklenen Dosya Etki Alanı

- `brain/FIELD_RESEARCH.md`
- `brain/TESTING.md`
- `brain/RELEASE.md`
- Cihaz/kapalı test kanıt dosyaları
- Yalnız kanıtlanan P0/P1 bulgularının gerektirdiği dar fix dosyaları

## Exit Criteria

- Cihaz matrisi tamamdır.
- P0/P1 açık hata yoktur.
- Kapalı test ve çocuk/ebeveyn gözlemi değerlendirilmiştir.
- `brain/RELEASE.md` içinde GO veya gerekçeli NO-GO vardır.

## Scope Locked Prompt

```text
Sadece gerçek cihaz ve kapalı test yayın kapısını işlet: Android/iOS telefon-tablet matrisinde kritik akışları, offline/restart/ilerleme, ebeveyn kapısı, ses/titreşim ve küçük yatay ekranı doğrula; 10-20 kişilik Google Play kapalı test ve 2-5 çocuk/ebeveyn gözlemi sonuçlarını kaydet; yalnız kanıtlanan P0/P1 hatalara dar fix uygula; final Go/No-Go kararı yaz. Yeni özellik veya public publish yapma.
```

## Test

```bash
flutter analyze
flutter test
git diff --check
```

## Tamamlanma Kanıtı

- Google Play ve App Store metadata paketleri tamamlandı; alan uzunlukları platform sınırları içinde.
- Google Families/Data Safety ve Apple Kids Category/App Privacy cevap taslakları kod/SDK denetimine göre hazırlandı.
- Canlı gizlilik/destek URL'si HTTP 200 doğrulandı; ayrı destek sayfası deploy adayı olarak hazırlandı.
- Google Play 512 px ikon, 1024 × 500 feature graphic ve App Store 1024 px ikon hazırlandı.
- Gerçek Flutter release build'den 2688 × 1242 telefon ve 2732 × 2048 iPad için 7'şer yatay ekran görüntüsü üretildi ve görsel QA yapıldı.
- Release notes ve mağaza gönderim checklist'i hazırlandı.
- `flutter analyze`: PASS.
- `flutter test`: PASS, 37 test.
- `flutter build web --release`: PASS.
- `git diff --check`: PASS.
