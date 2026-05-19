# STATE.md - Güncel Durum

> Son güncelleme: 2026-05-19
> Rol: Yeni pencere açıldığında hızlı bağlam yükleme.

## Aktif Gerçeklik

Flutter prototip içinde ilk oynanabilir boyama SLC ve ebeveyn güvenlik kabuğu mevcut. Kullanıcı, 4-5 yaş okul öncesi çocuklara yönelik reklamsız, güvenilir, faydalı ve düzenli yenilenebilir bir mobil oyun fikrini tarif etti. Ana ürün yönü: aileye güven veren, çocuğu korkutucu karakterlerle karşılaştırmayan, boyama/yaratıcılık odaklı ve zamanla fotoğrafı çizime çevirip boyatabilen bir uygulama.

## Aktif Odak

- Brain yapısı bu projeye ilk kez kuruldu.
- İlk SLC kapsamı kilitlendi: 4-5 yaş çocuk için reklamsız, güvenli, sadece boyama çekirdeği. Mini oyun sonraki fazlara bırakıldı.
- Karakter, isim ve görsel dünya için saha doğrulama adayları hazırlandı; nihai karar çocuk/ebeveyn gözlemi sonrası verilecek.
- Flutter proje iskeleti kuruldu; default sayaç demosu kaldırıldı.
- İlk boyama SLC çekirdeği çalışır: 3 sayfa, çizim kanvası, renk paleti, silgi, temizle ve geri dön.
- Kullanıcı geri bildirimiyle çizim repaint bug'ı düzeltildi: Boyama yaparken çizgi artık renk düğmesi gibi başka bir UI aksiyonu beklemeden görünür.
- Ebeveyn güvenlik kabuğu eklendi; ebeveyn alanı çocuk akışından ayrıldı.
- Aktif faz gerçek cihaz/çocuk playtest geri bildirim döngüsüdür.
- Phase 2A için güncel uygulama akışına göre playtest planı, gözlem formu, başarı/başarısızlık sinyalleri ve hızlı düzeltme listesi formatı `brain/FIELD_RESEARCH.md` içine eklendi.
- Gerçek cihaz testi için release APK üretildi ve masaüstüne `cocuk-oyun-playtest-release.apk` adıyla kopyalandı.
- Web/HTML test çıktısı `flutter build web --release --base-href /boyamaoyunu/` ile üretildi ve GitHub'a `gh-pages` branch'i olarak push edildi.
- Kullanıcının önemli yönlendirmesi: fazla plan yapmadan, doğrudan küçük bir uygulama çıkarıp çocuklarla test etmek.
- İsim, karakter ve görsel tasarım AI tahminiyle kilitlenmeyecek; 4-5 yaş çocuklara ve yakın çevredeki ebeveyn/anaokulu gözlemine gösterilerek doğrulanacak.
- `brain/FIELD_RESEARCH.md` içinde 5 karakter/tema yönü ve isim adayları hazırlandı; bunlar karar değil, saha testi adaylarıdır.
- Güncel template'e göre research, commercial validation, AI substitution, SLC ve kill report kapıları projeye eklendi.
- Para kazanma ilk aşamada baskın hedef değil; güven, fayda ve geri bildirim toplama öncelikli.

## Kısa Durum

- Kod: Flutter app içinde ilk oynanabilir boyama çekirdeği ve ebeveyn güvenlik kabuğu mevcut.
- Platform: Mobil hedefli; Flutter seçildi.
- Ürün: 4-5 yaş için reklamsız, sadece boyama odaklı SLC.
- Risk: Fazla planlama nedeniyle ürünün çıkmaması; fotoğrafı çizime çevirme özelliğini SLC'ye fazla erken almak; çocukların çekileceği karakter/isim/tasarımı sahada doğrulamadan seçmek.
- Doğrulama: Çizim repaint fix'i sonrası `flutter test`, `flutter analyze` ve `git diff --check` temiz geçti. Masaüstündeki `cocuk-oyun-playtest-release.apk` gerçek cihazda `brain/FIELD_RESEARCH.md` içindeki Phase 2A formuyla 2-5 çocukla denenmeli; web çıktısı için GitHub Pages ayarı `gh-pages` branch root olacak şekilde kontrol edilmeli. Karakter/isim/tasarım adayları en az 3 çocuk veya ebeveyn/çocuk gözlemiyle ayrıca doğrulanmalı.

## Sonraki Prompt

```text
Repo: /Users/ridvan/Documents/Çocuk Oyun

Önce brain/STATE.md, brain/RULES.md ve brain/CURRENT_PHASE.md dosyalarını oku.
CURRENT_PHASE içindeki Scope Locked Prompt'a göre devam et.
Türkçe yaz.
Kod değiştirirsen test et, commit ve push yap.
Scope dışı işlere dokunma.
```
