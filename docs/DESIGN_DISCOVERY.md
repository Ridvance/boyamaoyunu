# DESIGN_DISCOVERY.md - Tasarım Keşfi ve UI/UX Mimari Rehberi

## 1. Giriş ve Tasarım Felsefesi
4-5 yaş grubu okul öncesi çocukların dijital bir arayüzle etkileşimi, yetişkinlerden tamamen farklı bilişsel ve fiziksel kurallara tabidir. Bu döküman, "Çocuk Oyun" uygulamasının ilk sürümü (First SLC) için çocuk dostu, güvenli, sezgisel ve eğlenceli bir görsel dil ve etkileşim mimarisi tanımlar.

### Temel Tasarım İlkeleri
- **Sıfır Yazı (Zero-Text UI):** Hedef kitle okuma bilmediği için arayüzde hiçbir yazılı yönlendirme kullanılmayacaktır. Tüm işlevler ikonlar, renkler ve animasyonlarla anlatılacaktır.
- **Düşük Bilişsel Yük:** Ekrandaki eleman sayısı minimumda tutulacak, dikkat dağıtıcı süslemelerden kaçınılacaktır.
- **Hata Toleransı:** Çocukların istemsiz dokunuşları (avuç içi basması, çoklu dokunma) çizim motoru tarafından tolere edilecek, yanlışlıkla uygulamadan çıkma veya boyamayı kaybetme riskleri sıfırlanacaktır.

---

## 2. Pedagojik UI/UX Kararları

### 2.1. Etkileşim Mekaniği: Dokun ve Boya (Tap-to-Fill)
- **Neden:** 4-5 yaşındaki çocukların ince motor becerileri (kalemle hassas çizgi çizme) henüz gelişim aşamasındadır. Serbest çizim bu yaşta ekran üzerinde hızlıca hayal kırıklığına yol açabilir.
- **Nasıl:** Çocuk paletten bir renk seçer ve boyama şablonundaki kapalı bir alana dokunur. Dokunulan alan Flutter `CustomPainter` ve sınır tespiti algoritmasıyla anında seçilen renkle doldurulur.

### 2.2. Fiziksel Hedef Boyutları (Butonlar ve Kontroller)
- **Minimum Dokunma Alanı:** Çocukların parmak koordinasyonu zayıf olduğu için tüm butonlar en az **64x64 dp** (ideal olarak 80x80 dp) boyutunda olacaktır.
- **Geniş Boşluklar (Padding):** Butonlar arasında yanlış dokunmaları önlemek için en az **16 dp** boşluk bırakılacaktır.

### 2.3. Ekran Düzeni (Layout) ve Yönelim
- **Yönelim:** Uygulama sadece **Yatay (Landscape)** modda çalışacaktır. Bu yönelim, boyama alanı için en geniş ve ergonomik tableti/telefonu iki elle tutma alanını sağlar.
- **Sol/Sağ Palet Yerleşimi:** Renk paleti ekranın sağ veya sol kenarına dikey olarak yerleştirilecektir. Bu sayede çocuk cihazı iki eliyle tutarken başparmaklarıyla renklere kolayca erişebilir.
- **Üst Kontrol Barı:** Geri al (Undo), İleri al (Redo) ve Temizle (Reset) gibi sistem butonları ekranın üst kısmında, boyama alanından uzak tutularak yanlışlıkla basılması engellenecektir.

---

## 3. Çocuk Dostu Renk Paleti (6-8 Renk)
Karar yorgunluğunu önlemek için ilk aşamada sınırlı, yüksek kontrastlı ve canlı renklerden oluşan bir palet seçilmiştir:

| Renk Adı | Hex Kodu | Psikolojik / Pedagojik Etki |
| :--- | :--- | :--- |
| **Neşeli Kırmızı** | `#FF4B4B` | Dikkat çekici, enerji verici, birincil nesneler için ideal. |
| **Deniz Mavisi** | `#2B86FF` | Sakinleştirici, gökyüzü ve su elementleri için doğal tercih. |
| **Güneş Sarısı** | `#FFD000` | Mutluluk ve yaratıcılık tetikleyici, yüksek görünürlük. |
| **Doğa Yeşili** | `#2ECC71` | Huzurlu, dengeleyici, çevre ve ağaç boyamaları için. |
| **Turuncu Balon**| `#FF8E2B` | Arkadaş canlısı, sıcak, iştah ve heyecan uyandırıcı. |
| **Tatlı Pembe** | `#FF76B8` | Sevimli, yumuşak, hayal gücünü destekleyici. |
| **Gece Moru** | `#8E44AD` | Gizemli, sanatsal derinlik sağlayan renk. |
| **Arka Plan Krem**| `#FFFBF2` | Gözü yormayan, kağıt hissi veren yumuşak arka plan rengi. |

---

## 4. Güvenli Alan Tasarımı (Safety by Design)

### 4.1. Ebeveyn Kilidi (Parental Gate)
Uygulama içinde ebeveynlerin şablon değiştirmesi veya (ileride eklenebilecek) ayarlara erişmesi gerekirse, çocukların geçemeyeceği bir güvenlik kapısı tasarlanmıştır:
- **Mekanik:** Ekran üzerinde beliren basit bir matematiksel işlem veya görsel desen eşleştirme sorusu.
- **Örnek:** "Üç parmağınla ekrana 3 saniye boyunca basılı tut" veya "8, 3, 5 sayılarını sırasıyla tuşla" (yazılı değil, sesli veya büyük rakam ikonlarıyla).

### 4.2. Dış Bağlantı ve Reklam İzolasyonu
- UI üzerinde hiçbir web linki, sosyal medya ikonu veya harici mağaza yönlendirmesi bulunmayacaktır.
- Yanlışlıkla tıklanabilecek hiçbir "banner" veya "interstitial" alan tasarıma dahil edilmemiştir.

---

## 5. Görsel ve İşitsel Geri Bildirimler (Feedback)

- **Dokunma Efekti (Splash):** Çocuk bir alana dokunduğunda, dokunma noktasından dışarıya doğru hafif bir konfeti veya yıldız patlaması efekti (particle effect) yayılacaktır.
- **Seçim Belirginliği:** Aktif olan renk butonu, diğerlerine göre daha büyük görünecek ve etrafında hafif bir parlama (glow) efekti olacaktır.
- **Başarı Kutlaması:** Boyama tamamen bittiğinde (tüm alanlar renklendirildiğinde) ekranda sevimli bir karakter belirecek ve hafif bir alkış/balon uçurma animasyonu tetiklenecektir.