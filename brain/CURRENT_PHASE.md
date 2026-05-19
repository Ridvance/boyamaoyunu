# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-05-19

## Active Phase

Phase 0B - Discovery To MVP Lock

## Neden Bu Faz

Proje yeni ve kod yok. Kullanıcı güçlü bir ürün yönü tarif etti ancak ilk uygulama kapsamı küçük tutulmazsa çıkış gecikir. Bu fazın amacı, 4-5 yaş için ilk oynanabilir sürümün tam olarak neyi içerip neyi erteleyeceğini kilitlemek ve karakter/isim/tasarım kararlarını sahada doğrulanacak seçeneklere indirmektir.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/PHASES.md`
5. `brain/FIELD_RESEARCH.md`
6. `brain/PROMPTS/phase-00B-discovery-to-mvp-lock.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece 4-5 yaş okul öncesi çocuklar için ilk MVP kapsamını netleştir. Hedef kullanıcı, ilk oyun akışı, ilk içerik seti, karakter/isim/tasarım doğrulama yöntemi, MVP dışı bırakılacak fikirler ve başarı kriterlerini yaz. Kod üretme, mobil proje başlatma, ödeme/reklam/fotoğraf AI entegrasyonu yapma. Karakter ve isim kararını sadece AI çıktısıyla kesinleştirme; sahada çocuk/ebeveyn geri bildirimi gerektir. Scope dışına çıkma.
```

## Çıkış Kriterleri

- MVP'nin tek cümlelik tanımı yazılmış.
- İlk çocuk akışı 3-5 adımda netleşmiş.
- Karakter/isim/tasarım için 4-5 seçenekli çocuk geri bildirim planı yazılmış.
- MVP'ye girmeyen ama ileride önemli fikirler ayrılmış.
- İlk playtest başarı kriterleri belirlenmiş.
- Kullanıcıdan bir sonraki faza geçiş onayı alınmış.

## Test

```bash
git diff --check
```

## Sonraki Faz

Phase 1A - Flutter Scaffold Decision And Setup
