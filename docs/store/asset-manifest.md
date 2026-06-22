# Store Asset Manifest

> Üretim tarihi: 22 Haziran 2026

## Kaynak

- Kaynak uygulama: Flutter release web build.
- Yakalama giriş noktası: `tool/store_capture.dart`.
- Giriş noktası üretim oyun widget'larını doğrudan kullanır; ürün davranışını değiştirmez.
- Yakalama renderer'ı: Chrome headless + SwiftShader.
- Görsel QA: telefon ve tablet contact sheet üzerinden taşma/kırpılma kontrolü tamamlandı.

## Telefon — App Store 6.5 inç Landscape

Boyut: `2688 × 1242`, PNG, 7 dosya.

- `screenshots/iphone-6.5/home.png`
- `screenshots/iphone-6.5/coloring.png`
- `screenshots/iphone-6.5/tracing.png`
- `screenshots/iphone-6.5/balloon.png`
- `screenshots/iphone-6.5/shapes.png`
- `screenshots/iphone-6.5/sounds.png`
- `screenshots/iphone-6.5/colors.png`

## Tablet — App Store iPad 13 inç Landscape

Boyut: `2732 × 2048`, PNG, 7 dosya.

- `screenshots/ipad-13/home.png`
- `screenshots/ipad-13/coloring.png`
- `screenshots/ipad-13/tracing.png`
- `screenshots/ipad-13/balloon.png`
- `screenshots/ipad-13/shapes.png`
- `screenshots/ipad-13/sounds.png`
- `screenshots/ipad-13/colors.png`

## Google Play

- Telefon/tablet ekranları: Yukarıdaki gerçek uygulama görüntüleri Google Play için de kullanılabilir.
- Feature graphic: `assets/google-play-feature-graphic-1024x500.png` — 1024 × 500, 24-bit PNG, alpha yok.
- High-res icon: `assets/google-play-icon-512.png` — 512 × 512, PNG.

## App Store Icon

- `assets/app-store-icon-1024.png` — 1024 × 1024, RGB PNG, alpha yok.
- Kaynak: `assets/icon/app_icon.png`.

## Önerilen Ekran Sırası

1. Ana ekran — sekiz oyun alanı.
2. Boyama — 10 sayfa ve renk paleti.
3. Renk Laboratuvarı — renk keşif modları.
4. Şekil Eşleştirme.
5. Çizgi Takip.
6. Balon Patlatma.
7. Müzik Kutusu.

Phase 2P'de aynı akışlar fiziksel cihazlarda tekrar yakalanıp görsel fark varsa bu set yenilenmelidir.
