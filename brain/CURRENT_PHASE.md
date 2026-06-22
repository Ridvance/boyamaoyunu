# CURRENT_PHASE.md - Aktif Faz

> Son güncelleme: 2026-06-22

## Active Phase

Phase 2O - Store Listing, Compliance And Release Assets

## Durum

Active.

## Neden Bu Faz

Phase 2N sonunda ürün içeriği dengelendi ve release build baseline'ı hazır. Mağaza gönderiminden önce iki platformun metadata, çocuk/gizlilik beyanı ve gerçek uygulama kaynaklı görsel paketleri tek, doğrulanabilir bir teslim halinde hazırlanmalı.

## Scope

- Kanonik ürün adıyla Google Play ve App Store metadata paketini tamamla.
- Destek ve gizlilik URL'lerini doğrula.
- Google Play hedef kitle/Families ve Data Safety cevap taslağını hazırla.
- Apple Kids Category yaş aralığı ve App Privacy cevap taslağını hazırla.
- Güncel uygulama ikonunun mağaza kırpımını doğrula.
- Gerçek release build'den telefon/tablet yatay ekran görüntüleri üret.
- Google Play feature graphic oluştur.
- Sürüm notları ve release checklist'i güncelle.

## Scope Dışı

- Mağaza hesabında nihai beyan gönderme veya public publish.
- Ücretlendirme kararı.
- Reklam, analitik veya yeni veri toplama.
- Yeni oyun, level veya ürün davranışı.
- Phase 2P gerçek cihaz/kapalı test yürütmesi.

## Beklenen Dosya Etki Alanı

- `brain/RELEASE.md`
- `brain/VALIDATION.md`
- `docs/store/*`
- `docs/store_metadata.md`
- `docs/privacy_policy_tr.md`
- `web/privacy.html`
- İkon ve mağaza görsel varlıkları
- `brain/*`

## Exit Criteria

- İki mağaza için metadata ve asset paketi eksiksizdir.
- Gizlilik ve çocuk hedef kitle taslakları kod davranışıyla tutarlıdır.
- Destek/gizlilik URL'leri belgelenmiş ve doğrulanmıştır.
- Ekran görüntüleri gerçek release build kaynaklıdır.
- İkon ve feature graphic boyutları mağaza gereksinimlerine uygundur.
- `flutter analyze`, `flutter test` ve `git diff --check` temiz geçer.

## Scope Locked Prompt

```text
Sadece Google Play ve App Store gönderim paketini hazırla: kanonik ürün adı ve mağaza açıklamaları, destek/gizlilik URL'leri, Families/Data Safety ve Kids Category/App Privacy cevap taslakları, ikon kırpımı, gerçek release build'den telefon/tablet ekran görüntüleri, Google Play feature graphic ve release checklist oluştur. Mağaza hesabında nihai beyan gönderme, public publish, reklam/analitik veya ücretlendirme ekleme.
```

## Test

```bash
flutter analyze
flutter test
git diff --check
```
