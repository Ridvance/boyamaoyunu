import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Şablon Tipleri
enum ShapeType { circle, star, house }

/// Parçacık Sınıfı (Başarı Animasyonu Yıldızları)
class TracingParticle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double opacity;
  double rotation;
  double rotationSpeed;

  TracingParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    this.opacity = 1.0,
    required this.rotation,
    required this.rotationSpeed,
  });

  void update() {
    position += velocity;
    // Yerçekimi ve sürtünme simülasyonu
    velocity = Offset(velocity.dx * 0.96, velocity.dy * 0.96 + 0.15);
    opacity = (opacity - 0.015).clamp(0.0, 1.0);
    rotation += rotationSpeed;
  }
}

/// Çizgi Takip Noktası
class TracingDot {
  final Offset normalizedPosition; // 0.0 - 1.0 arası normalize pozisyon
  Offset position;                 // Ekran üzerindeki gerçek piksel koordinatı
  bool isTraced;
  double scale;

  TracingDot({
    required this.normalizedPosition,
    this.position = Offset.zero,
    this.isTraced = false,
    this.scale = 1.0,
  });
}

/// Şablon Modeli
class TracingTemplate {
  final ShapeType type;
  final List<Offset> points;
  final Color themeColor;
  final IconData icon;

  TracingTemplate({
    required this.type,
    required this.points,
    required this.themeColor,
    required this.icon,
  });
}

class TracingGame extends StatefulWidget {
  const TracingGame({super.key});

  @override
  State<TracingGame> createState() => _TracingGameState();
}

class _TracingGameState extends State<TracingGame> with TickerProviderStateMixin {
  late final AnimationController _particleController;
  late final AnimationController _pulseController;
  late final AnimationController _hintController;
  
  // Şablonlar
  final List<TracingTemplate> _templates = [];
  int _currentTemplateIndex = 0;

  // Noktacıklar ve parçacıklar
  List<TracingDot> _dots = [];
  final List<TracingParticle> _particles = [];
  
  bool _isCompleted = false;
  Size _canvasSize = Size.zero;
  
  // İpucu el animasyonu için durumlar
  Timer? _hintTimer;
  bool _showHint = false;
  Offset _hintPosition = Offset.zero;
  
