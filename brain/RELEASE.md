# RELEASE.md - Mağaza Yayın Durumu

> Son güncelleme: 2026-06-21

## Ürün

- Çalışma adı: Ninnice Çocuk; Phase 2K içinde kanonik ad kesinleştirilecek.
- Kod sürümü: `1.0.0+1`.
- Aktif Faz: Phase 2K - Store Release Blockers And Platform Baseline.
- Yayın kararı: `NO-GO PUBLIC`, Android kapalı teste yakın.

## Platform Durumu

| Platform | Durum | Kanıt / Eksik |
|---|---|---|
| Android | READY FOR INTERNAL/CLOSED TEST AFTER 2K | İmzalı AAB üretildi, 23.5 MB, target SDK 35. Balon ilerleme bug'ı ve marka tutarlılığı kapatılmalı. |
| iOS | BLOCKED | Deployment target 12.0; `audioplayers_darwin` en az iOS 13 istiyor. Build ve signing/archive doğrulanmalı. |
| Web/PWA | BUILD PASS | Release build başarılı; gerçek cihaz Chrome/Safari QA gerekli. |

## Public Release Kapıları

- [ ] Phase 2K platform/build engelleri tamamlandı.
- [ ] Phase 2L ilerleme ve ebeveyn kontrolleri tamamlandı.
- [ ] Phase 2M/2N içerik dengesi tamamlandı.
- [ ] Phase 2O mağaza metadata ve görselleri tamamlandı.
- [ ] Gizlilik ve çocuk hedef kitle beyanları gerçek davranışla eşleşiyor.
- [ ] Android cihaz matrisi ve kapalı test tamamlandı.
- [ ] iPhone/iPad TestFlight smoke tamamlandı.
- [ ] P0/P1 açık hata yok.
- [ ] `GO` kararı yazıldı.

## Release Komutları

```bash
flutter analyze
flutter test --reporter expanded
flutter build appbundle --release
flutter build ios --release --no-codesign
git diff --check
```

## Son Build Kanıtı

- Android AAB: PASS, `build/app/outputs/bundle/release/app-release.aab`.
- AAB SHA-256: `78c913180f87a2018a64987438aa3f0ef7c341efffdcb5d1ebbe20769d478c3c`.
- iOS release: FAIL, minimum deployment target uyuşmazlığı.
- Otomatik test: 28 PASS.

## Mağaza Politikası Notu

- Google Play'de çocuk hedef kitlesi ve Families/Data Safety beyanları Phase 2O'da hazırlanır.
- App Store Kids Category yaş aralığı, parental gate ve App Privacy cevapları Phase 2O'da hazırlanır.
- Kullanıcı hesabında nihai beyan gönderme ve public publish açık kullanıcı onayı ister.
