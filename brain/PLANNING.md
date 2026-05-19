# PLANNING.md - Planlama Disiplini

> Son güncelleme: 2026-05-19
> Rol: Agent'ın uygulamaya geçmeden önce nasıl plan yapacağını ve yeni fikirleri nasıl ele alacağını tanımlar.

## Her Oturumda Planlama

Agent uygulamaya geçmeden önce kısa bir faz planı çıkarır.

## Çalışma Modları

- Discovery Mode: Kullanıcıyla tek tek sorular sorarak beyin fırtınası yap; son hedefi, kullanıcıları, ana akışları, başarı kriterlerini ve kısıtları netleştir. Kod değiştirme.
- Planning Mode: Onaylanan hedefleri MVP, V1, V2 ve uzun vade fazlarına böl.
- Design Mode: `UX_ARCHITECTURE.md` içinde ekranları, akışları ve tasarım brief/promptlarını hazırla. Kod yazma.
- Execution Mode: Sadece `CURRENT_PHASE.md` içindeki aktif fazı uygula.
- Review Mode: Scope, test, risk ve tamamlanma kriterlerini kontrol et.
- Handoff Mode: Context şiştiğinde veya iş durak noktasına geldiğinde yeni sohbet devam promptu üret.

## Çıktı Standardı

- Discovery Mode: soru başlıkları altında keşif sentezi, yakın/orta/uzak vade ufku ve onay bekleyen keşif özeti.
- Planning Mode: MVP, V1, V2 ve uzun vade fazları; `PHASES.md`, `CURRENT_PHASE.md` ve gerekli `PROMPTS/phase-*.md` güncellemeleri.
- Design Mode: ana ekranlar, ana akışlar, UX ilkeleri ve tasarım prompt taslağı.
- Execution Mode: aktif faz kapsamındaki değişiklikler, doğrulama/test sonucu ve faz sonu notu.
- Review Mode: scope, risk, test ve eksik kalan noktalar kontrolü.
- Handoff Mode: yeni sohbet devam promptu ve sıradaki güvenli adım.

Plan şunları içerir:

- Aktif faz:
- Yapılacak iş:
- Scope dışı:
- Beklenen dosya etki alanı:
- Test/doğrulama:
- Onay gerektiren riskler:

## Yeni Fikir Geldiğinde

- Aktif işi hemen bırakma.
- Fikri önce `IDEA_POOL.md`, `PHASES.md` veya uzak vade hedeflerinden hangisine koyacağını sor.
- Kullanıcı açıkça öncelik değişikliği onayı vermedikçe `CURRENT_PHASE.md` değişmez.

Kullanılacak soru:

```text
Bunu planlamanın neresine koyayım: mevcut faza mı, sonraki faza mı, IDEA_POOL'a mı, yoksa uzak vade hedeflerine mi?
```

## Discovery Kuralı

- Yeni veya belirsiz projede önce kullanıcıyla beyin fırtınası yap.
- Tüm soruları tek seferde yığma; her seferinde tek ana başlık veya tek kritik soru sor.
- Her cevap sonrası o başlık altında kısa sentez yap.
- Sentezde "bu başlık nereye kadar gidebilir?" sorusunu cevaplayarak yakın, orta ve uzak vade ufkunu çıkar.
- Başlık yeterince netleşmeden sonraki ana başlığa geçme.
- Son hedef, kullanıcılar, ana akışlar ve başarı kriterleri netleşmeden büyük roadmap yazma.
- Tüm başlıklar yeterince netleşince tam kapsamlı keşif özetini kullanıcıya sun ve onay almadan fazları kesinleştirme.

## Otonomi Seviyesi

- A0 Read Only: sadece oku, analiz et, soru sor ve plan çıkar.
- A1 Safe Docs: Brain/doküman/checklist/prompt düzenleyebilir; `git diff --check` çalıştır.
- A2 Safe Code: aktif faz içindeki düşük riskli 1-3 dosyalık kod değişikliğini yapabilir; ilgili testi çalıştır.
- A3 Broad Change: çok modüllü, mimari veya davranış değişikliği; önce plan ve onay ister.
- A4 Dangerous: canlı API, ödeme, çocuk verisi, data wipe, destructive işlem, secret veya force push; açık onay zorunlu.

## Devam / Dur Kriteri

- Güvenli, geri alınabilir, aktif faz içinde ve test edilebilir işlerde ilerle.
- Scope dışı, geri dönüşü zor, canlı sistem etkili veya belirsiz işlerde dur ve onay iste.
- Aynı hatada en fazla iki küçük düzeltme dene; çözülmezse blocker olarak yaz ve handoff üret.

## Faz Sonu

- Yapılan işi `STATE.md` içine özetle.
- Gerekirse `CURRENT_PHASE.md` dosyasını bir sonraki küçük faza hazırla.
- Onaylanan yeni hedef varsa `PHASES.md` ve ilgili `PROMPTS/phase-*.md` dosyalarını güncelle.
