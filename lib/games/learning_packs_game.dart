import 'package:flutter/material.dart';
import 'coloring_game.dart';
import 'habits_game.dart';
import 'magic_colors_game.dart';
import '../services/guidance_widgets.dart';
import '../services/progress_service.dart';
import 'magic_colors/chameleon_painter.dart';
import 'dart:async';

class LearningPackActivity {
  final String id;
  final String title;
  final String skill;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;

  const LearningPackActivity({
    required this.id,
    required this.title,
    required this.skill,
    required this.icon,
    required this.color,
    required this.builder,
  });
}

class LearningPack {
  final String id;
  final String title;
  final String focus;
  final IconData icon;
  final Color color;
  final List<LearningPackActivity> activities;

  const LearningPack({
    required this.id,
    required this.title,
    required this.focus,
    required this.icon,
    required this.color,
    required this.activities,
  });
}

class LearningPacksGame extends StatefulWidget {
  const LearningPacksGame({super.key});

  @override
  State<LearningPacksGame> createState() => _LearningPacksGameState();
}

class _LearningPacksGameState extends State<LearningPacksGame> with TickerProviderStateMixin {
  static final List<LearningPack> _packs = [
    LearningPack(
      id: 'first-skills',
      title: 'İlk Beceriler',
      focus: 'Renkler, hikaye, günlük alışkanlık',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF8B5CF6),
      activities: [
        LearningPackActivity(
          id: 'story-coloring',
          title: 'Hikayeli Boyama',
          skill: 'Görsel takip',
          icon: Icons.brush_rounded,
          color: const Color(0xFFFF4B4B),
          builder: (_) => const ColoringGame(),
        ),
        LearningPackActivity(
          id: 'color-mix',
          title: 'Renk Karışımı',
          skill: 'Renk sonucu',
          icon: Icons.science_rounded,
          color: const Color(0xFFFF9500),
          builder: (_) => const MagicColorsGame(),
        ),
        LearningPackActivity(
          id: 'habits',
          title: 'İyi Alışkanlıklar',
          skill: 'Günlük görev',
          icon: Icons.volunteer_activism_rounded,
          color: const Color(0xFF2FA7A0),
          builder: (_) => const HabitsGame(),
        ),
      ],
    ),
  ];

  LearningPack? _selectedPack;

  bool _showHint = false;
  Offset _hintPosition = Offset.zero;
  late final AnimationController _hintController;

  String _kamoExpression = 'neutral';
  Timer? _kamoReactionTimer;

  final GlobalKey _firstPackKey = GlobalKey();
  final GlobalKey _firstActivityKey = GlobalKey();

  bool get showHint => _showHint;
  String get kamoExpression => _kamoExpression;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        if (_showHint) {
          final targetKey = _selectedPack == null ? _firstPackKey : _firstActivityKey;
          final startCenter = _getWidgetLocalCenter(targetKey);
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
    _hintController.dispose();
    _kamoReactionTimer?.cancel();
    super.dispose();
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

  void _triggerKamoHappy() {
    _kamoReactionTimer?.cancel();
    setState(() {
      _kamoExpression = 'happy';
    });
    _kamoReactionTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  void _selectPack(LearningPack pack) {
    setState(() {
      _selectedPack = pack;
      _showHint = false;
      _hintController.stop();
      _hintController.reset();
    });
    _triggerKamoHappy();
  }

  Future<void> _openActivity(LearningPackActivity activity) async {
    setState(() {
      _showHint = false;
      _hintController.stop();
      _hintController.reset();
    });
    _triggerKamoHappy();
    await Navigator.push<void>(context, MaterialPageRoute(builder: activity.builder));
    if (!mounted || !_isActivityCompleted(activity.id)) return;
    final activityIndex = _selectedPack?.activities.indexOf(activity) ?? -1;
    if (activityIndex >= 0) {
      await ProgressService.instance.completeLevel(
        ProgressChapters.learningPacks,
        activityIndex,
        stars: 1,
      );
    }
  }

  bool _isActivityCompleted(String activityId) {
    return switch (activityId) {
      'story-coloring' => ProgressService.instance.isLevelCompleted(
        ProgressChapters.coloring,
        0,
      ),
      'color-mix' => ProgressService.instance.getCompletedCount(
        ProgressChapters.magicColors,
      ) > 0,
      'habits' => ProgressService.instance.isLevelCompleted(
        ProgressChapters.habits,
        0,
      ),
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final selectedPack = _selectedPack;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: InactivityDetector(
        enabled: true,
        onActivity: () {
          if (_showHint) {
            setState(() {
              _showHint = false;
              _hintController.stop();
              _hintController.reset();
            });
          }
        },
        onInactivity: () {
          setState(() {
            _showHint = true;
            _hintController.repeat();
          });
        },
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          key: const ValueKey('learning-packs-back-button'),
                          onPressed:
                              selectedPack == null
                                  ? () => Navigator.pop(context)
                                  : () => setState(() {
                                        _selectedPack = null;
                                        _showHint = false;
                                        _hintController.stop();
                                        _hintController.reset();
                                      }),
                          icon: Icon(
                            selectedPack == null
                                ? Icons.arrow_back_rounded
                                : Icons.grid_view_rounded,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            selectedPack?.title ?? 'Öğrenme Paketleri',
                            style: const TextStyle(
                              color: Color(0xFF233238),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          selectedPack == null
                              ? _PackList(
                                packs: _packs,
                                onSelect: _selectPack,
                                firstPackKey: _firstPackKey,
                                showHint: _showHint,
                              )
                              : _PackDetail(
                                pack: selectedPack,
                                onActivityTap: _openActivity,
                                firstActivityKey: _firstActivityKey,
                                showHint: _showHint,
                              ),
                    ),
                  ],
                ),
              ),
            ),

            if (_showHint && _hintPosition != Offset.zero)
              GhostHandHint(
                position: _hintPosition,
                active: true,
              ),

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
          ],
        ),
      ),
    );
  }
}

