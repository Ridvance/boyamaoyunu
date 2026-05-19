# RISKS.md - Risk Haritası

> Son güncelleme: 2026-05-19
> Rol: Agent'ın dikkat etmesi gereken teknik, operasyonel ve güvenlik risklerini tutar.

## Riskler

### Fazla Planlama
- Alan: Ürün yürütme.
- Risk: Uygulama çıkmadan sürekli fikir ve plan üretmek.
- Kaçınılacak davranış: Büyük roadmap'i kod başlangıcının önüne koymak.
- Güvenli yaklaşım: İçeride küçük prototip, dışarıda dar SLC, gerçek cihaz ve çocuk testi.
- Test/doğrulama: İlk oynanabilir sürümün gerçekten kurulup denenmesi.

### Çocuk Verisi ve Fotoğraf
- Alan: Gizlilik.
- Risk: Çocuk fotoğrafı, galeri erişimi veya bulut AI işlemleri hassas veri doğurur.
- Kaçınılacak davranış: Ebeveyn onayı ve gizlilik akışı olmadan fotoğraf özelliği eklemek.
- Güvenli yaklaşım: Fotoğrafı çizime çevirme SLC sonrası ayrı faz ve açık onayla ele alınır.
- Test/doğrulama: İzin akışı, veri saklama ve silme davranışı açıkça test edilir.

### Ticari Doğrulama Eksikliği
- Alan: Pazar ve dağıtım.
- Risk: Rakip, fiyat, ödeme isteği ve app store keşfi doğrulanmadan uzun süre kod yazmak.
- Kaçınılacak davranış: "Boşluk var" varsayımıyla aylarca execution yapmak.
- Güvenli yaklaşım: Hızlı rakip taraması, AI substitution notu ve kill report üretmek.
- Test/doğrulama: `brain/VALIDATION.md` içinde Go/Pivot/Research More kararı.

### Reklam ve Satın Alma Baskısı
- Alan: Çocuk güvenliği.
- Risk: 4-5 yaş çocuk reklam kapatamaz; yanlış satın alma veya dış link riski oluşur.
- Kaçınılacak davranış: Çocuk ekranına reklam, dış link veya satın alma CTA'sı koymak.
- Güvenli yaklaşım: Çocuk alanı reklamsız, ebeveyn alanı ayrı.
- Test/doğrulama: Çocuk akışında dış bağlantı ve ödeme yolu yokluğu manuel kontrol edilir.
