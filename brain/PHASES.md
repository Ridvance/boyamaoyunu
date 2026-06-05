# PHASES.md - Küçük Faz Rotası

> Son güncelleme: 2026-06-05

## Faz Kullanma Kuralı

- Aynı anda sadece `brain/CURRENT_PHASE.md` içindeki faz çalışılır.
- Onaylı yön `SLC/V1/V2/Long-term -> Epic -> Micro Phase` olarak düşünülür.
- Epic'ler doğrudan uygulanmaz; sadece küçük ve test edilebilir micro phase aktif olur.
- Kod değişirse test çalışır.
- Faz sonunda `STATE.md` ve gerekiyorsa `CURRENT_PHASE.md` güncellenir.
- `IDEA_POOL.md` içindeki fikirler kullanıcı onayı olmadan aktif faza taşınmaz.
- Her uygulanabilir micro phase için `PROMPTS/phase-*.md` içinde scope kilitli prompt bulunur.

## Version Architecture

- SLC Epic: Reklamsız boyama çekirdeği ve ebeveyn güvenliği.
- V1 Epic: Playtest düzeltmeleri, karakter/ad doğrulama, hikayeli boyama akışı, renk karışımı mini oyun, değer/alışkanlık mini görevleri ve okul öncesi kazanım paketleri.
- V2 Epic: Ücretli paket, global/İngilizce hazırlığı ve gelişmiş içerik sistemi.
- Long-term Epic: Fotoğrafı güvenli şekilde çizime/boyama sayfasına dönüştürme.

## Onaylı İlk 4 Ürün İşi - Faz Özeti

Kullanıcı 2026-06-04 tarihinde ilk etapta aşağıdaki 4 ürün işinin planlanmasını istedi:

1. Hikayeli Boyama Akışı: Mevcut boyama çekirdeğine kısa, yazısız ve görsel görev hissi eklenir.
2. Renk Karışımı Mini Oyunu: Ana renkleri karıştırarak yeni renk öğrenme döngüsü kurulur.
3. Değer ve Alışkanlık Mini Görevleri: Temizlik, düzen, yardım etme gibi günlük davranışlar kısa oyun görevlerine çevrilir.
4. Okul Öncesi Kazanım Paketleri: Renk, şekil, eşleştirme, sıralama ve temel kavramlar paketlenebilir içerik yapısına alınır.

Sıralama prensibi: Önce mevcut boyama deneyimini hikayeyle güçlendir, sonra tek net öğrenme oyunu ekle, ardından davranış görevlerini dene, en sonda bunları paketlenebilir okul öncesi kazanım sistemine bağla.

## Phase 0 - Brain And Product Framing

### Phase 0A - Brain Structure Setup
- Amaç: Boş projeye brain çalışma belleğini kurmak.
- Scope: Doküman dosyaları.
- Test: `git diff --check`.
- Durum: completed.

### Phase 0B - Discovery To SLC Scope Lock
- Amaç: Konuşmadaki ürün fikrini tek küçük SLC kapsamına indirmek ve karakter/isim/tasarım kararını saha doğrulamasına bağlamak.
- Scope: Hedef kullanıcı, ilk oyun akışı, SLC dışı fikirler, karakter/isim seçenekleri için çocuk geri bildirim planı, research/commercial validation kapıları ve başarı kriterleri.
- Test: `git diff --check`.
- Durum: completed.
- Sonuç: İlk SLC sadece reklamsız boyama çekirdeği olacak; mini oyun sonraki fazlara bırakıldı.

### Phase 0C - Character And Name Field Validation
- Amaç: 4-5 yaş çocuklara ve ebeveynlere 4-5 karakter/isim seçeneği gösterip en çekici yönü doğrulamak.
- Scope: Basit görsel seçenekler, isim seçenekleri, kısa gözlem formu.
- Test: En az 3 çocuk veya ebeveyn/çocuk gözlemiyle not toplama.
- Durum: completed.
- Sonuç: 5 karakter/tema yönü, isim adayları, gözlem formu ve başarı sinyali hazırlandı; nihai karar saha gözlemi sonrası verilecek.

### Phase 0D - Commercial Validation And Kill Report
- Amaç: Çocuk boyama oyunu fikrinin rakip, fiyat, ödeme isteği, dağıtım, AI ikamesi ve zayıf yanlarını hızlı taramayla netleştirmek.
- Scope: 5-10 rakip, fiyat/özellik/dağıtım karşılaştırması, AI substitution notu, kısa kill report, Go/Pivot/Research More kararı.
- Test: Kaynaklı tablo ve `git diff --check`.
- Durum: pending.

