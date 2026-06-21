# DECISIONS.md - Karar Kaydı

> Son güncelleme: 2026-05-22 00:18
> Rol: Önemli kararların nedenini ve geri dönüş yolunu kaybetmemek.

## Kararlar

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
