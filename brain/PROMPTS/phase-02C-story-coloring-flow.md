# Phase 2C - Story Coloring Flow

## Amaç

Mevcut boyama ekranını tekil aktiviteden çıkarıp kısa, yazısız ve görsel görev hissi veren hikayeli akışa dönüştürmek.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/VALIDATION.md`
- `brain/UX_ARCHITECTURE.md`
- `brain/PHASES.md`

## Scope

- 1 küçük hikaye teması seç.
- 3 görev adımı oluştur.
- Yazısız veya minimum metinli ikon/görsel yönlendirme kullan.
- Görev tamamlanınca kısa görsel kutlama göster.
- Mevcut boyama sayfaları ve ana akışla uyumlu kal.

## Scope Dışı

- Uzun hikaye metinleri.
- Diyalog sistemi.
- Karmaşık seviye haritası.
- Yeni ticari model.
- Büyük karakter evreni.
- Ana boyama çekirdeğini bozacak büyük refactor.

## Beklenen Dosya Etki Alanı

- `lib/main.dart`
- İlgili `lib/games/*` dosyaları
- `test/widget_test.dart`
- Gerekirse `brain/STATE.md`

## Çıkış Kriterleri

- Çocuk ne yapacağını metin okumadan anlayabilir.
- 3 adımlık hikaye akışı tamamlanır.
- Görev tamamlanma hissi kısa ve net görünür.
- Mevcut boyama SLC akışı bozulmaz.

## Test

```bash
flutter test
flutter analyze
git diff --check
```

## Scope Locked Prompt

```text
Sadece mevcut boyama deneyimine 1 kısa hikayeli görev akışı ekle; yeni mini oyun, ödeme, dış sistem veya büyük refactor ekleme.
```
