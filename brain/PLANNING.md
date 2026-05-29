# PLANNING.md - Planlama Disiplini

> Son güncelleme: 2026-05-22 00:18
> Rol: Agent'ın uygulamaya geçmeden önce nasıl plan yapacağını ve yeni fikirleri nasıl ele alacağını tanımlar.

## Her Oturumda Planlama

Agent uygulamaya geçmeden önce kısa bir faz planı çıkarır.

## Çalışma Modları

Agent her işe başlamadan önce hangi modda çalıştığını açıkça belirler ve o modun uzman birimi gibi pozisyon alır. Modlar şirket içindeki ayrı iş birimleri gibi düşünülür; her mod kendi işini bitirir, karar ve kanıtını bırakır, sonraki moda devredilebilir çıktı üretir.

- Discovery Mode: Kullanıcıyla tek tek sorular sorarak beyin fırtınası yap; son hedefi, kullanıcıları, ana akışları, başarı kriterlerini ve kısıtları netleştir. Kod değiştirme.
- Planning Mode: Onaylanan hedefleri `SLC/V1/V2/Long-term -> Epic -> Micro Phase` mimarisine böl ve her micro phase için scope kilitli prompt yaz.
- Design Mode: `UX_ARCHITECTURE.md` içinde ekranları, akışları ve Stitch design brief/promptlarını hazırla. Kod yazma.
- Execution Mode: Sadece `CURRENT_PHASE.md` içindeki aktif fazı uygula.
- Review Mode: Scope, test, risk ve tamamlanma kriterlerini kontrol et.
- Handoff Mode: Context şiştiğinde veya iş durak noktasına geldiğinde yeni sohbet devam promptu üret.

## Mod Pozisyonları

- Discovery Architect: problemi, kullanıcıyı, niyeti ve belirsizlikleri netleştirir.
- Research/Validation Architect: pazar, rakip, ödeme isteği, AI substitution, SLC ve kill report kapılarını işletir.
- Planning Architect: version architecture, epic breakdown ve micro phase planını kurar.
- Design Architect: UX mimarisi, ekran akışları ve tasarım promptlarını hazırlar.
- Execution Engineer: sadece aktif micro phase'i uygular.
- Review Engineer: scope, test, risk ve tamamlanma kanıtını denetler.
- Handoff Coordinator: sıradaki iş birimine devredilebilir devam promptu ve durum özeti üretir.

## Çıktı Standardı

Her mod somut çıktı bırakır:

- Discovery Mode: soru başlıkları altında keşif sentezi, yakın/orta/uzak vade ufku ve onay bekleyen keşif özeti.
- Planning Mode: baştan kilitlenmiş version architecture, epic breakdown, micro phase planı, her micro phase için `Scope Locked Prompt`, `PHASES.md`, `CURRENT_PHASE.md` ve gerekli `PROMPTS/phase-*.md` güncellemeleri.
- Design Mode: ana ekranlar, ana akışlar, UX ilkeleri ve Stitch design brief/prompt taslağı.
- Execution Mode: aktif faz kapsamındaki değişiklikler, doğrulama/test sonucu ve faz sonu notu.
- Review Mode: scope, risk, test ve eksik kalan noktalar kontrolü.
- Handoff Mode: yeni sohbet devam promptu, sıradaki güvenli adım ve next work handoff.

## Yeni Fikir Geldiğinde

- Aktif işi hemen bırakma.
- Fikri önce kaynaklı kısa not olarak yakala.
- Fikri sınıflandır: aktif micro phase, sonraki micro phase, roadmap, research konusu, teknik iyileştirme, UX fikri, risk/test fikri veya uzak vade/rüya.
- Brain filtrelerinden geçir: scope, vision fit, roadmap fit, duplicate check, risk, research/commercial/AI/SLC/kill ihtiyacı, version placement ve phaseability.
- Sonucu şu kararlardan birine bağla: `Ignore`, `IDEA_POOL`, `Research More`, `Roadmap Candidate`, `Version Architecture Revision`, `Next Micro Phase`, `Current Phase Change`, `No-Go`, `Pivot`, `Go`.
- Kullanıcı açıkça öncelik değişikliği onayı vermedikçe `CURRENT_PHASE.md` değişmez.
- Aktif micro phase değişirse gerekçeyi `DECISIONS.md` içine yaz.

Kullanılacak soru:

```text
Bunu planlamanın neresine koyayım: mevcut micro phase'e mi, sonraki micro phase'e mi, IDEA_POOL'a mı, ROADMAP'e mi, yoksa research konusu mu yapalım?
```

## Otonomi Seviyeleri

RULES.md içindeki tüm otonomi ve yetki sınırları bu tablodan referanslanır:
- A0 Read Only: sadece oku, analiz et, soru sor ve plan çıkar.
- A1 Safe Docs: Brain/doküman/checklist/prompt düzenleyebilir; `git diff --check` çalıştır.
- A2 Safe Code: aktif faz içindeki düşük riskli 1-3 dosyalık kod değişikliğini yapabilir; ilgili testi çalıştır.
- A3 Broad Change: çok modüllü, mimari veya davranış değişikliği; önce plan ve onay ister.
- A4 Dangerous: canlı API, ödeme, kullanıcı verisi, data wipe, destructive işlem, secret veya force push; açık onay zorunlu.

## Devam / Dur Kriteri

- Güvenli, geri alınabilir, aktif faz içinde ve test edilebilir işlerde ilerle.
- Scope dışı, geri dönüşü zor, canlı sistem etkili veya belirsiz işlerde dur ve onay iste.
- Aynı hatada en fazla iki küçük düzeltme dene; çözülmezse blocker olarak yaz ve handoff üret.