class _PackList extends StatelessWidget {
  final List<LearningPack> packs;
  final ValueChanged<LearningPack> onSelect;
  final GlobalKey firstPackKey;
  final bool showHint;

  const _PackList({
    required this.packs,
    required this.onSelect,
    required this.firstPackKey,
    required this.showHint,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: packs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final pack = packs[index];
        final isFirst = index == 0;
        final child = Material(
          key: isFirst ? firstPackKey : null,
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            key: ValueKey('learning-pack-${pack.id}'),
            onTap: () => onSelect(pack),
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  const SizedBox(width: 22),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: pack.color.withValues(alpha: 0.16),
                    child: Icon(pack.icon, color: pack.color, size: 48),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pack.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF233238),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pack.focus,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF53666C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 42,
                    color: Color(0xFF53666C),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        );

        if (isFirst) {
          return PulseTarget(
            active: showHint,
            color: pack.color,
            baseSize: 150.0,
            child: child,
          );
        }
        return child;
      },
    );
  }
}

class _PackDetail extends StatelessWidget {
  final LearningPack pack;
  final ValueChanged<LearningPackActivity> onActivityTap;
  final GlobalKey firstActivityKey;
  final bool showHint;

  const _PackDetail({
    required this.pack,
    required this.onActivityTap,
    required this.firstActivityKey,
    required this.showHint,
  });

  @override
  Widget build(BuildContext context) {
    final activities = pack.activities;
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: List.generate(activities.length, (index) {
        final activity = activities[index];
        final isFirst = index == 0;
        final child = Material(
          key: isFirst ? firstActivityKey : null,
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            key: ValueKey('learning-activity-${activity.id}'),
            onTap: () => onActivityTap(activity),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(activity.icon, color: activity.color, size: 72),
                  const SizedBox(height: 14),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      activity.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF233238),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.skill,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF53666C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        if (isFirst) {
          return PulseTarget(
            active: showHint,
            color: activity.color,
            baseSize: 180.0,
            child: child,
          );
        }
        return child;
      }),
    );
  }
}
