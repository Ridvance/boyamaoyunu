# STATE.md - Güncel Durum

> Son güncelleme: 2026-06-22
> Rol: Yeni pencere açıldığında hızlı bağlam yükleme.

## Aktif Gerçeklik

Uygulama 8 ana girişli, reklamsız ve çevrimdışı okul öncesi mini oyun ürünüdür. Phase 2N sonunda çekirdek oyun içerikleri dengelenmiştir; `flutter analyze` temiz ve 37 test başarılıdır.

## Aktif Odak

- Mod / Rol: Execution Mode / Execution Engineer.
- Action State: COMPLETE.
- Aktif Faz: Phase 2N - Core Game Content Balance.
- Faz durumu: Tamamlandı; Phase 2O aktif edilmedi.
- Scope kaynağı: `brain/CURRENT_PHASE.md`.

## Denetim Özeti

- Android AAB: başarılı, yaklaşık 23.5 MB, target SDK 35, min SDK 21.
- Android signing: upload keystore ile çalışıyor.
- iOS minimum hedefi Podfile ve Xcode yapılandırmalarında 13.0; no-codesign release build başarılı.
- Balon Patlatma bölüm tamamlaması `balloon` ilerlemesine yazılıyor; `tracing` kaydının değişmediği regresyon testiyle doğrulandı.
- İlerleme: Sekiz benzersiz chapter, kalıcı tamamlanma/yıldız, çocuk kart rozetleri ve ebeveyn özeti mevcut.
- Ebeveyn kontrolleri: İkinci onaylı ilerleme sıfırlama ile kalıcı ses/titreşim tercihleri mevcut.
- İçerik: 10 boyama, 10 çiz takip, 12 eşleştirme şekli, üç ayırt edilebilir balon bölüm tipi, 5 kalıcı Sinek Avı rozeti, 4 Renk Laboratuvarı modu, 8 alışkanlık görevi, 3 öğrenme paketi ve 10 paket etkinliği.
- Mağaza materyali: ekran görüntüsü, feature graphic, metadata paketi ve gerçek cihaz görsel QA eksik.
- Kanonik marka: `Ninnice Çocuk Oyunları`; Android, iOS, Flutter, web ve gizlilik yüzeyleri hizalı.
- Git: Planlama başlamadan önce yerel `master`, `origin/master` üzerinde kullanıcıya ait `3907fe7` commit'iyle 1 commit ilerideydi; bu commit korunmalıdır.

## Onaylı Sıra

1. Phase 2K - Store Release Blockers And Platform Baseline.
2. Phase 2L - Unified Progress Journey And Parent Controls.
3. Phase 2M - Habits And Learning Pack Depth.
4. Phase 2N - Core Game Content Balance.
5. Phase 2O - Store Listing, Compliance And Release Assets.
6. Phase 2P - Real Device QA And Closed Test Gate.

## Sıradaki Güvenli İş

Phase 2N tamamlandı. Kullanıcı onayı olmadan Phase 2O'yu aktif etme.

## Son Doğrulama

```text
flutter analyze: PASS
flutter test: PASS (37)
flutter build appbundle --release: PASS (23.5 MB)
flutter build ios --release --no-codesign: PASS (Runner.app 26.5 MB)
git diff --check: PASS
```
