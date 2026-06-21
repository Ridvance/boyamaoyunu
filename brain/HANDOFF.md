# HANDOFF.md - Devir Teslim

> Son güncelleme: 2026-06-21

## Son Durum

- Son mod: Planning / Handoff.
- Son yapılan: Genel mağaza hazırlık denetimi tamamlandı ve öneriler Phase 2K-2P olarak planlandı.
- Aktif faz: Phase 2K - Store Release Blockers And Platform Baseline.
- Action State: READY.
- Kod değişikliği: Bu planlama işinde uygulama kodu değiştirilmedi.

## Kanıt

- `flutter analyze`: PASS.
- `flutter test --reporter expanded`: 28 PASS.
- Android imzalı AAB: PASS, 23.5 MB, target SDK 35.
- iOS release build: FAIL; iOS 12 hedefi, `audioplayers_darwin` iOS 13 ister.
- Web release build: PASS; CupertinoIcons font uyarısı var.
- Bilinen ürün bug'ı: `balloon_pop_game.dart` Balon tamamlamasını `tracing` chapter'ına yazıyor.
- Görsel audit: Uygulama içi tarayıcı bu oturumda kullanılamadığı için ekran görüntülü QA yapılmadı.

## Sıradaki İş

Phase 2K'yı sırayla uygula:

1. Balon ilerleme anahtarını düzelt ve regresyon testi yaz.
2. iOS minimum target'ı 13.0 veya bağımlılığın istediği güvenli seviyeye hizala.
3. `pod install` ve iOS no-codesign release build doğrula.
4. Android AAB regresyon build'i al.
5. Kanonik ürün adını yüzeylerde hizala.
6. Test, commit ve push yap; Phase 2K tamamlanmadan Phase 2L'ye geçme.

## Git Uyarısı

Planlama başlamadan önce yerel `master`, `origin/master` üzerinde kullanıcıya ait `3907fe7` commit'iyle 1 commit ilerideydi. Bu commit korunmalı; reset/revert yapılmamalı. Planlama commit'i push edildiğinde bu commit de normal sıra içinde origin'e gidebilir.

## Yeni Pencere Devam Promptu

```text
Repo: /Users/ridvan/Documents/Çocuk Oyun

Brain yapısına göre devam et. Önce şu dosyaları sırayla oku:
1. brain/STATE.md
2. brain/RULES.md
3. brain/CURRENT_PHASE.md
4. brain/STORE_READINESS_PLAN.md
5. brain/PHASES.md
6. brain/TESTING.md
7. brain/RELEASE.md
8. brain/HANDOFF.md

Aktif faz: Phase 2K - Store Release Blockers And Platform Baseline.

Sadece CURRENT_PHASE içindeki scope locked prompt'u uygula. Önce git durumunu kontrol et; kullanıcıya ait mevcut değişiklikleri/commitleri koru. Balon Patlatma ilerlemesinin yanlışlıkla `tracing` chapter'ına yazılması için fix ve regresyon testi yap. Sonra iOS minimum deployment target'ı `audioplayers_darwin` ile uyumlu hale getir ve hem Android AAB hem iOS no-codesign release build'i doğrula. Kanonik ürün adını Android, iOS, Flutter ve gizlilik yüzeylerinde hizala. Yeni level, yeni oyun, ilerleme ekranı, mağaza görseli, ödeme/reklam veya büyük refactor ekleme.

Bilinen baseline:
- flutter analyze: PASS
- flutter test: 28 PASS
- Android AAB: PASS, 23.5 MB, target SDK 35
- iOS build: FAIL; iOS 12 < audioplayers_darwin iOS 13
- Yerel master planlama öncesi origin/master'dan `3907fe7` ile 1 commit ilerideydi; bunu koru.

İş sonunda:
- flutter analyze
- flutter test
- flutter build appbundle --release
- flutter build ios --release --no-codesign
- git diff --check
- brain/STATE.md, brain/RELEASE.md ve gerekirse CURRENT_PHASE.md güncelle
- commit ve push yap

Phase 2K tamamlanmadan Phase 2L'ye geçme.
```
