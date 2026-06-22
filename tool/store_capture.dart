import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cocuk_oyun/games/balloon_pop_game.dart';
import 'package:cocuk_oyun/games/coloring_game.dart';
import 'package:cocuk_oyun/games/magic_colors_game.dart';
import 'package:cocuk_oyun/games/shape_sorter_game.dart';
import 'package:cocuk_oyun/games/sound_board_game.dart';
import 'package:cocuk_oyun/games/tracing_game.dart';
import 'package:cocuk_oyun/main.dart';
import 'package:cocuk_oyun/services/app_settings_service.dart';
import 'package:cocuk_oyun/services/progress_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettingsService.instance.init();
  await ProgressService.instance.init();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  const screen = String.fromEnvironment('STORE_SCREEN', defaultValue: 'home');
  if (screen == 'home') {
    runApp(const CocukOyunApp());
    return;
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ninnice Çocuk Oyunları',
      home: switch (screen) {
        'coloring' => const ColoringGame(),
        'tracing' => const TracingGame(),
        'balloon' => const BalloonPopGame(),
        'shapes' => const ShapeSorterGame(),
        'sounds' => const SoundBoardGame(),
        'colors' => const MagicColorsGame(),
        _ => const ColoringGame(),
      },
    ),
  );
}
