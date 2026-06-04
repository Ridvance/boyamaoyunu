import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/audio_synth.dart';

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

class _HabitsGameState extends State<HabitsGame> {
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

  void _completeActiveTask() {
    final task = _activeTask;
    setState(() {
      _completedTaskIds.add(task.id);
      if (!_isAllDone) {
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
    setState(() {
      _activeTaskIndex = index;
    });
    HapticFeedback.selectionClick();
  }

  void _resetTasks() {
    setState(() {
      _completedTaskIds.clear();
      _activeTaskIndex = 0;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
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
                      child: _HabitProgressTile(
                        key: ValueKey('habit-progress-${task.id}'),
                        task: task,
                        isDone: isDone,
                        isActive: isActive,
                        onTap: () => _selectTask(index),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    _isAllDone
                        ? const _HabitsCompletePanel()
                        : _HabitTaskPanel(
                          task: _activeTask,
                          onComplete: _completeActiveTask,
                        ),
              ),
            ],
          ),
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
      color:
          isDone
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

  const _HabitTaskPanel({required this.task, required this.onComplete});

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
                child: Material(
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
