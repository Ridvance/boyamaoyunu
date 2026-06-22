# DECISIONS.md - Karar Kaydı

> Son güncelleme: 2026-05-22 00:18
> Rol: Önemli kararların nedenini ve geri dönüş yolunu kaybetmemek.

## Kararlar

### 2026-06-22 - Phase 2P Ara NO-GO
- **Karar:** iPhone küçük yatay ekran P1'i kapatıldı; gerçek cihaz, kapalı test/TestFlight ve çocuk/ebeveyn gözlemi eksik olduğu için `NO-GO PUBLIC` kararı korundu ve Phase 2P aktif bırakıldı.
- **Neden:** Simülatör ve otomatik test kanıtı fiziksel ses/titreşim, offline/restart, gerçek kullanıcı ve mağaza dağıtım kapılarının yerine geçmez.
- **Etki:** Phase 3 veya public yayın başlamaz; dış QA erişimi sağlandığında `docs/qa/phase-2p-device-matrix.md` tamamlanır.
- **Geri alma yolu:** NO-GO kaydını yalnız tüm Phase 2P çıkış kriterleri kanıtlanıp yeni bir GO kararı yazıldığında değiştir.

### 2026-06-22 - Phase 2P Aktivasyonu
- **Karar:** Phase 2O tamamlandıktan sonra kullanıcının `devam` talimatıyla Phase 2P aktif edildi.
- **Neden:** Public yayın öncesindeki sıradaki onaylı kapı gerçek cihaz, kapalı test ve çocuk/ebeveyn gözlemidir.
- **Etki:** Yalnız cihaz/kapalı test kanıtı ve kanıtlanan P0/P1 bulgularına dar fix üretilecek; public publish yapılmayacak.
- **Geri alma yolu:** Aktivasyon commit'ini revert et ve `CURRENT_PHASE.md` dosyasını Phase 2O tamamlandı durumuna döndür.

### 2026-06-22 - Phase 2O Tamamlandı
- **Karar:** İki mağaza için metadata, politika cevap taslakları, ikonlar, feature graphic, 14 release ekranı ve checklist hazırlanarak faz kapatıldı.
- **Neden:** Build ve ürün içeriğini mağaza hesaplarına girmeden önce doğrulanabilir bir gönderim paketine dönüştürmek gerekiyordu.
- **Etki:** Public yayın kararı hâlâ `NO-GO`; fiziksel cihaz, kapalı test ve imzalı iOS archive Phase 2P'de bekliyor.
- **Geri alma yolu:** Phase 2O store package ve brain completion commit'lerini revert et.

### 2026-06-22 - Phase 2O Aktivasyonu
- **Karar:** Phase 2N tamamlandıktan sonra kullanıcının `devam` talimatıyla Phase 2O aktif edildi.
- **Neden:** Build ve içerik baseline'ından sonra sıradaki onaylı kapı mağaza gönderim paketidir.
- **Etki:** Yalnız metadata, politika taslakları, gizlilik/destek yüzeyleri ve mağaza görselleri değişecek; mağaza hesabında gönderim yapılmayacak.
- **Geri alma yolu:** Phase 2O değişikliklerini revert et ve `CURRENT_PHASE.md` dosyasını Phase 2N tamamlandı durumuna döndür.

### 2026-06-22 - Phase 2N Tamamlandı
- **Karar:** Çekirdek içerik 10 boyama, 10 çiz takip, üç balon bölüm tipi ve 5 kalıcı Sinek Avı rozetiyle dengelenerek faz kapatıldı.
- **Neden:** İlk oturum çeşitliliğini yeni ana oyun veya ekonomi eklemeden artırmak gerekiyordu.
- **Etki:** Yeni içerikler mevcut chapter ilerlemesine yazılıyor; Sinek Avı rozetleri diğer Renk Laboratuvarı modlarıyla çakışmayan indekslerde tutuluyor.
- **Geri alma yolu:** Phase 2N uygulama/test commit'ini revert et ve brain durumunu aktif Phase 2N'ye döndür.

### 2026-06-22 - Phase 2N Aktivasyonu
- **Karar:** Phase 2M tamamlandıktan sonra kullanıcının `devam` talimatıyla Phase 2N aktif edildi.
- **Neden:** Onaylı mağaza hazırlık sırasında sıradaki iş çekirdek oyun içerik dengesidir.
- **Etki:** Yalnız boyama, çiz takip, balon ve Sinek Avı içeriği/testleri değişecek; Phase 2O kapsamına geçilmeyecek.
- **Geri alma yolu:** Phase 2N değişikliklerini revert et ve `CURRENT_PHASE.md` dosyasını Phase 2M tamamlandı durumuna döndür.

### 2026-06-21 - Phase 2M Aktivasyonu
- **Karar:** Phase 2L tamamlandıktan sonra kullanıcının `Devam` talimatıyla Phase 2M aktif edildi.
- **Neden:** Onaylı mağaza hazırlık sırasında sıradaki iş, en sığ iki içerik alanını derinleştirmektir.
- **Etki:** Yalnız `HabitsGame` ve `LearningPacksGame` içeriği/testleri değişecek; Phase 2N kapsamına geçilmeyecek.
- **Geri alma yolu:** Phase 2M değişikliklerini revert et ve `CURRENT_PHASE.md` dosyasını Phase 2L tamamlandı durumuna döndür.

### 2026-05-21 - CEO Manuel Departman Gecisi: Research
- **Karar:** Durum manuel olarak Research moduna gecirildi.
- **Neden:** CEO'nun yonlendirmesi veya risk tercihi (Override).
- **Alternatifler:** Mevcut Research modunda kalmak
- **Etki:** Projenin aktif calisma fazi ve odagi degisti.
- **Geri alma yolu:** python brain.py transition --to Research

### 2026-05-21 - CEO Manuel Departman Gecisi: Discovery
- **Karar:** Durum manuel olarak Discovery moduna gecirildi.
- **Neden:** CEO'nun yonlendirmesi veya risk tercihi (Override).
- **Alternatifler:** Mevcut Research modunda kalmak
- **Etki:** Projenin aktif calisma fazi ve odagi degisti.
- **Geri alma yolu:** python brain.py transition --to Research

### 2026-05-21 - CEO Manuel Departman Gecisi: Research
- **Karar:** Durum manuel olarak Research moduna gecirildi.
- **Neden:** CEO'nun yonlendirmesi veya risk tercihi (Override).
- **Alternatifler:** Mevcut Discovery modunda kalmak
- **Etki:** Projenin aktif calisma fazi ve odagi degisti.
- **Geri alma yolu:** python brain.py transition --to Discovery

### 2026-05-21 - CEO Manuel Departman Gecisi: Discovery
- **Karar:** Durum manuel olarak Discovery moduna gecirildi.
- **Neden:** CEO'nun yonlendirmesi veya risk tercihi (Override).
- **Alternatifler:** Mevcut Review modunda kalmak
- **Etki:** Projenin aktif calisma fazi ve odagi degisti.
- **Geri alma yolu:** python brain.py transition --to Review

### 2026-05-21 - CEO Manuel Departman Gecisi: Discovery
- **Karar:** Durum manuel olarak Discovery moduna gecirildi.
- **Neden:** CEO'nun yonlendirmesi veya risk tercihi (Override).
- **Alternatifler:** Mevcut MissionControl modunda kalmak
- **Etki:** Projenin aktif calisma fazi ve odagi degisti.
- **Geri alma yolu:** python brain.py transition --to MissionControl
