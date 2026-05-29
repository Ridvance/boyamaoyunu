# VISION.md - Ürün Vizyonu ve Hedefleri

## 1. Ürün Vizyonu (Product Vision)
4-5 yaş grubu okul öncesi çocuklar için tamamen güvenli, dikkat dağıtıcı unsurlardan (reklamlar, uygulama içi satın alımlar, dış bağlantılar) arındırılmış, çocukların yaratıcılıklarını ve motor becerilerini geliştirmeye odaklanan saf bir dijital boyama deneyimi sunmak.

## 2. Hedef Kitle (Target Audience)
- **Birincil Kullanıcılar:** 4-5 yaş arası okul öncesi çocuklar.
- **Karar Vericiler / Alıcılar:** Çocukları için güvenli, eğitici ve reklamsız ekran süresi arayan ebeveynler.

## 3. Çözülen Ana Problem (Core Problem)
Mevcut mobil oyun pazarındaki çocuk uygulamalarının büyük bir kısmı agresif reklamlar, çocukların yanlışlıkla tıklayabileceği dış bağlantılar, karmaşık arayüzler ve gizli ödeme duvarları içerir. Ebeveynler, çocuklarına güvenle teslim edebilecekleri, internet bağlantısı gerektirmeyen ve tamamen izole bir oyun alanı bulmakta zorlanmaktadır.

## 4. İlk Sürüm Kapsamı (First SLC - Simple Lovable Complete)
- **Temel Boyama Çekirdeği:** Kolay anlaşılır, büyük butonlu ve çocuk dostu boyama arayüzü.
- **Sınırlı ve Seçkin Palet:** Çocukların kafasını karıştırmayacak temel renk seçenekleri.
- **Reklamsız ve Çevrimdışı:** Tamamen reklamsız, internet gerektirmeyen çalışma yapısı.
- **Güvenli Alan:** Ebeveyn kontrolü dışında hiçbir dış link veya ayar menüsü bulunmaması.

## 5. Kapsam Dışı (Out of Scope - Gelecek Fazlar)
- Mini oyunlar ve ek aktiviteler.
- Reklam entegrasyonu ve analiz araçları (çocuk gizliliği için).
- Uygulama içi satın alımlar ve abonelik modelleri.
- Fotoğraftan boyama şablonu üreten yapay zeka (AI) özellikleri.
- Kamera ve cihaz galerisine erişim izinleri.

## 6. Araştırma ve Doğrulama (Research & Validation)
### 6.1. Pedagojik ve UX Doğrulaması (4-5 Yaş)
- **Motor Beceriler:** Bu yaş grubundaki çocuklar ince motor becerilerini (kalem tutma vb.) yeni geliştirmektedir. Bu nedenle serbest çizim yerine "Dokun ve Boya" (Tap-to-fill) mekanizması birincil yöntem olarak seçilmiştir. Büyük dokunma alanları ve belirgin sınırlar kullanılacaktır.
- **Bilişsel Yük:** Karmaşık renk paletleri karar yorgunluğuna yol açar. İlk aşamada 6-8 arası temel ve canlı renk sunulacaktır. Yazılı metin yerine tamamen görsel/işitsel ikonlar kullanılacaktır.

### 6.2. Güvenlik ve Mevzuat Uyumluluğu (COPPA & GDPR-K)
- Uygulama sıfır veri toplama, sıfır izleme ve sıfır dış bağlantı prensibiyle çalışır. Bu sayede COPPA ve GDPR-K standartlarına %100 uyumludur. Ebeveynlerin en büyük endişesi olan veri gizliliği tamamen çözülmüştür.

### 6.3. Rakip Analizi ve Benzersiz Değer Önerisi (USP)
- **Rakipler:** Mevcut rakipler (örn. Coloring Book for Kids vb.) ücretsiz görünse de yoğun reklam ve "yanlışlıkla tıklama" tuzakları barındırır.
- **USP (Unique Selling Proposition):** "Sıfır Reklam, Sıfır İnternet, %100 Güvenli ve İzole Dijital Boyama Kitabı".

## 7. Tasarım ve Etkileşim Standartları (Design & Interaction Standards)
`docs/DESIGN_DISCOVERY.md` dökümanından türetilen ve vizyonu destekleyen temel tasarım kararları:
- **Sıfır Yazı (Zero-Text UI):** Okuma bilmeyen çocuklar için tamamen ikonik ve renk odaklı arayüz.
- **Fiziksel Hedef Boyutları:** Yanlış dokunmaları önlemek için minimum **64x64 dp** (ideal olarak 80x80 dp) buton boyutları ve en az **16 dp** boşluk (padding).
- **Yönelim (Orientation):** Sadece **Yatay (Landscape)** mod desteği ile maksimum çizim alanı ve ergonomik çift el tutuşu.
- **Ebeveyn Kilidi (Parental Gate):** Çocukların geçemeyeceği, rastgele üretilen matematiksel veya desen eşleştirme soruları ile korunan güvenli geçiş kapısı.
- **Renk Paleti (8 Canlı Renk):**
  - Neşeli Kırmızı (`#FF4B4B`)
  - Deniz Mavisi (`#2B86FF`)
  - Güneş Sarısı (`#FFD000`)
  - Doğa Yeşili (`#2ECC71`)
  - Turuncu Balon (`#FF8E2B`)
  - Tatlı Pembe (`#FF76B8`)
  - Gece Moru (`#8E44AD`)
  - Arka Plan Krem (`#FFFBF2`)
