# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-21

## Active Phase

Phase 2M - Habits And Learning Pack Depth

## Durum

Active.

## Neden Bu Faz

Phase 2L ile ilerleme ve ebeveyn kontrolleri tamamlandı. İyi Alışkanlıklar yalnız 3 görev, Öğrenme Paketleri yalnız 1 paket sunduğu için ilk sürümde tekrar oynanabilirlik ve paket farklılığı yetersiz. Yeni ana oyun eklemeden bu iki alan derinleştirilmeli.

## Scope

- İyi Alışkanlıklar görevlerini 6-8 görsel mikro göreve çıkar.
- Görevleri temizlik, düzen, öz bakım ve yardım başlıklarına dağıt.
- Öğrenme Paketlerini en az 3 ayırt edilebilir pakete çıkar.
- Her pakette 3-4 etkinlik ve farklı kazanım/etkinlik sırası sun.
- Paketlerin yalnız mevcut oyun kartlarına tekrar yönlendirme hissini azalt.

## Scope Dışı

- Resmî müfredat uyumu iddiası.
- Öğretmen paneli veya canlı içerik indirme.
- Metin ağırlıklı dersler.
- Yeni ana oyun, ödeme veya reklam.
- Phase 2N çekirdek oyun içerik dengesi.

## Beklenen Dosya Etki Alanı

- `lib/games/habits_game.dart`
- `lib/games/learning_packs_game.dart`
- İlgili widget testleri
- `brain/*`

## Exit Criteria

- En az 6 alışkanlık görevi oynanır.
- Görevler dört davranış başlığına dağılır.
- En az 3 farklı öğrenme paketi vardır.
- Her pakette 3-4 etkinlik vardır ve paket sıraları/kazanımları farklıdır.
- Paket içi ilerleme görünürdür.
- `flutter analyze`, `flutter test` ve `git diff --check` temiz geçer.

## Scope Locked Prompt

```text
Sadece İyi Alışkanlıklar ve Öğrenme Paketleri derinliğini artır: alışkanlıkları 6-8 görsel mikro göreve, öğrenme alanını en az 3 ayırt edilebilir ve her biri 3-4 etkinlikli pakete çıkar. Resmî müfredat iddiası, öğretmen paneli, canlı içerik, yeni ana oyun, ödeme veya metin ağırlıklı ders ekleme.
```

## Test

```bash
flutter analyze
flutter test
git diff --check
```
