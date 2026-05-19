# TESTING.md - Test ve Doğrulama

> Son güncelleme: 2026-05-19
> Rol: Projede hangi değişiklikte hangi doğrulamanın çalışacağını açıklar.

## Genel Komutlar

- Markdown/whitespace: `git diff --check`
- Kod yokken: yalnızca `git diff --check`
- Flutter kurulursa: `flutter test`
- APK istenirse: release APK masaüstüne çıkarılır, gereksiz büyük olmayan çıktı tercih edilir.

## Manuel Doğrulama

- Çocuk ana akışı gerçek cihazda denenmeli.
- Reklam, dış link ve ödeme çocuk ekranından erişilemez olmalı.
- 4-5 yaş çocuk için dokunma alanları büyük ve yazıya bağımlılık düşük olmalı.

## Özel Çıktılar

- APK istenirse masaüstüne kaydedilmiş, gereksiz büyük olmayan ve güncel Android telefonlarla uyumlu çıktı doğrulanır.
