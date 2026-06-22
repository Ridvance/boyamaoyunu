# VALIDATION.md - Araştırma ve Ticari Doğrulama

> Son güncelleme: 2026-06-22
> Rol: Research, commercial validation, AI substitution, SLC ve kill report kapılarını proje özelinde tutar.

## Kullanma Kuralı

- Bu dosya execution planı değildir; aktif iş yine `CURRENT_PHASE.md` içinden yürür.
- Kod yazmadan veya uzun execution'a geçmeden önce bu kapıların en az hızlı tarama seviyesinde cevaplanması gerekir.
- Çocuk güvenliği, ebeveyn güveni, karakter/isim saha doğrulaması ve dağıtım gerçekliği ticari doğrulamanın parçasıdır.

## Research Gate

### Phase 2O - Mağaza Uyumluluk Denetimi

- Release Android manifestinde çocuk uygulaması için hassas konum, kamera, mikrofon, kişi, telefon, Bluetooth veya `AD_ID` izni bulunmuyor.
- Uygulama reklam, üçüncü taraf analitik, hesap, sosyal özellik, kullanıcı üretimli içerik veya uygulama içi satın alma içermiyor.
- `shared_preferences` yalnız cihaz içi ilerleme ve tercihleri tutuyor; cihaz dışı veri iletimi yok.
- `url_launcher` yalnız ebeveyn kapısı arkasındaki canlı gizlilik sayfasını harici tarayıcıda açıyor.
- Google Play taslak hedef grubu `Ages 5 & Under`; Apple Kids Category taslağı `Made for Ages 5 and Under`.
- Google Data Safety ve Apple App Privacy için “veri toplanmıyor” yanıtı mevcut kod ve SDK kullanımıyla uyumlu bulundu.
- Bu denetim hukuki uygunluk garantisi değildir; hesap sahibi güncel artifact ve formları gönderim anında yeniden doğrulamalıdır.
- Resmî kaynaklar ve form cevapları `docs/store/*-compliance-draft.md` dosyalarındadır.

### Phase 2F - Okul Öncesi Paket Doğrulama Notu

- 2026-06-04 tarihinde "İlk Beceriler" adlı tek örnek paket eklendi.
- Paket renkler, hikayeli boyama ve günlük alışkanlık başlıklarını mevcut oyunlara bağlayan içerik taksonomisi olarak kullanılmaktadır.
- Bu paket resmi müfredat uyumu iddiası taşımaz.
- Resmi kazanım, okul/kurum uyumu veya öğretmen kullanım iddiası yazılmadan önce saha görüşmesi ve kaynaklı pedagojik doğrulama gerekir.

### Şu Anki Durum
- Durum: Hızlı sprint yapıldı; deep research açık.
- Derinlik: İlk kaynak taraması tamamlandı; uzun execution, ücretli model veya global pazarlama öncesi deep research gerekir.

### Cevaplanacak Sorular
- Google Play/App Store'da okul öncesi boyama oyunlarında başlıca rakipler kim?
- Rakiplerin reklam, abonelik, tek seferlik ödeme ve içerik yenileme modelleri ne?
- Hangi rakipler ebeveyn güvenini iyi anlatıyor?
- Hangi rakiplerin karakter/tasarım dili çocukları çekiyor ama ebeveyni rahatsız etmiyor?
- Rakiplerin zayıf yorumları neler: reklam, kilitli içerik, korkutucu karakter, sıkılma, teknik hata?

### Hızlı Research Sprint - 2026-05-20

