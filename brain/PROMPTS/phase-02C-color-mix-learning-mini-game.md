# Phase 2C - Color Mix Learning Mini Game

## Amaç

Renk karışımıyla yeni renk oluşumunu öğreten, boyama akışına bağlı tek ekranlık eğitim mini oyunu eklemek.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/VALIDATION.md`
- `brain/UX_ARCHITECTURE.md`

## Scope

- Çocuk iki ana rengi seçer.
- Sistem oluşan ara rengi büyük ve görsel şekilde gösterir.
- Çocuk oluşan renkle doğru nesneyi boyar veya doğru nesneye dokunur.
- Doğru seçimde yıldız/rozet/kısa kutlama ile motivasyon verilir.
- İlk karışımlar: kırmızı+sarı=turuncu, mavi+sarı=yeşil, kırmızı+mavi=mor.

## Scope Dışı

- Karmaşık seviye sistemi.
- Reklam, ödeme, dış link veya hesap sistemi.
- Çok sayıda renk kombinasyonu.
- Ana boyama çekirdeğini bozacak büyük mimari değişiklik.

## Beklenen Dosya Etki Alanı

- `lib/main.dart`
- `test/widget_test.dart`
- Gerekirse `brain/STATE.md`

## Çıkış Kriterleri

- Mini oyun 4-5 yaş çocuğun anlayacağı kadar basit.
- Eğitim kazanımı görünür: çocuk karışım sonucunu görür.
- Oyun motivasyonu görünür: doğru karışımda kısa ödül/ilerleme vardır.
- Boyama SLC akışı bozulmaz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```
