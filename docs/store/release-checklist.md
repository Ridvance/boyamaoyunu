# Store Release Checklist

> Son güncelleme: 22 Haziran 2026

## Hazır

- [x] Kanonik ürün adı tüm platformlarda aynı.
- [x] Google Play başlık, kısa ve uzun açıklama hazır.
- [x] App Store ad, alt başlık, promotional text, açıklama ve keywords hazır.
- [x] Privacy Policy URL canlı ve HTTP 200 doğrulandı.
- [x] Geçici Support URL canlı ve HTTP 200 doğrulandı; gizlilik sayfasındaki iletişim e-postasını kullanır.
- [x] Ayrı `support.html` sayfası repoda hazır.
- [x] Google Families/Target Audience taslağı hazır.
- [x] Google Data Safety taslağı hazır.
- [x] Apple Kids Category/App Privacy taslağı hazır.
- [x] 512 × 512 Google Play ikonu hazır.
- [x] 1024 × 500 Google Play feature graphic hazır.
- [x] 1024 × 1024 App Store ikonu hazır.
- [x] 2688 × 1242 telefon ekran görüntüleri hazır.
- [x] 2732 × 2048 iPad ekran görüntüleri hazır.
- [x] Sürüm notları hazır.

## Hesap Sahibi / Phase 2P Bekleyen

- [ ] `support.html` GitHub Pages'a deploy edildikten sonra HTTP 200 doğrula ve Support URL'yi ayrı sayfaya geçir.
- [ ] Play Console'da uygulama erişimi, hedef kitle, Data Safety ve IARC formlarını taslaktan gir.
- [ ] App Store Connect'te Kids Category, yaş derecesi ve App Privacy yanıtlarını taslaktan gir.
- [ ] Android fiziksel cihaz matrisi ve kapalı testi tamamla.
- [ ] İmzalı iOS archive/TestFlight üret ve iPhone/iPad smoke tamamla.
- [ ] Store ekran görüntülerini fiziksel cihaz görünümüyle karşılaştır.
- [ ] P0/P1 açık hata olmadığını doğrula.
- [ ] Kullanıcı açık onayı olmadan public publish yapma.

## Phase 2P Ara Sonuç

- [x] iPhone 11 Pro Max simulator küçük yatay ekran overflow bulgusu dar fix ve regresyon testiyle kapatıldı.
- [x] iPad Pro 13-inch simulator native yatay ana ekran smoke tamamlandı.
- [x] Final Android AAB ve iOS no-codesign release buildleri yeniden doğrulandı.
- [ ] Play Console hesabı/uygulama erişimi sağla; mevcut oturum kayıt sayfasına yönleniyor.
- [ ] App Store Connect oturumu ve signing erişimi sağla; mevcut oturum giriş sayfasına yönleniyor.
- [ ] 10-20 kapalı test katılımcısı ve 2-5 çocuk/ebeveyn gözlemi tamamla.
