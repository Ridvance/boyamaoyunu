# VALIDATION.md - Araştırma ve Ticari Doğrulama

> Son güncelleme: 2026-05-19
> Rol: Research, commercial validation, AI substitution, SLC ve kill report kapılarını proje özelinde tutar.

## Kullanma Kuralı

- Bu dosya execution planı değildir; aktif iş yine `CURRENT_PHASE.md` içinden yürür.
- Kod yazmadan veya uzun execution'a geçmeden önce bu kapıların en az hızlı tarama seviyesinde cevaplanması gerekir.
- Çocuk güvenliği, ebeveyn güveni, karakter/isim saha doğrulaması ve dağıtım gerçekliği ticari doğrulamanın parçasıdır.

## Research Gate

### Şu Anki Durum
- Durum: Açık.
- Derinlik: Hızlı tarama öneriliyor; uzun execution veya ücretli model öncesi deep research gerekir.

### Cevaplanacak Sorular
- Google Play/App Store'da okul öncesi boyama oyunlarında başlıca rakipler kim?
- Rakiplerin reklam, abonelik, tek seferlik ödeme ve içerik yenileme modelleri ne?
- Hangi rakipler ebeveyn güvenini iyi anlatıyor?
- Hangi rakiplerin karakter/tasarım dili çocukları çekiyor ama ebeveyni rahatsız etmiyor?
- Rakiplerin zayıf yorumları neler: reklam, kilitli içerik, korkutucu karakter, sıkılma, teknik hata?

## Commercial Validation Gate

### Şu Anki Durum
- Durum: Açık.
- Varsayım: Ebeveyn güvenilir ve faydalı çocuk içeriğine düşük/orta fiyat ödeyebilir, ancak kanıtlanmadı.

### Cevaplanacak Sorular
- Kim para öder: Türkiye ebeveyni mi, global/İngilizce pazar mı, anaokulu çevresi mi?
- Kullanım sıklığı yeterli mi: çocuk haftada kaç kez boyama açar?
- İçerik yenileme maliyeti ve ebeveynin ödeme isteği dengeli mi?
- 100, 500 ve 1000 ücretli kullanıcıda gelir/maliyet/bakım kabaca nasıl görünür?
- App store keşfi, görsel kalite, isim ve ikon ilk indirme kararını nasıl etkiler?

## AI Substitution Gate

### Şu Anki Durum
- Durum: Açık.
- İlk değerlendirme: Ebeveyn tek promptla boyama sayfası üretebilir, ancak 4-5 yaş çocuk için güvenli, reklamsız, dokunmatik, sürekli ve ebeveyn kontrollü oyun deneyimini tek promptla veremez.

### Savunulabilir Değer Adayları
- Çocuk için hazır ve güvenli etkileşim.
- Ebeveynin teknik uğraşmadan güvenilir içerik vermesi.
- Saha doğrulamalı karakter/isim/tasarım.
- Düzenli içerik yenileme.
- İleride gizlilik kontrollü fotoğrafı boyama sayfasına çevirme.

## SLC Gate

### SLC Adayı

4-5 yaş çocuk için reklamsız, saha doğrulamalı karakter/tema taşıyan, 3-5 güvenli görselle çalışan, renk paleti/silgi/temizle/geri dön akışı tamamlanmış basit boyama uygulaması.

### Simple
- Tek ana iş: çocuk bir görsel seçer ve boyar.
- İlk sürümde mini oyun, ödeme, AI fotoğraf ve büyük içerik mağazası zorunlu değildir.

### Lovable
- Karakter/isim/tasarım 4-5 yaş çocuklarda sempatiklik sinyali vermeli.
- Ebeveyn ilk bakışta reklamsız ve güvenli hissi almalı.
- Görsel dünya korkutucu, karmaşık veya ucuz hissettirmemeli.

### Complete
- Çocuk ana ekrandan boyama seçip boyamayı bitirebilmeli.
- Temel araçlar eksiksiz olmalı: renk, silgi, temizle, geri dön.
- Uygulama internete, reklama veya hesap açmaya ihtiyaç duymadan ilk işi yapabilmeli.

## Devil's Advocate / Kill Report

### Açık Karşı Argümanlar
- Çocuk boyama pazarı kalabalık olabilir; iyi ürün yapmak tek başına keşif ve indirme getirmeyebilir.
- Ebeveynler çocuk uygulamasına düşük fiyat bile ödemek istemeyebilir.
- Reklamsız model gelir üretmeyi zorlaştırabilir.
- Karakter/isim yanlış seçilirse oyun iyi olsa bile ilk izlenimde kaybedebilir.
- İçerik yenileme düzenli emek ister; sürdürülemezse vaat boşa düşer.
- Genel AI araçları ebeveyne kişisel boyama sayfası üretebilir; ürün değeri sadece AI çizim olursa savunmasız kalır.

### İlk Karar
- Karar: Research More.
- Neden: Ürün yönü güçlü ama rakip/fiyat/dağıtım ve çocuk çekiciliği henüz kanıtlanmadı.
- Sıradaki güvenli adım: SLC kapsamını kilitle, ardından karakter/isim saha testi ve hızlı rakip taraması yap.
