import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../services/audio_synth.dart';
import '../services/guidance_widgets.dart';
import 'magic_colors/chameleon_painter.dart';
import 'dart:async';

class SoundBoardGame extends StatefulWidget {
  const SoundBoardGame({super.key});

  @override
  State<SoundBoardGame> createState() => _SoundBoardGameState();
}

class _SoundBoardGameState extends State<SoundBoardGame> with TickerProviderStateMixin {
  final List<Particle> _particles = [];
  late final Ticker _ticker;

  // Cloud position tracking
  double _cloud1X = 100.0;
  double _cloud2X = 400.0;
  double _screenWidth = 800.0;

  // Görsel Yönlendirme ve Kamo Değişkenleri
  bool _showHint = false;
  Offset _hintPosition = Offset.zero;
  late final AnimationController _hintController;
  String _kamoExpression = 'neutral';
  Timer? _kamoReactionTimer;

  bool get showHint => _showHint;
  String get kamoExpression => _kamoExpression;

  @override
  void initState() {
    super.initState();
    // Ticker updates particles and clouds on every frame if active
    _ticker = createTicker((elapsed) {
      if (mounted) {
        setState(() {
          // Update clouds drift
          _cloud1X += 0.4;
          if (_cloud1X > _screenWidth) {
            _cloud1X = -100;
          }
          _cloud2X += 0.25;
          if (_cloud2X > _screenWidth) {
            _cloud2X = -100;
          }

          // Update particles
          for (int i = _particles.length - 1; i >= 0; i--) {
            final p = _particles[i];
            p.update();
            if (p.isDead) {
              _particles.removeAt(i);
            }
          }
        });
      }
    });
    _ticker.start();

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      if (_showHint) {
        final startCenter = _getWidgetLocalCenter(_keyKeys[0]);
        if (startCenter != null) {
          setState(() {
            _hintPosition = startCenter;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _hintController.dispose();
    _kamoReactionTimer?.cancel();
    super.dispose();
  }

  void _triggerKamoHappy() {
    _kamoReactionTimer?.cancel();
    setState(() {
      _kamoExpression = 'happy';
    });
    _kamoReactionTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  Offset? _getWidgetLocalCenter(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return null;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    final globalCenter = renderBox.localToGlobal(
      Offset(renderBox.size.width / 2, renderBox.size.height / 2),
    );

    final parentBox = this.context.findRenderObject() as RenderBox?;
    if (parentBox == null) return null;
    return parentBox.globalToLocal(globalCenter);
  }

  void _spawnParticles(Offset globalPosition, Color color, List<String> symbols) {
    if (_particles.length > 60) {
      _particles.removeRange(0, _particles.length - 60);
    }
    final random = math.Random();
    final count = 6 + random.nextInt(5); // Spawn 6-10 particles
    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (random.nextDouble() - 0.5) * 1.5; // upward cone
      final speed = 3.0 + random.nextDouble() * 6.0;
      final velocity = Offset(math.cos(angle) * speed, math.sin(angle) * speed);

      final symbol = symbols[random.nextInt(symbols.length)];

      _particles.add(
        Particle(
          position: globalPosition,
          velocity: velocity,
          color: color,
          text: symbol,
          size: 24.0 + random.nextDouble() * 24.0,
          maxLife: 35 + random.nextInt(20),
          rotationSpeed: (random.nextDouble() - 0.5) * 0.4,
        ),
      );
    }
  }

  void _playFeedback(int noteIndex) {
    SystemSound.play(SystemSoundType.click);
    AudioSynth.playXylophoneNote(noteIndex);
    // Mimic musical pitch scale using haptics
    if (noteIndex < 3) {
      HapticFeedback.lightImpact();
    } else if (noteIndex < 6) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  final List<GlobalKey<_XylophoneKeyWidgetState>> _keyKeys = List.generate(8, (_) => GlobalKey<_XylophoneKeyWidgetState>());
  int? _lastDraggedIndex;

  void _handleXylophoneDrag(PointerEvent event, double keyWidth) {
    final localX = event.localPosition.dx;
    final index = (localX / keyWidth).floor().clamp(0, 7);

    if (index != _lastDraggedIndex) {
      _lastDraggedIndex = index;
      
      // Calculate global position
      final box = context.findRenderObject() as RenderBox?;
      final globalPos = box != null ? box.localToGlobal(event.localPosition) : event.position;
      
      final color = [
        const Color(0xFFFF4B4B),
        const Color(0xFFFF8E2B),
        const Color(0xFFFFD000),
        const Color(0xFF2ECC71),
        const Color(0xFF1ABC9C),
        const Color(0xFF2B86FF),
        const Color(0xFF9B59B6),
        const Color(0xFFFF69B4),
      ][index];

      _playFeedback(index);
      _triggerKamoHappy();
      _spawnParticles(
        globalPos,
        color,
        ['🎵', '🎶', '✨', '⭐'],
      );
      _keyKeys[index].currentState?.animatePress();
    }
  }

  void _resetLastDragged() {
    _lastDraggedIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.sizeOf(context).width;
    final animalData = [
      const AnimalData(
        emoji: '🐱',
        color: Color(0xFFFF6B81),
        spawnEmojis: ['🐱', '🐾', '🐟', '❤️', '🎵', '🎶'],
      ),
      const AnimalData(
        emoji: '🐶',
        color: Color(0xFF4A90E2),
        spawnEmojis: ['🐶', '🐾', '🦴', '⭐', '🎵', '🎶'],
      ),
      const AnimalData(
        emoji: '🦆',
        color: Color(0xFFFFD15C),
        spawnEmojis: ['🦆', '🌊', '🫧', '✨', '🎵', '🎶'],
      ),
      const AnimalData(
        emoji: '🐸',
        color: Color(0xFF2ECC71),
        spawnEmojis: ['🐸', '💧', '🍀', '🍃', '🎵', '🎶'],
      ),
      const AnimalData(
        emoji: '🐮',
        color: Color(0xFF9B59B6),
        spawnEmojis: ['🐮', '🥛', '🌱', '🌸', '🎵', '🎶'],
      ),
      const AnimalData(
        emoji: '🐑',
        color: Color(0xFF1ABC9C),
        spawnEmojis: ['🐑', '🍀', '🌾', '☁️', '🎵', '🎶'],
      ),
      const AnimalData(
        emoji: '🐥',
        color: Color(0xFFFF9F43),
        spawnEmojis: ['🐥', '🌾', '🌻', '✨', '🎵', '🎶'],
      ),
    ];

    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    final woodBarTop = isShortHeight ? 20.0 : 40.0;
    final woodBarBottom = isShortHeight ? 20.0 : 40.0;
    final woodBarHeight = isShortHeight ? 8.0 : 16.0;

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
        child: SafeArea(
          child: Stack(
            children: [
             // Clouds in the background (slower depth element)
            Positioned(
              left: _cloud1X,
              top: isShortHeight ? 10 : 30,
              child: CloudWidget(
                onTap: (pos) {
                  AudioSynth.playRaindropSound();
                  _spawnParticles(pos, Colors.lightBlueAccent, ['☁️', '💧', '✨']);
                },
              ),
            ),
            Positioned(
              left: _cloud2X,
              top: isShortHeight ? 24 : 60,
              child: CloudWidget(
                onTap: (pos) {
                  AudioSynth.playRaindropSound();
                  _spawnParticles(pos, Colors.cyanAccent, ['☁️', '💧', '🎵']);
                },
              ),
            ),

            // Top Sun Widget (decorative & interactive)
            Positioned(
              right: isShortHeight ? 20 : 40,
              top: isShortHeight ? 10 : 20,
              child: SunWidget(
                onTap: (pos) {
                  AudioSynth.playSparkleSound();
                  _spawnParticles(pos, Colors.orangeAccent, ['☀️', '✨', '⭐', '💛']);
                },
              ),
            ),

            // Main UI Column
            Column(
              children: [
                SizedBox(height: isShortHeight ? 4 : 12),
                // Top Bar (just empty space to push animals down, back button placed absolutely)
                SizedBox(height: isShortHeight ? 16 : 64),
                // Animals Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isShortHeight ? 16.0 : 32.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: animalData.map((a) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: isShortHeight ? 6.0 : 14.0),
                          child: AnimalCardWidget(
                            emoji: a.emoji,
                            color: a.color,
                            onTap: (globalPos) {
                              _playFeedback(2); // Mid-high feedback
                              _triggerKamoHappy();
                              AudioSynth.playAnimalSound(a.emoji);
                              _spawnParticles(globalPos, a.color, a.spawnEmojis);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: isShortHeight ? 8 : 24),
                // Xylophone Section
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, isShortHeight ? 8 : 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Wood support bars
                        Positioned(
                          top: woodBarTop,
                          left: 16,
                          right: 16,
                          child: Container(
                            height: woodBarHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5A2B),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: woodBarBottom,
                          left: 16,
                          right: 16,
                          child: Container(
                            height: woodBarHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5A2B),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Keys
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final totalWidth = constraints.maxWidth;
                            final keyWidth = totalWidth / 8;
                            return Listener(
                              behavior: HitTestBehavior.opaque,
                              onPointerDown: (event) => _handleXylophoneDrag(event, keyWidth),
                              onPointerMove: (event) => _handleXylophoneDrag(event, keyWidth),
                              onPointerUp: (_) => _resetLastDragged(),
                              onPointerCancel: (_) => _resetLastDragged(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(8, (index) {
                                  final color = [
                                    const Color(0xFFFF4B4B), // Do (Red)
                                    const Color(0xFFFF8E2B), // Re (Orange)
                                    const Color(0xFFFFD000), // Mi (Yellow)
                                    const Color(0xFF2ECC71), // Fa (Green)
                                    const Color(0xFF1ABC9C), // Sol (Teal)
                                    const Color(0xFF2B86FF), // La (Blue)
                                    const Color(0xFF9B59B6), // Si (Purple)
                                    const Color(0xFFFF69B4), // Do (Pink)
                                  ][index];
                                  final heightFactor = 1.0 - (index * 0.04);
                                  return XylophoneKeyWidget(
                                    key: _keyKeys[index],
                                    color: color,
                                    heightFactor: heightFactor,
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Back Button at Top Left (absolute layout)
            Positioned(
              left: isShortHeight ? 12 : 20,
              top: isShortHeight ? 10 : 20,
              child: CircularBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Overlaid Particle Paint Layer
            IgnorePointer(
              child: CustomPaint(
                size: Size.infinite,
                painter: ParticlePainter(_particles),
              ),
            ),

            // Inactivity overlays (PulseTarget and GhostHandHint)
            if (_showHint && _hintPosition != Offset.zero) ...[
              Positioned(
                left: _hintPosition.dx - 28,
                top: _hintPosition.dy - 28,
                child: IgnorePointer(
                  child: PulseTarget(
                    active: true,
                    color: const Color(0xFFFF4B4B),
                    baseSize: 56.0,
                    child: const SizedBox(width: 56, height: 56),
                  ),
                ),
              ),
              GhostHandHint(
                position: _hintPosition,
                active: true,
              ),
            ],

            // Kamo Maskot Kartı
            Positioned(
              bottom: 16,
              right: 16,
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
}

// Particle model
class Particle {
  Offset position;
  Offset velocity;
  final Color color;
  final String text;
  final double size;
  double opacity = 1.0;
  double rotation = 0.0;
  final double rotationSpeed;
  int life = 0;
  final int maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.text,
    required this.size,
    required this.maxLife,
    required this.rotationSpeed,
  });

  void update() {
    position += velocity;
    // Gravity simulation
    velocity = Offset(velocity.dx * 0.97, velocity.dy + 0.18);
    life++;
    opacity = math.max(0.0, 1.0 - (life / maxLife));
    rotation += rotationSpeed;
  }

  bool get isDead => life >= maxLife;
}

// Custom Painter for Emojis / Musical Symbols
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (final p in particles) {
      if (p.opacity <= 0.0) continue;

      final textSpan = TextSpan(
        text: p.text,
        style: TextStyle(
          fontSize: p.size,
          color: p.color.withOpacity(p.opacity),
          fontFamily: 'EmojiOne', // Fallback safety
        ),
      );
      textPainter.text = textSpan;
      textPainter.layout();

      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.rotation);
      // Center align text drawing
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

// Animal Card Model
class AnimalData {
  final String emoji;
  final Color color;
  final List<String> spawnEmojis;

  const AnimalData({
    required this.emoji,
    required this.color,
    required this.spawnEmojis,
  });
}

// Animated Animal Card Widget
class AnimalCardWidget extends StatefulWidget {
  final String emoji;
  final Color color;
  final Function(Offset globalPos) onTap;

  const AnimalCardWidget({
    required this.emoji,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  State<AnimalCardWidget> createState() => _AnimalCardWidgetState();
}

class _AnimalCardWidgetState extends State<AnimalCardWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _jumpAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -45.0).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -45.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 55,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.85).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.0),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(PointerDownEvent event) {
    if (!_controller.isAnimating) {
      _controller.forward(from: 0.0);
      widget.onTap(event.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    final cardSize = isShortHeight ? 60.0 : 90.0;
    final borderWidth = isShortHeight ? 3.0 : 5.0;
    final emojiSize = isShortHeight ? 32.0 : 48.0;

    return Listener(
      onPointerDown: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _jumpAnimation.value * (isShortHeight ? 0.5 : 1.0)),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color.withOpacity(0.8), width: borderWidth),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: isShortHeight ? 6 : 10,
                      offset: Offset(0, isShortHeight ? 3 : 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.emoji,
                  style: TextStyle(fontSize: emojiSize, height: 1.1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Xylophone Key Widget
class XylophoneKeyWidget extends StatefulWidget {
  final Color color;
  final double heightFactor;

  const XylophoneKeyWidget({
    required this.color,
    required this.heightFactor,
    super.key,
  });

  @override
  State<XylophoneKeyWidget> createState() => _XylophoneKeyWidgetState();
}

class _XylophoneKeyWidgetState extends State<XylophoneKeyWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animatePress() {
    if (mounted) {
      _controller.forward().then((_) {
        if (mounted) _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    final pinOffset = isShortHeight ? 12.0 : 24.0;
    final pinSize = isShortHeight ? 8.0 : 14.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyHeight = constraints.maxHeight * widget.heightFactor;
            return Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _pressAnimation,
                builder: (context, child) {
                  final isPressed = _controller.value > 0;
                  return Transform.translate(
                    offset: Offset(0, _pressAnimation.value),
                    child: Container(
                      height: keyHeight - _pressAnimation.value,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(isShortHeight ? 10 : 20),
                        boxShadow: isPressed
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, (isShortHeight ? 5 : 10) - _pressAnimation.value),
                                  blurRadius: isShortHeight ? 3 : 5,
                                ),
                                BoxShadow(
                                  color: widget.color.withOpacity(0.4),
                                  offset: const Offset(0, 2),
                                  blurRadius: isShortHeight ? 4 : 8,
                                ),
                              ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.color.withOpacity(0.85),
                            widget.color,
                            widget.color.withOpacity(0.95),
                          ],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Top screw pin
                          Positioned(
                            top: pinOffset,
                            child: Container(
                              width: pinSize,
                              height: pinSize,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Colors.white, Colors.grey, Colors.black45],
                                ),
                              ),
                            ),
                          ),
                          // Bottom screw pin
                          Positioned(
                            bottom: pinOffset,
                            child: Container(
                              width: pinSize,
                              height: pinSize,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Colors.white, Colors.grey, Colors.black45],
                                ),
                              ),
                            ),
                          ),
                          // Pressed Glow overlay
                          if (isPressed)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(isShortHeight ? 10 : 20),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Drifting Cloud Widget
class CloudWidget extends StatefulWidget {
  final Function(Offset globalPos) onTap;

  const CloudWidget({required this.onTap, super.key});

  @override
  State<CloudWidget> createState() => _CloudWidgetState();
}

class _CloudWidgetState extends State<CloudWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(PointerDownEvent event) {
    if (!_controller.isAnimating) {
      _controller.forward(from: 0.0).then((_) => _controller.reverse());
      widget.onTap(event.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    return Listener(
      onPointerDown: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final wobble = math.sin(_controller.value * math.pi * 3) * 12;
          return Transform.translate(
            offset: Offset(wobble, 0),
            child: Text(
              '☁️',
              style: TextStyle(fontSize: isShortHeight ? 36 : 54),
            ),
          );
        },
      ),
    );
  }
}

// Spinning Sun Widget
class SunWidget extends StatefulWidget {
  final Function(Offset globalPos) onTap;

  const SunWidget({required this.onTap, super.key});

  @override
  State<SunWidget> createState() => _SunWidgetState();
}

class _SunWidgetState extends State<SunWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(PointerDownEvent event) {
    // Spin fast for 1.2 seconds on tap
    _controller.animateTo(
      _controller.value + 1.0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
    ).then((_) {
      if (mounted) {
        _controller.repeat();
      }
    });
    widget.onTap(event.position);
  }

  @override
  Widget build(BuildContext context) {
    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    return Listener(
      onPointerDown: _handleTap,
      child: RotationTransition(
        turns: _controller,
        child: Text(
          '☀️',
          style: TextStyle(fontSize: isShortHeight ? 36 : 56),
        ),
      ),
    );
  }
}

// Circular Back Button Widget with Scale Press Effect
class CircularBackButton extends StatefulWidget {
  final VoidCallback onTap;

  const CircularBackButton({required this.onTap, super.key});

  @override
  State<CircularBackButton> createState() => _CircularBackButtonState();
}

class _CircularBackButtonState extends State<CircularBackButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.82).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    final size = isShortHeight ? 44.0 : 64.0;
    final borderWidth = isShortHeight ? 3.0 : 5.0;
    final iconSize = isShortHeight ? 24.0 : 38.0;

    return Listener(
      onPointerDown: (_) {
        _controller.forward();
        SystemSound.play(SystemSoundType.click);
        HapticFeedback.mediumImpact();
      },
      onPointerUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onPointerCancel: (_) {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF8E2B),
              width: borderWidth,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: const Color(0xFFFF8E2B),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
