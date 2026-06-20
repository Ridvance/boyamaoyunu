import 'dart:async';
import 'dart:math' as math;
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
import 'services/fullscreen_controller.dart';
import 'services/progress_service.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Initialize offline progress storage
  await ProgressService.instance.init();
  // Preload all synthesized sounds asynchronously in the background
  AudioSynth.preloadAllSounds();
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
  bool _showFullscreenHint = false;

  bool get _isCompact => MediaQuery.sizeOf(context).height < 400;

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

  Future<void> _enterFullscreen() async {
    AudioSynth.playSparkleSound();
    final didEnter = await FullscreenController.toggleImmersiveMode();
    if (!mounted) return;
    setState(() {
      _showFullscreenHint = !didEnter;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isParentUnlocked) {
      return ParentSafetyScreen(onBack: _closeParentArea);
    }

    final compact = _isCompact;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16 : 32,
            vertical: compact ? 8 : 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Üst Başlık ve Ebeveyn Butonu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '🎨 Sihirli Oyun Dünyası',
                        style: TextStyle(
                          color: const Color(0xFF233238),
                          fontSize: compact ? 22 : 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        key: const ValueKey('fullscreen-button'),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF0BF),
                          padding: EdgeInsets.all(compact ? 8 : 12),
                        ),
                        icon: Icon(
                          Icons.fullscreen_rounded,
                          color: const Color(0xFFFF9500),
                          size: compact ? 24 : 30,
                        ),
                        onPressed: _enterFullscreen,
                      ),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                        key: const ValueKey('parent-gate-button'),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE6ECE8),
                          padding: EdgeInsets.all(compact ? 8 : 12),
                        ),
                        icon: Icon(
                          Icons.shield_rounded,
                          color: const Color(0xFF2FA7A0),
                          size: compact ? 22 : 28,
                        ),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (context) => MathParentGateDialog(
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
                ],
              ),
              if (_showFullscreenHint) ...[
                const SizedBox(height: 6),
                Container(
                  key: const ValueKey('fullscreen-hint'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7D6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFFFCC00),
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'Tam ekran için Chrome menüsünden "Ana ekrana ekle" ile aç.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6A5200),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              // Oyun Kartları Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = _isCompact;
                    return GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: compact ? 12 : 20,
                      mainAxisSpacing: compact ? 12 : 20,
                      childAspectRatio: compact ? 1.65 : 1.35,
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
    final compact = _isCompact;
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: 0.3), width: compact ? 2 : 3),
        borderRadius: BorderRadius.circular(compact ? 16 : 24),
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
        borderRadius: BorderRadius.circular(compact ? 13 : 21),
        child: Padding(
          padding: EdgeInsets.all(compact ? 8 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(compact ? 8 : 16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: compact ? 28 : 48, color: color),
              ),
              SizedBox(height: compact ? 6 : 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF233238),
                  fontSize: compact ? 13 : 18,
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

// Matematik Sorulu Ebeveyn Doğrulama Kilidi
class MathParentGateDialog extends StatefulWidget {
  const MathParentGateDialog({required this.onUnlocked, super.key});

  final VoidCallback onUnlocked;

  @override
  State<MathParentGateDialog> createState() => _MathParentGateDialogState();
}

class _MathParentGateDialogState extends State<MathParentGateDialog> {
  late String _question;
  late int _correctAnswer;
  late List<int> _options;
  final _random = math.Random();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    _errorMessage = null;
    final type = _random.nextInt(3); // 0: +, 1: -, 2: *
    int a, b;
    switch (type) {
      case 0: // +
        a = _random.nextInt(9) + 1; // 1-9
        b = _random.nextInt(9) + 1; // 1-9
        _question = '$a + $b = ?';
        _correctAnswer = a + b;
        break;
      case 1: // -
        a = _random.nextInt(9) + 10; // 10-18
        b = _random.nextInt(9) + 1;  // 1-9
        _question = '$a - $b = ?';
        _correctAnswer = a - b;
        break;
      case 2: // *
      default:
        a = _random.nextInt(4) + 2; // 2-5
        b = _random.nextInt(4) + 2; // 2-5
        _question = '$a × $b = ?';
        _correctAnswer = a * b;
        break;
    }

    final Set<int> wrongAnswers = {};
    while (wrongAnswers.length < 2) {
      final offset = _random.nextInt(5) + 1;
      final sign = _random.nextBool() ? 1 : -1;
      final wrongVal = _correctAnswer + (offset * sign);
      if (wrongVal != _correctAnswer && wrongVal > 0) {
        wrongAnswers.add(wrongVal);
      }
    }

    _options = [_correctAnswer, ...wrongAnswers];
    _options.shuffle(_random);
  }

  void _handleOptionSelected(int selectedValue) {
    if (selectedValue == _correctAnswer) {
      widget.onUnlocked();
    } else {
      setState(() {
        _generateQuestion();
        _errorMessage = 'Tekrar deneyin.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Center(
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF2),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFF2FA7A0), width: 4),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
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
                    'Devam etmek için lütfen işlemin sonucunu seçin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF53666C),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6ECE8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: () {
                      int wrongIndex = 0;
                      return _options.map((option) {
                        final isCorrect = option == _correctAnswer;
                        return SizedBox(
                          width: 110,
                          height: 50,
                          child: ElevatedButton(
                            key: ValueKey(isCorrect
                                ? 'parent-gate-option-correct'
                                : 'parent-gate-option-wrong-${wrongIndex++}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2FA7A0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () => _handleOptionSelected(option),
                            child: Text(
                              option.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        );
                      }).toList();
                    }(),
                  ),
                ],
              ),
              Positioned(
                top: -12,
                right: -12,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
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

  Future<void> _launchPrivacyPolicy(BuildContext context) async {
    final url = Uri.parse('https://ridvance.github.io/boyamaoyunu/privacy.html');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch URL';
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gizlilik politikası açılamadı.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

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
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => _launchPrivacyPolicy(context),
                  icon: const Icon(
                    Icons.privacy_tip_outlined,
                    size: 18,
                    color: Color(0xFF556B73),
                  ),
                  label: const Text(
                    'Gizlilik Politikası',
                    style: TextStyle(
                      color: Color(0xFF556B73),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
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
