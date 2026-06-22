# RELEASE.md - Mağaza Yayın Durumu

> Son güncelleme: 2026-06-22

## Ürün

- Kanonik ürün adı: Ninnice Çocuk Oyunları.
- Kod sürümü: `1.0.0+1`.
- Son tamamlanan faz: Phase 2O - Store Listing, Compliance And Release Assets. Phase 2P aktif.
- Yayın kararı: `NO-GO PUBLIC`; cihaz matrisi, kapalı test/TestFlight ve saha gözlemi tamamlanmadı.

## Platform Durumu

| Platform | Durum | Kanıt / Eksik |
|---|---|---|
| Android | BUILD READY / TEST BLOCKED | İmzalı AAB üretildi, 23.7 MB, target SDK 35. Play Console erişimi, 2 telefon + 1 tablet ve 10-20 kapalı test katılımcısı bekliyor. |
| iOS | NO-CODESIGN BUILD READY / TEST BLOCKED | Deployment target 13.0; release build ve iPhone/iPad simulator smoke başarılı. İmzalı archive, TestFlight ve fiziksel cihaz QA bekliyor. |
| Web/PWA | BUILD PASS | Release build başarılı; gerçek cihaz Chrome/Safari QA gerekli. |

## Public Release Kapıları

- [x] Phase 2K platform/build engelleri tamamlandı.
- [x] Phase 2L ilerleme ve ebeveyn kontrolleri tamamlandı.
- [x] Phase 2M/2N içerik dengesi tamamlandı.
- [x] Phase 2O mağaza metadata ve görselleri tamamlandı.
- [x] Gizlilik ve çocuk hedef kitle beyan taslakları mevcut davranışla eşleşiyor.
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

- Android AAB: PASS, `build/app/outputs/bundle/release/app-release.aab`, 23.7 MB.
- AAB SHA-256: `e8fefc77aa54863d17ed2735bddcbba149cb41fa7e81c9a23875aa1bf7da2e0a`.
- iOS release no-codesign: PASS, `build/ios/iphoneos/Runner.app`, 26.7 MB.
- Otomatik test: 38 PASS; `flutter analyze`: PASS.
- Phase 2P kanıtı: `docs/qa/phase-2p-device-matrix.md`.

## Phase 2P Go/No-Go Kararı

Karar: `NO-GO PUBLIC`.

Bir P1 küçük iPhone dashboard overflow hatası doğrulandı ve regresyon testiyle kapatıldı. Ancak gerçek Android/iOS cihaz matrisi, fiziksel ses/titreşim ve offline/restart smoke, 10-20 kişilik Google Play kapalı test, imzalı TestFlight ve 2-5 çocuk/ebeveyn gözlemi henüz tamamlanmadı. Phase 2P aktif kalır; bu kapılar kanıtlanmadan Phase 3'e veya public yayına geçilmez.

## Mağaza Politikası Notu

- Google Play hedef kitle/Families ve Data Safety cevap taslakları `docs/store/google-play-compliance-draft.md` içinde hazırdır.
- App Store Kids Category, parental gate ve App Privacy cevap taslakları `docs/store/app-store-compliance-draft.md` içinde hazırdır.
- Release asset manifesti `docs/store/asset-manifest.md` içindedir.
- Kullanıcı hesabında nihai beyan gönderme ve public publish açık kullanıcı onayı ister.