## Phase 1 - First Playable App

### Phase 1A - Flutter Scaffold Decision And Setup
- Amaç: Mobil teknoloji kararını verip ilk çalışır proje iskeletini kurmak.
- Scope: Flutter veya seçilecek mobil iskelet, paket adı, temel app shell.
- Test: Platformun oluşturduğu temel test/build komutu.
- Durum: completed.
- Sonuç: Flutter scaffold kuruldu, default sayaç demosu kaldırıldı, temel app shell ve widget testi hazır.

### Phase 1B - Child Home And Coloring SLC
- Amaç: Çocuk ana ekranı ve basit boyama ekranını dar ama tamamlanmış SLC seviyesinde oynanabilir yapmak.
- Scope: Saha doğrulamasından geçen karakter/tema yönü, 3-5 hazır boyama sayfası, renk paleti, silgi, temizle, geri dön. Mini oyun bu fazın scope'una girmez.
- Test: Widget/unit test veya manuel smoke.
- Durum: completed.
- Sonuç: 3 hazır sayfa, çizim kanvası, renk paleti, silgi, temizle ve geri dön akışı çalışır hale getirildi.

### Phase 1C - Parent Safety Shell
- Amaç: Reklamsızlık, dış link yokluğu ve ebeveyn alanı ayrımını netleştirmek.
- Scope: Ebeveyn ayarı/iletişim alanı, çocuk akışından ayrım.
- Test: Manuel çocuk akışı smoke.
- Durum: completed.
- Sonuç: Ebeveyn kapısı ve güvenlik ekranı eklendi; reklam, ödeme, dış link, kamera/galeri yokluğu görünür hale getirildi.

## Phase 2 - Retention And Feedback

### Phase 2A - Child Playtest Feedback Loop
- Amaç: İlk SLC/prototip akışını birkaç çocukla deneyip eksikleri listelemek.
- Scope: Gözlem formu, geri bildirim notları, hızlı düzeltme listesi.
- Scope dışı: Yeni oyun modu geliştirmek, renk karışımı mini oyununu kodlamak, ödeme/reklam/fotoğraf AI eklemek.
- Beklenen dosya etki alanı: `brain/FIELD_RESEARCH.md`, `brain/STATE.md`, gerekirse `brain/HANDOFF.md`.
- Çıkış kriterleri: 2-5 çocuk/ebeveyn gözlem notu veya gözlem yapılamadıysa net blocker; başarı/başarısızlık sinyalleri; sonraki micro phase kararı.
- Test: Gerçek cihazda oynatma.
- Scope Locked Prompt: Mevcut boyama SLC'sini gerçek cihaz/çocuk testi için değerlendir; kod değiştirme; gözlem sonucu olmadan yeni özellik uygulama.
- Durum: active.

### Phase 2B - Content Refresh System
- Amaç: Yeni boyama alanı ve küçük içerik paketlerini düzenli eklenebilir yapmak.
- Scope: Asset/content yapısı.
- Test: Yeni içerik ekleme smoke.
- Durum: pending.

### Phase 2C - Story Coloring Flow
- Amaç: Mevcut boyama ekranını tekil aktiviteden çıkarıp kısa görev hissi veren hikayeli akışa dönüştürmek.
- Scope: 1 küçük hikaye teması, 3 görev adımı, yazısız/ikonlu yönlendirme, görev tamamlanınca kısa görsel kutlama, mevcut boyama sayfalarıyla uyum.
- Scope dışı: Uzun hikaye metinleri, diyalog sistemi, karmaşık seviye haritası, yeni ticari model, büyük karakter evreni.
- Beklenen dosya etki alanı: `lib/main.dart`, ilgili oyun dosyaları, `test/widget_test.dart`, gerekirse `brain/STATE.md`.
- Çıkış kriterleri: Çocuk ne yapacağını metin okumadan anlayabilir; 3 adımlık akış tamamlanır; mevcut boyama SLC bozulmaz.
- Test: `flutter test`, `flutter analyze`, manuel çocuk akışı smoke, `git diff --check`.
- Scope Locked Prompt: Sadece mevcut boyama deneyimine 1 kısa hikayeli görev akışı ekle; yeni mini oyun, ödeme, dış sistem veya büyük refactor ekleme.
- Durum: completed.
- Sonuç: Ev temalı 3 adımlı hikayeli boyama akışı, hedef parça vurgusu ve tamamlanma paneli eklendi.

