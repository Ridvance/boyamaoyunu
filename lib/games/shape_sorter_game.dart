import 'dart:math';
import 'package:flutter/material.dart';
import '../services/audio_synth.dart';
import '../services/guidance_widgets.dart';
import '../services/progress_service.dart';
import 'magic_colors/chameleon_painter.dart';
import 'dart:async';

// Şekil tipleri
enum ShapeType {
  circle,
  square,
  triangle,
  star,
  heart,
  diamond,
  crescent,
  oval,
  pentagon,
  hexagon,
  cross,
  rectangle,
}

// Şekil yollarını çizen sınıf
class ShapePaths {
  static Path getCirclePath(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    return path;
  }

  static Path getSquarePath(Size size, {double radius = 20.0}) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );
    return path;
  }

  static Path getTrianglePath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = w * 0.12; // Yuvarlama yarıçapı

    // Yumuşak köşeli üçgen
    path.moveTo(w / 2, r);
    path.quadraticBezierTo(w / 2, 0, w / 2 + r * 0.8, r * 0.5);
    path.lineTo(w - r, h - r * 1.5);
    path.quadraticBezierTo(w, h - r * 0.5, w - r, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, r * 0.2, h - r * 0.5);
    path.lineTo(w / 2 - r * 0.8, r * 0.5);
    path.quadraticBezierTo(w / 2, 0, w / 2, r);
    path.close();
    return path;
  }

  static Path getStarPath(Size size) {
    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double rx = size.width / 2;

    final double rOuter = rx;
    final double rInner = rx * 0.45;

    double angle = -90.0 * (pi / 180.0);
    double angleStep = 360.0 / 10 * (pi / 180.0);

    path.moveTo(cx + rOuter * cos(angle), cy + rOuter * sin(angle));

    for (int i = 1; i < 10; i++) {
      angle += angleStep;
      double r = (i % 2 == 0) ? rOuter : rInner;
      path.lineTo(cx + r * cos(angle), cy + r * sin(angle));
    }
    path.close();
    return path;
  }

  static Path getHeartPath(Size size) {
    final path = Path();
    final double w = size.width;
    final double h = size.height;

    path.moveTo(w / 2, h * 0.3);
    path.cubicTo(w * 0.2, h * 0.05, w * -0.1, h * 0.45, w / 2, h * 0.9);
    path.cubicTo(w * 1.1, h * 0.45, w * 0.8, h * 0.05, w / 2, h * 0.3);
    path.close();
    return path;
  }

  static Path getDiamondPath(Size size) {
    final path = Path();
    final double w = size.width;
    final double h = size.height;

    final double r = w * 0.1;
    path.moveTo(w / 2, r);
    path.quadraticBezierTo(w / 2, 0, w / 2 + r, r);
    path.lineTo(w - r, h / 2 - r);
    path.quadraticBezierTo(w, h / 2, w - r, h / 2 + r);
    path.lineTo(w / 2 + r, h - r);
    path.quadraticBezierTo(w / 2, h, w / 2 - r, h - r);
    path.lineTo(r, h / 2 + r);
    path.quadraticBezierTo(0, h / 2, r, h / 2 - r);
    path.close();
    return path;
  }

  static Path getCrescentPath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.8, h * 0.1);
    path.quadraticBezierTo(w * 0.15, h * 0.15, w * 0.25, h * 0.5);
    path.quadraticBezierTo(w * 0.15, h * 0.85, w * 0.8, h * 0.9);
    path.quadraticBezierTo(w * 0.45, h * 0.75, w * 0.45, h * 0.5);
    path.quadraticBezierTo(w * 0.45, h * 0.25, w * 0.8, h * 0.1);
    path.close();
    return path;
  }

  static Path getOvalPath(Size size) {
    final path = Path();
    path.addOval(
      Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height),
    );
    return path;
  }

  static Path getPolygonPath(Size size, int sides) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + (2 * pi * i / sides);
      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  static Path getCrossPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path =
        Path()
          ..moveTo(w * 0.35, 0)
          ..lineTo(w * 0.65, 0)
          ..lineTo(w * 0.65, h * 0.35)
          ..lineTo(w, h * 0.35)
          ..lineTo(w, h * 0.65)
          ..lineTo(w * 0.65, h * 0.65)
          ..lineTo(w * 0.65, h)
          ..lineTo(w * 0.35, h)
          ..lineTo(w * 0.35, h * 0.65)
          ..lineTo(0, h * 0.65)
          ..lineTo(0, h * 0.35)
          ..lineTo(w * 0.35, h * 0.35)
          ..close();
    return path;
  }

  static Path getRectanglePath(Size size) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.6),
        const Radius.circular(18),
      ),
    );
    return path;
  }
}