| Rakip / Alternatif | Platform | Konumlandırma | Monetizasyon / Dağıtım | İlk Not |
|---|---|---|---|---|
| Samu's Coloring Book for Kids | App Store | 3-6 yaş, offline, no ads, no IAP, karakterli güvenli boyama | Ücretsiz; iPhone/iPad | Güvenli/offline/no ads iddiası güçlü; karakter dünyası ve gelecekte memory/storybook planı var. |
| Kids Colouring & Drawing Book / SmartyColors | App Store | Toddlers/preschool, yüzlerce sayfa, 11 tema, ad-free | Free + In-App Purchases | İçerik hacmi yüksek; bizim 3-5 sayfalık SLC'miz içerik sayısıyla rekabet edemez, deneyim ve güvenle ayrışmalı. |
| Colorir - Coloring Book | App Store | Ücretsiz, no ads/no subscriptions/no IAP, offline, fotoğraf/drawing import | Ücretsiz | Fotoğraf import fikri rakipte var; bizim fotoğraf-to-coloring iddiası gizlilik ve kaliteyle ayrışmalı. |
| Happy Lines Kids Coloring Book | App Store | 3-5 yaş, sakin, no ads/no external links, tek seferlik unlock | Free + In-App Purchases | Tek seferlik satın alma ve parent gate ebeveyn için iyi sinyal. |
| Colorino: Kids Coloring Book | Google Play | 2-5 yaş, ad-free, no trackers, 168 hand-drawn SVG page, tap-to-fill | In-app purchases; Teacher Approved | Türk geliştirici ve güçlü içerik hacmi var; tap-to-fill küçük çocuk için avantaj. |
| Colors & Shapes: Coloring game | Google Play | Renk/şekil öğrenme, no ads, 100% free | Ücretsiz; 10M+ indirme | Eğitim + oyun tarafında çok güçlü dağıtım; renk karışımı mini oyun için çıta yüksek. |
| Drawing for Kids - Baby Games / Bimi Boo | App Store + Google Play | 2-5 yaş, 176 coloring pages, 11 themes, offline, no ads | Free + IAP; büyük marka | Büyük dağıtım ve marka avantajı var; bizim küçük ürünün niş ve kalite netliği şart. |
| Pop Drawing | Google Play | 2-5 yaş, ad-free, multi-color pop animation, interactive delight | Ücretsiz/mağaza modeline bakılmalı | "Heyecanlandıran" animasyon/delight sinyali için iyi rakip örneği. |

### Sprint Çıktısı

- Rakipler benzer güven vaatlerini zaten kullanıyor: no ads, offline, no tracking, parent gate, simple interface.
- İçerik hacmi önemli rekabet alanı: 100+ sayfa, 11 tema, 168/176 sayfa gibi güçlü iddialar var.
- Küçük SLC'mizin ilk farkı içerik sayısı değil; gerçek 4-5 yaş saha doğrulaması, sade güven, hızlı çizim hissi ve renk karışımı gibi eğitim/heyecan döngüsü olmalı.
- Tap-to-fill rakiplerde sık; mevcut serbest çizim küçük çocuk için zor gelebilir. Playtestte mutlaka "parmakla çizmek mi, dokunup doldurmak mı?" gözlenmeli.
- Ücretli model için tek seferlik unlock ebeveyn güvenine daha uygun görünüyor; abonelik daha sonra ayrıca test edilmeli.

## Commercial Validation Gate

### Şu Anki Durum
- Durum: İlk varsayım var; ödeme isteği kanıtlanmadı.
- Varsayım: Ebeveyn güvenilir, reklamsız ve faydalı çocuk içeriğine düşük/orta fiyat veya tek seferlik unlock ödeyebilir, ancak bu saha/rakip fiyat verisiyle kanıtlanmalı.

### Cevaplanacak Sorular
- Kim para öder: Türkiye ebeveyni mi, global/İngilizce pazar mı, anaokulu çevresi mi?
- Kullanım sıklığı yeterli mi: çocuk haftada kaç kez boyama açar?
- İçerik yenileme maliyeti ve ebeveynin ödeme isteği dengeli mi?
- 100, 500 ve 1000 ücretli kullanıcıda gelir/maliyet/bakım kabaca nasıl görünür?
- App store keşfi, görsel kalite, isim ve ikon ilk indirme kararını nasıl etkiler?

## AI Substitution Gate

### Şu Anki Durum
- Durum: İlk değerlendirme yapıldı.
- İlk değerlendirme: Ebeveyn tek promptla boyama sayfası üretebilir veya bazı uygulamalarda fotoğraf/drawing import kullanabilir, ancak 4-5 yaş çocuk için güvenli, reklamsız, dokunmatik, sürekli ve ebeveyn kontrollü oyun deneyimini tek promptla veremez.

### Savunulabilir Değer Adayları
- Çocuk için hazır ve güvenli etkileşim.
- Ebeveynin teknik uğraşmadan güvenilir içerik vermesi.
- Saha doğrulamalı karakter/isim/tasarım.
- Düzenli içerik yenileme.
- İleride gizlilik kontrollü fotoğrafı boyama sayfasına çevirme.

## SLC Gate

### SLC Adayı

4-5 yaş çocuk için reklamsız, saha doğrulamalı karakter/tema taşıyan, 3-5 güvenli görselle çalışan, renk paleti/silgi/temizle/geri dön akışı tamamlanmış basit boyama uygulaması.

### Kilitli SLC Kararı
- Karar: İlk SLC sadece boyama çekirdeği olacak.
- Kapsam dışı: Mini oyun sonraki fazlara bırakıldı.
- Kaynak: 2026-05-19 kullanıcı kararı.

