import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/audio_synth.dart';
import '../services/guidance_widgets.dart';
import '../services/progress_service.dart';
import 'magic_colors/chameleon_painter.dart';
import 'dart:async';

class HabitTask {
  final String id;
  final String title;
  final IconData sceneIcon;
  final IconData actionIcon;
  final Color color;

  const HabitTask({
    required this.id,
    required this.title,
    required this.sceneIcon,
    required this.actionIcon,
    required this.color,
  });
}

class HabitsGame extends StatefulWidget {
  const HabitsGame({super.key});

  @override
  State<HabitsGame> createState() => _HabitsGameState();
}

class _HabitsGameState extends State<HabitsGame> with TickerProviderStateMixin {
  static const List<HabitTask> _tasks = [
    HabitTask(
      id: 'toys',
      title: 'Oyuncakları Topla',
      sceneIcon: Icons.toys_rounded,
      actionIcon: Icons.inventory_2_rounded,
      color: Color(0xFF2B86FF),
    ),
    HabitTask(
      id: 'teeth',
      title: 'Dişleri Fırçala',
      sceneIcon: Icons.sentiment_satisfied_alt_rounded,
      actionIcon: Icons.brush_rounded,
      color: Color(0xFF2FA7A0),
    ),
    HabitTask(
      id: 'trash',
      title: 'Çöpü Kutusuna At',
      sceneIcon: Icons.recycling_rounded,
      actionIcon: Icons.delete_rounded,
      color: Color(0xFFFF8E2B),
    ),
  ];

  final Set<String> _completedTaskIds = {};
  int _activeTaskIndex = 0;

  HabitTask get _activeTask => _tasks[_activeTaskIndex];
  bool get _isAllDone => _completedTaskIds.length == _tasks.length;

  bool _showHint = false;
  Offset _hintPosition = Offset.zero;
  late final AnimationController _hintController;
  final GlobalKey _actionButtonKey = GlobalKey();

  String _kamoExpression = 'neutral';
  Timer? _kamoReactionTimer;

  bool _isCelebrationActive = false;
  Timer? _celebrationTimer;
  late final List<StreamController<void>> _wiggleControllers;

  bool get showHint => _showHint;
  String get kamoExpression => _isAllDone ? 'happy' : _kamoExpression;
  bool get isCelebrationActive => _isCelebrationActive;

