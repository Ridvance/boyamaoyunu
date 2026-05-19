# DECISIONS.md - Karar Kaydı

> Son güncelleme: 2026-05-19
> Rol: Önemli kararların nedenini ve geri dönüş yolunu kaybetmemek.

## Kararlar

## Kullanma Kuralı

- Ticari ürün, uzun soluklu proje veya çok fazlı işlerde her büyük yön, scope, teknoloji, pazar veya faz kararı kısa ve kaynaklı yazılır.
- Kararlar mümkünse kaynak/kanıt iziyle birlikte tutulur.

### 2026-05-19 - Hedef Yaş 4-5
- Karar: Ürün okul öncesi 4-5 yaş çocuklara odaklanacak.
- Neden: Kullanıcı özellikle okula başlamadan önceki, reklam kapatamayacak yaş grubunu tarif etti.
- Alternatifler: Daha geniş 3-7 yaş aralığı.
- Etki: UI daha büyük, sade ve yazıdan bağımsız tasarlanacak.
- Geri alma yolu: Playtest sonrası yaş aralığı genişletilebilir.
- Kaynak/kanıt: 2026-05-19 kullanıcı konuşması.

### 2026-05-19 - Reklamsız Güven İlkesi
- Karar: İlk ürün yönü reklamsız ve güvenilir deneyim olacak.
- Neden: Hedef çocuk reklamı kapatamaz; ebeveyn güveni ana satın alma gerekçesi.
- Alternatifler: Reklam destekli ücretsiz model.
- Etki: Monetizasyon ilk SLC'de geri planda kalır.
- Geri alma yolu: İleride sadece ebeveyn alanında ücretli paket değerlendirilebilir.
- Kaynak/kanıt: 2026-05-19 kullanıcı konuşması.

### 2026-05-19 - Public İlk Sürüm SLC Olacak
- Karar: İçeride hızlı MVP/prototip yapılabilir, ancak aileye veya markete çıkacak ilk sürüm dar ama simple, lovable ve complete olmalıdır.
- Neden: Güncel Brain template SLC standardını ticari ürünlerde kalite kapısı olarak ekledi; çocuk ürünü ilk izlenim ve güvene daha duyarlı.
- Alternatifler: Ham MVP'yi doğrudan markete çıkarmak.
- Etki: İlk scope daralır ama karakter, güven ve boyama çekirdeği daha tamamlanmış çıkar.
- Geri alma yolu: Sadece kapalı testlerde MVP kalitesinde prototip kullanılabilir.
- Kaynak/kanıt: `/Users/ridvan/Desktop/Brain/BRAIN_KAYNAK_NOTLARI.md`, SLC referansları ve 2026-05-19 template güncellemesi.

### 2026-05-19 - İlk SLC Sadece Boyama Olacak
- Karar: İlk SLC sadece reklamsız boyama çekirdeği olacak; mini oyun sonraki fazlara bırakılacak.
- Neden: Kullanıcı hızlı ilerlemeyi ve küçük uygulama çıkarıp çocuklarla test etmeyi istiyor. Mini oyun ilk çıkışı genişletir ve boyama çekirdeğinin testini geciktirir.
- Alternatifler: İlk sürüme tek basit mini oyun eklemek.
- Etki: Phase 1B scope'u çocuk ana ekranı, 3-5 boyama sayfası, renk paleti, silgi, temizle ve geri dön akışıyla sınırlanır.
- Geri alma yolu: İlk boyama akışı çocuk testinde yetersiz kalırsa mini oyun Phase 2 veya ayrı bir micro phase olarak öne çekilebilir.
- Kaynak/kanıt: 2026-05-19 kullanıcı kararı: "Mini oyunu sonraki fazlara bırakırız işi ilerlet".

### 2026-05-19 - Flutter Mobil İskelet Seçimi
- Karar: İlk mobil iskelet Flutter ile kurulacak.
- Neden: Proje Android APK hedefli ve hızlı prototip/çocuk testi için tek kod tabanlı mobil geliştirme uygun.
- Alternatifler: Native Android veya React Native.
- Etki: Phase 1A repo köküne Flutter scaffold kurar; Phase 1B boyama SLC ekranlarını Flutter içinde geliştirir.
- Geri alma yolu: Flutter cihaz/build tarafında bloklanırsa native Android veya farklı mobil iskelet yeniden değerlendirilebilir.
- Kaynak/kanıt: Kullanıcının APK beklentisi, proje mobil hedefi ve 2026-05-19 "Devam" kararı.

### 2026-05-19 - İlk Boyama Etkileşimi Serbest Çizim Olacak
- Karar: İlk SLC'de boyama, hazır çizgi şablonlarının üstüne serbest parmak çizimi olarak uygulanacak.
- Neden: Doldurma algoritması veya bölge tabanlı boyama ilk prototipi yavaşlatır; çocuk testi için renk seçme, çizme, silme ve temizleme döngüsü yeterli ilk sinyal verir.
- Alternatifler: Kapalı alanları tek dokunuşla dolduran fill bucket veya bitmap tabanlı boyama.
- Etki: Phase 1B daha hızlı tamamlanır; ileri fazda fill bucket gerekirse ayrı micro phase olur.
- Geri alma yolu: Çocuk testinde serbest çizim yetersiz kalırsa alan doldurma davranışı Phase 2 sonrası eklenir.
- Kaynak/kanıt: 2026-05-19 pratik ilerleme hedefi ve Phase 1B implementasyonu.
