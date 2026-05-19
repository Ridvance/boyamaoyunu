# RULES.md - Çalışma Kuralları

> Son güncelleme: 2026-05-19
> Rol: Her yeni pencerede okunacak sabit sınırlar.

## Değişmez Kurallar

- Aktif faz dışına çıkma.
- Kod davranışı değişirse ilgili testleri çalıştır.
- Destructive reset, data wipe veya ilgisiz refactor yapma.
- Scope dışı modüllere dokunma.
- Eksik veriyi tahmin ederek üretim davranışına sokma.
- Her güncelleme, faz, fix veya kısa işten sonra commit ve push yap.
- Planlama, otonomi, onay kapıları ve yeni fikir yönetimi için `brain/PLANNING.md` dosyasını takip et.

## Mutlak Onay Gerektiren İşler

- Canlı API, ödeme, abonelik, reklam SDK'sı, çocuk verisi, destructive işlem, data wipe, büyük refactor veya scope değişikliği açık kullanıcı onayı ister.
- Çocuk fotoğrafı, cihaz galerisi veya kamera kullanımı içeren işler ayrıca gizlilik ve ebeveyn onayı tasarımı ister.
- `IDEA_POOL.md` içindeki fikirler kullanıcı onayı olmadan aktif faza taşınmaz.

## Çocuk Güvenliği İlkeleri

- 4-5 yaş hedeflendiği için reklam, manipülatif satın alma baskısı ve dış linkler varsayılan olarak kapalı düşünülür.
- Çocuk kullanıcıdan yazı yazması, hesap açması veya karmaşık ayar yapması beklenmez.
- Korkutucu, agresif, karanlık veya rahatsız edici karakter estetiğinden kaçınılır.
- Ebeveyn alanı çocuk alanından ayrılmalıdır.

## Doküman Gerçeği

- `brain/` çalışma belleğidir.
- `docs/` oluşursa kanıt ve detay arşividir.
- Eski root dokümanları tarihsel kaynak sayılır.

## Kullanıcı Tercihleri

- Kullanıcı APK isterse varsayılan çıktı: APK dosyası masaüstüne kaydedilir, gereksiz büyük tutulmaz ve güncel Android telefonlarla uyumlu hazırlanır.
- Kullanıcı pratik ilerlemeyi tercih eder: uzun teorik plan yerine küçük prototip, dar SLC, gerçek çocuk testi ve hızlı iterasyon.

## Güvenlik

- Secret/API key yazma.
- Canlı servis, ödeme veya kullanıcı verisi içeren işlem için açık kullanıcı onayı iste.