  @override
  void initState() {
    super.initState();
    _initTemplates();

    // Parçacık Animasyon Kontrolcüsü
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
        if (_particles.isNotEmpty) {
          setState(() {
            for (var particle in _particles) {
              particle.update();
            }
            _particles.removeWhere((p) => p.opacity <= 0.0);
          });
        }
      });

    // Nabız gibi büyüyen butonlar için Kontrolcü
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // İpucu Eli Kontrolcüsü (çizgi boyu hareket)
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        if (_showHint && _dots.isNotEmpty) {
          setState(() {
            // İpucu elinin konumunu güncelle
            final double progress = _hintController.value;
            final int index = (progress * (_dots.length - 1)).round();
            _hintPosition = _dots[index].position;
          });
        }
      });

    // İpucu timer'ını başlat
    _resetHintTimer();
  }

  void _initTemplates() {
    // 1. Daire Şablonu
    final circlePoints = <Offset>[];
    const int circleSegments = 40;
    for (int i = 0; i <= circleSegments; i++) {
      final double angle = (i * 2 * pi) / circleSegments;
      circlePoints.add(Offset(
        0.5 + 0.32 * cos(angle),
        0.5 + 0.32 * sin(angle),
      ));
    }
    _templates.add(TracingTemplate(
      type: ShapeType.circle,
      points: circlePoints,
      themeColor: const Color(0xFFFF5252), // Pembe/Kırmızı
      icon: Icons.circle_outlined,
    ));

    // 2. Yıldız Şablonu
    final starPoints = <Offset>[];
    const double R = 0.36; // dış yarıçap
    const double r = 0.16; // iç yarıçap
    for (int i = 0; i <= 10; i++) {
      final double angle = -pi / 2 + (i * pi / 5);
      final double radius = (i % 2 == 0) ? R : r;
      starPoints.add(Offset(
        0.5 + radius * cos(angle),
        0.5 + radius * sin(angle),
      ));
    }
    _templates.add(TracingTemplate(
      type: ShapeType.star,
      points: starPoints,
      themeColor: const Color(0xFFFFC107), // Altın Sarısı
      icon: Icons.star_border_rounded,
    ));

    // 3. Ev Şablonu
    final housePoints = const [
      Offset(0.25, 0.75), // Sol alt
      Offset(0.75, 0.75), // Sağ alt
      Offset(0.75, 0.45), // Sağ üst
      Offset(0.5, 0.18),  // Çatı tepesi
      Offset(0.25, 0.45), // Sol üst
      Offset(0.25, 0.75), // Sol alt (gövde kapandı)
      Offset(0.25, 0.45), // Sol üst
      Offset(0.75, 0.45), // Sağ üst (tavan çizgisi)
    ];
    _templates.add(TracingTemplate(
      type: ShapeType.house,
      points: housePoints,
      themeColor: const Color(0xFF4CAF50), // Yeşil
      icon: Icons.home_outlined,
    ));
  }

  @override
  void dispose() {
    _particleController.dispose();
    _pulseController.dispose();
    _hintController.dispose();
    _hintTimer?.cancel();
    super.dispose();
  }

  // Kullanıcı hareketsiz kaldığında tetiklenecek ipucu zamanlayıcısı
  void _resetHintTimer() {
    _hintTimer?.cancel();
    if (_isCompleted) return;

    _showHint = false;
    _hintController.stop();

    _hintTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted || _isCompleted) return;
      setState(() {
        _showHint = true;
        _hintController.repeat();
      });
    });
  }

  // Canvas boyutunu aldığımızda veya şablon değiştiğinde noktacıkları oluştururuz
  void _buildDots(Size size) {
    if (size == Size.zero) return;
    _canvasSize = size;
    final template = _templates[_currentTemplateIndex];
    final List<TracingDot> newDots = [];
    const double stepDistance = 15.0; // Pikseller arası mesafe

    for (int i = 0; i < template.points.length - 1; i++) {
      final pA = Offset(template.points[i].dx * size.width, template.points[i].dy * size.height);
      final pB = Offset(template.points[i + 1].dx * size.width, template.points[i + 1].dy * size.height);

      final vector = pB - pA;
      final distance = vector.distance;
      final int steps = (distance / stepDistance).floor();

      for (int j = 0; j < steps; j++) {
        final t = j / steps;
        final dotPos = Offset.lerp(pA, pB, t)!;
        newDots.add(TracingDot(
          normalizedPosition: Offset.lerp(template.points[i], template.points[i + 1], t)!,
          position: dotPos,
        ));
      }
    }

    // Son noktayı ekleyelim
    final lastNormalized = template.points.last;
    final lastPos = Offset(lastNormalized.dx * size.width, lastNormalized.dy * size.height);
    newDots.add(TracingDot(
      normalizedPosition: lastNormalized,
      position: lastPos,
    ));

    setState(() {
      _dots = newDots;
      _isCompleted = false;
    });
  }

  // Parmak hareketini takip etme
  void _onPanUpdate(DragUpdateDetails details) {
    if (_isCompleted) return;
    _resetHintTimer();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    bool updated = false;
    // Çocukların parmakları için toleranslı mesafe (40 piksel)
    const double touchThreshold = 40.0; 

    setState(() {
      for (var dot in _dots) {
        final dist = (dot.position - localPosition).distance;
        if (dist < touchThreshold) {
          if (!dot.isTraced) {
            dot.isTraced = true;
            updated = true;
            // Küçük titreşim/tıklama hissi
            HapticFeedback.selectionClick();
          }
          dot.scale = 1.6; // Parmağa yakın noktalar büyür
        } else {
          dot.scale = (dot.scale - 0.05).clamp(1.0, 1.6);
        }
      }
    });

    if (updated) {
      _checkProgress();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _resetHintTimer();
    setState(() {
      for (var dot in _dots) {
        dot.scale = 1.0;
      }
    });
  }

  void _checkProgress() {
    if (_dots.isEmpty) return;
    final int tracedCount = _dots.where((d) => d.isTraced).length;
    final double progress = tracedCount / _dots.length;

    if (progress >= 0.85 && !_isCompleted) {
      _isCompleted = true;
      _hintTimer?.cancel();
      _showHint = false;
      _hintController.stop();
      _triggerSuccess();
    }
  }

  void _triggerSuccess() {
    HapticFeedback.heavyImpact();
    // Yıldız patlaması oluşturma
    final random = Random();
    final template = _templates[_currentTemplateIndex];
    final colors = [
      template.themeColor,
      Colors.amber,
      Colors.pinkAccent,
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.lightGreenAccent,
    ];

    // Şeklin merkezinden parçacık fırlatma
    final center = Offset(_canvasSize.width / 2, _canvasSize.height / 2);
    _particles.clear();
    for (int i = 0; i < 90; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 4.0 + random.nextDouble() * 9.0;
      _particles.add(TracingParticle(
        position: center,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        color: colors[random.nextInt(colors.length)],
        size: 10.0 + random.nextDouble() * 14.0,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: -0.15 + random.nextDouble() * 0.3,
      ));
    }

    _particleController.forward(from: 0.0);
  }

  void _selectTemplate(int index) {
    if (_currentTemplateIndex == index && _dots.isNotEmpty) {
      // Zaten seçiliyse sadece sıfırla
      _resetCurrent();
      return;
    }
    setState(() {
      _currentTemplateIndex = index;
      _isCompleted = false;
      _particles.clear();
    });
    if (_canvasSize != Size.zero) {
      _buildDots(_canvasSize);
    }
    _resetHintTimer();
  }

  void _resetCurrent() {
    setState(() {
      _isCompleted = false;
      _particles.clear();
      for (var dot in _dots) {
        dot.isTraced = false;
        dot.scale = 1.0;
      }
    });
    _resetHintTimer();
  }

  void _nextTemplate() {
    final nextIndex = (_currentTemplateIndex + 1) % _templates.length;
    _selectTemplate(nextIndex);
  }

  @override
  Widget build(BuildContext context) {
    final currentTemplate = _templates[_currentTemplateIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Hafif yeşil/mavi pastel tonları
              Color(0xFFC8E6C9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 1. Çizim Alanı (Merkez)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(constraints.maxWidth, constraints.maxHeight);
                    if (_canvasSize != size) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _buildDots(size);
                      });
                    }
                    return GestureDetector(
                      onPanStart: (details) => _resetHintTimer(),
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: CustomPaint(
                        size: size,
                        painter: TracingPainter(
                          dots: _dots,
                          particles: _particles,
                          themeColor: currentTemplate.themeColor,
                          isCompleted: _isCompleted,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2. İlerleme Çubuğu (Gökkuşağı / Şeker Barı) - Üst Orta
              Positioned(
                top: 20,
                left: 120,
                right: 120,
                child: Center(
                  child: _buildProgressBar(currentTemplate.themeColor),
                ),
              ),

              // 3. Sol Üst Geri Butonu (En az 64x64 dp)
              Positioned(
                top: 16,
                left: 16,
                child: _buildIconButton(
                  icon: Icons.arrow_back_rounded,
                  color: Colors.redAccent,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                  },
                ),
              ),

              // 4. Sağ Üst Yenileme (Reset) Butonu
              Positioned(
                top: 16,
                right: 16,
                child: _buildIconButton(
                  icon: Icons.refresh_rounded,
                  color: Colors.orangeAccent,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _resetCurrent();
                  },
                ),
              ),

              // 5. Sol Orta - Şablon Seçim Barı (Dikey Panel)
              Positioned(
                left: 16,
                top: 100,
                bottom: 100,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_templates.length, (index) {
                        final temp = _templates[index];
                        final isSelected = index == _currentTemplateIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _buildTemplateSelector(temp, index, isSelected),
                        );
                      }),
                    ),
                  ),
                ),
              ),

              // 6. Başarı Durumunda Sağda Beliren Zıplayan "Sonraki" Butonu
              if (_isCompleted)
                Positioned(
                  right: 32,
                  bottom: 32,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.1).animate(
                      CurvedAnimation(
                        parent: _pulseController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: _buildSuccessNextButton(),
                  ),
                ),

              // 7. İpucu Eli (Tutorial Hand)
              if (_showHint && !_isCompleted)
                Positioned(
                  left: _hintPosition.dx - 24,
                  top: _hintPosition.dy - 24,
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.15),
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.touch_app_rounded,
                        size: 48,
                        color: currentTemplate.themeColor.withOpacity(0.8),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Büyük, sevimli ikon butonu şablonu (Geri ve Sıfırla için)
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 36),
        ),
      ),
    );
  }

  // Sol taraftaki şablon seçim butonları
  Widget _buildTemplateSelector(TracingTemplate template, int index, bool isSelected) {
    final double size = isSelected ? 72.0 : 60.0;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _selectTemplate(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? template.themeColor : Colors.grey[100],
          shape: BoxShape.circle,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: template.themeColor.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Icon(
            template.icon,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: isSelected ? 36 : 28,
          ),
        ),
      ),
    );
  }

  // İlerleme Çubuğu tasarımı
  Widget _buildProgressBar(Color themeColor) {
    if (_dots.isEmpty) return const SizedBox.shrink();
    final int tracedCount = _dots.where((d) => d.isTraced).length;
    final double ratio = tracedCount / _dots.length;

    return Container(
      width: 260,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          // Doluluk barı
          FractionallySizedBox(
            widthFactor: ratio,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor.withOpacity(0.7), themeColor],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Yıldız ikonu (ilerlemeyi taçlandırmak için)
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.star_rounded,
              color: ratio >= 0.85 ? Colors.amber : Colors.grey[400],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Başarıyla tamamlandığında gösterilecek sevimli "Sonraki" butonu
  Widget _buildSuccessNextButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _nextTemplate();
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 46,
          ),
        ),
      ),
    );
  }
}

