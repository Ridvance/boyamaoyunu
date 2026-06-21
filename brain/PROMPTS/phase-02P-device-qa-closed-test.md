# Phase 2P - Real Device QA And Closed Test Gate

## Scope Locked Prompt

```text
Sadece gerçek cihaz ve kapalı test yayın kapısını işlet: Android/iOS telefon-tablet matrisinde kritik akışları, offline/restart/ilerleme, ebeveyn kapısı, ses/titreşim ve küçük yatay ekranı doğrula; 10-20 kişilik Google Play kapalı test ve 2-5 çocuk/ebeveyn gözlemi sonuçlarını kaydet; yalnız kanıtlanan P0/P1 hatalara dar fix uygula; final Go/No-Go kararı yaz. Yeni özellik veya public publish yapma.
```

## Exit Criteria

- Cihaz matrisi tamamdır.
- P0/P1 açık hata yoktur.
- Kapalı test ve çocuk/ebeveyn gözlemi değerlendirilmiştir.
- `brain/RELEASE.md` içinde GO veya gerekçeli NO-GO vardır.