  @override
  void initState() {
    super.initState();
    _wiggleControllers = List.generate(
      _tasks.length,
      (_) => StreamController<void>.broadcast(),
    );

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        if (_showHint) {
          final startCenter = _getWidgetLocalCenter(_actionButtonKey);
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
    _celebrationTimer?.cancel();
    for (final controller in _wiggleControllers) {
      controller.close();
    }
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
    _kamoReactionTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  void _triggerKamoSurprised() {
    _kamoReactionTimer?.cancel();
    setState(() {
      _kamoExpression = 'surprised';
    });
    _kamoReactionTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  void _completeActiveTask() {
    final task = _activeTask;
    setState(() {
      _completedTaskIds.add(task.id);
      _showHint = false;
      _hintController.stop();
      _hintController.reset();

      if (_isAllDone) {
        _isCelebrationActive = true;
        ProgressService.instance.completeLevel('habits', 0);
        _celebrationTimer?.cancel();
        _celebrationTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isCelebrationActive = false;
            });
          }
        });
      } else {
        _triggerKamoHappy();
        final nextIndex = _tasks.indexWhere(
          (item) => !_completedTaskIds.contains(item.id),
        );
        _activeTaskIndex = nextIndex == -1 ? _activeTaskIndex : nextIndex;
      }
    });
    HapticFeedback.heavyImpact();
    AudioSynth.playSparkleSound();
  }

  void _selectTask(int index) {
    final task = _tasks[index];
    if (_completedTaskIds.contains(task.id)) {
      _wiggleControllers[index].add(null);
      _triggerKamoSurprised();
      HapticFeedback.lightImpact();
      return;
    }

    setState(() {
      _activeTaskIndex = index;
      _showHint = false;
      _hintController.stop();
      _hintController.reset();
    });
    HapticFeedback.selectionClick();
  }

  void _resetTasks() {
    setState(() {
      _completedTaskIds.clear();
      _activeTaskIndex = 0;
      _showHint = false;
      _isCelebrationActive = false;
      _kamoExpression = 'neutral';
      _kamoReactionTimer?.cancel();
      _celebrationTimer?.cancel();
      _hintController.stop();
      _hintController.reset();
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: InactivityDetector(
        enabled: !_isAllDone,
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
          if (!_isAllDone) {
            setState(() {
              _showHint = true;
              _hintController.repeat();
            });
          }
        },
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          key: const ValueKey('habits-back-button'),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'İyi Alışkanlıklar',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF233238),
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          key: const ValueKey('habits-reset-button'),
                          onPressed: _resetTasks,
                          icon: const Icon(Icons.refresh_rounded, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(_tasks.length, (index) {
                        final task = _tasks[index];
                        final isDone = _completedTaskIds.contains(task.id);
                        final isActive = index == _activeTaskIndex;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: SoftWrongFeedback(
                              triggerStream: _wiggleControllers[index].stream,
                              child: _HabitProgressTile(
                                key: ValueKey('habit-progress-${task.id}'),
                                task: task,
                                isDone: isDone,
                                isActive: isActive,
                                onTap: () => _selectTask(index),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _isAllDone
                          ? const _HabitsCompletePanel()
                          : _HabitTaskPanel(
                              task: _activeTask,
                              onComplete: _completeActiveTask,
                              actionButtonKey: _actionButtonKey,
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

            CelebrationEffect(active: _isCelebrationActive),

            Positioned(
              bottom: 16,
              left: _isAllDone ? null : 16,
              right: _isAllDone ? 16 : null,
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
                            expression: kamoExpression,
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

class _HabitProgressTile extends StatelessWidget {
  final HabitTask task;
  final bool isDone;
  final bool isActive;
  final VoidCallback onTap;

  const _HabitProgressTile({
    super.key,
    required this.task,
    required this.isDone,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDone
          ? const Color(0xFF10B981)
          : isActive
              ? task.color
              : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 72,
          child: Icon(
            isDone ? Icons.check_rounded : task.sceneIcon,
            color: isDone || isActive ? Colors.white : task.color,
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _HabitTaskPanel extends StatelessWidget {
  final HabitTask task;
  final VoidCallback onComplete;
  final GlobalKey actionButtonKey;
  final bool showHint;

  const _HabitTaskPanel({
    required this.task,
    required this.onComplete,
    required this.actionButtonKey,
    required this.showHint,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: task.color.withValues(alpha: 0.35), width: 4),
        boxShadow: [
          BoxShadow(
            color: task.color.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  task.sceneIcon,
                  color: task.color.withValues(alpha: 0.88),
                  size: 190,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 64,
              color: Color(0xFF53666C),
            ),
            Expanded(
              child: Semantics(
                button: true,
                label: task.title,
                child: PulseTarget(
                  active: showHint,
                  color: task.color,
                  baseSize: 160.0,
                  child: Material(
                    key: actionButtonKey,
                    color: task.color,
                    borderRadius: BorderRadius.circular(32),
                    child: InkWell(
                      key: ValueKey('habit-action-${task.id}'),
                      onTap: onComplete,
                      borderRadius: BorderRadius.circular(32),
                      child: Center(
                        child: Icon(
                          task.actionIcon,
                          color: Colors.white,
                          size: 160,
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

class _HabitsCompletePanel extends StatelessWidget {
  const _HabitsCompletePanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const ValueKey('habits-complete-panel'),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FFF6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF10B981), width: 4),
      ),
      child: const Center(
        child: Icon(
          Icons.emoji_events_rounded,
          color: Color(0xFF10B981),
          size: 180,
        ),
      ),
    );
  }
}