### İlk Çocuk Akışı
1. Çocuk uygulamayı açar ve büyük görselli ana ekrandan boyama seçer.
2. 3-5 güvenli boyama görselinden birine dokunur.
3. Büyük renk paletinden renk seçer ve görseli boyar.
4. Gerekirse silgi, temizle veya geri dön aksiyonunu kullanır.
5. Yeni görsele geçer veya aynı görseli yeniden boyar.

### İlk İçerik Seti
- 3-5 hazır boyama sayfası.
- Korkutucu olmayan, yumuşak çizgili ve okul öncesine uygun tema.
- Saha doğrulamasından geçen ana karakter/tema yönü.
- Yazıya bağımlı olmayan büyük seçim kartları.

### Simple
- Tek ana iş: çocuk bir görsel seçer ve boyar.
- İlk sürümde mini oyun, ödeme, AI fotoğraf ve büyük içerik mağazası yoktur.

### Lovable
- Karakter/isim/tasarım 4-5 yaş çocuklarda sempatiklik sinyali vermeli.
- Ebeveyn ilk bakışta reklamsız ve güvenli hissi almalı.
- Görsel dünya korkutucu, karmaşık veya ucuz hissettirmemeli.

### Complete
- Çocuk ana ekrandan boyama seçip boyamayı bitirebilmeli.
- Temel araçlar eksiksiz olmalı: renk, silgi, temizle, geri dön.
- Uygulama internete, reklama veya hesap açmaya ihtiyaç duymadan ilk işi yapabilmeli.

## SLC Genişleme Adayı: Renk Karışımı Mini Oyunu

### Eğitim Kazancı
- Ana kazanım: Çocuk iki rengin karışınca üçüncü bir renge dönüşebileceğini görür.
- Örnekler: kırmızı + sarı = turuncu, mavi + sarı = yeşil, kırmızı + mavi = mor.
- Ebeveyn değeri: "Sadece oyalayan oyun" değil, renk bilgisi ve neden-sonuç ilişkisi öğreten etkinlik.

### Oyun Motivasyonu
- Çocuk doğru karışımı bulunca yıldız, ses veya küçük kutlama alır.
- 3 doğru karışım sonrası yeni boyama sayfası veya yeni renk rozeti açılabilir.
- Ebeveyn geri bildirimi: Oyun sadece sakin boyama değil, çocuğu heyecanlandıran bir hedef ve merak döngüsü de taşımalı.
- Heyecan döngüsü basit olmalı: kısa görev, karışım animasyonu, sonuç rengi, doğru nesneyi boyama, yıldız/rozet, yeni görev.
- Başarısızlık sert cezalandırılmaz; "bir daha deneyelim" döngüsü kullanılır.

### Scope Notu
- İlk boyama SLC tamamlandıktan ve playtest düzeltmeleri alındıktan sonra ele alınmalı.
- Mini oyun ayrı karmaşık sistem değil, boyama akışına bağlı tek ekranlık öğrenme görevi olmalıdır.

## Devil's Advocate / Kill Report

### Açık Karşı Argümanlar
- Çocuk boyama pazarı kalabalık olabilir; iyi ürün yapmak tek başına keşif ve indirme getirmeyebilir.
- Ebeveynler çocuk uygulamasına düşük fiyat bile ödemek istemeyebilir.
- Reklamsız model gelir üretmeyi zorlaştırabilir.
- Karakter/isim yanlış seçilirse oyun iyi olsa bile ilk izlenimde kaybedebilir.
- İçerik yenileme düzenli emek ister; sürdürülemezse vaat boşa düşer.
- Genel AI araçları ebeveyne kişisel boyama sayfası üretebilir; ürün değeri sadece AI çizim olursa savunmasız kalır.
- Büyük rakiplerin çok sayfa, çok tema, no ads/offline/no tracking vaatleri zaten var; sadece "güvenli boyama" tek başına güçlü farklılaşma olmayabilir.
- Tap-to-fill deneyimi küçük çocuk için serbest çizimden daha tatmin edici olabilir; mevcut SLC bu açıdan playtestte zayıf çıkabilir.

### İlk Karar
- Karar: Research More.
- Neden: Ürün yönü güçlü; hızlı sprint rakip kalabalığını ve güven vaatlerinin yaygın olduğunu gösterdi. Çocuk çekiciliği, tap-to-fill ihtiyacı, ödeme isteği ve dağıtım hâlâ kanıtlanmadı.
- Sıradaki güvenli adım: Phase 2A playtestte çizim hissi, renk değiştirme, sıkılma ve "heyecan" sinyalini topla; ardından Phase 2C renk karışımı mini oyunu veya tap-to-fill düzeltmesi arasında karar ver.