// Şekil çizici CustomPainter
class ShapeCustomPainter extends CustomPainter {
  final ShapeType type;
  final Color color;
  final PaintingStyle style;
  final double strokeWidth;

  ShapeCustomPainter({
    required this.type,
    required this.color,
    this.style = PaintingStyle.fill,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = style
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    Path path;
    switch (type) {
      case ShapeType.circle:
        path = ShapePaths.getCirclePath(size);
        break;
      case ShapeType.square:
        path = ShapePaths.getSquarePath(size);
        break;
      case ShapeType.triangle:
        path = ShapePaths.getTrianglePath(size);
        break;
      case ShapeType.star:
        path = ShapePaths.getStarPath(size);
        break;
      case ShapeType.heart:
        path = ShapePaths.getHeartPath(size);
        break;
      case ShapeType.diamond:
        path = ShapePaths.getDiamondPath(size);
        break;
      case ShapeType.crescent:
        path = ShapePaths.getCrescentPath(size);
        break;
      case ShapeType.oval:
        path = ShapePaths.getOvalPath(size);
        break;
      case ShapeType.pentagon:
        path = ShapePaths.getPolygonPath(size, 5);
        break;
      case ShapeType.hexagon:
        path = ShapePaths.getPolygonPath(size, 6);
        break;
      case ShapeType.cross:
        path = ShapePaths.getCrossPath(size);
        break;
      case ShapeType.rectangle:
        path = ShapePaths.getRectanglePath(size);
        break;
    }

    canvas.drawPath(path, paint);

    if (style == PaintingStyle.fill) {
      // Şekli daha 3 boyutlu ve şirin göstermek için kenarlık gölgesi
      final strokePaint =
          Paint()
            ..color = color.withValues(alpha: 0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShapeCustomPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.color != color ||
        oldDelegate.style != style ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Şekil Widget'ı
class ShapeWidget extends StatelessWidget {
  final ShapeType type;
  final Color color;
  final double size;
  final bool isShadow;

  const ShapeWidget({
    super.key,
    required this.type,
    required this.color,
    this.size = 80.0,
    this.isShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow:
            isShadow
                ? []
                : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
      ),
      child: CustomPaint(
        painter: ShapeCustomPainter(
          type: type,
          color: isShadow ? Colors.blueGrey.withValues(alpha: 0.12) : color,
          style: PaintingStyle.fill,
        ),
        foregroundPainter:
            isShadow
                ? ShapeCustomPainter(
                  type: type,
                  color: Colors.blueGrey.withValues(alpha: 0.35),
                  style: PaintingStyle.stroke,
                  strokeWidth: 3.5,
                )
                : null,
      ),
    );
  }
}

// Şekil Veri Modeli
class ShapeItem {
  final ShapeType type;
  final Color color;
  bool isPlaced;
  bool isReturning;
  bool isDragging;
  final GlobalKey key = GlobalKey();

  ShapeItem({
    required this.type,
    required this.color,
    this.isPlaced = false,
    this.isReturning = false,
    this.isDragging = false,
  });
}

// Geri dönüş animasyonu verisi
class ActiveReturnAnimation {
  final ShapeType type;
  final Color color;
  final Offset startOffset;
  final Offset endOffset;
  late final AnimationController controller;
  late final Animation<Offset> animation;

  ActiveReturnAnimation({
    required this.type,
    required this.color,
    required this.startOffset,
    required this.endOffset,
    required TickerProvider vsync,
    required VoidCallback onComplete,
    required VoidCallback onUpdate,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 350),
    );
    animation =
        Tween<Offset>(begin: startOffset, end: endOffset).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          )
          ..addListener(onUpdate)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              onComplete();
            }
          });
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}

