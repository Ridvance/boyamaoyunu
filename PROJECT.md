# PROJECT.md - Proje Kimliği ve Teknik Çerçeve

## 1. Proje Tanımı
- **Proje Adı:** Çocuk Oyun (Cocuk Oyun)
- **Platform:** Mobil (iOS & Android) ve Web (Scaffold hazır)
- **Teknoloji:** Flutter (Dart)

## 2. Teknik Sınırlar ve Tercihler
- **Minimal Bağımlılık:** Çocuk güvenliği ve performans için minimum üçüncü parti paket kullanımı.
- **Çevrimdışı Öncelikli:** Tüm varlıkların (assets) yerel olarak barındırılması, internet bağımlılığının sıfırlanması.
- **Basit Durum Yönetimi (State Management):** Uygulamanın küçük ölçeği göz önüne alınarak karmaşık mimarilerden kaçınılması.

## 3. Başarı Kriterleri (Success Metrics)
- Sıfır reklam gösterimi ve sıfır dış bağlantı sızıntısı ile %100 güvenli alan sağlanması.
- 4-5 yaşındaki bir çocuğun ebeveyn yardımı olmadan uygulamayı açıp boyama yapabilmesi (Kullanılabilirlik).
- Uygulamanın çökme oranının (Crash Rate) %0.1'in altında olması.

## 4. Yol Haritası (Roadmap)
- **Phase-00A (Mevcut):** Ürün Keşfi ve Vizyon Belirleme.
- **Phase-01:** Temel Boyama Motoru ve Arayüz Tasarımı.
- **Phase-02:** Çocuk Dostu Geri Bildirimler (Sesler, efektler).
- **Phase-03:** Test ve Yayın Hazırlığı.

## 5. Teknik Doğrulama ve Altyapı Kararları (Technical Validation)
### 5.1. Çevrimdışı Varlık Yönetimi (Offline Assets)
- Tüm boyama şablonları (SVG/Vector formatında) yerel olarak `assets/` klasöründe barındırılacaktır. Bu sayede internet bağlantısı olmasa dahi uygulama tam performansla çalışır.

### 5.2. Performans ve Çökme Önleme
- Flutter'ın yerel çizim motoru (Canvas) kullanılacaktır. Üçüncü parti ağır kütüphaneler yerine Flutter `CustomPainter` kullanılarak bellek tüketimi minimumda tutulacaktır. Bu, eski cihazlarda dahi çökme oranını %0.1'in altında tutma hedefimizi destekler.

### 5.3. Durum Yönetimi (State Management)
- Uygulama içi durum sadece aktif renk seçimi ve boyama adımlarından (Undo/Redo) ibaret olduğu için karmaşık paketler (Bloc, Riverpod vb.) yerine yerel `ValueNotifier` veya basit `ChangeNotifier` kullanılacaktır.
