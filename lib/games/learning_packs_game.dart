import 'package:flutter/material.dart';
import 'coloring_game.dart';
import 'habits_game.dart';
import 'magic_colors_game.dart';
import '../services/guidance_widgets.dart';
import '../services/progress_service.dart';
import '../services/audio_synth.dart';
import '../services/app_settings_service.dart';
import 'magic_colors/chameleon_painter.dart';
import 'dart:async';

class LearningPackActivity {
  final String id;
  final String title;
  final String skill;
  final int progressIndex;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;

  const LearningPackActivity({
    required this.id,
    required this.title,
    required this.skill,
    required this.progressIndex,
    required this.icon,
    required this.color,
    required this.builder,
  });
}

class PackMiniStep {
  final String label;
  final IconData icon;

  const PackMiniStep({required this.label, required this.icon});
}

class PackMiniActivityScreen extends StatefulWidget {
  const PackMiniActivityScreen({
    required this.activityId,
    required this.title,
    required this.color,
    required this.steps,
    super.key,
  });

  final String activityId;
  final String title;
  final Color color;
  final List<PackMiniStep> steps;

  @override
  State<PackMiniActivityScreen> createState() => _PackMiniActivityScreenState();
}

class _PackMiniActivityScreenState extends State<PackMiniActivityScreen> {
  int _stepIndex = 0;
  bool _isComplete = false;

