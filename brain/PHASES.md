# PHASES.md - Küçük Faz Rotası

> Son güncelleme: 2026-05-19

## Faz Kullanma Kuralı

- Aynı anda sadece `brain/CURRENT_PHASE.md` içindeki faz çalışılır.
- Her faz küçük ve test edilebilir tutulur.
- Kod değişirse test çalışır.
- Faz sonunda `STATE.md` ve gerekiyorsa `CURRENT_PHASE.md` güncellenir.
- `IDEA_POOL.md` içindeki fikirler kullanıcı onayı olmadan aktif faza taşınmaz.

## Phase 0 - Brain And Product Framing

### Phase 0A - Brain Structure Setup
- Amaç: Boş projeye brain çalışma belleğini kurmak.
- Scope: Doküman dosyaları.
- Test: `git diff --check`.
- Durum: completed.

### Phase 0B - Discovery To SLC Scope Lock
- Amaç: Konuşmadaki ürün fikrini tek küçük SLC kapsamına indirmek ve karakter/isim/tasarım kararını saha doğrulamasına bağlamak.
- Scope: Hedef kullanıcı, ilk oyun akışı, SLC dışı fikirler, karakter/isim seçenekleri için çocuk geri bildirim planı, research/commercial validation kapıları ve başarı kriterleri.
- Test: `git diff --check`.
- Durum: completed.
- Sonuç: İlk SLC sadece reklamsız boyama çekirdeği olacak; mini oyun sonraki fazlara bırakıldı.

### Phase 0C - Character And Name Field Validation
- Amaç: 4-5 yaş çocuklara ve ebeveynlere 4-5 karakter/isim seçeneği gösterip en çekici yönü doğrulamak.
- Scope: Basit görsel seçenekler, isim seçenekleri, kısa gözlem formu.
- Test: En az 3 çocuk veya ebeveyn/çocuk gözlemiyle not toplama.
- Durum: completed.
- Sonuç: 5 karakter/tema yönü, isim adayları, gözlem formu ve başarı sinyali hazırlandı; nihai karar saha gözlemi sonrası verilecek.

### Phase 0D - Commercial Validation And Kill Report
- Amaç: Çocuk boyama oyunu fikrinin rakip, fiyat, ödeme isteği, dağıtım, AI ikamesi ve zayıf yanlarını hızlı taramayla netleştirmek.
- Scope: 5-10 rakip, fiyat/özellik/dağıtım karşılaştırması, AI substitution notu, kısa kill report, Go/Pivot/Research More kararı.
- Test: Kaynaklı tablo ve `git diff --check`.
- Durum: pending.

## Phase 1 - First Playable App

### Phase 1A - Flutter Scaffold Decision And Setup
- Amaç: Mobil teknoloji kararını verip ilk çalışır proje iskeletini kurmak.
- Scope: Flutter veya seçilecek mobil iskelet, paket adı, temel app shell.
- Test: Platformun oluşturduğu temel test/build komutu.
- Durum: completed.
- Sonuç: Flutter scaffold kuruldu, default sayaç demosu kaldırıldı, temel app shell ve widget testi hazır.

### Phase 1B - Child Home And Coloring SLC
- Amaç: Çocuk ana ekranı ve basit boyama ekranını dar ama tamamlanmış SLC seviyesinde oynanabilir yapmak.
- Scope: Saha doğrulamasından geçen karakter/tema yönü, 3-5 hazır boyama sayfası, renk paleti, silgi, temizle, geri dön. Mini oyun bu fazın scope'una girmez.
- Test: Widget/unit test veya manuel smoke.
- Durum: completed.
- Sonuç: 3 hazır sayfa, çizim kanvası, renk paleti, silgi, temizle ve geri dön akışı çalışır hale getirildi.

### Phase 1C - Parent Safety Shell
- Amaç: Reklamsızlık, dış link yokluğu ve ebeveyn alanı ayrımını netleştirmek.
- Scope: Ebeveyn ayarı/iletişim alanı, çocuk akışından ayrım.
- Test: Manuel çocuk akışı smoke.
- Durum: active.

## Phase 2 - Retention And Feedback

### Phase 2A - Child Playtest Feedback Loop
- Amaç: İlk SLC/prototip akışını birkaç çocukla deneyip eksikleri listelemek.
- Scope: Gözlem formu, geri bildirim notları, hızlı düzeltme listesi.
- Test: Gerçek cihazda oynatma.
- Durum: pending.

### Phase 2B - Content Refresh System
- Amaç: Yeni boyama alanı ve küçük içerik paketlerini düzenli eklenebilir yapmak.
- Scope: Asset/content yapısı.
- Test: Yeni içerik ekleme smoke.
- Durum: pending.

## Phase 3 - Differentiator

### Phase 3A - Photo To Coloring Prototype
- Amaç: Ebeveynin yüklediği resmi çizgi boyama sayfasına dönüştürmeyi prototiplemek.
- Scope: Yerel prototip veya güvenli API araştırması; çocuk verisi ve gizlilik ayrıca değerlendirilecek.
- Test: Örnek görsellerle çıktı kalitesi kontrolü.
- Durum: pending.
