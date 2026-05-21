# DISCOVERY_RECOVERY_PLAN.md - Discovery Kurtarma Planı

> Son güncelleme: 2026-05-21 22:40
> Rol: Discovery'den Research'a geçişte oluşan yanlış başarı algısını düzeltmek için güvenli plan.

## Durum

Discovery çalışması teknik olarak tamamlandı görünse de devredilebilir ürün keşfi çıktısı üretmemiştir.

Kanıt:

- `brain/live_log.txt` içinde ajan düşüncesi yok.
- `brain/live_log.txt` içinde rapor yok.
- `brain/PROJECT.md` içinde ürün açıklaması, hedef kullanıcı ve ana problem alanları placeholder durumunda.
- `brain/MISSION_CONTROL.md` `APPROVED` görünse de bu onay devredilebilir Discovery çıktısıyla desteklenmiyor.
- `audit --strict` `.env` dosyasının ignore edilmediğini yakaladı.

## Aktif Karar

Research'a ilerleme durdurulmalı. Önce Discovery çıktısı onarılmalı ve Mission Control tekrar denetlenmelidir.

## Otonomi Seviyesi

A1 Safe Docs.

İzinli işler:

- Brain ve ürün keşfi dokümanlarını düzeltmek.
- Secret içeriği okumadan `.env` ignore güvenliğini doğrulamak.
- `git diff --check`, `status` ve `audit --strict` çalıştırmak.

Yasak işler:

- Kod davranışı değiştirmek.
- Canlı API çağrısı yapmak.
- Secret/API key değeri okumak veya yazmak.
- Research, Planning veya Execution işine geçmek.

## Kurtarma Sırası

1. Mission Control verdict'ini `NEEDS_REVISION` yap.
2. `.env` dosyasının git tarafından ignore edildiğini kanıtla.
3. `brain/PROJECT.md` içindeki placeholder alanları mevcut `VISION.md` ve `VALIDATION.md` verilerine dayanarak doldur.
4. `brain/CONTEXT_CAPSULE.md` içindeki ana problem ve aktif durum özetini Discovery onarımına göre güncelle.
5. `brain/STATE.md` içinde Discovery'nin tamamlanmış sayılmadığını, Research'ın bloke olduğunu ve sıradaki işin Discovery onarımı olduğunu belirt.
6. `brain/MISSION_CONTROL.md` için tekrar denetim beklet.
7. Doğrula:

```bash
python3 /Users/ridvan/Desktop/Brain/brain.py --project "/Users/ridvan/Documents/Çocuk Oyun" status
python3 /Users/ridvan/Desktop/Brain/brain.py --project "/Users/ridvan/Documents/Çocuk Oyun" audit --strict
git diff --check
```

## Discovery Çıkış Kriteri

Discovery ancak aşağıdaki çıktılar hazırsa tamamlanmış sayılır:

- Ürün açıklaması net.
- Hedef kullanıcı net.
- Ana problem net.
- Vizyon ile PROJECT bilgileri uyumlu.
- Research'a devredilecek belirsizlikler listelenmiş.
- Mission Control açıkça `APPROVED` demiş.

## UI / Akış Notu

Bu olay, boş rapor veya placeholder doküman varken "görev tamamlandı" sinyalinin yanıltıcı olduğunu gösterdi. Brain web arayüzü ileride şu davranışla güçlendirilmeli:

- Ajan raporu yoksa başarı yerine blokaj göster.
- Faz deliverable dosyalarında placeholder kalmışsa Mission Control onayı isteme.
- Manuel geçişlerde neden kaydını zorunlu tut.
