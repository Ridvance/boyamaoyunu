# Phase 2P Device And Closed Test Matrix

> Son güncelleme: 22 Haziran 2026
> Karar: `NO-GO PUBLIC` — gerçek cihaz, kapalı test ve saha gözlemi eksik.

## Cihaz Matrisi

| Hedef | Ortam | Sonuç | Kanıt / Eksik |
|---|---|---|---|
| Android telefon 1 | Fiziksel | BLOCKED | Bağlı ADB cihazı yok. |
| Android telefon 2 / kısa yatay | Fiziksel | BLOCKED | Bağlı ADB cihazı yok. |
| Android tablet | Fiziksel | BLOCKED | Bağlı ADB cihazı yok. |
| iPhone 11 Pro Max, iOS 18.4 | Simülatör | PASS AFTER FIX | Native debug açılışında 7,2 px kart overflow bulundu; `< 440` kompakt eşik fixinden sonra console temiz ve yatay yerleşim görsel olarak geçti. Fiziksel cihaz yerine sayılmadı. |
| iPad Pro 13-inch M4, iOS 18.4 | Simülatör | PASS | Native debug açılış, manuel yatay döndürme ve ana grid görsel kontrolü geçti. Fiziksel cihaz yerine sayılmadı. |
| Ekrem 12ProMax | Fiziksel iPhone | BLOCKED | Cihaz kilitli veya Developer Mode kapalı; kablosuz bağlantı hata kodu `-27`. |

## Kritik Akış Durumu

| Akış | Otomatik / simülatör kanıtı | Gerçek cihaz durumu |
|---|---|---|
| İlk açılış ve yatay yerleşim | iPhone/iPad native simulator PASS | Bekliyor |
| Sekiz oyun kartını açma/geri dönme | Widget test PASS | Bekliyor |
| Restart sonrası ilerleme | Service/widget test PASS | Bekliyor |
| Ses/titreşim tercih kalıcılığı | Unit/widget test PASS | Fiziksel ses/titreşim bekliyor |
| Ebeveyn kapısı ve onaylı sıfırlama | Widget test PASS | Fiziksel cihaz bekliyor |
| Offline açılış/oynama | Kod ve otomatik test baseline'ı mevcut | Uçak modunda fiziksel test bekliyor |
| Küçük yatay ekran | Regresyon testi ve iPhone simulator PASS | Kısa Android cihaz bekliyor |

## Kapalı Test / TestFlight

- Google Play Console, mevcut tarayıcı oturumunda `/console/signup` sayfasına yönlendi; 10-20 kişilik kapalı test oluşturulamadı ve AAB yüklenmedi.
- App Store Connect, mevcut tarayıcı oturumunda `/login` sayfasına yönlendi; imzalı archive/TestFlight gönderimi yapılamadı.
- Test katılımcı listesi veya kullanıcıdan onaylı davet adresleri mevcut değil.
- Public publish yapılmadı.

## Doğrulanan P1 Bulgusu

- Bulgu: iPhone 11 Pro Max yatay açılışında dashboard kartları 7,2 px dikey taşıyordu.
- Kök neden: Kompakt layout yalnız `< 400` ekran yüksekliğinde devreye giriyordu; notch/SafeArea öncesi 414 px raporlayan iPhone kompakt sayılmıyordu.
- Fix: Kompakt eşik `< 440` yapıldı.
- Regresyon: `dashboard fits a notched landscape iPhone without overflow` PASS.
- Tekrar test: Aynı iPhone simülatöründe Flutter rendering exception yok; görsel yerleşim temiz.

## Açık Yayın Kapıları

1. İki Android telefon ve bir Android tablette tüm kritik akışları tamamla.
2. Fiziksel iPhone ve mümkünse iPad üzerinde ses/titreşim, offline ve restart smoke yap.
3. Play Console erişimiyle 10-20 kişilik kapalı test çalıştır ve geri bildirimleri değerlendir.
4. App Store Connect erişimiyle imzalı archive/TestFlight smoke yap.
5. 2-5 anonim çocuk/ebeveyn gözlemini tamamla.