  void _completeStep() {
    AppHaptics.mediumImpact();
    AudioSynth.playRaindropSound();
    if (_stepIndex == widget.steps.length - 1) {
      setState(() => _isComplete = true);
      AudioSynth.playSparkleSound();
      return;
    }
    setState(() => _stepIndex += 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.steps.length, (index) {
                  final isDone = index < _stepIndex || _isComplete;
                  final isActive = index == _stepIndex && !_isComplete;
                  return Container(
                    key: ValueKey('pack-mini-progress-${widget.activityId}-$index'),
                    width: 64,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isDone || isActive
                          ? widget.color
                          : const Color(0xFFE6ECE8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isComplete
                    ? Center(
                        child: FilledButton.icon(
                          key: ValueKey('pack-mini-complete-${widget.activityId}'),
                          style: FilledButton.styleFrom(
                            backgroundColor: widget.color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.emoji_events_rounded, size: 40),
                          label: const Text(
                            'Tamamladım',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Semantics(
                          button: true,
                          label: widget.steps[_stepIndex].label,
                          child: Material(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(36),
                            child: InkWell(
                              key: ValueKey(
                                'pack-mini-step-${widget.activityId}-$_stepIndex',
                              ),
                              onTap: _completeStep,
                              borderRadius: BorderRadius.circular(36),
                              child: SizedBox(
                                width: 300,
                                height: 260,
                                child: Icon(
                                  widget.steps[_stepIndex].icon,
                                  color: Colors.white,
                                  size: 150,
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
      ),
    );
  }
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
          progressIndex: 0,
          icon: Icons.brush_rounded,
          color: const Color(0xFFFF4B4B),
          builder: (_) => const ColoringGame(),
        ),
        LearningPackActivity(
          id: 'color-mix',
          title: 'Renk Karışımı',
          skill: 'Renk sonucu',
          progressIndex: 1,
          icon: Icons.science_rounded,
          color: const Color(0xFFFF9500),
          builder: (_) => const MagicColorsGame(),
        ),
        LearningPackActivity(
          id: 'habits',
          title: 'İyi Alışkanlıklar',
          skill: 'Günlük görev',
          progressIndex: 2,
          icon: Icons.volunteer_activism_rounded,
          color: const Color(0xFF2FA7A0),
          builder: (_) => const HabitsGame(),
        ),
        LearningPackActivity(
          id: 'star-trail',
          title: 'Yıldız Yolu',
          skill: 'Sıralı dikkat',
          progressIndex: 3,
          icon: Icons.route_rounded,
          color: const Color(0xFF8B5CF6),
          builder: (_) => const PackMiniActivityScreen(
            activityId: 'star-trail',
            title: 'Yıldız Yolu',
            color: Color(0xFF8B5CF6),
            steps: [
              PackMiniStep(label: 'Başla', icon: Icons.play_arrow_rounded),
              PackMiniStep(label: 'Devam et', icon: Icons.route_rounded),
              PackMiniStep(label: 'Yıldıza ulaş', icon: Icons.star_rounded),
            ],
          ),
        ),
      ],
    ),
    LearningPack(
      id: 'colors-shapes',
      title: 'Renk ve Şekil',
      focus: 'Renk sonucu, sıra ve görsel eşleme',
      icon: Icons.palette_rounded,
      color: const Color(0xFFFF9500),
      activities: [
        LearningPackActivity(
          id: 'color-mix-practice',
          title: 'Renk Deneyi',
          skill: 'Renk sonucu',
          progressIndex: 4,
          icon: Icons.science_rounded,
          color: const Color(0xFFFF9500),
          builder: (_) => const MagicColorsGame(),
        ),
        LearningPackActivity(
          id: 'color-sequence',
          title: 'Renk Sırası',
          skill: 'Sıralı dikkat',
          progressIndex: 5,
          icon: Icons.format_color_fill_rounded,
          color: const Color(0xFFFF4B4B),
          builder: (_) => const PackMiniActivityScreen(
            activityId: 'color-sequence',
            title: 'Renk Sırası',
            color: Color(0xFFFF4B4B),
            steps: [
              PackMiniStep(label: 'Kırmızı', icon: Icons.circle_rounded),
              PackMiniStep(label: 'Sarı', icon: Icons.wb_sunny_rounded),
              PackMiniStep(label: 'Mavi', icon: Icons.water_drop_rounded),
            ],
          ),
        ),
        LearningPackActivity(
          id: 'shape-path',
          title: 'Şekil Yolu',
          skill: 'Görsel ayırt etme',
          progressIndex: 6,
          icon: Icons.category_rounded,
          color: const Color(0xFF2B86FF),
          builder: (_) => const PackMiniActivityScreen(
            activityId: 'shape-path',
            title: 'Şekil Yolu',
            color: Color(0xFF2B86FF),
            steps: [
              PackMiniStep(label: 'Daire', icon: Icons.circle_outlined),
              PackMiniStep(label: 'Kare', icon: Icons.square_outlined),
              PackMiniStep(label: 'Yıldız', icon: Icons.star_outline_rounded),
            ],
          ),
        ),
      ],
    ),
    LearningPack(
      id: 'daily-heroes',
      title: 'Günlük Kahramanlar',
      focus: 'Öz bakım, düzen ve yardımlaşma',
      icon: Icons.volunteer_activism_rounded,
      color: const Color(0xFF2FA7A0),
      activities: [
        LearningPackActivity(
          id: 'habits-practice',
          title: 'Alışkanlık Görevleri',
          skill: 'Günlük sorumluluk',
          progressIndex: 7,
          icon: Icons.volunteer_activism_rounded,
          color: const Color(0xFF2FA7A0),
          builder: (_) => const HabitsGame(),
        ),
        LearningPackActivity(
          id: 'morning-order',
          title: 'Sabah Sırası',
          skill: 'Günlük sıralama',
          progressIndex: 8,
          icon: Icons.wb_sunny_rounded,
          color: const Color(0xFFF59E0B),
          builder: (_) => const PackMiniActivityScreen(
            activityId: 'morning-order',
            title: 'Sabah Sırası',
            color: Color(0xFFF59E0B),
            steps: [
              PackMiniStep(label: 'Uyan', icon: Icons.bed_rounded),
              PackMiniStep(label: 'Temizlen', icon: Icons.brush_rounded),
              PackMiniStep(label: 'Hazırlan', icon: Icons.checkroom_rounded),
            ],
          ),
        ),
        LearningPackActivity(
          id: 'helping-hands',
          title: 'Yardım Eden Eller',
          skill: 'Yardımlaşma sırası',
          progressIndex: 9,
          icon: Icons.back_hand_rounded,
          color: const Color(0xFFEC4899),
          builder: (_) => const PackMiniActivityScreen(
            activityId: 'helping-hands',
            title: 'Yardım Eden Eller',
            color: Color(0xFFEC4899),
            steps: [
              PackMiniStep(label: 'Fark et', icon: Icons.visibility_rounded),
              PackMiniStep(label: 'Yardım et', icon: Icons.back_hand_rounded),
              PackMiniStep(label: 'Birlikte bitir', icon: Icons.groups_rounded),
            ],
          ),
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
    final completedInline = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: activity.builder),
    );
    if (!mounted || (completedInline != true && !_isActivityCompleted(activity.id))) {
      return;
    }
    if (!ProgressService.instance.isLevelCompleted(
      ProgressChapters.learningPacks,
      activity.progressIndex,
    )) {
      await ProgressService.instance.completeLevel(
        ProgressChapters.learningPacks,
        activity.progressIndex,
        stars: 1,
      );
      if (mounted) setState(() {});
    }
  }

  bool _isActivityCompleted(String activityId) {
    return switch (activityId) {
      'story-coloring' => ProgressService.instance.isLevelCompleted(
        ProgressChapters.coloring,
        0,
      ),
      'color-mix' || 'color-mix-practice' => ProgressService.instance.getCompletedCount(
        ProgressChapters.magicColors,
      ) > 0,
      'habits' || 'habits-practice' => ProgressService.instance.isLevelCompleted(
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
                        if (selectedPack != null)
                          Container(
                            key: const ValueKey('learning-pack-progress'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedPack.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${selectedPack.activities.where((activity) => ProgressService.instance.isLevelCompleted(ProgressChapters.learningPacks, activity.progressIndex)).length} / ${selectedPack.activities.length}',
                              style: TextStyle(
                                color: selectedPack.color,
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
                                isActivityCompleted: (activity) =>
                                    ProgressService.instance.isLevelCompleted(
                                      ProgressChapters.learningPacks,
                                      activity.progressIndex,
                                    ),
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
                        const SizedBox(height: 6),
                        Text(
                          '${pack.activities.length} etkinlik',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: pack.color,
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
  final bool Function(LearningPackActivity) isActivityCompleted;
  final GlobalKey firstActivityKey;
  final bool showHint;

  const _PackDetail({
    required this.pack,
    required this.onActivityTap,
    required this.isActivityCompleted,
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
        final isDone = isActivityCompleted(activity);
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
                  Icon(
                    isDone ? Icons.check_circle_rounded : activity.icon,
                    key: ValueKey('learning-activity-status-${activity.id}'),
                    color: isDone ? const Color(0xFF10B981) : activity.color,
                    size: 72,
                  ),
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
