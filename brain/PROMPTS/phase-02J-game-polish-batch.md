# Phase 2J - Game Polish Batch

## Amaç

Kullanıcı gözlemine dayalı olarak mevcut oyunları daha uzun oynanır, daha anlaşılır ve mobil web'de daha kullanılabilir hale getirmek.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/PHASES.md`
- `brain/UX_ARCHITECTURE.md`

## Scope

- Şekil eşleştirmeye yeni şekiller, renkler ve bölüm ilerlemesi ekle.
- Fullscreen düğmesini web'de tekrar basınca çıkacak şekilde toggle yap.
- Çiz takipte erken başarıyı engelle ve daha fazla takip şekli ekle.
- Balon patlatmaya bölüm, hedef ve görünür skor ekle.
- Boyama kitabına yeni sayfalar ekle; tamamlanma göstergesini tuvali kapatmayacak şekilde konumlandır ve sayfa değişiminde güncel tut.

## Scope Dışı

- Yeni ana oyun modu.
- Reklam, ödeme, abonelik veya profil ekonomisi.
- Fotoğraf/AI üretim akışı.
- Büyük navigasyon refactor.

## Beklenen Dosya Etki Alanı

- `lib/games/shape_sorter_game.dart`
- `lib/games/tracing_game.dart`
- `lib/games/balloon_pop_game.dart`
- `lib/games/coloring_game.dart`
- `lib/main.dart`
- `lib/services/fullscreen_controller*.dart`
- `test/widget_test.dart`
- Gerekirse `brain/*`

## Çıkış Kriterleri

- Şekil eşleştirme, çiz takip, balon patlatma ve boyama kitabı daha fazla bölüm/içerik sunar.
- Çiz takip tamamlanmadan başarı sesi çıkmaz.
- Balon patlatmada skor ve bölüm hedefi görünür.
- Boyama tamamlanma göstergesi çizimi engellemez ve sayfa değişiminde sıfırlanır/güncellenir.
- Fullscreen düğmesi tekrar basıldığında fullscreen'den çıkar.

## Test

```bash
flutter test
dart analyze lib/games/shape_sorter_game.dart lib/games/tracing_game.dart lib/games/balloon_pop_game.dart lib/games/coloring_game.dart lib/main.dart lib/services/fullscreen_controller.dart lib/services/fullscreen_controller_stub.dart lib/services/fullscreen_controller_web.dart test/widget_test.dart
git diff --check
```

## Scope Locked Prompt

```text
Sadece mevcut oyunlardaki bölüm/skor/içerik ve mobil fullscreen kullanılabilirliği düzeltmelerini yap; yeni ana oyun, ödeme, reklam, dış sistem veya büyük refactor ekleme.
```
