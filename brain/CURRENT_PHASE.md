# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-05-19

## Active Phase

Phase 0C - Character And Name Field Validation

## Neden Bu Faz

Phase 0B sonunda kullanıcı ilk SLC'nin sadece boyama çekirdeği olmasını, mini oyunun sonraki fazlara bırakılmasını onayladı. Projede kod yok. İlk oynanabilir uygulamaya geçmeden önce karakter, isim ve görsel dünya AI tahminiyle kesinleştirilmeyecek; 4-5 yaş çocuk ve ebeveyn gözlemiyle doğrulanacak seçenekler hazırlanacak.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/PHASES.md`
5. `brain/FIELD_RESEARCH.md`
6. `brain/VALIDATION.md`
7. `brain/PROMPTS/phase-00C-character-and-name-field-validation.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece 4-5 yaş çocuklar için ilk boyama SLC'sine uygun karakter, isim ve görsel dünya saha doğrulama hazırlığını yap. 4-5 farklı karakter/tema yönü, her yön için kısa isim adayları, ebeveyn güven kontrolü ve çocuk gözlem formunu netleştir. Karakter veya uygulama adını kesinleştirme; karar için en az 3 çocuk veya ebeveyn/çocuk gözlemi gerektiğini koru. Kod üretme, mobil proje başlatma, mini oyun ekleme, ödeme/reklam/fotoğraf AI entegrasyonu yapma. Scope dışına çıkma.
```

## Çıkış Kriterleri

- 4-5 karakter/tema yönü hazırlanmış.
- Her karakter/tema yönü için 4-5 kısa isim adayı yazılmış.
- Çocuk gözlem formu ve ebeveyn güven soruları netleşmiş.
- Karar kriteri yazılmış: ana karakter/ad kesinleşmeden önce en az 3 çocuk veya ebeveyn/çocuk gözlemi.
- Kullanıcıdan Flutter scaffold fazına geçiş veya önce ticari hızlı tarama yapma kararı alınmış.

## Test

```bash
git diff --check
```

## Sonraki Faz

Phase 0D - Commercial Validation And Kill Report veya kullanıcı onayıyla Phase 1A - Flutter Scaffold Decision And Setup
