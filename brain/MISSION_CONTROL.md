# MISSION_CONTROL.md - Hedef Koruma Kapısı

> Son güncelleme: 2026-05-21 22:38
> Rol: Her iş birimi çıktısından sonra ürünün asıl hedefe doğru ilerleyip ilerlemediğini denetler.

## Güncel Verdict

- Verdict: PENDING
- Summary: Discovery onarımı tamamlandı; ürün açıklaması, hedef kullanıcı ve ana problem alanları VISION/VALIDATION ile uyumlu hale getirildi. Research’a geçmeden önce CEO/Mission Control onayı gerekiyor.
- Requested By: Discovery Architect
- Requested At: 2026-05-21T22:25:35.836281
- Checked At: 2026-05-21T22:38:39.881436
- Target Phase: Phase-00A
- Last Job: 20260521-222535-discovery

## Kapı Kuralı

Mission Control `APPROVED` demeden yeni iş birimine veya faza geçilmez. `NEEDS_REVISION` çıkarsa aynı iş birimi işi düzeltir. `USER_DECISION_REQUIRED`, `PIVOT_RECOMMENDED` veya `NO_GO_RECOMMENDED` çıkarsa CEO kararı beklenir.

## Kontrol Soruları

- Yapılan iş aktif fazın scope kilidine uyuyor mu?
- Ürünün ana problemine ve hedef kullanıcıya doğru ilerliyor mu?
- Yeni risk, ticari doğrulama eksiği veya AI substitution tehdidi doğdu mu?
- Sonraki iş birimine devredilebilir net çıktı var mı?
- Context şiştiyse yeni pencere handoff'u yeterli mi?
