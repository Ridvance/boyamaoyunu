# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-05-19

## Active Phase

Phase 1C - Parent Safety Shell

## Neden Bu Faz

İlk boyama SLC çekirdeği çalışır durumda: çocuk ana ekrandan 3 sayfadan birini seçip renk paletiyle boyayabiliyor, silgi/temizle/geri dön aksiyonları çalışıyor. Bu fazın amacı çocuk akışında reklam, dış link, ödeme ve yetişkin alanına yanlışlıkla geçiş riskini görünür şekilde ayırmak; gerçek ödeme, reklam veya dış servis entegrasyonu yapılmayacak.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/PHASES.md`
5. `brain/TESTING.md`
6. `brain/UX_ARCHITECTURE.md`
7. `brain/PROMPTS/phase-01C-parent-safety-shell.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece ebeveyn güvenlik kabuğunu netleştir. Çocuk akışında reklam, ödeme, dış link, kamera/galeri ve hesap akışı olmadığını koru. Ebeveyn alanını çocuk alanından ayıran basit bir giriş/kapı tasarla; gerçek ödeme, reklam, abonelik, dış servis, kamera/galeri veya fotoğraf AI entegrasyonu yapma. Kod değişirse `flutter test` ve `flutter analyze` çalıştır, `git diff --check` temiz olsun.
```

## Çıkış Kriterleri

- Çocuk akışında reklam, ödeme, dış link, hesap, kamera/galeri erişimi yoktur.
- Ebeveyn alanı çocuk akışından ayrılmıştır.
- Güvenlik bilgisi çocuk akışını karmaşıklaştırmadan sunulur.
- `flutter test` başarılı.
- `flutter analyze` başarılı.
- `git diff --check` temiz.

## Test

```bash
git diff --check
```

## Sonraki Faz

Phase 2A - Child Playtest Feedback Loop
