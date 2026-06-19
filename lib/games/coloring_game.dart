import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/audio_synth.dart';
import '../services/guidance_widgets.dart';
import 'magic_colors/chameleon_painter.dart';

class ColoringPart {
  final String id;
  final Path path;
  Color color;
  final Color defaultColor;

  ColoringPart({
    required this.id,
    required this.path,
    this.color = Colors.white,
    this.defaultColor = Colors.white,
  });
}

class ColoringTemplate {
  final String name;
  final IconData icon;
  final List<ColoringPart> parts;
  final void Function(Canvas canvas, Size size, Paint paint) drawDetails;

  ColoringTemplate({
    required this.name,
    required this.icon,
    required this.parts,
    required this.drawDetails,
  });
}

class StoryColoringStep {
  final int templateIndex;
  final Set<String> targetPartIds;
  final IconData icon;
  final Color accentColor;
  final String semanticsLabel;

  const StoryColoringStep({
    required this.templateIndex,
    required this.targetPartIds,
    required this.icon,
    required this.accentColor,
    required this.semanticsLabel,
  });
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;
  double decay;
  int type; // 0: circle, 1: square, 2: star

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
    required this.decay,
    required this.type,
  });
}

class ColoringGame extends StatefulWidget {
  const ColoringGame({super.key});

  @override
  State<ColoringGame> createState() => _ColoringGameState();
}

