# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-22

## Active Phase

Phase 2N - Core Game Content Balance

## Durum

Active.

## Neden Bu Faz

Phase 2M ile en sığ paket alanları derinleştirildi. Boyama ve çiz takip içerik sayısı ilk sürüm hedefinin altında; Balon Patlatma bölümleri ağırlıkla hız farkına dayanıyor ve Sinek Avı hedef/geri bildirim/rozet döngüsünü net sunmuyor. Yeni ana oyun eklemeden çekirdek içerik dengelenmeli.

## Scope

- Boyama kitabını 10-12 farklı sayfaya çıkar.
- Çiz takibi en az 10 farklı şekil/yola çıkar.
- Balon Patlatma'ya hedef renk, süre/rahat mod ve özel balonla ayırt edilen bölüm varyasyonları ekle.
- Sinek Avı V2'ye hedef kartı, doğru/yanlış geri bildirim ve rozet döngüsü ekle.
- Yeni içerikleri birleşik ilerleme sistemiyle uyumlu tut.
- Mevcut 12 şekil eşleştirme içeriğini koru.

## Scope Dışı

- Yeni ana oyun.
- AI/fotoğraf veya sınırsız içerik üretimi.
- Rekabetçi skor tablosu veya karmaşık ekonomi.
- Ödeme/reklam.
- Mağaza görseli ve metadata; Phase 2O.

## Beklenen Dosya Etki Alanı

- `lib/games/coloring_game.dart`
- `lib/games/tracing_game.dart`
- `lib/games/balloon_pop_game.dart`
- `lib/games/magic_colors_game.dart`
- İlgili testler
- `brain/*`

## Exit Criteria

- Boyama kitabında 10-12 ayırt edilebilir sayfa vardır.
- Çiz takipte en az 10 farklı yol vardır.
- Balon bölümleri yalnız hız farkı değil hedef/süre/özel balon davranışı sunar.
- Sinek Avı hedefi görünür, yanlış seçim yumuşak geri bildirim verir ve tamamlanma rozeti kalıcı ilerlemeye yazılır.
- `flutter analyze`, `flutter test` ve `git diff --check` temiz geçer.

## Scope Locked Prompt

```text
Sadece çekirdek oyun içeriğini dengeli genişlet: boyamayı 10-12 sayfaya, çiz takibi en az 10 farklı yola çıkar; Balon Patlatma'ya hedef/süre/özel balon varyasyonları ekle; Sinek Avı V2 hedef kartı, geri bildirim ve rozet döngüsünü tamamla. Yeni ana oyun, AI/fotoğraf, rekabetçi skor, ekonomi veya sınırsız içerik sistemi ekleme.
```

## Test

```bash
flutter analyze
flutter test
git diff --check
```
