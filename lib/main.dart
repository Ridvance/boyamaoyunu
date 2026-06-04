import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'games/coloring_game.dart';
import 'games/tracing_game.dart';
import 'games/balloon_pop_game.dart';
import 'games/shape_sorter_game.dart';
import 'games/sound_board_game.dart';
import 'games/magic_colors_game.dart';
import 'games/habits_game.dart';
import 'games/learning_packs_game.dart';
import 'services/audio_synth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const CocukOyunApp());
}

class CocukOyunApp extends StatelessWidget {
  const CocukOyunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Çocuk Oyun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2FA7A0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF2),
        useMaterial3: true,
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final isPortrait = mediaQuery.size.height > mediaQuery.size.width;
        if (isPortrait) {
          return Scaffold(
            backgroundColor: const Color(0xFFFFFBF2),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.screen_rotation_rounded,
                      size: 80,
                      color: Color(0xFF2FA7A0),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Lütfen Cihazını Yan Çevir! 🔄',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF233238),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Oyunları en iyi şekilde oynamak için ekranı yatay (yan) konuma getirmelisin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF53666C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return child!;
      },
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isParentUnlocked = false;

  void _openParentArea() {
    setState(() {
      _isParentUnlocked = true;
    });
  }

  void _closeParentArea() {
    setState(() {
      _isParentUnlocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isParentUnlocked) {
      return ParentSafetyScreen(onBack: _closeParentArea);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Üst Başlık ve Ebeveyn Butonu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🎨 Sihirli Oyun Dünyası',
                    style: TextStyle(
                      color: Color(0xFF233238),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton.filledTonal(
                    key: const ValueKey('parent-gate-button'),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFE6ECE8),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(
                      Icons.shield_rounded,
                      color: Color(0xFF2FA7A0),
                      size: 28,
                    ),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) => MultiFingerParentGate(
                              onUnlocked: () {
                                Navigator.of(context).pop();
                                AudioSynth.playSparkleSound();
                                _openParentArea();
                              },
                            ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Oyun Kartları Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.35,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildGameCard(
                          context: context,
                          key: 'coloring',
                          icon: Icons.brush_rounded,
                          color: const Color(0xFFFF4B4B),
                          title: 'Boyama Kitabı',
                          gameWidget: const ColoringGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'tracing',
                          icon: Icons.gesture_rounded,
                          color: const Color(0xFF2B86FF),
                          title: 'Çizgi Takip',
                          gameWidget: const TracingGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'balloon_pop',
                          icon: Icons.bubble_chart_rounded,
                          color: const Color(0xFFFFD000),
                          title: 'Balon Patlatma',
                          gameWidget: const BalloonPopGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'shape_sorter',
                          icon: Icons.category_rounded,
                          color: const Color(0xFF2ECC71),
                          title: 'Şekil Eşleştirme',
                          gameWidget: const ShapeSorterGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'sound_board',
                          icon: Icons.music_note_rounded,
                          color: const Color(0xFFFF8E2B),
                          title: 'Müzik Kutusu',
                          gameWidget: const SoundBoardGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'magic_colors',
                          icon: Icons.science_rounded,
                          color: const Color(0xFFFF9500),
                          title: 'Renk Laboratuvarı',
                          gameWidget: const MagicColorsGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'habits',
                          icon: Icons.volunteer_activism_rounded,
                          color: const Color(0xFF2FA7A0),
                          title: 'İyi Alışkanlıklar',
                          gameWidget: const HabitsGame(),
                        ),
                        _buildGameCard(
                          context: context,
                          key: 'learning_packs',
                          icon: Icons.school_rounded,
                          color: const Color(0xFF8B5CF6),
                          title: 'Öğrenme Paketleri',
                          gameWidget: const LearningPacksGame(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String key,
    required IconData icon,
    required Color color,
    required String title,
    required Widget gameWidget,
  }) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        key: ValueKey('game-card-$key'),
        onTap: () {
          AudioSynth.playSparkleSound();
          Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (context) => gameWidget),
          );
        },
        borderRadius: BorderRadius.circular(21),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF233238),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gelişmiş Çoklu Dokunmatik Ebeveyn Kilidi
class MultiFingerParentGate extends StatefulWidget {
  const MultiFingerParentGate({required this.onUnlocked, super.key});

  final VoidCallback onUnlocked;

  @override
  State<MultiFingerParentGate> createState() => _MultiFingerParentGateState();
}

class _MultiFingerParentGateState extends State<MultiFingerParentGate> {
  final Map<int, Offset> _pointerPositions = {};
  Timer? _unlockTimer;
  double _progress = 0.0;
  static const int requiredFingers = 3;
  static const int durationSeconds = 3;

  @override
  void dispose() {
    _unlockTimer?.cancel();
    super.dispose();
  }

  void _checkPointers() {
    if (_pointerPositions.length == requiredFingers) {
      _startUnlockTimer();
    } else {
      _cancelUnlockTimer();
    }
  }

  void _startUnlockTimer() {
    _unlockTimer?.cancel();
    _progress = 0.0;
    const tickDuration = Duration(milliseconds: 100);
    final totalTicks = (durationSeconds * 1000) ~/ tickDuration.inMilliseconds;
    int currentTick = 0;

    _unlockTimer = Timer.periodic(tickDuration, (timer) {
      setState(() {
        currentTick++;
        _progress = currentTick / totalTicks;
      });

      if (currentTick >= totalTicks) {
        timer.cancel();
        widget.onUnlocked();
      }
    });
  }

  void _cancelUnlockTimer() {
    _unlockTimer?.cancel();
    setState(() {
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Center(
        child: Container(
          width: 500,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF2),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFF2FA7A0), width: 4),
          ),
          child: Stack(
            children: [
              // İçerik ve Listener
              Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  setState(() {
                    _pointerPositions[event.pointer] = event.localPosition;
                  });
                  _checkPointers();
                },
                onPointerMove: (event) {
                  setState(() {
                    _pointerPositions[event.pointer] = event.localPosition;
                  });
                },
                onPointerUp: (event) {
                  setState(() {
                    _pointerPositions.remove(event.pointer);
                  });
                  _checkPointers();
                },
                onPointerCancel: (event) {
                  setState(() {
                    _pointerPositions.remove(event.pointer);
                  });
                  _checkPointers();
                },
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.lock_person_rounded,
                        size: 54,
                        color: Color(0xFF2FA7A0),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ebeveyn Doğrulaması',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF233238),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Açmak için ekranın ortasına 3 parmağınızla birden dokunun ve 3 saniye basılı tutun.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF53666C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // İlerleme Çubuğu veya Durum
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: _progress,
                                strokeWidth: 8,
                                backgroundColor: const Color(0xFFE6ECE8),
                                color: const Color(0xFF6BCB77),
                              ),
                            ),
                            Text(
                              '${_pointerPositions.length} / $requiredFingers',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF233238),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Kapatma Butonu (Sağ üst)
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Dokunulan noktalarda görsel daire çizme
              ..._pointerPositions.values.map(
                (pos) => Positioned(
                  left: pos.dx - 35,
                  top: pos.dy - 35,
                  child: IgnorePointer(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2FA7A0).withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2FA7A0),
                          width: 3,
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

// Ebeveyn Güvenlik Ekranı
class ParentSafetyScreen extends StatelessWidget {
  const ParentSafetyScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    key: const ValueKey('parent-back-button'),
                    tooltip: 'Geri',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Ebeveyn Kontrol Paneli',
                      style: TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3.2,
                  children: const [
                    SafetyStatusCard(
                      label: 'Sıfır Reklam Gösterimi',
                      description:
                          'Uygulamada hiçbir ticari reklam alanı bulunmamaktadır.',
                      icon: Icons.block_rounded,
                    ),
                    SafetyStatusCard(
                      label: 'Ödeme Duvarı Yok',
                      description:
                          'Gizli veya yanlışlıkla satın alınabilecek içerik yoktur.',
                      icon: Icons.payments_rounded,
                    ),
                    SafetyStatusCard(
                      label: 'İnternetsiz / Çevrimdışı Çalışma',
                      description:
                          'Cihazın internet bağlantısı kesilse dahi tüm oyunlar çalışır.',
                      icon: Icons.wifi_off_rounded,
                    ),
                    SafetyStatusCard(
                      label: 'Kamera ve Galeri İzni Yok',
                      description:
                          'Uygulama kişisel verilerinizi toplamaz ve erişim istemez.',
                      icon: Icons.no_photography_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SafetyStatusCard extends StatelessWidget {
  const SafetyStatusCard({
    required this.label,
    required this.description,
    required this.icon,
    super.key,
  });

  final String label;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6ECE8), width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2FA7A0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2FA7A0), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF233238),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF53666C),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF6BCB77),
            size: 24,
          ),
        ],
      ),
    );
  }
}