// Parıldama (Sparkle) parçacığı
class SparkleParticle {
  final double angle;
  final double speed;
  final Color color;
  double distance = 0.0;
  double size;

  SparkleParticle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
  });
}

// Parıldama efekti
class ActiveSparkleEffect {
  final Offset position;
  final List<SparkleParticle> particles;
  late final AnimationController controller;

  ActiveSparkleEffect({
    required this.position,
    required TickerProvider vsync,
    required VoidCallback onComplete,
    required VoidCallback onUpdate,
    required List<Color> colors,
  }) : particles = [] {
    final random = Random();
    for (int i = 0; i < 12; i++) {
      particles.add(
        SparkleParticle(
          angle: (i * 30.0) * (pi / 180.0) + (random.nextDouble() * 0.3 - 0.15),
          speed: 2.0 + random.nextDouble() * 2.5,
          color: colors[random.nextInt(colors.length)],
          size: 6.0 + random.nextDouble() * 8.0,
        ),
      );
    }

    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 450),
    );

    controller.addListener(() {
      final progress = controller.value;
      for (var p in particles) {
        p.distance = progress * p.speed * 35.0;
      }
      onUpdate();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onComplete();
      }
    });

    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}

// Parıldama Çizicisi
class SparklePainter extends CustomPainter {
  final List<ActiveSparkleEffect> sparkles;

  SparklePainter(this.sparkles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var effect in sparkles) {
      final double progress = effect.controller.value;
      final opacity = 1.0 - progress;

      for (var p in effect.particles) {
        final paint =
            Paint()
              ..color = p.color.withValues(alpha: opacity)
              ..style = PaintingStyle.fill;

        final double x = effect.position.dx + cos(p.angle) * p.distance;
        final double y = effect.position.dy + sin(p.angle) * p.distance;

        canvas.drawCircle(Offset(x, y), p.size * (1.0 - progress * 0.4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SparklePainter oldDelegate) => true;
}

// Konfeti parçacığı
class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double rotation;
  double rotationSpeed;
  Color color;
  final double shapeType;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.shapeType,
  });
}

// Konfeti Çizicisi
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint =
          Paint()
            ..color = p.color
            ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);

      if (p.shapeType == 0) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => true;
}

// Sevimli Geri Butonu
class CuteBackButton extends StatefulWidget {
  final VoidCallback onPressed;
  const CuteBackButton({super.key, required this.onPressed});

  @override
  State<CuteBackButton> createState() => _CuteBackButtonState();
}

class _CuteBackButtonState extends State<CuteBackButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFFF8A80), width: 3),
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFFFF5252),
              size: 36,
            ),
          ),
        ),
      ),
    );
  }
}

// Ana Oyun Sınıfı
class ShapeSorterGame extends StatefulWidget {
  const ShapeSorterGame({super.key});

  @override
  State<ShapeSorterGame> createState() => _ShapeSorterGameState();
}

