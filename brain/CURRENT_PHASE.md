# CURRENT_PHASE.md - Aktif Micro Phase

> Son güncelleme: 2026-05-19

## Active Micro Phase

Phase 2A - Child Playtest Feedback Loop

## Neden Bu Faz

İlk oynanabilir boyama SLC çekirdeği ve ebeveyn güvenlik kabuğu tamamlandı. Çocuk ana akışında 3 boyama sayfası, renk paleti, silgi, temizle ve geri dön var; ebeveyn alanı çocuk akışından ayrıldı. Bu fazın amacı gerçek cihazda ve mümkünse 2-5 çocuk/ebeveyn gözleminde ilk kullanım sinyallerini toplamak.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/PHASES.md`
5. `brain/TESTING.md`
6. `brain/FIELD_RESEARCH.md`
7. `brain/PROMPTS/phase-02A-child-playtest-feedback-loop.md`

## Planlama Kuralı

Uygulamaya geçmeden önce modunu, uzman pozisyonunu, aktif micro phase'i, scope dışı işleri, dosya etki alanını, test komutunu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Kod değiştirmeden önce mevcut ilk oynanabilir boyama SLC'sini gerçek cihaz/çocuk testi için değerlendir. 2-5 çocuk veya ebeveyn/çocuk gözlemiyle hangi sayfaya basıldığı, çizim yapıp yapmadığı, renk/silgi/temizle kullanımında zorlanma, sıkılma ve ebeveyn güven yorumu toplanacak şekilde kısa playtest planı ve gözlem notu üret. Kod değişikliği yapma; test planı doküman değişirse `git diff --check` çalıştır. Scope dışına çıkma.
```

## Çıkış Kriterleri

- Playtest gözlem formu güncel uygulama akışına göre hazırlanmış.
- Başarı/başarısızlık sinyalleri yazılmış.
- Kullanıcıdan gerçek cihaz testi veya APK üretim kararı alınmış.
- `git diff --check` temiz.

## Test

```bash
git diff --check
```

## Sonraki Faz

Phase 2B - Content Refresh System veya playtest bulgularına göre düzeltme fazı
