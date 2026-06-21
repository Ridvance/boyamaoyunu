# STATE.md - Güncel Durum

> Son güncelleme: 2026-06-21
> Rol: Yeni pencere açıldığında hızlı bağlam yükleme.

## Aktif Gerçeklik

Uygulama 8 ana girişli, reklamsız ve çevrimdışı okul öncesi mini oyun ürünüdür. 2026-06-21 denetiminde `flutter analyze` temiz, 28 test başarılı ve imzalı Android AAB üretimi başarılıdır. iOS release build, minimum iOS hedefi 12.0 iken `audioplayers_darwin` en az 13.0 istediği için blokelidir.

## Aktif Odak

- Mod / Rol: Execution Mode / Execution Engineer.
- Action State: READY.
- Aktif Faz: Phase 2K - Store Release Blockers And Platform Baseline.
- Öncelik: Yeni içerikten önce yayın engellerini ve veri tutarlılığı hatasını kapatmak.
- Scope kaynağı: `brain/CURRENT_PHASE.md`.

## Denetim Özeti

- Android AAB: başarılı, yaklaşık 23.5 MB, target SDK 35, min SDK 21.
- Android signing: upload keystore ile çalışıyor.
- iOS build: blokeli; deployment target 13.0 veya üstüne hizalanmalı.
- Bilinen bug: Balon Patlatma bölüm tamamlaması `tracing` ilerlemesine yazılıyor.
- İlerleme: `SharedPreferences` altyapısı var; oyunlar arasında kimlik ve görünür yolculuk tutarsız.
- İçerik: 7 boyama, 8 çiz takip, 12 eşleştirme şekli, 4 Renk Laboratuvarı modu, 3 alışkanlık görevi, 1 öğrenme paketi.
- Mağaza materyali: ekran görüntüsü, feature graphic, metadata paketi ve gerçek cihaz görsel QA eksik.
- Marka: `Çocuk Oyun`, `Ninnice Çocuk`, `Ninnice Çocuk Oyunları` adları hizalanmalı.
- Git: Planlama başlamadan önce yerel `master`, `origin/master` üzerinde kullanıcıya ait `3907fe7` commit'iyle 1 commit ilerideydi; bu commit korunmalıdır.

## Onaylı Sıra

1. Phase 2K - Store Release Blockers And Platform Baseline.
2. Phase 2L - Unified Progress Journey And Parent Controls.
3. Phase 2M - Habits And Learning Pack Depth.
4. Phase 2N - Core Game Content Balance.
5. Phase 2O - Store Listing, Compliance And Release Assets.
6. Phase 2P - Real Device QA And Closed Test Gate.

## Sıradaki Güvenli İş

`brain/CURRENT_PHASE.md` içindeki Phase 2K scope locked prompt'u uygula. Önce Balon ilerleme bug'ı ve testi; sonra iOS 13 platform hizalaması/build; ardından kanonik ürün adı ve release dokümanları.

## Son Doğrulama

```text
flutter analyze: PASS
flutter test: PASS (28)
flutter build appbundle --release: PASS
flutter build ios --release --no-codesign: FAIL (iOS 12 < audioplayers_darwin iOS 13)
flutter build web --release: PASS, CupertinoIcons font uyarısı mevcut
```