### Phase 2D - Color Mix Learning Mini Game
- Amaç: Renk karışımıyla yeni renk oluşumunu öğreten, heyecan ve merak hissi veren, boyama akışına bağlı küçük eğitim mini oyunu eklemek.
- Scope: 2 renk seç, karıştır, oluşan renkle doğru nesneyi boya; yıldız/rozet, sürpriz açılma veya kısa seviye ilerlemesiyle çocuğu motive et.
- Scope dışı: Karmaşık seviye sistemi, ödeme/dış link, çok sayıda renk kombinasyonu, ana boyama çekirdeğini bozacak büyük refactor.
- Beklenen dosya etki alanı: `lib/main.dart`, `test/widget_test.dart`, `brain/STATE.md`.
- Çıkış kriterleri: 3 temel karışım çalışır; eğitim kazanımı görünür; kısa ödül/ilerleme vardır; boyama SLC akışı bozulmaz.
- Test: Widget test, manuel çocuk akışı smoke, playtestte çocuğun karışımı anlayıp tekrar deneme isteği ve heyecan sinyali.
- Scope Locked Prompt: Sadece renk karışımı mini oyununu tek ekranlık eğitim/heyecan döngüsü olarak ekle; boyama çekirdeğini bozma; ödeme, dış sistem veya fotoğraf AI ekleme.
- Durum: completed.
- Sonuç: Mevcut Renk Laboratuvarı temel renk karışımı akışı test key'leriyle doğrulandı; kırmızı+sarı=turuncu widget testi eklendi.

### Phase 2E - Values And Habits Mini Tasks
- Amaç: Günlük yaşam değerlerini ve alışkanlıklarını 4-5 yaş çocuğa uygun kısa etkileşim görevleriyle denemek.
- Scope: 3 mikro görev prototipi; oyuncakları yerine koy, dişleri fırçala veya çöpü kutuya at gibi tek eylemli görevler; doğru eylemde kısa görsel/sesli geri bildirim.
- Scope dışı: Metin ağırlıklı öğüt ekranları, puan ekonomisi, ceza sistemi, uzun görev zinciri, okul/öğretmen paneli.
- Beklenen dosya etki alanı: `lib/main.dart`, `lib/games/*`, `test/widget_test.dart`, gerekirse `brain/STATE.md`.
- Çıkış kriterleri: En az 3 görev oynanabilir; çocuk görev hedefini görsel olarak anlayabilir; görevler 30-60 saniyede tamamlanabilir; ana akış karışmaz.
- Test: `flutter test`, `flutter analyze`, manuel smoke, en az 1 ebeveyn/çocuk gözlem notu hedefi.
- Scope Locked Prompt: Sadece 3 kısa değer/alışkanlık görevini prototip olarak ekle; metin ağırlıklı eğitim, karmaşık seviye veya ticari özellik ekleme.
- Durum: completed.
- Sonuç: Oyuncak toplama, diş fırçalama ve çöpü kutusuna atma görevlerini içeren `HabitsGame` eklendi.

### Phase 2F - Preschool Learning Packs
- Amaç: Hikaye, renk karışımı ve mini görevleri okul öncesi kazanım başlıklarına göre paketlenebilir hale getirmek.
- Scope: Renkler, şekiller, eşleştirme/sıralama ve günlük alışkanlıklar için içerik taksonomisi; paket seçimi ekranı; 1 örnek paket.
- Scope dışı: Resmi müfredat uyumu iddiası, öğretmen paneli, ödeme sistemi, geniş içerik kataloğu, canlı içerik indirme.
- Beklenen dosya etki alanı: `lib/main.dart`, içerik model dosyaları, `test/widget_test.dart`, `brain/VALIDATION.md`, gerekirse `brain/STATE.md`.
- Çıkış kriterleri: En az 1 paket uçtan uca seçilip oynanır; içerikler ileride yeni paket eklenebilecek şekilde ayrışır; resmi eğitim iddiaları doğrulama olmadan yazılmaz.
- Test: `flutter test`, `flutter analyze`, paket ekleme smoke, `git diff --check`.
- Scope Locked Prompt: Sadece okul öncesi kazanım paketleri için içerik yapısı ve 1 örnek paket oluştur; ödeme, resmi müfredat iddiası veya geniş katalog ekleme.
- Durum: completed.
- Sonuç: "İlk Beceriler" adlı tek örnek öğrenme paketi eklendi; hikayeli boyama, renk karışımı ve alışkanlık görevleri paket ekranından açılabilir hale getirildi.

