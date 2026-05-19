# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-05-19

## Active Phase

Phase 0B - Discovery To SLC Scope Lock

## Neden Bu Faz

Proje yeni ve kod yok. Kullanıcı güçlü bir ürün yönü tarif etti ancak ilk uygulama kapsamı küçük tutulmazsa çıkış gecikir. Güncel template standardına göre iç prototip hızlı olabilir, fakat dışarı çıkacak ilk ürün dar ama sevilebilir ve tamamlanmış SLC olmalıdır. Bu fazın amacı, 4-5 yaş için ilk oynanabilir kapsamın neyi içerip neyi erteleyeceğini kilitlemek, karakter/isim/tasarım kararlarını sahada doğrulanacak seçeneklere indirmek ve ticari doğrulama kapılarını görünür hale getirmektir.

## Oku

1. `brain/STATE.md`
2. `brain/RULES.md`
3. `brain/PLANNING.md`
4. `brain/PHASES.md`
5. `brain/FIELD_RESEARCH.md`
6. `brain/VALIDATION.md`
7. `brain/PROMPTS/phase-00B-discovery-to-slc-scope-lock.md`

## Planlama Kuralı

Uygulamaya geçmeden önce aktif faz, scope dışı işler, dosya etki alanı, test komutu ve onay gerektiren riskleri içeren kısa plan çıkar.

## Scope Locked Prompt

```text
Sadece 4-5 yaş okul öncesi çocuklar için ilk SLC kapsamını netleştir. İç prototip hızlı MVP olabilir; markete veya gerçek aileye verilecek ilk sürüm simple, lovable ve complete olmalıdır. Hedef kullanıcı, ilk oyun akışı, ilk içerik seti, karakter/isim/tasarım doğrulama yöntemi, SLC dışı bırakılacak fikirler, research/commercial validation, AI substitution ve kill report kapılarını yaz. Kod üretme, mobil proje başlatma, ödeme/reklam/fotoğraf AI entegrasyonu yapma. Karakter ve isim kararını sadece AI çıktısıyla kesinleştirme; sahada çocuk/ebeveyn geri bildirimi gerektir. Scope dışına çıkma.
```

## Çıkış Kriterleri

- SLC'nin tek cümlelik tanımı yazılmış.
- İlk çocuk akışı 3-5 adımda netleşmiş.
- Karakter/isim/tasarım için 4-5 seçenekli çocuk geri bildirim planı yazılmış.
- SLC'ye girmeyen ama ileride önemli fikirler ayrılmış.
- Research/commercial validation, AI substitution ve kill report için ilk kapı notları yazılmış.
- İlk playtest başarı kriterleri belirlenmiş.
- Kullanıcıdan bir sonraki faza geçiş onayı alınmış.

## Test

```bash
git diff --check
```

## Sonraki Faz

Phase 1A - Flutter Scaffold Decision And Setup
