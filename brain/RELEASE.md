# RELEASE.md - Mağaza Yayın Durumu

> Son güncelleme: 2026-06-21

## Ürün

- Kanonik ürün adı: Ninnice Çocuk Oyunları.
- Kod sürümü: `1.0.0+1`.
- Aktif Faz: Phase 2L - Unified Progress Journey And Parent Controls.
- Yayın kararı: `NO-GO PUBLIC`, Android kapalı teste yakın.

## Platform Durumu

| Platform | Durum | Kanıt / Eksik |
|---|---|---|
| Android | BUILD READY | İmzalı AAB üretildi, 23.5 MB, target SDK 35. Kapalı test ve cihaz QA bekliyor. |
| iOS | NO-CODESIGN BUILD READY | Deployment target 13.0; CocoaPods ve release build başarılı. İmzalı archive/TestFlight ve cihaz QA bekliyor. |
| Web/PWA | BUILD PASS | Release build başarılı; gerçek cihaz Chrome/Safari QA gerekli. |

## Public Release Kapıları

- [x] Phase 2K platform/build engelleri tamamlandı.
- [x] Phase 2L ilerleme ve ebeveyn kontrolleri tamamlandı.
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
- AAB SHA-256: `e44e45c921f6c002e37508adc959c09080ecb0671f01b12414f4c9cc1f0d84db`.
- iOS release no-codesign: PASS, `build/ios/iphoneos/Runner.app`, 26.5 MB.
- Otomatik test: 33 PASS; `flutter analyze`: PASS.

## Mağaza Politikası Notu

- Google Play'de çocuk hedef kitlesi ve Families/Data Safety beyanları Phase 2O'da hazırlanır.
- App Store Kids Category yaş aralığı, parental gate ve App Privacy cevapları Phase 2O'da hazırlanır.
- Kullanıcı hesabında nihai beyan gönderme ve public publish açık kullanıcı onayı ister.