class _ShapeSorterGameState extends State<ShapeSorterGame>
    with TickerProviderStateMixin {
  static const double _itemContainerSize = 100.0;
  static const double _shapeSize = 72.0;
  static const double _itemPadding = 4.0;
  static const double _gridSpacingHorizontal = 8.0;
  static const double _gridSpacingVertical = 4.0;

  final GlobalKey _playAreaKey = GlobalKey();

  List<ShapeItem> _leftItems = [];
  List<ShapeItem> _rightItems = [];

  final List<ActiveReturnAnimation> _returningShapes = [];
  final List<ActiveSparkleEffect> _sparkles = [];
  final List<ConfettiParticle> _confetti = [];

  late final AnimationController _celebrationController;
  bool _isCelebrationActive = false;
  int _levelNumber = 1;
  int _matchesThisLevel = 0;

  final List<Color> _presetColors = const [
    Color(0xFFFF5252), // Kırmızı
    Color(0xFF3498DB), // Canlı Mavi
    Color(0xFF2ECC71), // Zümrüt Yeşili
    Color(0xFFF1C40F), // Güneş Sarısı
    Color(0xFF9B59B6), // Mor
    Color(0xFFFF7675), // Pastel Kırmızı
    Color(0xFFFF9F43), // Turuncu
    Color(0xFF00D2D3), // Turkuaz
  ];

  // Görsel Yönlendirme ve Kamo Değişkenleri
  bool _showHint = false;
  Offset _hintPosition = Offset.zero;
  late final AnimationController _hintController;
  String _kamoExpression = 'neutral';
  Timer? _kamoReactionTimer;
  final List<StreamController<void>> _wiggleControllers = List.generate(4, (_) => StreamController<void>.broadcast());

  List<ShapeItem> get leftItems => _leftItems;
  List<ShapeItem> get rightItems => _rightItems;
  int get matchesThisLevel => _matchesThisLevel;
  bool get isCelebrationActive => _isCelebrationActive;
  String get kamoExpression => _kamoExpression;
  int get levelNumber => _levelNumber;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(_updateConfetti);

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      if (_showHint && _leftItems.isNotEmpty && _rightItems.isNotEmpty) {
        final targetItem = _leftItems.cast<ShapeItem?>().firstWhere(
          (item) => item != null && !item.isPlaced,
          orElse: () => null,
        );
        if (targetItem != null) {
          final targetSlot = _rightItems.cast<ShapeItem?>().firstWhere(
            (slot) => slot != null && slot.type == targetItem.type,
            orElse: () => null,
          );
          if (targetSlot != null) {
            final startCenter = _getWidgetLocalCenter(targetItem.key);
            final endCenter = _getWidgetLocalCenter(targetSlot.key);
            if (startCenter != null && endCenter != null) {
              setState(() {
                _hintPosition = Offset.lerp(startCenter, endCenter, _hintController.value)!;
              });
            }
          }
        }
      }
    });

    _generateNewLevel();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _hintController.dispose();
    _kamoReactionTimer?.cancel();
    for (var anim in _returningShapes) {
      anim.dispose();
    }
    for (var effect in _sparkles) {
      effect.dispose();
    }
    for (var c in _wiggleControllers) {
      c.close();
    }
    super.dispose();
  }

  void _generateNewLevel() {
    final random = Random();

    // Şekil havuzundan 4 adet seç
    final List<ShapeType> availableShapes = List.from(ShapeType.values)
      ..shuffle(random);
    final List<ShapeType> selectedShapes = availableShapes.take(4).toList();

    // Renk havuzundan 4 adet seç
    final List<Color> availableColors = List.from(_presetColors)
      ..shuffle(random);
    final List<Color> selectedColors = availableColors.take(4).toList();

    setState(() {
      _returningShapes.clear();
      _sparkles.clear();
      _matchesThisLevel = 0;

      _leftItems = List.generate(4, (index) {
        return ShapeItem(
          type: selectedShapes[index],
          color: selectedColors[index],
        );
      });

      // Sağ taraf sol tarafın kopyası fakat sırası karıştırılmış
      _rightItems = List.generate(4, (index) {
        return ShapeItem(
          type: _leftItems[index].type,
          color: _leftItems[index].color,
        );
      });
      _rightItems.shuffle(random);
    });
  }

  void _handleDragCancel(ShapeItem item, Offset cancelOffset) {
    final RenderBox? playAreaBox =
        _playAreaKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? itemBox =
        item.key.currentContext?.findRenderObject() as RenderBox?;

    // Trigger wrong feedback wiggle on the item
    final idx = _leftItems.indexOf(item);
    if (idx != -1) {
      _wiggleControllers[idx].add(null);
    }

    if (!_isCelebrationActive) {
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

    if (playAreaBox == null || itemBox == null) {
      setState(() {
        item.isDragging = false;
        item.isReturning = false;
      });
      return;
    }

    // Global cancelOffset'i oyun alanı lokal koordinatlarına çevir
    final localStartOffset = playAreaBox.globalToLocal(cancelOffset);

    // Hedef kutunun oyun alanı üzerindeki lokal pozisyonunu bul
    // Ortalamak için paddingOffset ekliyoruz
    const double paddingOffset = (_itemContainerSize - _shapeSize) / 2;
    final localTargetOffset = playAreaBox.globalToLocal(
      itemBox.localToGlobal(const Offset(paddingOffset, paddingOffset)),
    );

    setState(() {
      item.isDragging = false;
      item.isReturning = true;
    });

    late ActiveReturnAnimation anim;
    anim = ActiveReturnAnimation(
      type: item.type,
      color: item.color,
      startOffset: localStartOffset,
      endOffset: localTargetOffset,
      vsync: this,
      onUpdate: () {
        setState(() {});
      },
      onComplete: () {
        setState(() {
          item.isReturning = false;
          _returningShapes.remove(anim);
        });
        anim.dispose();
      },
    );

    setState(() {
      _returningShapes.add(anim);
    });
  }

  void _startSparkle(Offset position, Color color) {
    late ActiveSparkleEffect effect;
    final colors = [
      color,
      Colors.white,
      Colors.yellowAccent,
      color.withValues(alpha: 0.6),
    ];

    effect = ActiveSparkleEffect(
      position: position,
      vsync: this,
      colors: colors,
      onUpdate: () {
        setState(() {});
      },
      onComplete: () {
        setState(() {
          _sparkles.remove(effect);
        });
        effect.dispose();
      },
    );

    setState(() {
      _sparkles.add(effect);
    });
  }

  void _checkLevelCompletion() {
    final allPlaced = _rightItems.every((item) => item.isPlaced);
    if (allPlaced) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    setState(() {
      _isCelebrationActive = true;
      _kamoExpression = 'happy';
      _levelNumber++;
    });
    ProgressService.instance.completeLevel('shapes', 0);
    _kamoReactionTimer?.cancel();
    AudioSynth.playSparkleSound();

    final random = Random();
    final double screenWidth = MediaQuery.of(context).size.width;

    _confetti.clear();
    for (int i = 0; i < 100; i++) {
      _confetti.add(
        ConfettiParticle(
          x: random.nextDouble() * screenWidth,
          y: -20 - random.nextDouble() * 120,
          vx: random.nextDouble() * 4 - 2,
          vy: 3 + random.nextDouble() * 4,
          size: 8 + random.nextDouble() * 8,
          rotation: random.nextDouble() * 2 * pi,
          rotationSpeed: random.nextDouble() * 0.1 - 0.05,
          color: _presetColors[random.nextInt(_presetColors.length)],
          shapeType: random.nextInt(2).toDouble(),
        ),
      );
    }

    _celebrationController.repeat();

    // 3 saniye sonra yeni seviye
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _celebrationController.stop();
        setState(() {
          _isCelebrationActive = false;
          _kamoExpression = 'neutral';
          _confetti.clear();
        });
        _generateNewLevel();
      }
    });
  }

  void _updateConfetti() {
    if (!mounted || !_isCelebrationActive) return;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final random = Random();

    setState(() {
      for (var p in _confetti) {
        p.x += p.vx;
        p.y += p.vy;
        p.rotation += p.rotationSpeed;

        // Rüzgar etkisi
        p.vx += sin(p.y / 25.0) * 0.08;

        // Ekran dışına çıkanları tekrar yukarı yerleştir
        if (p.y > screenHeight + 20) {
          p.y = -20;
          p.x = random.nextDouble() * screenWidth;
          p.vy = 3 + random.nextDouble() * 4;
          p.vx = random.nextDouble() * 4 - 2;
        }
      }
    });
  }

  Widget _buildLeftItem(ShapeItem item) {
    final bool shouldShowShape =
        !item.isPlaced && !item.isReturning && !item.isDragging;
    final int idx = _leftItems.indexOf(item);
    final bool isTarget = _showHint &&
        !_isCelebrationActive &&
        _leftItems.firstWhere((i) => !i.isPlaced, orElse: () => _leftItems.first) == item;

    Widget leftContent = Container(
      key: item.key,
      width: _itemContainerSize,
      height: _itemContainerSize,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: Center(
        child: shouldShowShape
            ? Draggable<ShapeType>(
                data: item.type,
                feedback: Transform.scale(
                  scale: 1.15,
                  child: Opacity(
                    opacity: 0.85,
                    child: ShapeWidget(
                      type: item.type,
                      color: item.color,
                      size: _shapeSize,
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.1,
                  child: ShapeWidget(
                    type: item.type,
                    color: item.color,
                    size: _shapeSize,
                  ),
                ),
                onDragStarted: () {
                  setState(() {
                    item.isDragging = true;
                  });
                },
                onDragEnd: (details) {
                  setState(() {
                    item.isDragging = false;
                  });
                },
                onDraggableCanceled: (velocity, offset) {
                  _handleDragCancel(item, offset);
                },
                child: PulseTarget(
                  active: isTarget,
                  color: item.color,
                  baseSize: _shapeSize,
                  child: ShapeWidget(
                    type: item.type,
                    color: item.color,
                    size: _shapeSize,
                  ),
                ),
              )
            : Container(),
      ),
    );

    if (idx != -1) {
      leftContent = SoftWrongFeedback(
        triggerStream: _wiggleControllers[idx].stream,
        child: leftContent,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(_itemPadding),
      child: leftContent,
    );
  }

  Widget _buildRightItem(ShapeItem item) {
    return Padding(
      padding: const EdgeInsets.all(_itemPadding),
      child: DragTarget<ShapeType>(
        onWillAcceptWithDetails: (details) {
          return details.data == item.type && !item.isPlaced;
        },
        onAcceptWithDetails: (details) {
          setState(() {
            item.isPlaced = true;
            _matchesThisLevel++;
            // Sol taraftaki eşleşeni de yerleşti olarak işaretle
            final leftItem = _leftItems.firstWhere(
              (left) => left.type == item.type,
            );
            leftItem.isPlaced = true;

            // Kamo tepkisi
            if (!_isCelebrationActive) {
              _kamoExpression = 'happy';
              _kamoReactionTimer?.cancel();
              _kamoReactionTimer = Timer(const Duration(milliseconds: 1200), () {
                if (mounted) {
                  setState(() {
                    _kamoExpression = _isCelebrationActive ? 'happy' : 'neutral';
                  });
                }
              });
            }
          });
          AudioSynth.playRaindropSound();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final RenderBox? playAreaBox =
                _playAreaKey.currentContext?.findRenderObject() as RenderBox?;
            final RenderBox? itemBox =
                item.key.currentContext?.findRenderObject() as RenderBox?;
            if (playAreaBox != null && itemBox != null) {
              final localCenter = playAreaBox.globalToLocal(
                itemBox.localToGlobal(
                  Offset(itemBox.size.width / 2, itemBox.size.height / 2),
                ),
              );
              _startSparkle(localCenter, item.color);
            }
            _checkLevelCompletion();
          });
        },
        builder: (context, candidateData, rejectedData) {
          final bool isHovered =
              candidateData.isNotEmpty && candidateData.first == item.type;

          return Container(
            key: item.key,
            width: _itemContainerSize,
            height: _itemContainerSize,
            decoration: BoxDecoration(
              color:
                  isHovered
                      ? item.color.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isHovered
                        ? item.color.withValues(alpha: 0.65)
                        : Colors.white.withValues(alpha: 0.4),
                width: isHovered ? 3.5 : 2,
              ),
            ),
            child: Center(
              child: ShapeWidget(
                type: item.type,
                color: item.color,
                size: _shapeSize,
                isShadow: !item.isPlaced,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLeftItem(_leftItems[0]),
            const SizedBox(width: _gridSpacingHorizontal),
            _buildLeftItem(_leftItems[1]),
          ],
        ),
        const SizedBox(height: _gridSpacingVertical),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLeftItem(_leftItems[2]),
            const SizedBox(width: _gridSpacingHorizontal),
            _buildLeftItem(_leftItems[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildRightGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRightItem(_rightItems[0]),
            const SizedBox(width: _gridSpacingHorizontal),
            _buildRightItem(_rightItems[1]),
          ],
        ),
        const SizedBox(height: _gridSpacingVertical),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRightItem(_rightItems[2]),
            const SizedBox(width: _gridSpacingHorizontal),
            _buildRightItem(_rightItems[3]),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_leftItems.isEmpty || _rightItems.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool kamoOnLeft = _isKamoOnLeft();

    return Scaffold(
      body: InactivityDetector(
        duration: const Duration(seconds: 3),
        onInactivity: () {
          if (mounted) {
            setState(() {
              _showHint = true;
            });
            _hintController.repeat();
          }
        },
        onActivity: () {
          if (mounted) {
            setState(() {
              _showHint = false;
            });
            _hintController.stop();
            _hintController.reset();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFDF5), Color(0xFFE8F4FD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Center(
                    child: Container(
                      key: const ValueKey('shape-sorter-level-badge'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF2FA7A0),
                          width: 3,
                        ),
                      ),
                      child: Text(
                        'Bölüm $_levelNumber  •  $_matchesThisLevel / ${_rightItems.length}',
                        style: const TextStyle(
                          color: Color(0xFF233238),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Oyun Alanı (Yatay yerleşim)
              SafeArea(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      key: _playAreaKey,
                      width: 600,
                      height: 260,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Row(
                            children: [
                              // Sol Bölüm (2x2 Renkli Şekiller)
                              Expanded(child: Center(child: _buildLeftGrid())),

                              // Orta İkon / Süreç Belirteci (Sevimli bir yıldız)
                              Container(
                                width: 80,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.star_rounded,
                                  size: 40,
                                  color: Colors.white54,
                                ),
                              ),

                              // Sağ Bölüm (2x2 Gölgeler)
                              Expanded(child: Center(child: _buildRightGrid())),
                            ],
                          ),

                          // GhostHandHint
                          if (_showHint && !_isCelebrationActive)
                            GhostHandHint(
                              position: _hintPosition,
                              active: true,
                            ),

                          // Yumuşak Geri Dönüş Animasyonu Katmanı
                          ..._returningShapes.map((anim) {
                            return AnimatedBuilder(
                              animation: anim.animation,
                              builder: (context, child) {
                                return Positioned(
                                  left: anim.animation.value.dx,
                                  top: anim.animation.value.dy,
                                  child: IgnorePointer(
                                    child: ShapeWidget(
                                      type: anim.type,
                                      color: anim.color,
                                      size: _shapeSize,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),

                          // Parıldama (Sparkle) Efekti Katmanı
                          if (_sparkles.isNotEmpty)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: SparklePainter(_sparkles),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Geri Butonu
              Positioned(
                top: 16,
                left: 16,
                child: SafeArea(
                  child: CuteBackButton(onPressed: () => Navigator.pop(context)),
                ),
              ),

              // Kutlama Konfeti Katmanı
              if (_isCelebrationActive)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: ConfettiPainter(_confetti)),
                  ),
                ),

              // Kutlama Görsel Efekti
              if (_isCelebrationActive)
                IgnorePointer(
                  child: CelebrationEffect(active: _isCelebrationActive),
                ),

              // Kamo Maskot Kartı
              Positioned(
                bottom: 16,
                left: kamoOnLeft ? 16 : null,
                right: kamoOnLeft ? null : 16,
                child: IgnorePointer(
                  child: Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2FA7A0).withValues(alpha: 0.5),
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
                      child: CustomPaint(
                        painter: ChameleonPainter(
                          chameleonColor: const Color(0xFF2FA7A0),
                          tongueProgress: 0.0,
                          lookTarget: const Offset(200, 200),
                          flies: const [],
                          idleProgress: 0.0,
                          isCamouflaged: false,
                          chameleonPos: const Offset(45, 30),
                          expression: _kamoExpression,
                        ),
                      ),
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

  Offset? _getWidgetLocalCenter(GlobalKey key) {
    final RenderBox? playAreaBox =
        _playAreaKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? widgetBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (playAreaBox == null || widgetBox == null) return null;

    final globalCenter = widgetBox.localToGlobal(
      Offset(widgetBox.size.width / 2, widgetBox.size.height / 2),
    );
    return playAreaBox.globalToLocal(globalCenter);
  }

  bool _isKamoOnLeft() {
    if (_rightItems.length > 3 && !_rightItems[3].isPlaced) {
      return true;
    }
    return false;
  }
}
