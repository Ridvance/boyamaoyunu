# UX_ARCHITECTURE.md - Kullanıcı Deneyimi Mimarisi

> Son güncelleme: 2026-05-19

## Ana Kullanıcı

Ana kullanıcı 4-5 yaş okul öncesi çocuktur. Satın alma ve güven kararı ebeveyndedir.

## Temel Ekran İlkesi

Çocuk ekranında az seçenek, büyük dokunma alanları, net görseller ve yazıya bağımlı olmayan akış kullanılmalıdır. Ebeveyn ayarları çocuk akışından ayrılmalı ve çocuk tarafından yanlışlıkla açılması zor olmalıdır.

## Aksiyon Disiplini

- Buton varsa gerçek davranışı olmalı.
- Çocuk alanında metin az, görsel geri bildirim güçlü olmalı.
- Hata ve izin istekleri çocuk ekranında değil ebeveyn alanında ele alınmalı.
- Satın alma, dış link, fotoğraf yükleme ve ayarlar ebeveyn kapısı arkasında olmalı.

## Görsel Karakter

- Sıcak, sade, yumuşak ama profesyonel çocuk estetiği.
- Korkutucu, çirkin, agresif veya karanlık karakterler yok.
- Tek renge boğulmuş, ucuz görünen UI yok.
- Okul öncesi için sakin ve anlaşılır görsel yoğunluk.
- Karakter ve isim seçimi AI'ın tek başına vereceği karar değildir; 4-5 yaş çocuklara 4-5 seçenek gösterilip hangisine yaklaştıkları, hangisini sempatik buldukları ve hangi ismi yakıştırdıkları gözlenmelidir.

## Ana Ekranlar

- Çocuk ana ekranı: büyük oyun/boyama seçimleri.
- Boyama ekranı: çizim alanı, renk seçimi, silgi, geri al, temizle.
- Mini oyun ekranı: basit eşleştirme veya renk/şekil görevi.
- Ebeveyn alanı: güvenlik, içerik paketleri, ileride fotoğraf yükleme.

## Ana Akışlar

- Çocuk uygulamayı açar, boyama seçer, renklendirir, kaydeder veya yeni resme geçer.
- Ebeveyn yeni içerik paketini açar veya ileride fotoğraf yükleyip boyama sayfası üretir.
- İlk SLC'de ana akış sadece boyama ve gerekirse tek basit mini oyunla sınırlanabilir.

## Stitch Design Brief

- Ürün: 4-5 yaş çocuklar için reklamsız boyama ve mini oyun uygulaması.
- Hedef kullanıcı: Okul öncesi çocuk ve güven arayan ebeveyn.
- Platform: Mobile.
- Tasarım karakteri: Sade, güven veren, sıcak, çocuk dostu, rahatsız edici karakterlerden uzak.
- Ana ekranlar: Çocuk ana ekranı, boyama ekranı, mini oyun ekranı, ebeveyn alanı.
- Kaçınılacak tasarım davranışları: Reklam hissi, karmaşık menüler, korkutucu karakterler, küçük yazılar, dış linkler, satın alma baskısı.

## Stitch Prompt Kaynakları

- Kullanılacak ürün/UX kararları: `brain/PROJECT.md`, `brain/VISION.md`, `brain/CURRENT_PHASE.md`.
- Karakter/isim doğrulama kaynağı: `brain/FIELD_RESEARCH.md`.
