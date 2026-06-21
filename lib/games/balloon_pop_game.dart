import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/audio_synth.dart';
import '../services/app_settings_service.dart';
import '../services/guidance_widgets.dart';
import '../services/progress_service.dart';
import 'magic_colors/chameleon_painter.dart';

const String balloonProgressChapterId = ProgressChapters.balloon;

Future<void> recordBalloonLevelCompletion({int levelIndex = 1}) {
  return ProgressService.instance.completeLevel(
    balloonProgressChapterId,
    levelIndex,
    stars: 3,
  );
}

class BalloonPopGame extends StatefulWidget {
  const BalloonPopGame({super.key});

  @override
  State<BalloonPopGame> createState() => _BalloonPopGameState();
}

class _BalloonPopGameState extends State<BalloonPopGame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tickerController;
  final List<Balloon> _balloons = [];
  final List<Particle> _particles = [];
  final List<Cloud> _clouds = [];

  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  bool _isInitialized = false;
  double _balloonSpawnTimer = 0.0;
  int _popCount = 0;
  int _score = 0;
  int _level = 1;
  int _levelPopCount = 0;
  bool _showExitHint = false;

  // Son güncelleme zamanı
  int _lastTimestamp = 0;

  // Görsel Kalite / Kamo Değişkenleri
  bool _showHint = false;
  String _kamoExpression = 'neutral';
  Timer? _kamoReactionTimer;
  Timer? _exitTooltipTimer;
  final StreamController<void> _wrongFeedbackController = StreamController<void>.broadcast();
  bool _isCelebrationActive = false;

  @override
  void initState() {
    super.initState();
    // Oyun güncelleme döngüsü için 60 FPS'lik bir animasyon controller kullanıyoruz
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick);
    _tickerController.repeat();
    _lastTimestamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    _tickerController.dispose();
    _kamoReactionTimer?.cancel();
    _exitTooltipTimer?.cancel();
    _wrongFeedbackController.close();
    super.dispose();
  }

  void _initializeGame(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;

    // Yavaşça kayan sevimli bulutları başlat
    _clouds.clear();
    final random = Random();
    _clouds.add(
      Cloud(x: width * 0.1, y: height * 0.15, scale: 1.0, speed: 6.0),
    );
    _clouds.add(
      Cloud(x: width * 0.4, y: height * 0.08, scale: 1.4, speed: 8.0),
    );
    _clouds.add(
      Cloud(x: width * 0.7, y: height * 0.20, scale: 0.8, speed: 5.0),
    );
    _clouds.add(
      Cloud(x: width * 1.0, y: height * 0.12, scale: 1.2, speed: 7.0),
    );

    // İlk başta ekranda hazır yükselen birkaç balon oluştur
    for (int i = 0; i < 4; i++) {
      _spawnBalloon(initialY: height * (0.3 + random.nextDouble() * 0.6));
    }

    _isInitialized = true;
  }

  void _tick() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    // Delta time hesapla (saniye cinsinden, maksimum 0.1 sn ile sınırla)
    final double dt = min((now - _lastTimestamp) / 1000.0, 0.1);
    _lastTimestamp = now;

    if (!_isInitialized) return;

    setState(() {
      _updateGame(dt);
    });
  }

  void _updateGame(double dt) {
    // 1. Bulutları güncelle
    for (var cloud in _clouds) {
      cloud.x -= cloud.speed * dt;
      if (cloud.x < -150 * cloud.scale) {
        cloud.x = _screenWidth + 100;
      }
    }

    // 2. Balonları güncelle ve ekran dışına çıkanları temizle
    final double elapsedSeconds =
        DateTime.now().millisecondsSinceEpoch / 1000.0;

    for (int i = _balloons.length - 1; i >= 0; i--) {
      final balloon = _balloons[i];

      // Yukarı doğru yükselme
      balloon.y -= balloon.speed * dt;

      // Sinüs dalgası ile pürüzsüz sağa-sola salınım
      balloon.x =
          balloon.baseX +
          sin(elapsedSeconds * balloon.waveFrequency + balloon.wavePhase) *
              balloon.waveAmplitude;

      // Ekranın üstünden tamamen çıktıysa sil
      if (balloon.y < -balloon.radius * 3) {
        _balloons.removeAt(i);
      }
    }

    // 3. Parçacıkları (Patlama ve Konfeti) güncelle ve sil
    for (int i = _particles.length - 1; i >= 0; i--) {
      final particle = _particles[i];
      particle.update(dt);
      if (particle.alpha <= 0 || particle.radius <= 0.5) {
        _particles.removeAt(i);
      }
    }

    // 4. Yeni balon üretme zamanlayıcısını güncelle
    _balloonSpawnTimer -= dt;
    if (_balloonSpawnTimer <= 0) {
      _spawnBalloon();
      // Bir sonraki balonun doğuş süresi (0.7 - 1.3 saniye arası rastgele)
      final levelSpeedUp = min(0.35, (_level - 1) * 0.05);
      _balloonSpawnTimer = 0.7 - levelSpeedUp + Random().nextDouble() * 0.6;
    }
  }

  void _spawnBalloon({double? initialY}) {
    if (_screenWidth <= 0) return;
    final random = Random();

    // Boyut ve Hız parametreleri (Çocuklar kolay dokunsun diye ideal boyutta)
    final double radius =
        38.0 + random.nextDouble() * 18.0; // 38 - 56 piksel arası yarıçap
    final double speed =
        65.0 +
        (_level - 1) * 10.0 +
        random.nextDouble() * 75.0; // Bölüm ilerledikçe hafif hızlanır

    // Yatayda ekran dışına taşmayacak şekilde X konumu
    final double margin = radius * 1.5;
    final double baseX =
        margin + random.nextDouble() * (_screenWidth - margin * 2);

    // Başlangıç Y konumu (isteğe bağlı olarak ekranın ortasından veya altından)
    final double y = initialY ?? (_screenHeight + radius * 3);

    // Sevimli çocuk renk paleti (canlı ve sevimli)
    final colors = [
      const Color(0xFFFF6B6B), // Tatlı Kırmızı/Pembe
      const Color(0xFF4D96FF), // Sevimli Mavi
      const Color(0xFF6BCB77), // Doğa Yeşili
      const Color(0xFFFFD93D), // Güneş Sarısı
      const Color(0xFFFF9F43), // Turuncu
      const Color(0xFFB983FF), // Pastel Mor
      const Color(0xFFFF8AAE), // Pamuk Şeker Pembesi
    ];

    final isSpecial = random.nextDouble() < 0.15;
    Color color;
    IconData? icon;

    if (isSpecial) {
      color = const Color(0xFFFFD700); // Parlak Altın Rengi
      icon =
          random.nextBool()
              ? Icons.star_rounded
              : Icons.redeem_rounded; // Yıldız veya Hediye ikonu
    } else {
      color = colors[random.nextInt(colors.length)];
      // %45 ihtimalle içinde sevimli bir sembol gösterilsin
      if (random.nextDouble() < 0.45) {
        final icons = [
          Icons.favorite_rounded, // Kalp
          Icons.star_rounded, // Yıldız
          Icons.sentiment_very_satisfied_rounded, // Gülen Yüz
          Icons.wb_sunny_rounded, // Güneş
          Icons.music_note_rounded, // Müzik Notası
          Icons.pets_rounded, // Pati
          Icons.cloud_rounded, // Bulutçuk
        ];
        icon = icons[random.nextInt(icons.length)];
      }
    }

    // Dalgalanma (Salınım) Hareket Parametreleri
    final double waveAmplitude =
        10.0 + random.nextDouble() * 18.0; // 10-28 piksel salınım genişliği
    final double waveFrequency =
        1.2 + random.nextDouble() * 1.8; // Salınım hızı
    final double wavePhase = random.nextDouble() * 2 * pi; // Başlangıç fazı

    _balloons.add(
      Balloon(
        x: baseX,
        y: y,
        baseX: baseX,
        radius: radius,
        color: color,
        speed: speed,
        icon: icon,
        waveAmplitude: waveAmplitude,
        waveFrequency: waveFrequency,
        wavePhase: wavePhase,
        isSpecial: isSpecial,
      ),
    );
  }

  // Dokunma (Touch) Algılama Yönetimi - Multi-touch Dostu
  void _handleTouch(Offset touchPoint) {
    bool poppedAny = false;

    // En son çizilen balon en üsttedir, bu yüzden sondan başa doğru ararız
    for (int i = _balloons.length - 1; i >= 0; i--) {
      final balloon = _balloons[i];

      // Balon oval formunda olduğu için dikeyde biraz daha geniş bir dokunma alanına sahiptir.
      // Dokunmayı daha bağışlayıcı yapmak adına alan toleransını artırıyoruz.
      final double dx = touchPoint.dx - balloon.x;
      final double dy = touchPoint.dy - balloon.y;

      // Elips çarpışma kontrolü: (x²/a²) + (y²/b²) <= 1
      // Çocukların kolayca dokunabilmesi için çarpışma alanını %25 daha geniş tutuyoruz.
      final double a = balloon.radius * 1.25;
      final double b = balloon.radius * 1.5;

      if ((dx * dx) / (a * a) + (dy * dy) / (b * b) <= 1.0) {
        _popBalloon(balloon, i);
        poppedAny = true;
        break; // Bir dokunuşta sadece tek bir balon patlatılsın (üst üste gelenlerde en üstteki)
      }
    }

    // Çocuk ekranda boş yere dokunursa da hafif bir dalga efekti oluşturabiliriz
    if (!poppedAny) {
      _triggerRipple(touchPoint);
      _triggerWrongFeedback();
    }
  }

  void _triggerWrongFeedback() {
    _wrongFeedbackController.add(null);
    AppHaptics.lightImpact();
    // Only set Kamo to surprised if not currently celebrating or happy
    if (_kamoExpression == 'neutral' && !_isCelebrationActive) {
      setState(() {
        _kamoExpression = 'surprised';
      });
      _kamoReactionTimer?.cancel();
      _kamoReactionTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _kamoExpression = _isCelebrationActive ? 'happy' : 'neutral';
          });
        }
      });
    }
  }

  void _popBalloon(Balloon balloon, int index) {
    _balloons.removeAt(index);
    _popCount++;
    _levelPopCount++;
    _score += balloon.isSpecial ? 5 : 1;

    // Dokunsal Geri Bildirim (Haptic Feedback) - Çocuklar için çok tatmin edicidir
    if (balloon.isSpecial) {
      AppHaptics.heavyImpact();
      AudioSynth.playSparkleSound();
    } else {
      AppHaptics.mediumImpact();
      AudioSynth.playRaindropSound();
    }

    final random = Random();

    // Patlama anında yayılacak parçacıklar (Particles)
    // Sihirli balon patladığında double parçacık saçılması (24-35 parçacık)
    final int particleCount =
        balloon.isSpecial
            ? (24 + random.nextInt(12))
            : (12 + random.nextInt(6));

    final rainbowColors = [
      const Color(0xFFFF5252), // Kırmızı
      const Color(0xFFFF4081), // Pembe
      const Color(0xFFE040FB), // Mor
      const Color(0xFF7C4DFF), // Derin Mor
      const Color(0xFF536DFE), // Mavi
      const Color(0xFF448AFF), // Açık Mavi
      const Color(0xFF00B0FF), // Turkuaz
      const Color(0xFF00E676), // Yeşil
      const Color(0xFFFFD600), // Sarı
      const Color(0xFFFFAB40), // Turuncu
    ];

    for (int i = 0; i < particleCount; i++) {
      final double angle = random.nextDouble() * 2 * pi;
      // Özel balon parçacıkları biraz daha hızlı saçılabilir
      final double speed =
          (balloon.isSpecial ? 150.0 : 100.0) +
          random.nextDouble() * (balloon.isSpecial ? 300.0 : 200.0);
      final double vx = cos(angle) * speed;
      final double vy =
          sin(angle) * speed - 50.0; // Yukarı doğru hafif bir itme verelim

      final Color particleColor =
          balloon.isSpecial
              ? rainbowColors[random.nextInt(rainbowColors.length)]
              : balloon.color;

      _particles.add(
        Particle(
          x: balloon.x,
          y: balloon.y,
          vx: vx,
          vy: vy,
          color: particleColor,
          // Özel parçacıklar biraz daha büyük olabilir
          radius:
              (balloon.isSpecial ? 5.0 : 4.0) +
              random.nextDouble() * (balloon.isSpecial ? 8.0 : 6.0),
        ),
      );
    }

    // Kamo Tepki Mantığı: Özel balonda veya her 5 balonda bir 1.2s sevinç
    final bool isSpecial = balloon.isSpecial;
    final bool isEvery5th = (_popCount % 5 == 0);
    if ((isSpecial || isEvery5th) && !_isCelebrationActive) {
      setState(() {
        _kamoExpression = 'happy';
      });
      _kamoReactionTimer?.cancel();
      _kamoReactionTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _kamoExpression = _isCelebrationActive ? 'happy' : 'neutral';
          });
        }
      });
    }

    final levelTarget = _levelTarget;
    if (_levelPopCount >= levelTarget) {
      _level++;
      _levelPopCount = 0;
      _triggerCelebration();
      _triggerLevelCompleteCelebration();
    } else if (_popCount % 8 == 0) {
      _triggerCelebration();
    }
  }

  void _triggerLevelCompleteCelebration() {
    setState(() {
      _isCelebrationActive = true;
      _kamoExpression = 'happy';
    });
    recordBalloonLevelCompletion(levelIndex: _level - 1);
    _kamoReactionTimer?.cancel();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCelebrationActive = false;
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  int get _levelTarget => 8 + min(_level - 1, 4) * 2;

  // Boş dokunmalar için küçük halka efekti parçacıkları
  void _triggerRipple(Offset point) {
    final random = Random();
    final colors = [Colors.white70, const Color(0x66B3E5FC)];
    final color = colors[random.nextInt(colors.length)];

    for (int i = 0; i < 4; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 40.0 + random.nextDouble() * 60.0;
      _particles.add(
        Particle(
          x: point.dx,
          y: point.dy,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          color: color,
          radius: 3.0 + random.nextDouble() * 3.0,
        ),
      );
    }
  }

  // Ekranın üstünden süzülen harika bir konfeti kutlaması
  void _triggerCelebration() {
    final random = Random();
    final int confettiCount = 35 + random.nextInt(20); // 35-54 adet konfeti

    for (int i = 0; i < confettiCount; i++) {
      // Yatayda ekranın rastgele bir yerinden başla
      final double x = random.nextDouble() * _screenWidth;
      // Ekranın hemen üstünden dökülmeye başlasınlar
      final double y = -20.0 - random.nextDouble() * 60.0;

      final double vx =
          -40.0 +
          random.nextDouble() * 80.0; // rüzgar gibi sağa sola savrulma hızı
      final double vy = 120.0 + random.nextDouble() * 150.0; // aşağı düşme hızı

      final colors = [
        const Color(0xFFFF4081),
        const Color(0xFF00E676),
        const Color(0xFF00B0FF),
        const Color(0xFFFFD600),
        const Color(0xFFFFAB40),
        const Color(0xFFE040FB),
        const Color(0xFFFF5252),
      ];

      _particles.add(
        Particle(
          x: x,
          y: y,
          vx: vx,
          vy: vy,
          color: colors[random.nextInt(colors.length)],
          radius: 4.0 + random.nextDouble() * 5.0,
          isConfetti: true,
          rotationSpeed: 2.0 + random.nextDouble() * 5.0,
        ),
      );
    }

    // Konfeti patlamasında daha güçlü bir titreşim verelim
    AppHaptics.lightImpact();
    AudioSynth.playSparkleSound();
  }

  void _showExitTooltip() {
    if (_showExitHint) return;
    setState(() {
      _showExitHint = true;
    });
    _exitTooltipTimer?.cancel();
    _exitTooltipTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showExitHint = false;
        });
      }
    });
  }

  bool _isKamoOnLeft() {
    if (_screenWidth <= 0 || _screenHeight <= 0) return false;
    for (var b in _balloons) {
      if (b.x > _screenWidth * 0.5 && b.y > _screenHeight * 0.5) {
        return true;
      }
    }
    return false;
  }

  Balloon? _findTargetBalloon() {
    if (_balloons.isEmpty) return null;
    Balloon? target;
    double maxY = -1.0;
    for (var b in _balloons) {
      if (b.y > maxY && b.y < _screenHeight - b.radius * 2 && b.y > b.radius) {
        maxY = b.y;
        target = b;
      }
    }
    return target ?? _balloons.last;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isShortScreen = size.height < 450;
    final double buttonSize = isShortScreen ? 48.0 : 64.0;
    final double iconSize = isShortScreen ? 26.0 : 36.0;
    final double borderWidth = isShortScreen ? 3.0 : 4.0;
    final double buttonPadding = isShortScreen ? 12.0 : 20.0;

    final Balloon? target = _showHint ? _findTargetBalloon() : null;
    final bool kamoOnLeft = _isKamoOnLeft();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2), // Açık, krem arka plan
      body: InactivityDetector(
        duration: const Duration(seconds: 3),
        onInactivity: () {
          if (mounted) {
            setState(() {
              _showHint = true;
            });
          }
        },
        onActivity: () {
          if (mounted) {
            setState(() {
              _showHint = false;
            });
          }
        },
        child: Stack(
          children: [
            // 1. Gökyüzü ve bulut gradyan arka planı
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFBEE3F8), // Sevimli açık mavi gökyüzü
                      Color(0xFFEBF8FF), // Alt taraflara doğru açılan gökyüzü
                      Color(0xFFFFFBF2), // Uygulamanın genel arka planıyla bütünleşme
                    ],
                  ),
                ),
              ),
            ),

            // 2. Ana Çizim Katmanı (CustomPainter) ve Multi-touch Listener
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (!_isInitialized) {
                    // Ekran boyutları alındıktan sonra oyunu başlat
                    _initializeGame(constraints.maxWidth, constraints.maxHeight);
                  }

                  return Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (event) {
                      _handleTouch(event.localPosition);
                    },
                    child: CustomPaint(
                      painter: BalloonPainter(
                        balloons: _balloons,
                        particles: _particles,
                        clouds: _clouds,
                      ),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
            ),

            // Hareketsizlik İpucu Efekti (PulseTarget ve GhostHandHint)
            if (target != null) ...[
              Positioned(
                left: target.x - target.radius * 1.3,
                top: target.y - target.radius * 1.3,
                child: IgnorePointer(
                  child: PulseTarget(
                    active: true,
                    color: target.color,
                    baseSize: target.radius * 2.6,
                    child: SizedBox(
                      width: target.radius * 2.6,
                      height: target.radius * 2.6,
                    ),
                  ),
                ),
              ),
              GhostHandHint(
                position: Offset(target.x, target.y),
                active: true,
              ),
            ],

            // Kamo Maskot Kartı (küçük, müdahalesiz, boş tıklamalarda SoftWrongFeedback ile sallanır)
            Positioned(
              bottom: 16,
              left: kamoOnLeft ? 16 : null,
              right: kamoOnLeft ? null : 16,
              child: IgnorePointer(
                child: SoftWrongFeedback(
                  triggerStream: _wrongFeedbackController.stream,
                  child: Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFD000).withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: 300,
                          height: 200,
                          child: CustomPaint(
                            painter: ChameleonPainter(
                              chameleonColor: const Color(0xFF2FA7A0),
                              tongueProgress: 0.0,
                              lookTarget: const Offset(200, 200),
                              flies: const [],
                              idleProgress: 0.0,
                              isCamouflaged: false,
                              chameleonPos: const Offset(150, 80),
                              expression: _kamoExpression,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: buttonPadding,
                    right: buttonPadding,
                  ),
                  child: Container(
                    key: const ValueKey('balloon-score-panel'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFFFD000),
                        width: borderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Bölüm $_level  •  Skor $_score  •  $_levelPopCount / $_levelTarget',
                      style: const TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Çocuk Dostu Büyük Geri Dönüş Butonu (Sol Üst)
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: buttonPadding,
                    left: buttonPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        key: const ValueKey('balloon-game-back-button'),
                        onTap: _showExitTooltip,
                        onDoubleTap: () {
                          AppHaptics.mediumImpact();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: buttonSize,
                          height: buttonSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2FA7A0).withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF2FA7A0).withValues(alpha: 0.4),
                              width: borderWidth,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: iconSize,
                              color: const Color(0xFF2FA7A0),
                            ),
                          ),
                        ),
                      ),
                      if (_showExitHint) ...[
                        const SizedBox(width: 12),
                        AnimatedOpacity(
                          opacity: _showExitHint ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2FA7A0),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2FA7A0).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  color: Colors.amber.shade300,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Çıkmak için çift dokun! 🌟',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Kutlama Konfeti Katmanı (seviye tamamlandığında)
            Positioned.fill(
              child: IgnorePointer(
                child: CelebrationEffect(active: _isCelebrationActive),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bulut Modeli
class Cloud {
  double x;
  double y;
  final double scale;
  final double speed;

  Cloud({
    required this.x,
    required this.y,
    required this.scale,
    required this.speed,
  });
}

// Balon Modeli
class Balloon {
  double x;
  double y;
  final double baseX;
  final double radius;
  final Color color;
  final double speed;
  final IconData? icon;

  // Salınım hareketi için
  final double waveAmplitude;
  final double waveFrequency;
  final double wavePhase;
  final bool isSpecial;

  Balloon({
    required this.x,
    required this.y,
    required this.baseX,
    required this.radius,
    required this.color,
    required this.speed,
    this.icon,
    required this.waveAmplitude,
    required this.waveFrequency,
    required this.wavePhase,
    this.isSpecial = false,
  });
}

// Parçacık (Efekt) Modeli
class Particle {
  double x;
  double y;
  double vx;
  double vy;
  final Color color;
  double radius;
  double alpha = 1.0;

  // Konfetiye özel alanlar
  final bool isConfetti;
  final double rotationSpeed;
  double rotation = 0.0;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.radius,
    this.isConfetti = false,
    this.rotationSpeed = 0.0,
  });

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;

    if (isConfetti) {
      // Konfeti rüzgar ve hafif yerçekimi simülasyonu
      vy += 80.0 * dt; // yerçekimi
      vx +=
          sin(DateTime.now().millisecondsSinceEpoch / 150.0) *
          15.0 *
          dt; // rüzgar salınımı
      alpha -= 0.6 * dt; // yavaşça kaybolma
      rotation += rotationSpeed * dt;
    } else {
      // Normal patlama parçacığı
      vy += 350.0 * dt; // daha güçlü yerçekimi düşüşü
      radius = max(0.0, radius - 4.0 * dt); // küçülme
      alpha -= 1.8 * dt; // hızlıca kaybolma
    }

    if (alpha < 0) alpha = 0.0;
  }
}

