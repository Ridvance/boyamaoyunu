# STORE_READINESS_PLAN.md - Mağaza Hazırlık Planı

> Son güncelleme: 2026-06-21

## Karar

Uygulama prototip seviyesini geçti. Android imzalı AAB ve iOS no-codesign release build üretilebilmektedir; ancak kapalı test, gerçek cihaz QA, imzalı iOS archive ve sonraki mağaza kapıları tamamlanmadan herkese açık yayına hazır değildir. Birleşik ilerleme, ebeveyn kontrolleri, alışkanlık ve öğrenme paketi derinliği tamamlandı; sıradaki ürün sınırı çekirdek oyun içerik dengesidir.

## Denetim Kanıtı

- `flutter analyze`: temiz.
- `flutter test --reporter expanded`: 29 test geçti.
- Android release AAB: başarılı, yaklaşık 23.5 MB.
- Android release manifest: `targetSdkVersion=35`, `minSdkVersion=21`.
- Android release signing: `key.properties` ve upload keystore mevcut; imzalı AAB üretildi.
- iOS release no-codesign build: başarılı; minimum hedef 13.0.
- Balon Patlatma ilerlemesi `balloon` chapter'ına yazılıyor ve regresyon testiyle korunuyor.
- Sekiz chapter kimliği benzersiz; tamamlanma/yıldız, çocuk rozetleri ve ebeveyn kontrolleri Phase 2L'de tamamlandı.
- İçerik tabanı: 7 boyama sayfası, 8 çiz takip şablonu, 12 şekil, 4 Renk Laboratuvarı modu, 3 alışkanlık görevi, 1 öğrenme paketi.
- Kalıcı ilerleme altyapısı mevcut fakat oyunların gerçek bölüm derinliğini tutarlı göstermiyor.
- Mağaza ekran görüntüsü, feature graphic, açıklama paketi ve destek materyalleri repo içinde hazır değil.
- Kanonik ürün adı Android, iOS, Flutter, web ve gizlilik yüzeylerinde `Ninnice Çocuk Oyunları` olarak hizalandı.
- Uygulama içi audit tarayıcısı bu oturumda kullanılamadığı için ekran görüntüsüne dayalı tam görsel QA tamamlanmadı.
- Yerel `master`, `origin/master` üzerinde `3907fe7` commit'iyle 1 commit ilerideydi; yeni çalışma bu commit'i korumalıdır.

## Sıralı Fazlar

1. Phase 2K: Yayın engelleri ve platform baseline.
2. Phase 2L: Birleşik ilerleme yolculuğu ve ebeveyn kontrolleri.
3. Phase 2M: Alışkanlıklar ve öğrenme paketlerinde içerik derinliği.
4. Phase 2N: Boyama, çiz takip, balon ve Sinek Avı içerik dengesi.
5. Phase 2O: Mağaza metadata, uyumluluk ve görsel varlık paketi.
6. Phase 2P: Gerçek cihaz QA, Google Play kapalı test ve TestFlight smoke.

## Yayın Eşiği

Herkese açık yayına geçmek için:

- Android AAB ve iOS archive üretilebilir olmalı.
- P0/P1 açık hata bulunmamalı.
- İlerleme chapter'ları doğru ve restart sonrası kalıcı olmalı.
- İsim, gizlilik politikası ve mağaza beyanları uygulamayla tutarlı olmalı.
- Telefon/tablet cihaz matrisi geçmeli.
- En az 2-5 çocuk/ebeveyn gözlemi ve Google Play kapalı test geri bildirimi değerlendirilmiş olmalı.
- `brain/RELEASE.md` içinde açık `GO` kararı yazılmalı.

## Ürün Yönü

İlk mağaza sürümü, yeni ana oyunlar eklemek yerine “reklamsız, çevrimdışı, Kamo karakterli okul öncesi mini oyun yolculuğu” olarak odaklanmalıdır. İçerik artışı sayısal şişirme değil; farklı beceri, görev ve bölüm davranışı üretmelidir.
