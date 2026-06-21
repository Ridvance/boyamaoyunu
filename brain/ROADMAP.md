# ROADMAP.md - Yön Haritası

> Son güncelleme: 2026-06-21
> Rol: Onaylanmış yönü yakın, orta ve uzak vade olarak tutar; günlük iş değildir.

## Kullanma Kuralı

- Günlük execution sadece `CURRENT_PHASE.md` içinden yürür.
- Yeni başlıklar kullanıcı onayı olmadan aktif faza taşınmaz.
- Ticari başlıklar research, commercial validation, AI substitution, SLC ve kill report kapılarından geçer.
- İç prototip MVP olabilir; public/market sürümü SLC hedeflemelidir.

## Yakın Vade

### Mağaza Hazırlık Hattı
- Phase 2K: Android/iOS build engelleri, ilerleme bug'ı ve marka tutarlılığı.
- Phase 2L: Birleşik ilerleme yolculuğu ve ebeveyn kontrolleri.
- Phase 2M: Alışkanlıklar ve öğrenme paketlerinde derinlik.
- Phase 2N: Çekirdek oyun içerik dengesi.
- Phase 2O: Mağaza metadata, çocuk/gizlilik beyanları ve görsel varlıklar.
- Phase 2P: Gerçek cihaz QA, kapalı test ve Go/No-Go.
- Durum: active; ayrıntı `brain/STORE_READINESS_PLAN.md`.

### SLC 0 - Reklamsız Boyama Çekirdeği
- Kaynak: 2026-05-19 kullanıcı konuşmaları.
- Neden: En dar ama tamamlanmış çocuk değeri; aileye güven veren ilk deneyim.
- Kapsam: Çocuk ana ekranı, saha doğrulamalı karakter/tema, basit boyama ekranı, 3-5 güvenli görsel, renk paleti, silgi, temizle, geri dön.
- Gerekli kapı: SLC Gate, çocuk/ebeveyn saha doğrulaması.
- Durum: completed; mağaza hazırlık hattına devredildi.

### Çocuk/ebeveyn geri bildirim döngüsü
- Kaynak: 2026-05-19 kullanıcı konuşmaları.
- Neden: AI ve internet varsayımı yerine gerçek çocuk çekiciliğini ölçmek.
- Kapsam: Karakter/isim seçenekleri, kısa gözlem formu, 2-5 çocuk testi.
- Gerekli kapı: Field validation.
- Durum: Phase 2P içinde güncel ürünle uygulanacak.

### Ticari hızlı tarama
- Kaynak: Güncel template research/commercial validation kapısı.
- Neden: Çocuk boyama pazarında rakip, fiyat, dağıtım ve ödeme isteği bilinmeden uzun execution'a girmemek.
- Kapsam: 5-10 rakip, fiyat/özellik/dağıtım tablosu, kill report.
- Gerekli kapı: Research, commercial validation, AI substitution, kill report.
- Durum: pending.

## Orta Vade

### İçerik yenileme sistemi
- Daha fazla boyama paketi.
- Türkçe/İngilizce metin altyapısı.
- Ebeveyn alanı ve güvenlik ayrımı.

### Soft Launch Sonrası İyileştirme
- Kapalı testte kanıtlanan sürtünmeleri dar fix fazlarıyla çöz.
- İçerik ekleme kararını kullanım gözlemi ve tekrar isteğine göre ver.
- Çocuk verisi toplamadan manuel geri bildirim ve mağaza yorumlarıyla ilerle.

### Ücretli paket denemesi
- Ücretli paket veya tek seferlik satın alma denemesi.
- Ebeveyn ekranında güvenli satın alma akışı.
- 100/500/1000 kullanıcı gelir-maliyet senaryosu.

## Uzak Vade

- Global mağaza optimizasyonu.
- Kişiselleştirilmiş içerik.
- Güvenli, ebeveyn kontrollü üretken görsel akışları.
- Fotoğrafı çizime dönüştürme prototipi.
