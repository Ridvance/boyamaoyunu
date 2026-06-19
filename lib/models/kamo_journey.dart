import 'package:flutter/material.dart';
import '../games/coloring_game.dart';
import '../games/magic_colors_game.dart';
import '../games/shape_sorter_game.dart';
import '../games/sound_board_game.dart';
import '../games/habits_game.dart';
import '../games/tracing_game.dart';
import '../games/balloon_pop_game.dart';

class JourneyLevel {
  final int levelIndex;
  final String title;
  final Widget Function(BuildContext) builder;

  const JourneyLevel({
    required this.levelIndex,
    required this.title,
    required this.builder,
  });
}

class JourneyChapter {
  final String id;
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final List<JourneyLevel> levels;

  const JourneyChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.levels,
  });
}

final List<JourneyChapter> kamoChapters = [
  JourneyChapter(
    id: 'colors',
    title: 'Renkler',
    description: 'Boyama ve Renk Karıştırma',
    color: const Color(0xFFFF4B4B),
    icon: Icons.brush_rounded,
    levels: [
      JourneyLevel(
        levelIndex: 0,
        title: 'Boyama Kitabı',
        builder: (context) => const ColoringGame(),
      ),
      JourneyLevel(
        levelIndex: 1,
        title: 'Renk Laboratuvarı',
        builder: (context) => const MagicColorsGame(),
      ),
    ],
  ),
  JourneyChapter(
    id: 'shapes',
    title: 'Şekiller',
    description: 'Eşleştirme ve Şekiller',
    color: const Color(0xFF2ECC71),
    icon: Icons.category_rounded,
    levels: [
      JourneyLevel(
        levelIndex: 0,
        title: 'Şekil Eşleştirme',
        builder: (context) => const ShapeSorterGame(),
      ),
    ],
  ),
  JourneyChapter(
    id: 'sounds',
    title: 'Sesler',
    description: 'Melodiler ve Hayvan Sesleri',
    color: const Color(0xFFFF8E2B),
    icon: Icons.music_note_rounded,
    levels: [
      JourneyLevel(
        levelIndex: 0,
        title: 'Müzik Kutusu',
        builder: (context) => const SoundBoardGame(),
      ),
    ],
  ),
  JourneyChapter(
    id: 'habits',
    title: 'Alışkanlıklar',
    description: 'Günlük Alışkanlıklar',
    color: const Color(0xFF2FA7A0),
    icon: Icons.volunteer_activism_rounded,
    levels: [
      JourneyLevel(
        levelIndex: 0,
        title: 'İyi Alışkanlıklar',
        builder: (context) => const HabitsGame(),
      ),
    ],
  ),
  JourneyChapter(
    id: 'tracing',
    title: 'Çizgi Takip',
    description: 'El Becerisi ve Eğlence',
    color: const Color(0xFF2B86FF),
    icon: Icons.gesture_rounded,
    levels: [
      JourneyLevel(
        levelIndex: 0,
        title: 'Çizgi Takip',
        builder: (context) => const TracingGame(),
      ),
      JourneyLevel(
        levelIndex: 1,
        title: 'Balon Patlatma',
        builder: (context) => const BalloonPopGame(),
      ),
    ],
  ),
];
