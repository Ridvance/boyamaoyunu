# PLANNING.md - Planlama Disiplini

> Son güncelleme: 2026-05-19
> Rol: Agent'ın uygulamaya geçmeden önce nasıl plan yapacağını ve yeni fikirleri nasıl ele alacağını tanımlar.

## Her Oturumda Planlama

Agent uygulamaya geçmeden önce kısa bir faz planı çıkarır.

## Çalışma Modları

- Discovery Mode: Kullanıcıyla tek tek sorular sorarak beyin fırtınası yap; son hedefi, kullanıcıları, ana akışları, başarı kriterlerini ve kısıtları netleştir. Kod değiştirme.
- Planning Mode: Onaylanan hedefleri SLC, V1, V2 ve uzun vade fazlarına böl.
- Design Mode: `UX_ARCHITECTURE.md` içinde ekranları, akışları ve tasarım brief/promptlarını hazırla. Kod yazma.
- Execution Mode: Sadece `CURRENT_PHASE.md` içindeki aktif fazı uygula.
- Review Mode: Scope, test, risk ve tamamlanma kriterlerini kontrol et.
- Handoff Mode: Context şiştiğinde veya iş durak noktasına geldiğinde yeni sohbet devam promptu üret.

## Çıktı Standardı

- Discovery Mode: soru başlıkları altında keşif sentezi, yakın/orta/uzak vade ufku ve onay bekleyen keşif özeti.
- Planning Mode: SLC, V1, V2 ve uzun vade fazları; `PHASES.md`, `CURRENT_PHASE.md` ve gerekli `PROMPTS/phase-*.md` güncellemeleri.
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

## Research ve Commercial Validation

Ticari ürün fikrinde agent execution'a geçmeden önce araştırma ve ticari doğrulama kapısını işletir.

Önce araştırma derinliği seçilir:

- Hızlı tarama: düşük maliyetli iç prototip, alan ön elemesi veya kısa karar ihtiyacı.
- Deep research: ticari ürün, aylar sürecek execution, rekabetli pazar veya yüksek fırsat maliyeti.

Research çıktısı:

- Rakip isimleri, fiyatları, özellikleri, platformları ve dağıtım avantajları.
- Kullanıcı segmentleri ve mevcut çözümlerdeki kanıtlı memnuniyetsizlikler.
- "Rakipler bunu yapmıyor" gibi varsayımların kaynaklı kontrolü.
- Büyük pazar sayısının bu ürünün gerçek fırsatına ne kadar dönüştüğü.

Commercial validation çıktısı:

- Kim para öder, neden öder, ne sıklıkta kullanır?
- Hangi ülke veya segment ödeme açısından daha uygundur?
- CAC, LTV, churn, destek ve bakım maliyeti için kaba varsayımlar.
- 100, 500 ve 1000 müşteri senaryosunda gelir, maliyet ve break-even görünümü.

Bu projede çocuk güvenliği ve saha gözlemi ticari doğrulamanın parçasıdır. Çocuk verisi veya fotoğraf içeren her fikir ayrıca gizlilik/onay kapısından geçer.

## AI Substitution Gate

Faz planına geçmeden önce şu soru cevaplanır: Hedef kullanıcı bu işi tek promptla veya genel amaçlı AI aracıyla yeterince iyi çözebilir mi?

- Genel AI aracı problemi hangi kalitede çözer?
- Ürün değeri özel veri, güvenli çocuk UX'i, ebeveyn workflow'u, içerik yenileme, dağıtım veya domain bilgisinde mi?
- Eğer AI tek başına çözebiliyorsa ürünleşme gerekçesi nedir?
- AI tarafından kolay ikame edilen kısımlar scope dışına mı alınmalı, yoksa savunulabilir hale mi getirilmeli?

Sonuç zayıfsa karar `Pivot`, `No-Go` veya `Research More` olarak yazılır. Kullanıcı onayı olmadan execution'a geçilmez.

## SLC Gate

Execution'a geçmeden önce en dar ama tamamlanmış ve sevilebilir ilk kapsam tanımlanır.

- En dar tamamlanmış kapsam nedir?
- Kullanıcı bu sürümü gerçek kullanımda çocuğa verebilir mi?
- Bu kapsam terk edilse bile kendi başına değer sağlar mı?
- "Evet ama X de lazım" itirazlarından hangileri kapsamı gerçekten eksik bırakır?
- Definition of Done içinde simple, lovable ve complete ölçütleri yazıldı mı?

Bu projede hızlı prototip içeride MVP olabilir; markete veya gerçek aileye verilecek ilk sürüm SLC hedeflemelidir.

## Devil's Advocate / Kill Report

Fikir umut verici görünüyorsa agent kısa ama sert bir karşı rapor üretir: "Bu işe neden girilmemeli?"

Kill report şunları kontrol eder:

- Pazar verisi yanıltıcı mı?
- Gerçek ödeme yapan segment küçük mü?
- Rakipler zaten bu boşluğu doldurmuş olabilir mi?
- Rakiplerin dağıtım, ekip, marka veya güven avantajı var mı?
- App Store/Google Play, büyük çocuk içerik markaları veya genel AI araçları ürünü savunmasız bırakır mı?
- Boşluk gerçek fırsat mı, yoksa düşük ödeme isteği, içerik maliyeti veya keşif zorluğu nedeniyle ertelenmiş alan mı?
- CAC/LTV, churn, destek ve bakım yükü işi öldürüyor mu?

Sonuç `Go`, `No-Go`, `Pivot` veya `Research More` olarak yazılır. Kullanıcı onayı olmadan doğrudan execution'a geçilmez.

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
