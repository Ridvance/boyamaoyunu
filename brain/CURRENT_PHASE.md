# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-05

## Active Phase

Phase 2H - Fly Hunt V2

## Neden Bu Faz

Phase 2J oyun cilalama paketi tamamlandı. Sıradaki güvenli ürün fırsatı, kullanıcının daha önce işaret ettiği Renk Laboratuvarı içindeki Sinek Avı modunu daha güçlü bölüm/oyun hissine taşımak.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PHASES.md`
4. `brain/UX_ARCHITECTURE.md`
5. `brain/VALIDATION.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece Renk Laboratuvarı içindeki Sinek Avı modunu 3 kısa bölüm, hedef renk kartı, doğru/yanlış geri bildirim ve rozet döngüsüyle güçlendir; yeni ana oyun, ödeme, dış sistem veya büyük refactor ekleme.
```

## Exit Criteria

- Sinek Avı hedefi çocuk için daha görünür olur.
- En az 3 kısa bölüm ilerlemesi vardır.
- Yanlış seçim yumuşak geri bildirim verir.
- Bölüm sonu kutlama/rozet görünür.
- Mevcut renk karışımı ve diğer modlar bozulmaz.

## Test

```bash
flutter test
dart analyze lib/games/magic_colors_game.dart test/widget_test.dart
git diff --check
```
