import 'dart:async';
import 'package:flutter/material.dart';
import '../games/magic_colors/chameleon_painter.dart';
import '../models/kamo_journey.dart';
import '../services/audio_synth.dart';
import '../services/progress_service.dart';

class KamoJourneyScreen extends StatefulWidget {
  const KamoJourneyScreen({super.key});

  @override
  State<KamoJourneyScreen> createState() => _KamoJourneyScreenState();
}

class _KamoJourneyScreenState extends State<KamoJourneyScreen> {
  String _kamoExpression = 'neutral';
  Timer? _expressionTimer;

  @override
  void dispose() {
    _expressionTimer?.cancel();
    super.dispose();
  }

  void _triggerKamoExpression(String expr) {
    _expressionTimer?.cancel();
    setState(() {
      _kamoExpression = expr;
    });
    _expressionTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  void _onChapterTap(JourneyChapter chapter) {
    AudioSynth.playSparkleSound();
    _triggerKamoExpression('happy');

    // Show level selection dialog
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: 480,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: chapter.color, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: chapter.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(chapter.icon, color: chapter.color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapter.title,
                              style: const TextStyle(
                                color: Color(0xFF233238),
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              chapter.description,
                              style: const TextStyle(
                                color: Color(0xFF53666C),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Levels List
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: chapter.levels.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final lvl = chapter.levels[index];
                        final isCompleted = ProgressService.instance.isLevelCompleted(chapter.id, lvl.levelIndex);

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompleted ? const Color(0xFFE8F8F5) : Colors.white,
                            foregroundColor: const Color(0xFF233238),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(
                                color: isCompleted ? const Color(0xFF2ECC71) : const Color(0xFFE6ECE8),
                                width: 2.5,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // pop dialog
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => lvl.builder(context),
                              ),
                            ).then((_) {
                              // Refresh stars state when returning
                              setState(() {});
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isCompleted ? const Color(0xFF2ECC71) : const Color(0xFFE6ECE8),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${lvl.levelIndex + 1}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isCompleted ? Colors.white : const Color(0xFF53666C),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  lvl.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Icon(
                                isCompleted ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
                                color: isCompleted ? const Color(0xFF2ECC71) : chapter.color,
                                size: 28,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button & Title
                  Row(
                    children: [
                      IconButton.filledTonal(
                        key: const ValueKey('journey-back-button'),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE6ECE8),
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded, size: 24, color: Color(0xFF233238)),
                        onPressed: () {
                          AudioSynth.playRaindropSound();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Kamo\'nun Yolculuğu',
                        style: TextStyle(
                          color: Color(0xFF233238),
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Chapters list
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 120, bottom: 20),
                      itemCount: kamoChapters.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final chapter = kamoChapters[index];
                        final completedCount = ProgressService.instance.getCompletedCount(chapter.id);
                        final totalCount = chapter.levels.length;

                        return GestureDetector(
                          key: ValueKey('chapter-card-${chapter.id}'),
                          onTap: () => _onChapterTap(chapter),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: chapter.color.withValues(alpha: 0.3), width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: chapter.color.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Chapter Icon
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: chapter.color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(chapter.icon, color: chapter.color, size: 26),
                                  ),
                                ),
                                const Spacer(),
                                // Chapter Name
                                Text(
                                  chapter.title,
                                  style: const TextStyle(
                                    color: Color(0xFF233238),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  chapter.description,
                                  style: const TextStyle(
                                    color: Color(0xFF53666C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                // Progress Stars
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(totalCount, (starIdx) {
                                    final isDone = starIdx < completedCount;
                                    return Icon(
                                      isDone ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: isDone ? const Color(0xFFFFD000) : const Color(0xFFE6ECE8),
                                      size: 26,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Kamo Mascot Mascot Card (Interactive)
            Positioned(
              bottom: 24,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  AudioSynth.playSparkleSound();
                  _triggerKamoExpression(_kamoExpression == 'happy' ? 'surprised' : 'happy');
                },
                child: Container(
                  width: 90,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF2FA7A0).withValues(alpha: 0.4),
                      width: 2.5,
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
    );
  }
}
