# Google Play Compliance Draft

> Taslak tarihi: 22 Haziran 2026. Play Console'da nihai gönderim değildir.

## Target Audience And Content

- Hedef yaş grubu: `Ages 5 & Under`.
- Daha büyük çocuk veya yetişkin hedef grubu seçme: Hayır; ürün 1-5 yaşa göre tasarlanmıştır.
- Çocuklara hitap eden görsel/terminoloji: Evet.
- Reklam: Yok.
- Uygulama içi satın alma: Yok.
- Sosyal özellik, sohbet veya kullanıcı üretimli içerik: Yok.
- Hassas izinler: Release manifestinde konum, kamera, mikrofon, kişi, telefon, Bluetooth veya `AD_ID` izni yok.
- Dış bağlantı: Yalnız gizlilik politikası; ebeveyn kapısı arkasından harici tarayıcıda açılır.

## Families Policy Teknik Kontrolü

- Release uygulaması AAID veya cihaz kimliği istemez ve iletmez.
- Konum izni yoktur.
- Reklam/analitik SDK'sı yoktur.
- Kullanılan native paketler: `audioplayers`, `shared_preferences`, `path_provider`, `url_launcher`.
- `audioplayers` yalnız uygulama içinde üretilen ses byte'larını oynatır; uzak medya URL'si kullanılmaz.
- `shared_preferences` yalnız level/yıldız ve ses/titreşim tercihini cihazda tutar.
- `url_launcher` yalnız ebeveyn kapısı arkasındaki HTTPS gizlilik sayfasını harici tarayıcıda açar.

## Data Safety Taslağı

- Uygulama kullanıcı verisi topluyor veya paylaşıyor mu?: `Hayır`.
- Gerekçe: Ad, e-posta, konum, cihaz kimliği, uygulama etkileşimi veya diğer kullanıcı verileri cihaz dışına iletilmez.
- Yerel ilerleme: Google'ın tanımında cihaz dışına iletilmediği için collection olarak işaretlenmez.
- Üçüncü taraflarla paylaşım: Yok.
- Privacy policy URL: `https://ridvance.github.io/boyamaoyunu/privacy.html`.
- Veri silme: Sunucuda kullanıcı verisi yoktur. Yerel ilerleme ebeveyn panelinden onayla sıfırlanabilir veya uygulama kaldırılarak silinir.

## Content Rating Taslak Sinyalleri

- Şiddet, korku, kumar, cinsellik, kontrollü madde, küfür: Yok.
- Kullanıcı iletişimi veya içerik paylaşımı: Yok.
- Dijital ürün satın alma: Yok.
- Balon patlatma yalnız soyut, renkli ve zarar içermeyen oyun etkileşimidir.

## Resmî Kaynaklar

- Families Policies: https://support.google.com/googleplay/android-developer/answer/9893335
- Data Safety: https://support.google.com/googleplay/android-developer/answer/10787469
- Preview assets: https://support.google.com/googleplay/android-developer/answer/9866151

## Gönderim Öncesi Manuel Onay

Play Console, aktif artifact ve tüm entegre SDK'ları esas alır. Hesap sahibi bu taslağı güncel AAB üzerinde tekrar kontrol etmeli ve yalnız sonra formu göndermelidir.
