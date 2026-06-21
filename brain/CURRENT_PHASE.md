# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-21

## Active Phase

Phase 2K - Store Release Blockers And Platform Baseline

## Durum

Completed. Phase 2L aktif edilmedi.

## Neden Bu Faz

2026-06-21 mağaza hazırlık denetiminde Android AAB üretimi başarılı oldu; ancak iOS release build, projenin iOS 12 hedefi ile `audioplayers_darwin` paketinin iOS 13 gereksinimi çakıştığı için başarısız oldu. Ayrıca Balon Patlatma ilerlemesi yanlışlıkla `tracing` chapter'ına yazılıyor, ürün adı yüzeyler arasında tutarsız ve release belgeleri eski durumda. Yeni içerikten önce bu yayın engelleri kapatılmalı.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/STORE_READINESS_PLAN.md`
4. `brain/PHASES.md`
5. `brain/TESTING.md`
6. `brain/RELEASE.md`

## Scope

- Balon Patlatma ilerleme chapter anahtarını düzelt ve regresyon testi ekle.
- iOS minimum deployment target'ı en az 13.0 olarak tüm proje yüzeylerinde hizala.
- CocoaPods bağımlılık çözümünü ve iOS release build'i doğrula.
- Kanonik ürün adını belirleyip mevcut Android, iOS, Flutter ve gizlilik yüzeylerinde tutarlı hale getir.
- Release ve test belgelerini güncel build gerçekliğiyle hizala.

## Scope Dışı

- Yeni level veya oyun içeriği.
- İlerleme ekranı ve ebeveyn ayarları; Phase 2L.
- Alışkanlık/paket genişletme; Phase 2M.
- Çekirdek oyun içerik genişletme; Phase 2N.
- Mağaza görselleri ve metadata; Phase 2O.
- Mağazaya nihai gönderim; Phase 2P sonrasına kadar yapılmaz.

## Beklenen Dosya Etki Alanı

- `lib/games/balloon_pop_game.dart`
- İlgili test dosyaları
- `ios/Podfile`
- `ios/Runner.xcodeproj/project.pbxproj`
- Ürün adı geçen Android/iOS/Flutter/web dosyaları
- `brain/RELEASE.md`
- `brain/TESTING.md`
- `brain/STATE.md`

## Exit Criteria

- Balon bölümü tamamlanınca `balloon` ilerlemesi kaydedilir; `tracing` değişmez.
- `flutter analyze` ve `flutter test` temiz geçer.
- `flutter build appbundle --release` başarıyla tamamlanır.
- `flutter build ios --release --no-codesign` başarıyla tamamlanır.
- Ürün adı mağaza ve uygulama yüzeylerinde tutarlıdır.
- `git diff --check` temizdir.

## Scope Locked Prompt

```text
Sadece Phase 2K mağaza yayın engellerini kapat: Balon Patlatma ilerleme anahtarını düzelt, iOS minimum hedefini bağımlılıklarla uyumlu hale getir, Android/iOS release buildlerini doğrula, ürün adını ve release belgelerini hizala. Yeni level, oyun modu, ilerleme ekranı, mağaza görseli, ödeme veya büyük refactor ekleme.
```

## Test

```bash
flutter analyze
flutter test
flutter build appbundle --release
flutter build ios --release --no-codesign
git diff --check
```

## Tamamlanma Kanıtı

- Balon ilerlemesi `balloon` chapter'ına yazılıyor; `tracing` değişmiyor.
- iOS minimum deployment target 13.0 ve CocoaPods çözümü başarılı.
- `flutter analyze`: PASS.
- `flutter test`: PASS, 29 test.
- Android AAB: PASS, 23.5 MB.
- iOS no-codesign release: PASS, 26.5 MB.
- Kanonik ad: `Ninnice Çocuk Oyunları`.