// Tüm Görsel Öğeleri Çizen CustomPainter
class BalloonPainter extends CustomPainter {
  final List<Balloon> balloons;
  final List<Particle> particles;
  final List<Cloud> clouds;

  BalloonPainter({
    required this.balloons,
    required this.particles,
    required this.clouds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Bulutları çiz
    for (var cloud in clouds) {
      _drawCloud(canvas, Offset(cloud.x, cloud.y), cloud.scale);
    }

    // 2. Balonları çiz
    for (var balloon in balloons) {
      final center = Offset(balloon.x, balloon.y);

      // Balon İpi (Dalgalı sevimli bir çizgi)
      final ipPaint =
          Paint()
            ..color = const Color(0x3D000000) // Hafif saydam siyah ip
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      final ipPath = Path();
      final double knotY = center.dy + balloon.radius * 1.15;
      ipPath.moveTo(center.dx, knotY);

      // İpin dalgalı aşağı inmesi
      ipPath.quadraticBezierTo(
        center.dx - 8,
        knotY + balloon.radius * 0.4,
        center.dx,
        knotY + balloon.radius * 0.8,
      );
      ipPath.quadraticBezierTo(
        center.dx + 8,
        knotY + balloon.radius * 1.2,
        center.dx,
        knotY + balloon.radius * 1.6,
      );
      canvas.drawPath(ipPath, ipPaint);

      // Balonun Gövdesi (Yumurta şeklinde dikey elips)
      final bodyPaint =
          Paint()
            ..color = balloon.color
            ..style = PaintingStyle.fill;

      final rect = Rect.fromCenter(
        center: center,
        width: balloon.radius * 2.0,
        height: balloon.radius * 2.3,
      );

      // Özel balonlar için parıltılı ve parlak dış kontur (outline) eklenmesi
      if (balloon.isSpecial) {
        final glowPaint =
            Paint()
              ..color = const Color(0xFFFFE082).withValues(alpha: 0.5)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8.0;
        canvas.drawOval(rect, glowPaint);

        final strokePaint =
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5;
        canvas.drawOval(rect, strokePaint);
      }

      canvas.drawOval(rect, bodyPaint);

      // Balon Düğümü (Alt kısımdaki üçgen)
      final dugumPath = Path();
      dugumPath.moveTo(center.dx, center.dy + balloon.radius * 1.05);
      dugumPath.lineTo(center.dx - 8, center.dy + balloon.radius * 1.22);
      dugumPath.lineTo(center.dx + 8, center.dy + balloon.radius * 1.22);
      dugumPath.close();
      canvas.drawPath(dugumPath, bodyPaint);

      // Balon Üzerindeki Parlama Efekti (3D parlaklık kazandırmak için sol üstte beyaz elips)
      final parlamaPaint =
          Paint()
            ..color = Colors.white.withValues(alpha: 0.35)
            ..style = PaintingStyle.fill;

      canvas.save();
      // Parlamayı hafif sola ve yukarı taşıyıp döndürerek gerçekçi bir yansıma elde ediyoruz
      canvas.translate(
        center.dx - balloon.radius * 0.4,
        center.dy - balloon.radius * 0.55,
      );
      canvas.rotate(-0.35);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: balloon.radius * 0.32,
          height: balloon.radius * 0.58,
        ),
        parlamaPaint,
      );
      canvas.restore();

      // Balonun İçindeki Sembol / İkon
      if (balloon.icon != null) {
        final iconPainter = TextPainter(textDirection: TextDirection.ltr);
        iconPainter.text = TextSpan(
          text: String.fromCharCode(balloon.icon!.codePoint),
          style: TextStyle(
            fontSize: balloon.radius * 0.85,
            fontFamily: balloon.icon!.fontFamily,
            package: balloon.icon!.fontPackage,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        );
        iconPainter.layout();
        // İkonu tam merkeze hizala
        iconPainter.paint(
          canvas,
          Offset(
            center.dx - iconPainter.width / 2,
            center.dy - iconPainter.height / 2,
          ),
        );
      }
    }

    // 3. Parçacıkları (Patlama ve Konfeti) Çiz
    for (var particle in particles) {
      if (particle.isConfetti) {
        // Konfeti Çizimi (Döndürülmüş renkli küçük dikdörtgenler)
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(particle.rotation);

        final paint =
            Paint()
              ..color = particle.color.withValues(alpha: particle.alpha)
              ..style = PaintingStyle.fill;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.radius * 2.2,
            height: particle.radius * 1.3,
          ),
          paint,
        );
        canvas.restore();
      } else {
        // Normal Balon Parçacığı Çizimi (Daireler)
        final paint =
            Paint()
              ..color = particle.color.withValues(alpha: particle.alpha)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.radius,
          paint,
        );
      }
    }
  }

  // Basit vektörel bulut çizici yardımcı fonksiyonu
  void _drawCloud(Canvas canvas, Offset position, double scale) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.68)
          ..style = PaintingStyle.fill;

    // Birkaç daireyi birleştirerek yumuşak bir bulut kümesi oluşturuyoruz
    canvas.drawCircle(position, 28 * scale, paint);
    canvas.drawCircle(
      Offset(position.dx - 22 * scale, position.dy + 4 * scale),
      20 * scale,
      paint,
    );
    canvas.drawCircle(
      Offset(position.dx + 22 * scale, position.dy + 4 * scale),
      22 * scale,
      paint,
    );
    canvas.drawCircle(
      Offset(position.dx, position.dy + 12 * scale),
      20 * scale,
      paint,
    );
    canvas.drawCircle(
      Offset(position.dx - 10 * scale, position.dy + 12 * scale),
      22 * scale,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant BalloonPainter oldDelegate) => true;
}
