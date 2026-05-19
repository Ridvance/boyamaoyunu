# Phase 0C - Character And Name Field Validation

## Amaç

4-5 yaş çocuklar için ilk boyama SLC'sinde kullanılacak karakter, isim ve görsel dünya kararını AI tahminine bırakmadan saha doğrulamasına hazır hale getirmek.

## Oku

- `brain/STATE.md`
- `brain/RULES.md`
- `brain/CURRENT_PHASE.md`
- `brain/FIELD_RESEARCH.md`
- `brain/VALIDATION.md`
- `brain/UX_ARCHITECTURE.md`

## Scope

- 4-5 karakter veya tema yönü.
- Her karakter/tema yönü için 4-5 kısa isim adayı.
- Çocuk gözlem formu.
- Ebeveyn güven ve rahatsız edicilik kontrol soruları.
- Karar kriteri: en az 3 çocuk veya ebeveyn/çocuk gözlemi olmadan ana karakter/ad kesinleşmez.

## Scope Dışı

- Kod yazmak.
- Flutter projesi başlatmak.
- Mini oyun eklemek.
- Ödeme, reklam, abonelik veya mağaza entegrasyonu.
- Fotoğrafı çizime çeviren AI entegrasyonu.
- Karakter veya uygulama adını sadece AI önerisiyle kesinleştirmek.

## Beklenen Dosya Etki Alanı

- `brain/FIELD_RESEARCH.md`
- `brain/STATE.md`
- `brain/HANDOFF.md`
- Gerekirse `brain/DECISIONS.md`

## Çıkış Kriterleri

- Saha testinde gösterilecek 4-5 karakter/tema yönü yazılmış.
- Her yön için isim adayları yazılmış.
- Gözlem formu kullanılabilir hale gelmiş.
- Kullanıcıdan gerçek saha testi veya sonraki faza geçiş kararı alınmış.

## Test

```bash
git diff --check
```
