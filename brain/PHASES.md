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

### Phase 0B - Discovery To MVP Lock
- Amaç: Konuşmadaki ürün fikrini tek küçük MVP kapsamına indirmek.
- Scope: Hedef kullanıcı, ilk oyun akışı, MVP dışı fikirler ve başarı kriterleri.
- Test: `git diff --check`.
- Durum: active.

## Phase 1 - First Playable App

### Phase 1A - Flutter Scaffold Decision And Setup
- Amaç: Mobil teknoloji kararını verip ilk çalışır proje iskeletini kurmak.
- Scope: Flutter veya seçilecek mobil iskelet, paket adı, temel app shell.
- Test: Platformun oluşturduğu temel test/build komutu.
- Durum: pending.

### Phase 1B - Child Home And Coloring MVP
- Amaç: Çocuk ana ekranı ve basit boyama ekranını oynanabilir yapmak.
- Scope: 3-5 hazır boyama sayfası, renk paleti, silgi/temizle.
- Test: Widget/unit test veya manuel smoke.
- Durum: pending.

### Phase 1C - Parent Safety Shell
- Amaç: Reklamsızlık, dış link yokluğu ve ebeveyn alanı ayrımını netleştirmek.
- Scope: Ebeveyn ayarı/iletişim alanı, çocuk akışından ayrım.
- Test: Manuel çocuk akışı smoke.
- Durum: pending.

## Phase 2 - Retention And Feedback

### Phase 2A - Child Playtest Feedback Loop
- Amaç: İlk MVP'yi birkaç çocukla deneyip eksikleri listelemek.
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
