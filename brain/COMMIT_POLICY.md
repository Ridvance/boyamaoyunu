# COMMIT_POLICY.md - Commit / Push Politikası

> Son güncelleme: 2026-05-22 00:18
> Rol: Brain OS içindeki değişikliklerin güvenli commit ve push standardını tanımlar.

## Temel Politika

- Her anlamlı faz, fix veya ürünleştirme adımı ayrı commit edilir.
- Commit öncesi en az şu kontroller çalıştırılır: `git diff --check`, `git status --short`, `git diff --check`.
- Kullanıcıya ait aktif proje registry'si repo dışında tutulur: `/Users/ridvan/Library/Application Support/Brain Studio/central_registry.json`.
- Push yalnızca doğrulama geçtikten ve commit başarıyla oluştuğunda yapılır.
- Force push, destructive reset veya canlı sistemi etkileyen işlem açık kullanıcı onayı olmadan yapılmaz.

## Audit Beklentisi

- Release öncesi `python3 brain.py --project /Users/ridvan/Documents/Çocuk Oyun audit --strict` çalıştırılır.
- Yeni proje kurulumu sonrası `python3 brain.py --project /Users/ridvan/Documents/Çocuk Oyun migration-check` çalıştırılır.
- Audit çıktısı `brain/audit.log` içine JSONL olarak eklenir.
