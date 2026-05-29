# MISSION_CONTROL.md - Hedef Koruma Kapısı

> Son güncelleme: 2026-05-22 00:18
> Rol: Her iş birimi çıktısından sonra ürünün asıl hedefe doğru ilerleyip ilerlemediğini denetler.

## Güncel Verdict

- Verdict: BLOCKED
- Summary: UI cockpit üzerinden BLOCKED verdict verildi.
- Requested By: Handoff Coordinator
- Requested At: 2026-05-22T00:18:11.568423
- Checked At: 2026-05-22T00:18:19.542586
- Target Phase: Phase-00A
- Last Job: same-day-20260522-001811

## Kapı Kuralı

Mission Control `APPROVED` demeden yeni iş birimine veya faza geçilmez. `NEEDS_REVISION` çıkarsa aynı iş birimi işi düzeltir. `USER_DECISION_REQUIRED`, `PIVOT_RECOMMENDED` veya `NO_GO_RECOMMENDED` çıkarsa CEO kararı beklenir.

## Kontrol Soruları

- Yapılan iş aktif fazın scope kilidine uyuyor mu?
- Ürünün ana problemine ve hedef kullanıcıya doğru ilerliyor mu?
- Yeni risk, ticari doğrulama eksiği veya AI substitution tehdidi doğdu mu?
- Sonraki iş birimine devredilebilir net çıktı var mı?
- Context şiştiyse yeni pencere handoff'u yeterli mi?
