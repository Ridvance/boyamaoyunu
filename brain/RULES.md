# RULES.md - Çalışma Kuralları

> Son güncelleme: 2026-05-22 00:18
> Rol: Her yeni pencerede okunacak sabit sınırlar.

## Değişmez Kurallar

- Aktif faz dışına çıkma.
- Kod davranışı değişirse ilgili testleri çalıştır.
- Destructive reset, data wipe veya ilgisiz refactor yapma.
- Scope dışı modüllere dokunma.
- Eksik veriyi tahmin ederek üretim davranışına sokma.
- Tamamlanan işi commit ve push et.
- Planlama, otonomi, onay kapıları ve yeni fikir yönetimi için `brain/PLANNING.md` dosyasını takip et.

## Mutlak Onay Gerektiren İşler

- Canlı API, destructive işlem, data wipe, büyük refactor veya scope değişikliği açık kullanıcı onayı ister.
- `IDEA_POOL.md` içindeki fikirler kullanıcı onayı olmadan aktif faza taşınmaz.

## Doküman Gerçeği

- `brain/` çalışma belleğidir.
- `docs/` kanıt ve detay arşividir.
- Eski root dokümanları tarihsel kaynak sayılır.

## Kullanıcı Tercihleri

- Kullanıcı APK isterse varsayılan çıktı: APK dosyası masaüstüne kaydedilir, gereksiz büyük tutulmaz ve güncel Android telefonlarla uyumlu hazırlanır.

## Güvenlik

- Secret/API key yazma.
- Canlı yazıcı API çağrıları için açık kullanıcı onayı iste.