class _ColoringGameState extends State<ColoringGame>
    with TickerProviderStateMixin {
  late List<ColoringTemplate> _templates;
  int _selectedTemplateIndex = 1;
  Color _selectedColor = const Color(0xFFFF4B4B);
  int _storyStepIndex = 0;
  bool _storyCompleted = false;

  // Görsel Rehber (Quality UX) Değişkenleri
  bool _showGhostHand = false;
  Offset? _ghostHandPosition;
  bool _showCelebration = false;
  Timer? _celebrationTimer;
  late AnimationController _pulseAnimationController;

  static const List<StoryColoringStep> _storySteps = [
    StoryColoringStep(
      templateIndex: 1,
      targetPartIds: {'roof'},
      icon: Icons.roofing_rounded,
      accentColor: Color(0xFFFFB300),
      semanticsLabel: 'Hikaye gorevi 1: catiyi boya',
    ),
    StoryColoringStep(
      templateIndex: 1,
      targetPartIds: {'wall', 'door'},
      icon: Icons.home_rounded,
      accentColor: Color(0xFF2FA7A0),
      semanticsLabel: 'Hikaye gorevi 2: evi tamamla',
    ),
    StoryColoringStep(
      templateIndex: 1,
      targetPartIds: {'left_window', 'right_window', 'attic_window'},
      icon: Icons.wb_sunny_rounded,
      accentColor: Color(0xFFFFD13B),
      semanticsLabel: 'Hikaye gorevi 3: isiklari yak',
    ),
  ];

  final List<Color> _paletteColors = [
    const Color(0xFFFF4B4B), // Red
    const Color(0xFF3B82F6), // Blue
    const Color(0xFFFFD13B), // Yellow
    const Color(0xFF10B981), // Green
    const Color(0xFFF59E0B), // Orange
    const Color(0xFFEC4899), // Pink
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFFFFFFFF), // White (Eraser)
  ];

  final List<Particle> _particles = [];
  late AnimationController _particleController;
  final GlobalKey _canvasKey = GlobalKey();
  final Set<int> _celebratedTemplates = {};

  @override
  void initState() {
    super.initState();
    // Force landscape mode for premium game feel
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _templates = _initTemplates();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
      _updateParticles();
    });

    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    // Reset orientation preference back to default when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _celebrationTimer?.cancel();
    _particleController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _spawnParticles(Offset position, Color color) {
    if (_particles.length > 80) {
      _particles.removeRange(0, _particles.length - 80);
    }
    final random = Random();
    for (int i = 0; i < 20; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 1.5 + random.nextDouble() * 4.5;
      _particles.add(
        Particle(
          position: position,
          velocity: Offset(cos(angle) * speed, sin(angle) * speed),
          color: color,
          size: 6.0 + random.nextDouble() * 8.0,
          life: 1.0,
          decay: 0.02 + random.nextDouble() * 0.02,
          type: random.nextInt(3),
        ),
      );
    }
    if (!_particleController.isAnimating) {
      _particleController.repeat();
    }
  }

  void _updateParticles() {
    if (_particles.isEmpty) {
      _particleController.stop();
      return;
    }
    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        final p = _particles[i];
        p.position += p.velocity;
        // Gravity effect
        p.velocity = Offset(p.velocity.dx, p.velocity.dy + 0.12);
        p.life -= p.decay;
        if (p.life <= 0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  void _resetCurrentTemplate() {
    setState(() {
      _celebratedTemplates.remove(_selectedTemplateIndex);
      for (var part in _templates[_selectedTemplateIndex].parts) {
        part.color = part.defaultColor;
      }
      if (_selectedTemplateIndex == _storySteps.first.templateIndex) {
        _storyStepIndex = 0;
        _storyCompleted = false;
      }
    });
    HapticFeedback.vibrate();
    AudioSynth.playSparkleSound();

    // Trigger cleanup fireworks
    final RenderBox? renderBox =
        _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      _spawnParticles(
        Offset(size.width * 0.3, size.height * 0.4),
        const Color(0xFFFF4B4B),
      );
      _spawnParticles(
        Offset(size.width * 0.5, size.height * 0.5),
        const Color(0xFFFFD13B),
      );
      _spawnParticles(
        Offset(size.width * 0.7, size.height * 0.4),
        const Color(0xFF3B82F6),
      );
    }
  }

  void _handleTap(Offset virtualPoint, Offset localPosition) {
    final template = _templates[_selectedTemplateIndex];
    // Check parts in reverse order to respect rendering depth (topmost parts first)
    for (int i = template.parts.length - 1; i >= 0; i--) {
      final part = template.parts[i];
      if (part.path.contains(virtualPoint)) {
        if (part.color != _selectedColor) {
          setState(() {
            part.color = _selectedColor;
          });
          HapticFeedback.mediumImpact();
          AudioSynth.playRaindropSound();
          // Use bright colors for particle explosion even if eraser (white) is used
          final explosionColor =
              _selectedColor == Colors.white
                  ? const Color(0xFFFFD13B)
                  : _selectedColor;
          _spawnParticles(localPosition, explosionColor);
          _advanceStoryIfNeeded(part, localPosition);

          // Check if template is fully colored
          final allColored = template.parts.every(
            (p) => p.color != Colors.white,
          );
          if (allColored &&
              !_celebratedTemplates.contains(_selectedTemplateIndex)) {
            _celebratedTemplates.add(_selectedTemplateIndex);
            HapticFeedback.heavyImpact();
            AudioSynth.playSparkleSound();

            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) {
                final RenderBox? renderBox =
                    _canvasKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final size = renderBox.size;
                  _spawnParticles(
                    Offset(size.width * 0.3, size.height * 0.45),
                    const Color(0xFFFF4B4B),
                  );
                  _spawnParticles(
                    Offset(size.width * 0.5, size.height * 0.5),
                    const Color(0xFFFFD13B),
                  );
                  _spawnParticles(
                    Offset(size.width * 0.7, size.height * 0.45),
                    const Color(0xFF3B82F6),
                  );
                }
              }
            });
          }
        }
        break;
      }
    }
  }

  void _advanceStoryIfNeeded(ColoringPart changedPart, Offset localPosition) {
    if (_storyCompleted || _storyStepIndex >= _storySteps.length) {
      return;
    }

    final step = _storySteps[_storyStepIndex];
    if (_selectedTemplateIndex != step.templateIndex ||
        !step.targetPartIds.contains(changedPart.id)) {
      return;
    }

    final template = _templates[_selectedTemplateIndex];
    final stepFinished = step.targetPartIds.every(
      (id) => template.parts.any(
        (part) => part.id == id && part.color != Colors.white,
      ),
    );
    if (!stepFinished) {
      return;
    }

    setState(() {
      _showCelebration = true;
      if (_storyStepIndex == _storySteps.length - 1) {
        _storyCompleted = true;
      } else {
        _storyStepIndex += 1;
      }
    });

    _celebrationTimer?.cancel();
    _celebrationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showCelebration = false;
        });
      }
    });

    HapticFeedback.heavyImpact();
    AudioSynth.playSparkleSound();
    _spawnParticles(localPosition, step.accentColor);
  }

  void _onInactivity() {
    if (mounted) {
      setState(() {
        _showGhostHand = true;
        _ghostHandPosition = _getGhostHandPosition();
      });
    }
  }

  void _onActivity() {
    if (_showGhostHand && mounted) {
      setState(() {
        _showGhostHand = false;
      });
    }
  }

  Offset? _getGhostHandPosition() {
    final targets = _activeStoryTargets;
    final template = _templates[_selectedTemplateIndex];
    if (targets.isEmpty) {
      // Serbest mod: boyanmamış ilk parçayı bul
      for (var part in template.parts) {
        if (part.color == Colors.white) {
          return part.path.getBounds().center;
        }
      }
      return null;
    }

    // Hikaye modu: boyanmamış ilk hedef parçayı bul
    for (var part in template.parts) {
      if (targets.contains(part.id) && part.color == Colors.white) {
        return part.path.getBounds().center;
      }
    }
    return null;
  }

  Offset _convertToVirtualPoint(Offset localPoint, Size size) {
    final double side = min(size.width, size.height);
    final double offsetX = (size.width - side) / 2;
    final double offsetY = (size.height - side) / 2;

    final double relativeX = localPoint.dx - offsetX;
    final double relativeY = localPoint.dy - offsetY;

    final double virtualX = (relativeX / side) * 400;
    final double virtualY = (relativeY / side) * 400;

    return Offset(virtualX, virtualY);
  }

  Widget _buildTemplateButton(int index, ColoringTemplate template) {
    final isSelected = _selectedTemplateIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemplateIndex = index;
          _resetStoryProgressForSelectedTemplate();
        });
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE082) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                isSelected ? const Color(0xFFFFB300) : const Color(0xFFE0E0E0),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CustomPaint(painter: TemplateMiniPainter(template)),
          ),
        ),
      ),
    );
  }

  Set<String> get _activeStoryTargets {
    if (_storyCompleted || _storyStepIndex >= _storySteps.length) {
      return const {};
    }

    final step = _storySteps[_storyStepIndex];
    if (_selectedTemplateIndex != step.templateIndex) {
      return const {};
    }

    return step.targetPartIds;
  }

  Widget _buildStoryOverlay() {
    if (_selectedTemplateIndex != _storySteps.first.templateIndex) {
      return const SizedBox.shrink();
    }

    final currentStep =
        _storyCompleted ? _storySteps.last : _storySteps[_storyStepIndex];

    return Positioned(
      key: const ValueKey('story-flow-panel'),
      left: 66,
      right: 66,
      bottom: 12,
      child: IgnorePointer(
        child: Semantics(
          label:
              _storyCompleted
                  ? 'Hikaye tamamlandi'
                  : currentStep.semanticsLabel,
          child: DecoratedBox(
            key: ValueKey(
              _storyCompleted ? 'story-complete-panel' : 'story-active-panel',
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7D6).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFC83D), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_storySteps.length, (index) {
                  final isDone = _storyCompleted || index < _storyStepIndex;
                  final isActive = !_storyCompleted && index == _storyStepIndex;
                  final step = _storySteps[index];

                  return AnimatedContainer(
                    key: ValueKey('story-step-$index'),
                    duration: const Duration(milliseconds: 200),
                    width: isActive ? 48 : 40,
                    height: isActive ? 48 : 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color:
                          isDone
                              ? const Color(0xFF10B981)
                              : isActive
                              ? step.accentColor
                              : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isActive
                                ? const Color(0xFF233238)
                                : const Color(0xFFFFD13B),
                        width: isActive ? 3 : 2,
                      ),
                    ),
                    child: Icon(
                      isDone ? Icons.check_rounded : step.icon,
                      size: isActive ? 28 : 24,
                      color:
                          isDone || isActive
                              ? Colors.white
                              : const Color(0xFF8A6A00),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetStoryProgressForSelectedTemplate() {
    if (_selectedTemplateIndex == _storySteps.first.templateIndex) {
      _storyStepIndex = 0;
      _storyCompleted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEF),
      body: InactivityDetector(
        enabled: !_storyCompleted,
        onInactivity: _onInactivity,
        onActivity: _onActivity,
        child: Stack(
          children: [
            SafeArea(
              child: Row(
                children: [
                  // Left Column: Navigation & Templates Selection
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 4),
                          BouncyButton(
                            size: 48,
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 28,
                              color: Color(0xFF5C5C5C),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(_templates.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _buildTemplateButton(index, _templates[index]),
                            );
                          }),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),

                  // Middle Column: Drawing Board
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          width: 400,
                          height: 400,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Clickable Custom Paint Canvas
                              GestureDetector(
                                key: const ValueKey('coloring-canvas-touch-area'),
                                onTapUp: (details) {
                                  final RenderBox? canvasBox =
                                      _canvasKey.currentContext?.findRenderObject()
                                          as RenderBox?;
                                  if (canvasBox != null) {
                                    final canvasLocalPos = canvasBox.globalToLocal(
                                      details.globalPosition,
                                    );
                                    final virtualPoint = _convertToVirtualPoint(
                                      canvasLocalPos,
                                      canvasBox.size,
                                    );
                                    _handleTap(virtualPoint, canvasLocalPos);
                                  }
                                },
                                child: AnimatedBuilder(
                                  animation: _pulseAnimationController,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      key: _canvasKey,
                                      size: Size.infinite,
                                      painter: ColoringPainter(
                                        _templates[_selectedTemplateIndex],
                                        highlightedPartIds: _activeStoryTargets,
                                        pulseProgress: _pulseAnimationController.value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              _buildStoryOverlay(),
                              // Floating Particles Canvas (Unclickable)
                              IgnorePointer(
                                child: CustomPaint(
                                  size: Size.infinite,
                                  painter: ParticlePainter(_particles),
                                ),
                              ),
                              if (_showGhostHand && _ghostHandPosition != null)
                                GhostHandHint(
                                  position: _ghostHandPosition!,
                                  active: true,
                                ),
                              if (_storyCompleted)
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  child: Container(
                                    width: 120,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFF2FA7A0), width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      child: CustomPaint(
                                        painter: ChameleonPainter(
                                          chameleonColor: const Color(0xFF2FA7A0),
                                          tongueProgress: 0.0,
                                          lookTarget: const Offset(200, 200),
                                          flies: const [],
                                          idleProgress: 0.0,
                                          isCamouflaged: false,
                                          chameleonPos: const Offset(60, 40),
                                          expression: 'happy',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Right Column: Palette & Trash
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 4),
                          // Reset Button
                          BouncyButton(
                            size: 48,
                            onTap: _resetCurrentTemplate,
                            child: const Icon(
                              Icons.refresh_rounded,
                              size: 24,
                              color: Color(0xFF5C5C5C),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Colors Grid (2 columns Wrap)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: List.generate(_paletteColors.length, (index) {
                              final color = _paletteColors[index];
                              final isSelected = _selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = color;
                                  });
                                  HapticFeedback.selectionClick();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: isSelected ? 40 : 36,
                                  height: isSelected ? 40 : 36,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.black : Colors.white,
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1.5),
                                      ),
                                    ],
                                  ),
                                  child:
                                      color == Colors.white
                                          ? Icon(
                                            Icons.auto_fix_high_rounded,
                                            size: isSelected ? 20 : 16,
                                            color: Colors.grey.shade700,
                                          )
                                          : null,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showCelebration)
              const Positioned.fill(
                child: CelebrationEffect(active: true),
              ),
          ],
        ),
      ),
    );
  }

  List<ColoringTemplate> _initTemplates() {
    return [
      // 1. CAT TEMPLATE
      ColoringTemplate(
        name: 'Cat',
        icon: Icons.pets_rounded,
        parts: [
          ColoringPart(id: 'tail', path: _getCatTailPath()),
          ColoringPart(id: 'left_ear', path: _getCatLeftEarPath()),
          ColoringPart(id: 'right_ear', path: _getCatRightEarPath()),
          ColoringPart(id: 'left_inner_ear', path: _getCatLeftInnerEarPath()),
          ColoringPart(id: 'right_inner_ear', path: _getCatRightInnerEarPath()),
          ColoringPart(id: 'body', path: _getCatBodyPath()),
          ColoringPart(id: 'left_paw', path: _getCatLeftPawPath()),
          ColoringPart(id: 'right_paw', path: _getCatRightPawPath()),
          ColoringPart(id: 'head', path: _getCatHeadPath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final paint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round;

          final fillPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.fill;

          // Eyes
          canvas.drawCircle(const Offset(160, 160), 8, fillPaint);
          canvas.drawCircle(const Offset(240, 160), 8, fillPaint);

          // Eye highlights
          final whitePaint =
              Paint()
                ..color = Colors.white
                ..style = PaintingStyle.fill;
          canvas.drawCircle(const Offset(158, 157), 2.5, whitePaint);
          canvas.drawCircle(const Offset(238, 157), 2.5, whitePaint);

          // Nose (Triangle)
          final nosePath =
              Path()
                ..moveTo(192, 178)
                ..lineTo(208, 178)
                ..lineTo(200, 186)
                ..close();
          canvas.drawPath(nosePath, fillPaint);

          // Mouth
          canvas.drawArc(
            Rect.fromLTRB(185, 180, 200, 195),
            0,
            pi,
            false,
            paint..strokeWidth = 3,
          );
          canvas.drawArc(
            Rect.fromLTRB(200, 180, 215, 195),
            0,
            pi,
            false,
            paint,
          );

          // Whiskers
          paint.strokeWidth = 3;
          // Left side whiskers
          canvas.drawLine(const Offset(135, 182), const Offset(95, 177), paint);
          canvas.drawLine(const Offset(135, 189), const Offset(90, 189), paint);
          canvas.drawLine(const Offset(135, 196), const Offset(95, 201), paint);
          // Right side whiskers
          canvas.drawLine(
            const Offset(265, 182),
            const Offset(305, 177),
            paint,
          );
          canvas.drawLine(
            const Offset(265, 189),
            const Offset(310, 189),
            paint,
          );
          canvas.drawLine(
            const Offset(265, 196),
            const Offset(305, 201),
            paint,
          );
        },
      ),

      // 2. HOUSE TEMPLATE
      ColoringTemplate(
        name: 'House',
        icon: Icons.home_rounded,
        parts: [
          ColoringPart(id: 'chimney', path: _getHouseChimneyPath()),
          ColoringPart(id: 'wall', path: _getHouseWallPath()),
          ColoringPart(id: 'roof', path: _getHouseRoofPath()),
          ColoringPart(id: 'door', path: _getHouseDoorPath()),
          ColoringPart(id: 'left_window', path: _getHouseLeftWindowPath()),
          ColoringPart(id: 'right_window', path: _getHouseRightWindowPath()),
          ColoringPart(id: 'attic_window', path: _getHouseAtticWindowPath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final paint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round;

          // Door knob
          final fillPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.fill;
          canvas.drawCircle(const Offset(215, 315), 5, fillPaint);

          // Left window inner cross (+)
          canvas.drawLine(
            const Offset(105, 235),
            const Offset(155, 235),
            paint,
          );
          canvas.drawLine(
            const Offset(130, 210),
            const Offset(130, 260),
            paint,
          );

          // Right window inner cross (+)
          canvas.drawLine(
            const Offset(245, 235),
            const Offset(295, 235),
            paint,
          );
          canvas.drawLine(
            const Offset(270, 210),
            const Offset(270, 260),
            paint,
          );

          // Attic window cross (+)
          canvas.drawLine(
            const Offset(180, 115),
            const Offset(220, 115),
            paint,
          );
          canvas.drawLine(const Offset(200, 95), const Offset(200, 135), paint);

          // Smoke puffs from chimney
          final smokePath =
              Path()
                ..moveTo(275, 55)
                ..quadraticBezierTo(285, 35, 270, 25)
                ..moveTo(285, 60)
                ..quadraticBezierTo(295, 40, 280, 30);
          canvas.drawPath(smokePath, paint..strokeWidth = 3);
        },
      ),

      // 3. TEDDY BEAR TEMPLATE
      ColoringTemplate(
        name: 'Teddy',
        icon: Icons.face_rounded,
        parts: [
          ColoringPart(id: 'left_ear', path: _getTeddyLeftEarPath()),
          ColoringPart(id: 'right_ear', path: _getTeddyRightEarPath()),
          ColoringPart(id: 'left_inner_ear', path: _getTeddyLeftInnerEarPath()),
          ColoringPart(
            id: 'right_inner_ear',
            path: _getTeddyRightInnerEarPath(),
          ),
          ColoringPart(id: 'body', path: _getTeddyBodyPath()),
          ColoringPart(id: 'left_arm', path: _getTeddyLeftArmPath()),
          ColoringPart(id: 'right_arm', path: _getTeddyRightArmPath()),
          ColoringPart(id: 'left_leg', path: _getTeddyLeftLegPath()),
          ColoringPart(id: 'right_leg', path: _getTeddyRightLegPath()),
          ColoringPart(id: 'belly', path: _getTeddyBellyPath()),
          ColoringPart(id: 'head', path: _getTeddyHeadPath()),
          ColoringPart(id: 'muzzle', path: _getTeddyMuzzlePath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final paint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round;

          final fillPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.fill;

          // Eyes
          canvas.drawCircle(const Offset(165, 160), 8, fillPaint);
          canvas.drawCircle(const Offset(235, 160), 8, fillPaint);

          // Eye highlights
          final whitePaint =
              Paint()
                ..color = Colors.white
                ..style = PaintingStyle.fill;
          canvas.drawCircle(const Offset(163, 157), 2.5, whitePaint);
          canvas.drawCircle(const Offset(233, 157), 2.5, whitePaint);

          // Nose (Horizontal Oval)
          canvas.drawOval(
            Rect.fromCenter(
              center: const Offset(200, 195),
              width: 28,
              height: 16,
            ),
            fillPaint,
          );

          // Mouth
          final mouthPath =
              Path()
                ..moveTo(200, 203)
                ..quadraticBezierTo(190, 215, 182, 210)
                ..moveTo(200, 203)
                ..quadraticBezierTo(210, 215, 218, 210);
          canvas.drawPath(mouthPath, paint..strokeWidth = 3);
        },
      ),

      // 4. BUTTERFLY TEMPLATE
      ColoringTemplate(
        name: 'Butterfly',
        icon: Icons.emoji_nature_rounded,
        parts: [
          ColoringPart(id: 'left_wing', path: _getButterflyLeftWingPath()),
          ColoringPart(id: 'right_wing', path: _getButterflyRightWingPath()),
          ColoringPart(id: 'left_spot', path: _getButterflyLeftWingSpotPath()),
          ColoringPart(
            id: 'right_spot',
            path: _getButterflyRightWingSpotPath(),
          ),
          ColoringPart(id: 'body', path: _getButterflyBodyPath()),
          ColoringPart(id: 'head', path: _getButterflyHeadPath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final antennaPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..strokeCap = StrokeCap.round;
          final fillPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.fill;

          // Left antenna
          final leftAntenna =
              Path()
                ..moveTo(195, 85)
                ..quadraticBezierTo(170, 50, 160, 55);
          canvas.drawPath(leftAntenna, antennaPaint);
          canvas.drawCircle(const Offset(160, 55), 4, fillPaint);

          // Right antenna
          final rightAntenna =
              Path()
                ..moveTo(205, 85)
                ..quadraticBezierTo(230, 50, 240, 55);
          canvas.drawPath(rightAntenna, antennaPaint);
          canvas.drawCircle(const Offset(240, 55), 4, fillPaint);

          // Face details (Eyes & Smile)
          canvas.drawCircle(const Offset(194, 98), 2.5, fillPaint);
          canvas.drawCircle(const Offset(206, 98), 2.5, fillPaint);
          canvas.drawArc(
            Rect.fromLTRB(195, 102, 205, 112),
            0,
            pi,
            false,
            antennaPaint..strokeWidth = 2,
          );
        },
      ),

      // 5. CAR TEMPLATE
      ColoringTemplate(
        name: 'Car',
        icon: Icons.directions_car_rounded,
        parts: [
          ColoringPart(id: 'roof', path: _getCarRoofPath()),
          ColoringPart(id: 'window', path: _getCarWindowPath()),
          ColoringPart(id: 'body', path: _getCarBodyPath()),
          ColoringPart(id: 'front_wheel', path: _getCarFrontWheelPath()),
          ColoringPart(id: 'rear_wheel', path: _getCarRearWheelPath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final fillPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.fill;
          final lightPaint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3;

          // Wheel Hubcaps
          canvas.drawCircle(const Offset(125, 310), 8, fillPaint);
          canvas.drawCircle(const Offset(275, 310), 8, fillPaint);

          // Front Headlight (Facing Right)
          canvas.drawArc(
            Rect.fromLTRB(330, 235, 345, 260),
            -pi / 2,
            pi,
            false,
            lightPaint,
          );

          // Rear Stoplight
          canvas.drawRect(Rect.fromLTRB(55, 235, 62, 255), fillPaint);
        },
      ),

      // 6. FLOWER TEMPLATE
      ColoringTemplate(
        name: 'Flower',
        icon: Icons.local_florist_rounded,
        parts: [
          ColoringPart(id: 'stem', path: _getFlowerStemPath()),
          ColoringPart(id: 'left_leaf', path: _getFlowerLeftLeafPath()),
          ColoringPart(id: 'right_leaf', path: _getFlowerRightLeafPath()),
          ColoringPart(id: 'top_petal', path: _getFlowerTopPetalPath()),
          ColoringPart(id: 'left_petal', path: _getFlowerLeftPetalPath()),
          ColoringPart(id: 'right_petal', path: _getFlowerRightPetalPath()),
          ColoringPart(id: 'bottom_petal', path: _getFlowerBottomPetalPath()),
          ColoringPart(id: 'center', path: _getFlowerCenterPath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final paint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..strokeCap = StrokeCap.round;
          canvas.drawLine(
            const Offset(200, 260),
            const Offset(200, 360),
            paint,
          );
        },
      ),

      // 7. ROCKET TEMPLATE
      ColoringTemplate(
        name: 'Rocket',
        icon: Icons.rocket_launch_rounded,
        parts: [
          ColoringPart(id: 'body', path: _getRocketBodyPath()),
          ColoringPart(id: 'window', path: _getRocketWindowPath()),
          ColoringPart(id: 'left_fin', path: _getRocketLeftFinPath()),
          ColoringPart(id: 'right_fin', path: _getRocketRightFinPath()),
          ColoringPart(id: 'flame', path: _getRocketFlamePath()),
        ],
        drawDetails: (canvas, size, basePaint) {
          final paint =
              Paint()
                ..color = basePaint.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..strokeCap = StrokeCap.round;
          canvas.drawLine(
            const Offset(170, 170),
            const Offset(230, 170),
            paint,
          );
          canvas.drawLine(
            const Offset(170, 270),
            const Offset(230, 270),
            paint,
          );
        },
      ),
    ];
  }

  // --- FLOWER TEMPLATE PATHS ---
  Path _getFlowerStemPath() {
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(185, 230, 215, 370),
        const Radius.circular(14),
      ),
    );
  }

  Path _getFlowerLeftLeafPath() {
    return Path()
      ..moveTo(195, 310)
      ..quadraticBezierTo(120, 280, 110, 230)
      ..quadraticBezierTo(170, 235, 205, 300)
      ..close();
  }

  Path _getFlowerRightLeafPath() {
    return Path()
      ..moveTo(205, 330)
      ..quadraticBezierTo(280, 300, 300, 250)
      ..quadraticBezierTo(235, 255, 195, 320)
      ..close();
  }

  Path _getFlowerTopPetalPath() {
    return Path()..addOval(Rect.fromLTRB(160, 65, 240, 155));
  }

  Path _getFlowerLeftPetalPath() {
    return Path()..addOval(Rect.fromLTRB(105, 125, 195, 205));
  }

  Path _getFlowerRightPetalPath() {
    return Path()..addOval(Rect.fromLTRB(205, 125, 295, 205));
  }

  Path _getFlowerBottomPetalPath() {
    return Path()..addOval(Rect.fromLTRB(160, 180, 240, 270));
  }

  Path _getFlowerCenterPath() {
    return Path()..addOval(Rect.fromLTRB(165, 135, 235, 205));
  }

  // --- ROCKET TEMPLATE PATHS ---
  Path _getRocketBodyPath() {
    return Path()
      ..moveTo(200, 45)
      ..quadraticBezierTo(270, 120, 245, 300)
      ..lineTo(155, 300)
      ..quadraticBezierTo(130, 120, 200, 45)
      ..close();
  }

  Path _getRocketWindowPath() {
    return Path()..addOval(Rect.fromLTRB(170, 125, 230, 185));
  }

  Path _getRocketLeftFinPath() {
    return Path()
      ..moveTo(160, 250)
      ..lineTo(90, 330)
      ..lineTo(170, 315)
      ..close();
  }

  Path _getRocketRightFinPath() {
    return Path()
      ..moveTo(240, 250)
      ..lineTo(310, 330)
      ..lineTo(230, 315)
      ..close();
  }

  Path _getRocketFlamePath() {
    return Path()
      ..moveTo(175, 300)
      ..quadraticBezierTo(200, 385, 225, 300)
      ..lineTo(200, 330)
      ..close();
  }

  // --- BUTTERFLY TEMPLATE PATHS ---
  Path _getButterflyLeftWingPath() {
    final path = Path();
    path.moveTo(200, 200);
    path.cubicTo(100, 50, 40, 100, 80, 200);
    path.cubicTo(40, 280, 120, 320, 200, 250);
    path.close();
    return path;
  }

  Path _getButterflyRightWingPath() {
    final path = Path();
    path.moveTo(200, 200);
    path.cubicTo(300, 50, 360, 100, 320, 200);
    path.cubicTo(360, 280, 280, 320, 200, 250);
    path.close();
    return path;
  }

  Path _getButterflyBodyPath() {
    final path = Path();
    path.addOval(Rect.fromLTRB(185, 120, 215, 280));
    return path;
  }

  Path _getButterflyHeadPath() {
    final path = Path();
    path.addOval(Rect.fromLTRB(180, 80, 220, 120));
    return path;
  }

  Path _getButterflyLeftWingSpotPath() {
    final path = Path();
    path.addOval(Rect.fromLTRB(100, 120, 135, 155));
    return path;
  }

  Path _getButterflyRightWingSpotPath() {
    final path = Path();
    path.addOval(Rect.fromLTRB(265, 120, 300, 155));
    return path;
  }

  // --- CAR TEMPLATE PATHS ---
  Path _getCarBodyPath() {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(60, 220, 340, 310),
        const Radius.circular(20),
      ),
    );
    return path;
  }

  Path _getCarRoofPath() {
    final path = Path();
    path.moveTo(110, 220);
    path.lineTo(150, 140);
    path.lineTo(250, 140);
    path.lineTo(290, 220);
    path.close();
    return path;
  }

  Path _getCarFrontWheelPath() {
    final path = Path();
    path.addOval(Rect.fromLTRB(95, 280, 155, 340));
    return path;
  }

  Path _getCarRearWheelPath() {
    final path = Path();
    path.addOval(Rect.fromLTRB(245, 280, 305, 340));
    return path;
  }

  Path _getCarWindowPath() {
    final path = Path();
    path.moveTo(155, 155);
    path.lineTo(245, 155);
    path.lineTo(270, 210);
    path.lineTo(130, 210);
    path.close();
    return path;
  }

  // --- CAT TEMPLATE PATHS ---
  Path _getCatTailPath() {
    return Path()
      ..moveTo(260, 310)
      ..quadraticBezierTo(370, 290, 360, 190)
      ..quadraticBezierTo(320, 170, 330, 210)
      ..quadraticBezierTo(340, 270, 255, 330)
      ..close();
  }

  Path _getCatLeftEarPath() {
    return Path()
      ..moveTo(120, 150)
      ..lineTo(90, 60)
      ..lineTo(180, 110)
      ..close();
  }

  Path _getCatRightEarPath() {
    return Path()
      ..moveTo(280, 150)
      ..lineTo(310, 60)
      ..lineTo(220, 110)
      ..close();
  }

  Path _getCatLeftInnerEarPath() {
    return Path()
      ..moveTo(125, 135)
      ..lineTo(105, 75)
      ..lineTo(165, 110)
      ..close();
  }

  Path _getCatRightInnerEarPath() {
    return Path()
      ..moveTo(275, 135)
      ..lineTo(295, 75)
      ..lineTo(235, 110)
      ..close();
  }

  Path _getCatBodyPath() {
    return Path()..addOval(Rect.fromLTRB(130, 220, 270, 370));
  }

  Path _getCatLeftPawPath() {
    return Path()..addOval(Rect.fromLTRB(115, 340, 185, 385));
  }

  Path _getCatRightPawPath() {
    return Path()..addOval(Rect.fromLTRB(215, 340, 285, 385));
  }

  Path _getCatHeadPath() {
    return Path()..addOval(Rect.fromLTRB(100, 100, 300, 240));
  }

  // --- HOUSE TEMPLATE PATHS ---
  Path _getHouseChimneyPath() {
    return Path()
      ..moveTo(260, 130)
      ..lineTo(260, 70)
      ..lineTo(300, 70)
      ..lineTo(300, 165)
      ..close();
  }

  Path _getHouseWallPath() {
    return Path()..addRect(Rect.fromLTRB(80, 180, 320, 370));
  }

  Path _getHouseRoofPath() {
    return Path()
      ..moveTo(50, 180)
      ..lineTo(200, 50)
      ..lineTo(350, 180)
      ..close();
  }

  Path _getHouseDoorPath() {
    return Path()..addRect(Rect.fromLTRB(165, 260, 235, 370));
  }

  Path _getHouseLeftWindowPath() {
    return Path()..addOval(Rect.fromLTRB(105, 210, 155, 260));
  }

  Path _getHouseRightWindowPath() {
    return Path()..addRect(Rect.fromLTRB(245, 210, 295, 260));
  }

  Path _getHouseAtticWindowPath() {
    return Path()..addOval(Rect.fromLTRB(180, 95, 220, 135));
  }

  // --- TEDDY TEMPLATE PATHS ---
  Path _getTeddyLeftEarPath() {
    return Path()..addOval(Rect.fromLTRB(90, 80, 160, 150));
  }

  Path _getTeddyRightEarPath() {
    return Path()..addOval(Rect.fromLTRB(240, 80, 310, 150));
  }

  Path _getTeddyLeftInnerEarPath() {
    return Path()..addOval(Rect.fromLTRB(105, 95, 145, 135));
  }

  Path _getTeddyRightInnerEarPath() {
    return Path()..addOval(Rect.fromLTRB(255, 95, 295, 135));
  }

  Path _getTeddyBodyPath() {
    return Path()..addOval(Rect.fromLTRB(120, 230, 280, 370));
  }

  Path _getTeddyLeftArmPath() {
    return Path()..addOval(Rect.fromLTRB(60, 240, 130, 320));
  }

  Path _getTeddyRightArmPath() {
    return Path()..addOval(Rect.fromLTRB(270, 240, 340, 320));
  }

  Path _getTeddyLeftLegPath() {
    return Path()..addOval(Rect.fromLTRB(90, 335, 165, 390));
  }

  Path _getTeddyRightLegPath() {
    return Path()..addOval(Rect.fromLTRB(235, 335, 310, 390));
  }

  Path _getTeddyBellyPath() {
    return Path()..addOval(Rect.fromLTRB(145, 255, 255, 345));
  }

  Path _getTeddyHeadPath() {
    return Path()..addOval(Rect.fromLTRB(110, 110, 290, 250));
  }

  Path _getTeddyMuzzlePath() {
    return Path()..addOval(Rect.fromLTRB(165, 175, 235, 225));
  }
}

// Custom Painter for main coloring page
class ColoringPainter extends CustomPainter {
  final ColoringTemplate template;
  final Set<String> highlightedPartIds;
  final double pulseProgress;

  ColoringPainter(this.template, {
    this.highlightedPartIds = const {},
    this.pulseProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double side = min(size.width, size.height);
    final double offsetX = (size.width - side) / 2;
    final double offsetY = (size.height - side) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(side / 400);

    final borderPaint =
        Paint()
          ..color = const Color(0xFF2B2B2B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // 1. Fill parts with their current color
    for (var part in template.parts) {
      fillPaint.color = part.color;
      canvas.drawPath(part.path, fillPaint);
    }

    // 2. Draw black boundary strokes
    for (var part in template.parts) {
      canvas.drawPath(part.path, borderPaint);
    }

    if (highlightedPartIds.isNotEmpty) {
      // Glow border animates between 9.0 and 15.0 width
      final double glowWidth = 9.0 + pulseProgress * 6.0;
      // Border color pulses in opacity
      final double glowOpacity = 0.5 + (1.0 - pulseProgress) * 0.5;

      final highlightPaint =
          Paint()
            ..color = const Color(0xFFFFD13B).withOpacity(glowOpacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = glowWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

      final innerHighlightPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0 + pulseProgress * 2.0
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

      for (var part in template.parts) {
        if (highlightedPartIds.contains(part.id) &&
            part.color == Colors.white) {
          canvas.drawPath(part.path, highlightPaint);
          canvas.drawPath(part.path, innerHighlightPaint);
          canvas.drawPath(part.path, borderPaint);
        }
      }
    }

    // 3. Draw features/details (Eyes, nose, whiskers etc.)
    template.drawDetails(canvas, const Size(400, 400), borderPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ColoringPainter oldDelegate) => true;
}

// Mini preview painter for the selection buttons
class TemplateMiniPainter extends CustomPainter {
  final ColoringTemplate template;

  TemplateMiniPainter(this.template);

  @override
  void paint(Canvas canvas, Size size) {
    final double side = min(size.width, size.height);
    canvas.save();
    canvas.scale(side / 400);

    final paint =
        Paint()
          ..color = const Color(0xFF555555)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final fillPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    for (var part in template.parts) {
      canvas.drawPath(part.path, fillPaint);
      canvas.drawPath(part.path, paint);
    }

    template.drawDetails(canvas, const Size(400, 400), paint..strokeWidth = 3);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Confetti Particle Effect Painter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint =
          Paint()
            ..color = p.color.withValues(alpha: p.life)
            ..style = PaintingStyle.fill;

      if (p.type == 0) {
        canvas.drawCircle(p.position, p.size, paint);
      } else if (p.type == 1) {
        canvas.drawRect(
          Rect.fromCenter(
            center: p.position,
            width: p.size * 1.4,
            height: p.size,
          ),
          paint,
        );
      } else {
        // Draw star particle
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Bouncy Physical Button for Preschoolers
class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double size;

  const BouncyButton({
    super.key,
    required this.child,
    required this.onTap,
    this.size = 64,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
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
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