/// CustomPainter ile Şablonu, Noktaları ve Parçacıkları Çizelim
class TracingPainter extends CustomPainter {
  final List<TracingDot> dots;
  final List<TracingParticle> particles;
  final Color themeColor;
  final bool isCompleted;

  TracingPainter({
    required this.dots,
    required this.particles,
    required this.themeColor,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dots.isEmpty) return;

    // 1. Çizilmeyen (yetToTrace) Noktaları Gri/Kesikli Çizelim
    final dotCorePaint = Paint()
      ..color = Colors.blueGrey[200]!.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Şablonun genel hattını (gri kılavuz yolu) çizelim
    for (int i = 0; i < dots.length; i++) {
      canvas.drawCircle(dots[i].position, 6.0, dotCorePaint);
    }

    // 2. Çizilen (Traced) Noktaları Parlak ve Neon Şeklinde Boyayalım
    final tracePaint = Paint()
      ..color = themeColor
      ..style = PaintingStyle.fill;

    final traceGlowPaint = Paint()
      ..color = themeColor.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dots.length; i++) {
      final dot = dots[i];
      if (dot.isTraced) {
        // Neon parıltı etkisi için dış katman
        canvas.drawCircle(dot.position, 16.0 * dot.scale, traceGlowPaint);
        // Merkez dolgu
        canvas.drawCircle(dot.position, 10.0 * dot.scale, tracePaint);
      }
    }

    // 3. Patlama Parçacıklarını (TracingParticle) Çizelim
    if (particles.isNotEmpty) {
      for (var p in particles) {
        _drawStar(canvas, p.position, p.size, p.color.withOpacity(p.opacity), p.rotation);
      }
    }
  }

  // Yıldız Şekli Çizici (CustomPainter için)
  void _drawStar(Canvas canvas, Offset center, double size, Color color, double rotation) {
    final paint = Paint()..color = color;
    final path = Path();
    const int points = 5;
    final double halfWidth = size / 2;
    final double externalRadius = halfWidth;
    final double internalRadius = halfWidth / 2.5;

    path.moveTo(
      center.dx + externalRadius * cos(rotation - pi / 2),
      center.dy + externalRadius * sin(rotation - pi / 2),
    );

    for (int i = 1; i < points * 2; i++) {
      final double angle = rotation - pi / 2 + i * pi / points;
      final double r = i.isEven ? externalRadius : internalRadius;
      path.lineTo(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TracingPainter oldDelegate) {
    return true; // Animasyonların akıcı olması için sürekli yeniden çizilmesini sağlıyoruz
  }
}
