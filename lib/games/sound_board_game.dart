import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    // Ticker updates particles and clouds on every frame if active
    _ticker = createTicker((elapsed) {
      if (mounted) {
        setState(() {
          // Update clouds drift
          _cloud1X += 0.4;
          if (_cloud1X > MediaQuery.of(context).size.width) {
            _cloud1X = -100;
          }
          _cloud2X += 0.25;
          if (_cloud2X > MediaQuery.of(context).size.width) {
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
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _spawnParticles(Offset globalPosition, Color color, List<String> symbols) {
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
    // Mimic musical pitch scale using haptics
    if (noteIndex < 3) {
      HapticFeedback.lightImpact();
    } else if (noteIndex < 6) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
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
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Clouds in the background (slower depth element)
            Positioned(
              left: _cloud1X,
              top: 30,
              child: CloudWidget(
                onTap: (pos) => _spawnParticles(pos, Colors.lightBlueAccent, ['☁️', '💧', '✨']),
              ),
            ),
            Positioned(
              left: _cloud2X,
              top: 60,
              child: CloudWidget(
                onTap: (pos) => _spawnParticles(pos, Colors.cyanAccent, ['☁️', '💧', '🎵']),
              ),
            ),

            // Top Sun Widget (decorative & interactive)
            Positioned(
              right: 40,
              top: 20,
              child: SunWidget(
                onTap: (pos) => _spawnParticles(pos, Colors.orangeAccent, ['☀️', '✨', '⭐', '💛']),
              ),
            ),

            // Main UI Column
            Column(
              children: [
                const SizedBox(height: 12),
                // Top Bar (just empty space to push animals down, back button placed absolutely)
                const SizedBox(height: 64),
                // Animals Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: animalData.map((a) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: AnimalCardWidget(
                        emoji: a.emoji,
                        color: a.color,
                        onTap: (globalPos) {
                          _playFeedback(2); // Mid-high feedback
                          _spawnParticles(globalPos, a.color, a.spawnEmojis);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Xylophone Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Wood support bars
                        Positioned(
                          top: 40,
                          left: 16,
                          right: 16,
                          child: Container(
                            height: 16,
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
                          bottom: 40,
                          left: 16,
                          right: 16,
                          child: Container(
                            height: 16,
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
                        Row(
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
                              color: color,
                              heightFactor: heightFactor,
                              onTap: (globalPos) {
                                _playFeedback(index);
                                _spawnParticles(
                                  globalPos,
                                  color,
                                  ['🎵', '🎶', '✨', '⭐'],
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Back Button at Top Left (absolute layout)
            Positioned(
              left: 20,
              top: 20,
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
          ],
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
    return Listener(
      onPointerDown: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _jumpAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color.withOpacity(0.8), width: 5),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 48, height: 1.1),
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
  final Function(Offset globalPos) onTap;

  const XylophoneKeyWidget({
    required this.color,
    required this.heightFactor,
    required this.onTap,
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

  void _handleTap(PointerDownEvent event) {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap(event.position);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyHeight = constraints.maxHeight * widget.heightFactor;
            return Align(
              alignment: Alignment.center,
              child: Listener(
                onPointerDown: _handleTap,
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isPressed
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 10 - _pressAnimation.value),
                                    blurRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: widget.color.withOpacity(0.4),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
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
                              top: 24,
                              child: Container(
                                width: 14,
                                height: 14,
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
                              bottom: 24,
                              child: Container(
                                width: 14,
                                height: 14,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
    return Listener(
      onPointerDown: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final wobble = math.sin(_controller.value * math.pi * 3) * 12;
          return Transform.translate(
            offset: Offset(wobble, 0),
            child: const Text(
              '☁️',
              style: TextStyle(fontSize: 54),
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
    return Listener(
      onPointerDown: _handleTap,
      child: RotationTransition(
        turns: _controller,
        child: const Text(
          '☀️',
          style: TextStyle(fontSize: 56),
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF8E2B),
              width: 5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFFFF8E2B),
            size: 38,
          ),
        ),
      ),
    );
  }
}
