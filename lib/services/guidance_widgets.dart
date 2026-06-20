import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that overlays pulsing concentric circles around its child to draw attention.
class PulseTarget extends StatefulWidget {
  final Widget child;
  final bool active;
  final Color color;
  final double baseSize;

  const PulseTarget({
    required this.child,
    required this.active,
    this.color = const Color(0xFFFFCC00),
    this.baseSize = 56.0,
    super.key,
  });

  @override
  State<PulseTarget> createState() => _PulseTargetState();
}

class _PulseTargetState extends State<PulseTarget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PulseTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outermost circle expanding and fading
            Positioned(
              child: Container(
                width: widget.baseSize + _controller.value * 28,
                height: widget.baseSize + _controller.value * 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: (1.0 - _controller.value) * 0.6),
                    width: 3.5,
                  ),
                ),
              ),
            ),
            // Middle circle with offset phase
            Positioned(
              child: Container(
                width: widget.baseSize + ((_controller.value + 0.5) % 1.0) * 28,
                height: widget.baseSize + ((_controller.value + 0.5) % 1.0) * 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: (1.0 - ((_controller.value + 0.5) % 1.0)) * 0.4),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// A floating, bouncing, and pulsing hand hint indicating where the child should tap.
class GhostHandHint extends StatefulWidget {
  final Offset position;
  final bool active;

  const GhostHandHint({
    required this.position,
    required this.active,
    super.key,
  });

  @override
  State<GhostHandHint> createState() => _GhostHandHintState();
}

class _GhostHandHintState extends State<GhostHandHint> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant GhostHandHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double scale = 1.0 - (_controller.value * 0.15);
        final double offset = _controller.value * 12.0;
        return Positioned(
          left: widget.position.dx - 22,
          top: widget.position.dy - 22 + offset,
          child: IgnorePointer(
            child: Transform.scale(
              scale: scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse halo behind the hand
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFCC00).withValues(alpha: (1.0 - _controller.value) * 0.45),
                    ),
                  ),
                  const Icon(
                    Icons.touch_app_rounded,
                    size: 42,
                    color: Color(0xFFFF9500),
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                      Shadow(
                        color: Colors.white,
                        blurRadius: 1,
                        offset: Offset(-0.5, -0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Detects any user activity within its child widget subtree, resetting the inactivity timer.
class InactivityDetector extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onInactivity;
  final VoidCallback onActivity;
  final bool enabled;

  const InactivityDetector({
    required this.child,
    required this.onInactivity,
    required this.onActivity,
    this.duration = const Duration(seconds: 3),
    this.enabled = true,
    super.key,
  });

  @override
  State<InactivityDetector> createState() => _InactivityDetectorState();
}

class _InactivityDetectorState extends State<InactivityDetector> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant InactivityDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.duration, () {
      if (mounted) {
        widget.onInactivity();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleActivity() {
    if (!widget.enabled) return;
    widget.onActivity();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handleActivity(),
      onPointerMove: (_) => _handleActivity(),
      child: widget.child,
    );
  }
}

/// A shake animation widget to softly communicate errors or wrong selections without hard blocks.
class SoftWrongFeedback extends StatefulWidget {
  final Widget child;
  final Stream<void> triggerStream;

  const SoftWrongFeedback({
    required this.child,
    required this.triggerStream,
    super.key,
  });

  @override
  State<SoftWrongFeedback> createState() => _SoftWrongFeedbackState();
}

class _SoftWrongFeedbackState extends State<SoftWrongFeedback> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late StreamSubscription<void> _subscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _subscription = widget.triggerStream.listen((_) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(_controller);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(offsetAnimation.value, 0.0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A fullscreen celebration effect emitting colorful stars and circles.
class CelebrationEffect extends StatefulWidget {
  final bool active;
  const CelebrationEffect({required this.active, super.key});

  @override
  State<CelebrationEffect> createState() => _CelebrationEffectState();
}

class _CelebrationEffectState extends State<CelebrationEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_CelebrationParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
        _updateParticles();
      });

    if (widget.active) {
      _spawnParticles();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant CelebrationEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active && widget.active) {
      _spawnParticles();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawnParticles() {
    _particles.clear();
    final colors = [
      const Color(0xFFFF4B4B),
      const Color(0xFF2B86FF),
      const Color(0xFFFFD000),
      const Color(0xFF2ECC71),
      const Color(0xFFFF8E2B),
      const Color(0xFFFF76B8),
      const Color(0xFF8E44AD),
    ];

    // Spawn 60 particles bursting outwards
    for (int i = 0; i < 65; i++) {
      final angle = _random.nextDouble() * 2.0 * math.pi;
      final speed = 150.0 + _random.nextDouble() * 250.0;
      _particles.add(
        _CelebrationParticle(
          position: const Offset(0.0, 0.0), // centered on start
          velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
          color: colors[_random.nextInt(colors.length)],
          size: 6.0 + _random.nextDouble() * 8.0,
          isStar: _random.nextBool(),
        ),
      );
    }
  }

  void _updateParticles() {
    final double dt = 0.02; // constant step
    setState(() {
      for (var p in _particles) {
        // Gravity
        p.velocity = Offset(p.velocity.dx, p.velocity.dy + 120.0 * dt);
        // Drag
        p.velocity = Offset(p.velocity.dx * 0.98, p.velocity.dy * 0.98);
        p.position += p.velocity * dt;
        p.life -= 0.5 * dt;
      }
      _particles.removeWhere((p) => p.life <= 0.0);
    });

    if (_particles.isNotEmpty && !_controller.isAnimating) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active || _particles.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2 - 40);
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _CelebrationPainter(_particles, center),
          );
        },
      ),
    );
  }
}

class _CelebrationParticle {
  Offset position;
  Offset velocity;
  final Color color;
  final double size;
  final bool isStar;
  double life = 1.0;

  _CelebrationParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.isStar,
  });
}

class _CelebrationPainter extends CustomPainter {
  final List<_CelebrationParticle> particles;
  final Offset center;

  _CelebrationPainter(this.particles, this.center);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life)
        ..style = PaintingStyle.fill;

      if (!p.isStar) {
        canvas.drawCircle(p.position, p.size, paint);
      } else {
        final path = Path();
        final x = p.position.dx;
        final y = p.position.dy;
        final s = p.size;
        path.moveTo(x, y - s);
        path.lineTo(x + s * 0.4, y - s * 0.2);
        path.lineTo(x + s * 0.9, y - s * 0.2);
        path.lineTo(x + s * 0.5, y + s * 0.2);
        path.lineTo(x + s * 0.7, y + s * 0.8);
        path.lineTo(x, y + s * 0.4);
        path.lineTo(x - s * 0.7, y + s * 0.8);
        path.lineTo(x - s * 0.5, y + s * 0.2);
        path.lineTo(x - s * 0.9, y - s * 0.2);
        path.lineTo(x - s * 0.4, y - s * 0.2);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