### Phase 2G - Mobile Web Fullscreen And Game Hierarchy
- Amaç: Mobil Chrome yatay kullanımda adres çubuğu/üst menü nedeniyle daralan oyun alanını iyileştirmek ve ana ekran/oyun bölümü hiyerarşisini sadeleştirmek.
- Scope: Web fullscreen isteği, PWA landscape/fullscreen manifest ayarı, ana ekranda tam ekran düğmesi, ana ekran kartlarının bölüm sistemiyle ilişkisini netleştiren plan.
- Scope dışı: Native Android/iOS tam ekran paketleme, store yayın ayarları, büyük navigasyon refactor.
- Beklenen dosya etki alanı: `lib/main.dart`, `lib/services/*`, `web/index.html`, `web/manifest.json`, `test/widget_test.dart`, `brain/*`.
- Çıkış kriterleri: Web'de kullanıcı dokunuşuyla fullscreen isteği yapılır; PWA landscape/fullscreen davranışı tanımlıdır; testler geçer.
- Test: `flutter test`, değişen dosyalar için `dart analyze`, `git diff --check`.
- Scope Locked Prompt: Sadece mobil web tam ekran/PWA kullanılabilirliğini ve sıradaki oyun hiyerarşisi planını ekle; büyük oyun refactor veya yeni oyun modu ekleme.
- Durum: completed.
- Sonuç: Ana ekrana tam ekran düğmesi eklendi; web fullscreen/orientation servisi ve PWA landscape/fullscreen manifest ayarları yapıldı. Phase 2H ve 2I oyun geliştirme fazları planlandı.

### Phase 2H - Fly Hunt V2
- Amaç: Renk Laboratuvarı içindeki Sinek Avı modunu daha net bölüm hissi, hedef renk, doğru/yanlış geri bildirim ve rozet döngüsüyle güçlendirmek.
- Scope: 3 kısa bölüm, hedef renk kartı, iki doğru sinek seçimi, yanlış sinekte yumuşak geri bildirim, bölüm sonu kutlama/rozet.
- Scope dışı: Karmaşık seviye ekonomisi, ceza sistemi, yeni karakter evreni, dış içerik.
- Beklenen dosya etki alanı: `lib/games/magic_colors_game.dart`, `test/widget_test.dart`, gerekirse `brain/STATE.md`.
- Çıkış kriterleri: Sinek Avı çocuk için hedefi daha görünür ve tekrar denenebilir hale gelir; mevcut renk karışımı modu bozulmaz.
- Test: `flutter test`, ilgili dosyalar için `dart analyze`, manuel smoke.
- Durum: pending.

### Phase 2I - Coloring And Drawing Creative Tools
- Amaç: Boyama deneyimini tam serbest çizim karmaşasına girmeden kontrollü yaratıcılıkla geliştirmek.
- Scope: Sahne tamamlama, çıkartma/sticker, parıltı fırçası veya özel fırça gibi 1-2 küçük yaratıcı araç.
- Scope dışı: Fotoğraf import, AI üretim, sınırsız çizim editörü, karmaşık katman sistemi.
- Beklenen dosya etki alanı: `lib/games/coloring_game.dart`, `test/widget_test.dart`, gerekirse `brain/STATE.md`.
- Çıkış kriterleri: Çocuk boyama sonrası sahneye küçük yaratıcı dokunuş ekleyebilir; mevcut hikayeli boyama bozulmaz.
- Test: `flutter test`, ilgili dosyalar için `dart analyze`, manuel smoke.
- Durum: pending.

## Phase 3 - Differentiator

### Phase 3A - Photo To Coloring Prototype
- Amaç: Ebeveynin yüklediği resmi çizgi boyama sayfasına dönüştürmeyi prototiplemek.
- Scope: Yerel prototip veya güvenli API araştırması; çocuk verisi ve gizlilik ayrıca değerlendirilecek.
- Test: Örnek görsellerle çıktı kalitesi kontrolü.
- Durum: pending.
