import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/audio_synth.dart';
import '../services/app_settings_service.dart';
import 'magic_colors/chameleon_painter.dart';
import '../services/guidance_widgets.dart';
import '../services/progress_service.dart';

class MagicColorsGame extends StatefulWidget {
  const MagicColorsGame({super.key});

  @override
  State<MagicColorsGame> createState() => _MagicColorsGameState();
}

class _MagicColorsGameState extends State<MagicColorsGame>
    with SingleTickerProviderStateMixin {
  bool get _isCompact => MediaQuery.sizeOf(context).height < 400;
  int get _progressLevelForCurrentMode => switch (_currentMode) {
    'sandbox' => 0,
    'camouflage' => 1,
    'flyhunt' => 2,
    'coloring' => 3,
    _ => 0,
  };

  // Oyun güncelleyici döngüsü
  late final AnimationController _tickerController;
  int _lastTimestamp = 0;
  double _time = 0.0;

  // Skor / Yıldızlar
  int _stars = 0;

  // Kamo'nun durumu
  String _kamoExpression = 'neutral';
  Timer? _kamoExpressionTimer;
  bool _showCelebration = false;
  Timer? _celebrationTimer;
  bool _showGhostHand = false;
  Offset? _ghostHandPosition;
  final StreamController<void> _wrongFeedbackController = StreamController<void>.broadcast();

  Color _chameleonColor = const Color(0xFF4CAF50); // Başlangıçta Yeşil
  String _chameleonColorName = 'Yeşil';
  Offset _lookTarget = const Offset(400, 200);
  double _tongueProgress = 0.0;
  Offset? _tongueTarget;
  bool _isEating = false;
  bool _isRetracting = false;
  ChameleonFly? _targetEatingFly;
  bool _isCamouflaged = false;

  // Laboratuvar kapları / Karışım slotları (En fazla 2 renk karıştırılır)
  final List<Map<String, dynamic>> _beakerSlots = [];
  Color _mixedColor = Colors.transparent;
  String _mixedColorName = '';

  // Sinek listesi (Sinek Avı modu için)
  final List<ChameleonFly> _flies = [];

  // Mod Seçimi
  // 'menu', 'sandbox', 'camouflage', 'flyhunt', 'coloring'
  String _currentMode = 'menu';

  // 1. Kamufle Ol! Modu Durumları
  int _camouLevel = 0;
  String _camouTargetName = '';
  Color _camouTargetColor = Colors.transparent;
  String _camouBgEmoji = '';
  double _starTimer = 1.0; // 1.0 -> 0.0
  final double _camouStarTimerDuration = 12.0; // 12 saniye süre
  bool _showBird = false;
  double _birdProgress = 0.0; // 0.0 -> 1.0
  String _birdText = '';

  // 2. Sinek Avı Modu Durumları
  int _flyHuntLevel = 0;
  String _flyHuntTargetName = '';
  final List<String> _flyHuntEatenColors = [];

  // 3. Resim Defteri Modu Durumları
  int _coloringLevel = 0;
  // Şablon parçaları
  final List<ColoringPart> _coloringParts = [];
  bool _coloringCompleted = false;

  // Konfeti ve Yıldız Parçacıkları (Kutlama)
  final List<ConfettiParticle> _confetti = [];

  // Renk Kütüphanesi
  static const Map<String, Color> baseColors = {
    'Kırmızı': Color(0xFFFF3B30),
    'Sarı': Color(0xFFFFCC00),
    'Mavi': Color(0xFF007AFF),
    'Beyaz': Color(0xFFFFFFFF),
    'Siyah': Color(0xFF1C1C1E),
  };

  static const Map<String, String> mixRules = {
    'Kırmızı+Sarı': 'Turuncu',
    'Mavi+Sarı': 'Yeşil',
    'Kırmızı+Mavi': 'Mor',
    'Beyaz+Kırmızı': 'Pembe',
    'Mavi+Beyaz': 'Açık Mavi',
    'Siyah+Beyaz': 'Gri',
    'Kırmızı+Yeşil': 'Kahverengi',
    'Sarı+Mavi': 'Yeşil',
    'Sarı+Kırmızı': 'Turuncu',
    'Mavi+Kırmızı': 'Mor',
    'Kırmızı+Beyaz': 'Pembe',
    'Beyaz+Mavi': 'Açık Mavi',
    'Beyaz+Siyah': 'Gri',
    'Kırmızı+Siyah': 'Koyu Kırmızı',
    'Mavi+Siyah': 'Lacivert',
  };

  static const Map<String, Color> mixedColors = {
    'Turuncu': Color(0xFFFF9500),
    'Yeşil': Color(0xFF4CAF50),
    'Mor': Color(0xFFAF52DE),
    'Pembe': Color(0xFFFF2D55),
    'Açık Mavi': Color(0xFF5AC8FA),
    'Gri': Color(0xFF8E8E93),
    'Kahverengi': Color(0xFFA25A38),
    'Koyu Kırmızı': Color(0xFF8B0000),
    'Lacivert': Color(0xFF000080),
    'Gökkuşağı ✨': Color(
      0xFFFFD700,
    ), // Beklenmeyen karışımlar için sihirli altın renk
  };

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick);
    _tickerController.repeat();
    _lastTimestamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    _tickerController.dispose();
    _kamoExpressionTimer?.cancel();
    _celebrationTimer?.cancel();
    _wrongFeedbackController.close();
    super.dispose();
  }

  void _setKamoExpression(String exp, {Duration delay = const Duration(seconds: 2)}) {
    setState(() {
      _kamoExpression = exp;
    });
    _kamoExpressionTimer?.cancel();
    _kamoExpressionTimer = Timer(delay, () {
      if (mounted && _kamoExpression == exp) {
        setState(() {
          _kamoExpression = 'neutral';
        });
      }
    });
  }

  List<String> _getRequiredBaseColors(String targetName) {
    if (baseColors.containsKey(targetName)) {
      return [targetName];
    }
    for (var entry in mixRules.entries) {
      if (entry.value == targetName) {
        return entry.key.split('+');
      }
    }
    return [];
  }

  Key? _getTargetHighlightKey() {
    String targetColorName = '';
    if (_currentMode == 'camouflage') {
      targetColorName = _camouTargetName;
    } else if (_currentMode == 'flyhunt') {
      targetColorName = _flyHuntTargetName;
    } else if (_currentMode == 'coloring') {
      final activeParts = _coloringParts.where((p) => !p.isCorrect).toList();
      if (activeParts.isEmpty) return null;
      final activePart = activeParts[0];
      if (_chameleonColorName == activePart.targetColorName) {
        return null;
      }
      targetColorName = activePart.targetColorName;
    } else if (_currentMode == 'sandbox') {
      if (_beakerSlots.length < 2) {
        return const ValueKey('magic-colors-tube-Kırmızı');
      } else {
        return const ValueKey('magic-colors-mix-button');
      }
    } else {
      return null;
    }

    final requiredBases = _getRequiredBaseColors(targetColorName);
    if (requiredBases.isEmpty) return null;

    if (_beakerSlots.isEmpty) {
      return ValueKey('magic-colors-tube-${requiredBases[0]}');
    }

    if (_beakerSlots.length == 1) {
      final addedColor = _beakerSlots[0]['name'];
      if (requiredBases.contains(addedColor)) {
        final otherColor = requiredBases.firstWhere((c) => c != addedColor, orElse: () => requiredBases[0]);
        return ValueKey('magic-colors-tube-$otherColor');
      } else {
        return const ValueKey('magic-colors-clear-button');
      }
    }

    if (_beakerSlots.length == 2) {
      return const ValueKey('magic-colors-mix-button');
    }

    return null;
  }

  Offset? _getElementPosition(Key key) {
    Element? targetElement;
    void findElement(Element element) {
      if (element.widget.key == key) {
        targetElement = element;
        return;
      }
      element.visitChildren(findElement);
    }
    context.visitChildElements((element) {
      findElement(element);
    });

    if (targetElement == null) return null;
    final RenderBox? box = targetElement!.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final position = box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
    final RenderBox? screenBox = context.findRenderObject() as RenderBox?;
    if (screenBox != null) {
      return screenBox.globalToLocal(position);
    }
    return position;
  }

  Offset? _getGhostHandPosition() {
    final key = _getTargetHighlightKey();
    if (key == null) return null;
    return _getElementPosition(key);
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

  void _tick() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final double dt = min((now - _lastTimestamp) / 1000.0, 0.1);
    _lastTimestamp = now;

    _time += dt;

    setState(() {
      _updateGame(dt);
    });
  }

  void _updateGame(double dt) {
    // 1. Sinek avı modunda sinekleri uçur ve Kamo'nun gözünün en yakın sineğe bakmasını sağla
    if (_currentMode == 'flyhunt') {
      double closestDist = 9999.0;
      Offset targetEyePos = const Offset(400, 200);

      final double width = MediaQuery.sizeOf(context).width;
      final double height = MediaQuery.sizeOf(context).height;
      final Offset chameleonPos = Offset(width * 0.22, height * 0.5);
      final Offset mouthPos = Offset(
        chameleonPos.dx + 82,
        chameleonPos.dy + 20,
      );

      for (var fly in _flies) {
        fly.update(dt, _time, width, height);

        final double dist = (fly.position - mouthPos).distance;
        if (dist < closestDist) {
          closestDist = dist;
          targetEyePos = fly.position;
        }
      }

      if (!_isEating) {
        _lookTarget = targetEyePos;
      }
    } else {
      // Diğer modlarda göz ekranın ortasına baksın
      _lookTarget = const Offset(500, 200);
    }

    // 2. Dil fırlatma ve Sinek yakalama animasyonu
    if (_isEating && _tongueTarget != null) {
      final double width = MediaQuery.sizeOf(context).width;
      final double height = MediaQuery.sizeOf(context).height;
      final Offset chameleonPos = Offset(width * 0.22, height * 0.5);
      final Offset mouthPos = Offset(
        chameleonPos.dx + 82,
        chameleonPos.dy + 20,
      );

      if (!_isRetracting && _targetEatingFly != null) {
        // Dil hedefe doğru gider
        _tongueProgress += 5.0 * dt;
        if (_tongueProgress >= 1.0) {
          _tongueProgress = 1.0;
          _isRetracting = true;
          // Sineği dille yakala, listeden çıkar
          _flies.remove(_targetEatingFly);
          _targetEatingFly!.position = _tongueTarget!; // Dille hizala
        }
      } else {
        // Dil geri çekilir
        _tongueProgress -= 4.0 * dt;
        if (_targetEatingFly != null) {
          // Sineğin pozisyonu dil ucuna bağlı geri çekilir
          _targetEatingFly!.position =
              mouthPos + (_tongueTarget! - mouthPos) * _tongueProgress;
        }

        if (_tongueProgress <= 0.0) {
          _tongueProgress = 0.0;
          _isEating = false;
          _isRetracting = false;
          _tongueTarget = null;

          if (_targetEatingFly != null) {
            _onFlyEaten(_targetEatingFly!.color, _targetEatingFly!.colorName);
            _targetEatingFly = null;
          }
        }
      }
    }

    // 3. Kamufle Ol modunda yıldız zamanlayıcısını düşür ve kuşu uçur
    if (_currentMode == 'camouflage' && !_isCamouflaged) {
      _starTimer = max(0.0, _starTimer - (dt / _camouStarTimerDuration));
    }

    if (_showBird) {
      _birdProgress += 0.8 * dt;
      if (_birdProgress >= 1.0) {
        _showBird = false;
        _birdProgress = 0.0;
        _onBirdPassCompleted();
      }
    }

    // 4. Konfeti parçacıklarını güncelle
    for (int i = _confetti.length - 1; i >= 0; i--) {
      final p = _confetti[i];
      p.update(dt);
      if (p.alpha <= 0.0) {
        _confetti.removeAt(i);
      }
    }
  }

  // ===========================================
  // RENK KARIŞTIRMA MANTIĞI
  // ===========================================
  void _addPaintToBeaker(String name, Color color) {
    if (_beakerSlots.length >= 2) {
      // En fazla 2 slot
      AppHaptics.lightImpact();
      return;
    }

    String targetColorName = '';
    if (_currentMode == 'camouflage') {
      targetColorName = _camouTargetName;
    } else if (_currentMode == 'coloring') {
      final activeParts = _coloringParts.where((p) => !p.isCorrect).toList();
      if (activeParts.isNotEmpty) {
        targetColorName = activeParts[0].targetColorName;
      }
    }

    if (targetColorName.isNotEmpty) {
      final requiredBases = _getRequiredBaseColors(targetColorName);
      if (requiredBases.isNotEmpty && !requiredBases.contains(name)) {
        _wrongFeedbackController.add(null);
        AppHaptics.lightImpact();
      }
    }

    AppHaptics.mediumImpact();
    AudioSynth.playRaindropSound();

    setState(() {
      _beakerSlots.add({'name': name, 'color': color});
      _mixedColor = Colors.transparent;
      _mixedColorName = '';
    });
  }

  void _clearBeaker() {
    AppHaptics.lightImpact();
    setState(() {
      _beakerSlots.clear();
      _mixedColor = Colors.transparent;
      _mixedColorName = '';
      _isCamouflaged = false;
    });
  }

  void _mixBeaker() {
    if (_beakerSlots.isEmpty) return;

    AppHaptics.mediumImpact();
    AudioSynth.playSparkleSound();

    setState(() {
      if (_beakerSlots.length == 1) {
        _mixedColorName = _beakerSlots[0]['name'];
        _mixedColor = _beakerSlots[0]['color'];
      } else {
        final r1 = _beakerSlots[0]['name'];
        final r2 = _beakerSlots[1]['name'];

        final key1 = '$r1+$r2';
        final key2 = '$r2+$r1';

        if (mixRules.containsKey(key1)) {
          _mixedColorName = mixRules[key1]!;
          _mixedColor = mixedColors[_mixedColorName]!;
        } else if (mixRules.containsKey(key2)) {
          _mixedColorName = mixRules[key2]!;
          _mixedColor = mixedColors[_mixedColorName]!;
        } else if (r1 == r2) {
          _mixedColorName = r1;
          _mixedColor = _beakerSlots[0]['color'];
        } else {
          // Tanımsız karışımlar için "Gökkuşağı" / Altın rengi
          _mixedColorName = 'Gökkuşağı ✨';
          _mixedColor = mixedColors['Gökkuşağı ✨']!;
        }
      }

      // Kamo rengi püskürtülür ve renk değiştirir
      _chameleonColor = _mixedColor;
      _chameleonColorName = _mixedColorName;
      _beakerSlots.clear();

      bool isSuccess = false;
      if (_currentMode == 'sandbox') {
        isSuccess = true;
      } else if (_currentMode == 'camouflage' &&
          _chameleonColorName == _camouTargetName) {
        _isCamouflaged = true;
        _showBird = true;
        _birdProgress = 0.0;
        _birdText = 'Kuş geliyor! Kamo gizlendi mi?';
        AudioSynth.playSparkleSound();
        isSuccess = true;
      } else if (_currentMode == 'coloring') {
        final activeParts = _coloringParts.where((p) => !p.isCorrect).toList();
        if (activeParts.isNotEmpty && _chameleonColorName == activeParts[0].targetColorName) {
          isSuccess = true;
        }
      }

      if (isSuccess) {
        _setKamoExpression('happy', delay: const Duration(seconds: 3));
        _showCelebration = true;
        ProgressService.instance.completeLevel(
          ProgressChapters.magicColors,
          _progressLevelForCurrentMode,
          stars: _currentMode == 'sandbox' ? 1 : 3,
        );
        _celebrationTimer?.cancel();
        _celebrationTimer = Timer(const Duration(milliseconds: 2500), () {
          if (mounted) {
            setState(() {
              _showCelebration = false;
            });
          }
        });
      } else if (_currentMode == 'camouflage' || _currentMode == 'coloring') {
        _setKamoExpression('surprised');
      }
    });
  }

  // ===========================================
  // MOD BAŞLATMA VE GEÇİŞLER
  // ===========================================
  void _startSandboxMode() {
    _clearBeaker();
    setState(() {
      _currentMode = 'sandbox';
      _chameleonColor = const Color(0xFF4CAF50);
      _chameleonColorName = 'Yeşil';
    });
  }

  void _startCamouflageMode() {
    _clearBeaker();
    _camouLevel = 1;
    _setupCamouflageLevel();
    setState(() {
      _currentMode = 'camouflage';
    });
  }

  void _setupCamouflageLevel() {
    _isCamouflaged = false;
    _showBird = false;
    _birdProgress = 0.0;
    _starTimer = 1.0;

    final levels = [
      {
        'name': 'Turuncu',
        'emoji': '🍁',
        'color': mixedColors['Turuncu']!,
      }, // Sonbahar Yaprağı
      {'name': 'Mor', 'emoji': '🍇', 'color': mixedColors['Mor']!}, // Üzüm Bağı
      {
        'name': 'Pembe',
        'emoji': '🌸',
        'color': mixedColors['Pembe']!,
      }, // Çiçek Bahçesi
      {
        'name': 'Açık Mavi',
        'emoji': '☁️',
        'color': mixedColors['Açık Mavi']!,
      }, // Gökyüzü bulutu
    ];

    final lvl = levels[(_camouLevel - 1) % levels.length];
    _camouTargetName = lvl['name'] as String;
    _camouTargetColor = lvl['color'] as Color;
    _camouBgEmoji = lvl['emoji'] as String;
    _chameleonColor = const Color(0xFF4CAF50);
    _chameleonColorName = 'Yeşil';
  }

  void _onBirdPassCompleted() {
    if (_chameleonColorName == _camouTargetName) {
      // Başarılı kamuflaj kutlaması
      int earnedStars = 1;
      if (_starTimer > 0.6) {
        earnedStars = 3;
      } else if (_starTimer > 0.3) {
        earnedStars = 2;
      }

      setState(() {
        _stars += earnedStars;
        _triggerCelebration();
      });

      // Seviye geçişi
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => SuccessModal(
              emoji: '🎉',
              title: 'Harika Gizlendin!',
              message: 'Kuş seni göremedi! Kamo artık güvende. +$earnedStars ⭐',
              onContinue: () {
                Navigator.pop(context);
                setState(() {
                  _camouLevel++;
                  _setupCamouflageLevel();
                });
              },
            ),
      );
    } else {
      // Kamufle olamadı ama yanma yok! Bobi şefkatle yardım eder
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => SuccessModal(
              emoji: '💡',
              title: 'Neredeyse Oluyordu!',
              message:
                  'Kamo tam gizlenemedi. Hadi tekrar deneyelim, rengi $_camouTargetName yapalım!',
              onContinue: () {
                Navigator.pop(context);
                setState(() {
                  _setupCamouflageLevel();
                });
              },
            ),
      );
    }
  }

  // Sinek Avı Modu
  void _startFlyHuntMode() {
    _clearBeaker();
    _flyHuntLevel = 1;
    _setupFlyHuntLevel();
    setState(() {
      _currentMode = 'flyhunt';
    });
  }

  void _setupFlyHuntLevel() {
    _flyHuntEatenColors.clear();
    _flies.clear();
    _isEating = false;
    _isRetracting = false;
    _tongueProgress = 0.0;
    _tongueTarget = null;
    _targetEatingFly = null;

    final levels = [
      {
        'name': 'Turuncu',
        'color': mixedColors['Turuncu']!,
        'needs': ['Kırmızı', 'Sarı'],
      },
      {
        'name': 'Yeşil',
        'color': mixedColors['Yeşil']!,
        'needs': ['Mavi', 'Sarı'],
      },
      {
        'name': 'Mor',
        'color': mixedColors['Mor']!,
        'needs': ['Kırmızı', 'Mavi'],
      },
      {
        'name': 'Pembe',
        'color': mixedColors['Pembe']!,
        'needs': ['Kırmızı', 'Beyaz'],
      },
      {
        'name': 'Açık Mavi',
        'color': mixedColors['Açık Mavi']!,
        'needs': ['Mavi', 'Beyaz'],
      },
    ];

    final lvl = levels[(_flyHuntLevel - 1) % levels.length];
    _flyHuntTargetName = lvl['name'] as String;

    // Sinekleri üret
    final random = Random();
    final needed = lvl['needs'] as List<String>;

    // Gerekli sinekleri koy
    for (var colorName in needed) {
      _flies.add(
        ChameleonFly(
          position: Offset(
            200.0 + random.nextDouble() * 300.0,
            100.0 + random.nextDouble() * 150.0,
          ),
          color: baseColors[colorName]!,
          colorName: colorName,
          speed: 60.0 + random.nextDouble() * 40.0,
        ),
      );
    }

    // Fazladan kafa karıştırıcı sinek ekle
    final otherColors =
        baseColors.keys
            .where((k) => !needed.contains(k) && k != 'Beyaz' && k != 'Siyah')
            .toList();
    if (otherColors.isNotEmpty) {
      final extraColor = otherColors[random.nextInt(otherColors.length)];
      _flies.add(
        ChameleonFly(
          position: Offset(
            200.0 + random.nextDouble() * 300.0,
            100.0 + random.nextDouble() * 150.0,
          ),
          color: baseColors[extraColor]!,
          colorName: extraColor,
          speed: 70.0 + random.nextDouble() * 30.0,
        ),
      );
    }

    _chameleonColor = const Color(0xFF8E8E93); // Başlangıçta nötr gri
    _chameleonColorName = 'Gri';
  }

  void _onFlyTapped(ChameleonFly fly) {
    if (_isEating || _isCamouflaged) return;

    AppHaptics.mediumImpact();
    // Kamo'nun dili hedefe kilitlenir
    setState(() {
      _isEating = true;
      _isRetracting = false;
      _tongueProgress = 0.0;
      _tongueTarget = fly.position;
      _targetEatingFly = fly;
      _lookTarget = fly.position;
    });
  }

  void _onFlyEaten(Color flyColor, String colorName) {
    AudioSynth.playAnimalSound('🦎'); // Bukalemun yutkunma sesi
    setState(() {
      _flyHuntEatenColors.add(colorName);

      if (_flyHuntEatenColors.length == 1) {
        _chameleonColor = flyColor;
        _chameleonColorName = colorName;
        _setKamoExpression('happy');
      } else {
        // İki sinek yendi, midede renkleri karıştır
        final r1 = _flyHuntEatenColors[0];
        final r2 = _flyHuntEatenColors[1];
        final key1 = '$r1+$r2';
        final key2 = '$r2+$r1';

        if (mixRules.containsKey(key1)) {
          _chameleonColorName = mixRules[key1]!;
          _chameleonColor = mixedColors[_chameleonColorName]!;
        } else if (mixRules.containsKey(key2)) {
          _chameleonColorName = mixRules[key2]!;
          _chameleonColor = mixedColors[_chameleonColorName]!;
        } else {
          _chameleonColorName = 'Gökkuşağı ✨';
          _chameleonColor = mixedColors['Gökkuşağı ✨']!;
        }

        // Seviye bitti mi kontrolü
        if (_chameleonColorName == _flyHuntTargetName) {
          _stars += 3;
          _triggerCelebration();
          _setKamoExpression('happy', delay: const Duration(seconds: 3));
          _showCelebration = true;
          ProgressService.instance.completeLevel(
            ProgressChapters.magicColors,
            2,
            stars: 3,
          );
          _celebrationTimer?.cancel();
          _celebrationTimer = Timer(const Duration(milliseconds: 2500), () {
            if (mounted) {
              setState(() {
                _showCelebration = false;
              });
            }
          });
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => SuccessModal(
                  emoji: '😋',
                  title: 'Harika Avcı!',
                  message: 'Renkleri Kamo\'nun midesinde karıştırdın! +3 ⭐',
                  onContinue: () {
                    Navigator.pop(context);
                    setState(() {
                      _flyHuntLevel++;
                      _setupFlyHuntLevel();
                    });
                  },
                ),
          );
        } else {
          // Yanlış karışım, baştan dene
          _setKamoExpression('surprised');
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => SuccessModal(
                  emoji: '🧐',
                  title: 'Tadı Biraz Farklı!',
                  message:
                      'Karışım $_chameleonColorName oldu. Hadi hedefimiz olan $_flyHuntTargetName için tekrar deneyelim!',
                  onContinue: () {
                    Navigator.pop(context);
                    setState(() {
                      _setupFlyHuntLevel();
                    });
                  },
                ),
          );
        }
      }
    });
  }

  // Resim Defteri Oyunu
  void _startColoringMode() {
    _clearBeaker();
    _coloringLevel = 1;
    _setupColoringLevel();
    setState(() {
      _currentMode = 'coloring';
    });
  }

  void _setupColoringLevel() {
    _coloringCompleted = false;
    _coloringParts.clear();
    _chameleonColor = const Color(0xFF4CAF50);
    _chameleonColorName = 'Yeşil';

    if (_coloringLevel == 1) {
      // Havuç Çizimi
      _coloringParts.add(
        ColoringPart(
          path:
              Path()
                ..moveTo(180, 80)
                ..quadraticBezierTo(210, 160, 240, 240)
                ..quadraticBezierTo(190, 210, 140, 160)
                ..close(),
          targetColorName: 'Turuncu',
          label: 'Havuç Gövdesi',
        ),
      );
      _coloringParts.add(
        ColoringPart(
          path:
              Path()
                ..moveTo(140, 160)
                ..quadraticBezierTo(100, 150, 80, 120)
                ..quadraticBezierTo(110, 120, 140, 160)
                ..close(),
          targetColorName: 'Yeşil',
          label: 'Havuç Yaprağı 1',
        ),
      );
      _coloringParts.add(
        ColoringPart(
          path:
              Path()
                ..moveTo(140, 160)
                ..quadraticBezierTo(130, 100, 110, 80)
                ..quadraticBezierTo(150, 110, 140, 160)
                ..close(),
          targetColorName: 'Yeşil',
          label: 'Havuç Yaprağı 2',
        ),
      );
    } else {
      // Üzüm Çizimi
      _coloringParts.add(
        ColoringPart(
          path: Path()..addOval(const Rect.fromLTWH(100, 120, 48, 48)),
          targetColorName: 'Mor',
          label: 'Üzüm 1',
        ),
      );
      _coloringParts.add(
        ColoringPart(
          path: Path()..addOval(const Rect.fromLTWH(140, 120, 48, 48)),
          targetColorName: 'Mor',
          label: 'Üzüm 2',
        ),
      );
      _coloringParts.add(
        ColoringPart(
          path: Path()..addOval(const Rect.fromLTWH(120, 155, 48, 48)),
          targetColorName: 'Mor',
          label: 'Üzüm 3',
        ),
      );
      _coloringParts.add(
        ColoringPart(
          path:
              Path()
                ..moveTo(140, 120)
                ..lineTo(140, 80)
                ..quadraticBezierTo(110, 80, 90, 100)
                ..lineTo(140, 120)
                ..close(),
          targetColorName: 'Yeşil',
          label: 'Asma Yaprağı',
        ),
      );
    }
  }

  void _onColoringPartTapped(ColoringPart part) {
    if (_coloringCompleted) return;

    if (_chameleonColorName == part.targetColorName) {
      AppHaptics.mediumImpact();
      AudioSynth.playSparkleSound();
      setState(() {
        part.currentColor = _chameleonColor;
        part.isCorrect = true;

        // Tüm parçalar doğru boyandı mı?
        if (_coloringParts.every((p) => p.isCorrect)) {
          _coloringCompleted = true;
          _stars += 5;
          _triggerCelebration();

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => SuccessModal(
                  emoji: '🎨',
                  title: 'Mükemmel Boyama!',
                  message: 'Resim defterinin bu sayfasını tamamladın! +5 ⭐',
                  onContinue: () {
                    Navigator.pop(context);
                    setState(() {
                      _coloringLevel++;
                      _setupColoringLevel();
                    });
                  },
                ),
          );
        }
      });
    } else {
      // Yanlış renkle boyama denemesi
      AppHaptics.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Burası için ${part.targetColorName} rengini karıştırmalısın! 💡',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: const Color(0xFF2FA7A0),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _triggerCelebration() {
    final random = Random();
    for (int i = 0; i < 40; i++) {
      _confetti.add(
        ConfettiParticle(
          x: random.nextDouble() * 800,
          y: -20 - random.nextDouble() * 50,
          vx: (random.nextDouble() - 0.5) * 150,
          vy: 150 + random.nextDouble() * 200,
          color:
              HSLColor.fromAHSL(
                1.0,
                random.nextDouble() * 360,
                0.8,
                0.6,
              ).toColor(),
          radius: 4.0 + random.nextDouble() * 6.0,
          rotationSpeed: 1.0 + random.nextDouble() * 4.0,
        ),
      );
    }
  }

  // ===========================================
  // ARAYÜZ BİLEŞENLERİ (WIDGET BUILDERS)
  // ===========================================
  @override
  Widget build(BuildContext context) {
    if (_currentMode == 'menu') {
      return _buildMainMenu();
    }

    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: InactivityDetector(
        onInactivity: _onInactivity,
        onActivity: _onActivity,
        child: Stack(
          children: [
          // Arka Plan Dekorasyonu (Moda özel)
          Positioned.fill(child: _buildBackground()),

          // Sol Taraf: Bukalemun Kamo & Canlılar
          Positioned(
            left: 0,
            top: 0,
            width: width * 0.45,
            height: height,
            child: _buildChameleonStage(),
          ),

          // Sağ Taraf: Renk Karıştırma Arayüzü / Boyama Paneli
          Positioned(
            right: 0,
            top: 0,
            width: width * 0.55,
            height: height,
            child: _buildInteractivePanel(),
          ),

          // Sol Üst: Geri Dönüş ve Yıldız Skoru
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    key: const ValueKey('magic-colors-back-button'),
                    onTap: () {
                      AppHaptics.mediumImpact();
                      if (_currentMode != 'menu') {
                        setState(() {
                          _currentMode = 'menu';
                          _isEating = false;
                          _isRetracting = false;
                          _tongueProgress = 0.0;
                          _tongueTarget = null;
                          _targetEatingFly = null;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF9500,
                            ).withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFFF9500).withValues(alpha: 0.4),
                          width: 3.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                          color: Color(0xFFFF9500),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFCC00),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('⭐ ', style: TextStyle(fontSize: 20)),
                        Text(
                          '$_stars',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF9500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Kuş Geçişi Animasyonu (Kamufle Ol Modu)
          if (_showBird)
            Positioned(
              left: width * _birdProgress - 120,
              top: height * 0.15 + sin(_birdProgress * pi * 3) * 30,
              child: IgnorePointer(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        _birdText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Text('🦅', style: TextStyle(fontSize: 64)),
                  ],
                ),
              ),
            ),

          // Kutlama Konfetileri
          ..._confetti.map(
            (p) => Positioned(
              left: p.x,
              top: p.y,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: p.rotation,
                  child: Container(
                    width: p.radius * 2,
                    height: p.radius * 1.2,
                    color: p.color.withValues(alpha: p.alpha),
                  ),
                ),
              ),
            ),
          ),
          // Görsel Dokunma İpuçları (Faz 4)
          if (_showGhostHand && _ghostHandPosition != null) ...[
            Positioned(
              left: _ghostHandPosition!.dx - 28,
              top: _ghostHandPosition!.dy - 28,
              child: IgnorePointer(
                child: PulseTarget(
                  active: true,
                  baseSize: 56,
                  child: const SizedBox(width: 56, height: 56),
                ),
              ),
            ),
            GhostHandHint(
              position: _ghostHandPosition!,
              active: true,
            ),
          ],
          if (_showCelebration)
            const Positioned.fill(
              child: CelebrationEffect(active: true),
            ),
        ],
      ),
    ),
  );
}

  Widget _buildBackground() {
    if (_currentMode == 'camouflage') {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _camouTargetColor.withValues(alpha: 0.08),
              const Color(0xFFFFFBF2),
            ],
          ),
        ),
      );
    }
    return Container(color: const Color(0xFFFFFBF2));
  }

  Widget _buildMainMenu() {
    final compact = _isCompact;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: Stack(
        children: [
          // Geri Dön Butonu
          Positioned(
            top: compact ? 10 : 20,
            left: compact ? 10 : 20,
            child: SafeArea(
              child: IconButton.filledTonal(
                key: const ValueKey('magic-colors-back-button'),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_rounded, size: compact ? 22 : 28),
                style: IconButton.styleFrom(padding: EdgeInsets.all(compact ? 8 : 12)),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: compact ? 12 : 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🧪 Sihirli Renk Laboratuvarı',
                    style: TextStyle(
                      fontSize: compact ? 22 : 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF233238),
                    ),
                  ),
                  SizedBox(height: compact ? 4 : 12),
                  Text(
                    'Bukalemun Kamo ile renklerin büyüleyici dünyasını keşfet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: compact ? 12 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF53666C),
                    ),
                  ),
                  SizedBox(height: compact ? 12 : 32),
                  // Mod Seçenekleri (Yan yana veya kısıtlı alanda scroll ile)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: compact ? 12 : 20,
                    runSpacing: compact ? 12 : 20,
                    children: [
                      _buildMenuCard(
                        key: 'sandbox',
                        emoji: '🎨',
                        title: 'Serbest Laboratuvar',
                        color: const Color(0xFFFF9500),
                        onTap: _startSandboxMode,
                      ),
                      _buildMenuCard(
                        key: 'camouflage',
                        emoji: '🍃',
                        title: 'Kamufle Ol!',
                        color: const Color(0xFF4CAF50),
                        onTap: _startCamouflageMode,
                      ),
                      _buildMenuCard(
                        key: 'flyhunt',
                        emoji: '🦟',
                        title: 'Sinek Avı',
                        color: const Color(0xFF007AFF),
                        onTap: _startFlyHuntMode,
                      ),
                      _buildMenuCard(
                        key: 'coloring',
                        emoji: '🖍️',
                        title: 'Resim Defteri',
                        color: const Color(0xFFFF2D55),
                        onTap: _startColoringMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String key,
    required String emoji,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final compact = _isCompact;
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: 0.3), width: compact ? 2 : 3),
        borderRadius: BorderRadius.circular(compact ? 16 : 24),
      ),
      child: InkWell(
        key: ValueKey('magic-colors-mode-$key'),
        onTap: () {
          AppHaptics.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(compact ? 14 : 21),
        child: Container(
          width: compact ? 150 : 200,
          height: compact ? 100 : 160,
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: compact ? 6 : 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: compact ? 32 : 48)),
              SizedBox(height: compact ? 4 : 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: compact ? 12 : 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF233238),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChameleonStage() {
    // Bukalemun Kamo'nun çizildiği sol sahne
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        // Kamufle Ol Modunda Arkadaki Gizlenme Ögesi
        if (_currentMode == 'camouflage')
          Center(
            child: Opacity(
              opacity: _isCamouflaged ? 0.9 : 0.4,
              child: Container(
                width: 180,
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _camouTargetColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: _camouTargetColor, width: 4),
                ),
                child: Text(
                  _camouBgEmoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
          ),

        // Bukalemun Kamo'nun CustomPaint ile Çizimi
        Positioned.fill(
          child: Listener(
            onPointerDown: (event) {
              if (_currentMode == 'flyhunt') {
                // Sineklerin üzerine tıklamayı kontrol et
                for (var fly in _flies) {
                  final double dx = event.localPosition.dx - fly.position.dx;
                  final double dy = event.localPosition.dy - fly.position.dy;
                  if (sqrt(dx * dx + dy * dy) < 40) {
                    _onFlyTapped(fly);
                    break;
                  }
                }
              }
            },
            child: CustomPaint(
              painter: ChameleonPainter(
                chameleonColor: _chameleonColor,
                tongueProgress: _tongueProgress,
                tongueTarget: _tongueTarget,
                lookTarget: _lookTarget,
                flies: _flies,
                idleProgress: _time,
                isCamouflaged: _isCamouflaged,
                chameleonPos: Offset(width * 0.22, height * 0.5),
                expression: _kamoExpression,
              ),
              size: Size.infinite,
            ),
          ),
        ),

        // Kamo'nun Rengi Bilgilendirmesi (Kafasının üstünde)
        Positioned(
          left: width * 0.1,
          top: height * 0.22,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _chameleonColor.withValues(alpha: 0.8),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              _chameleonColorName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color:
                    _chameleonColorName == 'Beyaz'
                        ? Colors.grey[700]
                        : _chameleonColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractivePanel() {
    final compact = _isCompact;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 16,
        vertical: compact ? 4 : 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(color: Color(0x0C000000), blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: compact ? 3 : 6),
          // Yönerge Kutusu
          _buildInstructionBox(),
          SizedBox(height: compact ? 4 : 8),

          // Seçili Moda Göre İlgili Arayüz (Taşmayı önlemek için SingleChildScrollView)
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: _currentMode == 'coloring'
                  ? _buildColoringCanvas()
                  : _buildLabFlaskMixing(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBox() {
    final compact = _isCompact;
    String title = '';
    String sub = '';
    Color boxColor = const Color(0xFFFF9500);

    if (_currentMode == 'sandbox') {
      title = '🎨 Serbest Renk Karıştırma';
      sub = 'Renk tüplerini dene, Kamo\'nun nasıl renk değiştirdiğini gör!';
      boxColor = const Color(0xFFFF9500);
    } else if (_currentMode == 'camouflage') {
      title = '🍃 Kamufle Ol! (Seviye $_camouLevel)';
      sub =
          'Kamo\'yu $_camouBgEmoji üzerine gizlemek için $_camouTargetName yap!';
      boxColor = const Color(0xFF4CAF50);
    } else if (_currentMode == 'flyhunt') {
      title = '🦟 Sinek Avı (Seviye $_flyHuntLevel)';
      sub = 'Kamo\'yu $_flyHuntTargetName yapmak için doğru sinekleri ye!';
      boxColor = const Color(0xFF007AFF);
    } else if (_currentMode == 'coloring') {
      title = '🖍️ Kamo\'nun Defteri (Seviye $_coloringLevel)';
      sub = 'Laboratuvarda renk karıştır, şablon parçalarına dokunarak boya!';
      boxColor = const Color(0xFFFF2D55);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: boxColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 12 : 16),
        border: Border.all(color: boxColor.withValues(alpha: 0.4), width: compact ? 1.5 : 2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: compact ? 12 : 15,
              fontWeight: FontWeight.w900,
              color: boxColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(
              fontSize: compact ? 9 : 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF53666C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabFlaskMixing() {
    final compact = _isCompact;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Yıldız Zamanlayıcı Barı (Sadece Kamufle Ol Modunda)
        if (_currentMode == 'camouflage') ...[
          Row(
            children: [
              const Text('⏰ ', style: TextStyle(fontSize: 14)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _starTimer,
                    minHeight: compact ? 6 : 8,
                    backgroundColor: const Color(0xFFE6ECE8),
                    color:
                        _starTimer > 0.6
                            ? const Color(0xFF4CAF50)
                            : (_starTimer > 0.3
                                ? const Color(0xFFFFCC00)
                                : const Color(0xFFFF3B30)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 4 : 8),
        ],

        // Laboratuvar Kabı ve Karışan Renkler (Scroll içinde Expanded olmaması için Padding & Row)
        Padding(
          padding: EdgeInsets.symmetric(vertical: compact ? 6.0 : 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Laboratuvar Kabı Görseli (Beaker)
              Container(
                width: compact ? 65 : 90,
                height: compact ? 70 : 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  border: Border.all(color: const Color(0xFF2FA7A0), width: compact ? 3 : 4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2FA7A0).withValues(alpha: 0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // İçindeki sıvı karışımı
                    if (_beakerSlots.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                        child: Container(
                          height: (compact ? 20.0 : 30.0) * _beakerSlots.length,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                _beakerSlots.length == 1
                                    ? _beakerSlots[0]['color'].withValues(
                                      alpha: 0.85,
                                    )
                                    : Color.lerp(
                                      _beakerSlots[0]['color'],
                                      _beakerSlots[1]['color'],
                                      0.5,
                                    )!.withValues(alpha: 0.85),
                          ),
                        ),
                      ),

                    // Köpürme baloncukları
                    if (_beakerSlots.isNotEmpty)
                      Positioned(
                        top: compact ? 20 : 35,
                        child: Text('🫧', style: TextStyle(fontSize: compact ? 12 : 16)),
                      ),

                    Positioned(
                      top: compact ? 4 : 8,
                      child: Text(
                        'LAB',
                        style: TextStyle(
                          color: const Color(0xFF2FA7A0),
                          fontWeight: FontWeight.w900,
                          fontSize: compact ? 9 : 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: compact ? 8 : 16),

              // Slot Yuvaları ve Kontroller
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Karışım Slotları:',
                    style: TextStyle(
                      fontSize: compact ? 10 : 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF53666C),
                    ),
                  ),
                  SizedBox(height: compact ? 2 : 4),
                  Row(
                    children: [
                      _buildSlotTile(0),
                      SizedBox(width: compact ? 4 : 8),
                      Text(
                        '+',
                        style: TextStyle(
                          fontSize: compact ? 12 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: compact ? 4 : 8),
                      _buildSlotTile(1),
                    ],
                  ),
                  SizedBox(height: compact ? 4 : 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        key: const ValueKey('magic-colors-clear-button'),
                        onPressed: _beakerSlots.isEmpty ? null : _clearBeaker,
                        icon: Icon(Icons.delete_outline, size: compact ? 11 : 14),
                        label: Text(
                          'Temizle',
                          style: TextStyle(fontSize: compact ? 9 : 11),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF2D55),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[200],
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 6 : 10,
                            vertical: compact ? 4 : 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      SizedBox(width: compact ? 4 : 8),
                      ElevatedButton.icon(
                        key: const ValueKey('magic-colors-mix-button'),
                        onPressed: _beakerSlots.isEmpty ? null : _mixBeaker,
                        icon: Icon(Icons.science, size: compact ? 11 : 14),
                        label: Text(
                          'Karıştır!',
                          style: TextStyle(fontSize: compact ? 9 : 11),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[200],
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 6 : 10,
                            vertical: compact ? 4 : 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: compact ? 4 : 8),
        // Alt Palet (Renk Tüpleri)
        _buildPaletteRow(),
      ],
    );
  }

  Widget _buildSlotTile(int index) {
    final bool filled = _beakerSlots.length > index;
    final compact = _isCompact;
    return Container(
      width: compact ? 32 : 42,
      height: compact ? 32 : 42,
      decoration: BoxDecoration(
        color: filled ? _beakerSlots[index]['color'] : Colors.grey[100],
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color:
              filled
                  ? Colors.white
                  : const Color(0xFF2FA7A0).withValues(alpha: 0.3),
          width: compact ? 1.8 : 2.5,
        ),
        boxShadow: [
          if (filled)
            BoxShadow(
              color: _beakerSlots[index]['color'].withValues(alpha: 0.4),
              blurRadius: 4,
              offset: const Offset(0, 1.5),
            ),
        ],
      ),
      child: Center(
        child: Text(
          filled ? '' : '?',
          style: TextStyle(
            fontSize: compact ? 12 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildPaletteRow() {
    final compact = _isCompact;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: compact ? 4 : 6,
        horizontal: compact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(compact ? 12 : 16),
        border: Border.all(
          color: const Color(0xFFFFCC00).withValues(alpha: 0.3),
          width: compact ? 1.5 : 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            baseColors.entries.map((e) {
              return GestureDetector(
                key: ValueKey('magic-colors-tube-${e.key}'),
                onTap: () => _addPaintToBeaker(e.key, e.value),
                child: Column(
                  children: [
                    Container(
                      width: compact ? 30 : 40,
                      height: compact ? 30 : 40,
                      decoration: BoxDecoration(
                        color: e.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              e.key == 'Beyaz'
                                  ? Colors.grey[300]!
                                  : Colors.white,
                          width: compact ? 1.8 : 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: compact ? 8 : 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF233238),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildColoringCanvas() {
    final compact = _isCompact;
    // Resim Defteri Modunun Çizim Alanı
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: compact ? 150 : 240,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              width: 320,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFF2D55).withValues(alpha: 0.3),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                children:
                    _coloringParts.map((part) {
                      return GestureDetector(
                        onTap: () => _onColoringPartTapped(part),
                        child: CustomPaint(
                          painter: PartPainter(part: part),
                          size: const Size(320, 240),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),

        SizedBox(height: compact ? 4 : 8),
        // Alt tarafa laboratuvar karıştırma paletini küçük şekilde gömüyoruz
        Container(
          padding: EdgeInsets.all(compact ? 4 : 6),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _clearBeaker,
                icon: Icon(Icons.delete_outline, size: compact ? 10 : 12),
                label: Text('Sil', style: TextStyle(fontSize: compact ? 9 : 10)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2D55),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 6 : 8,
                    vertical: compact ? 3 : 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              ...baseColors.entries.map((e) {
                return InkWell(
                  onTap: () => _addPaintToBeaker(e.key, e.value),
                  child: Container(
                    width: compact ? 22 : 28,
                    height: compact ? 22 : 28,
                    decoration: BoxDecoration(
                      color: e.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: compact ? 1.5 : 2),
                    ),
                  ),
                );
              }),
              IconButton.filledTonal(
                onPressed: _mixBeaker,
                icon: Icon(Icons.science, size: compact ? 12 : 14),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(compact ? 4 : 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Resim Defteri Parça Modeli
class ColoringPart {
  final Path path;
  final String targetColorName;
  final String label;
  Color currentColor = Colors.white;
  bool isCorrect = false;

  ColoringPart({
    required this.path,
    required this.targetColorName,
    required this.label,
  });
}

class PartPainter extends CustomPainter {
  final ColoringPart part;

  PartPainter({required this.part});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = part.currentColor
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = const Color(0xFF233238)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

    canvas.drawPath(part.path, paint);
    canvas.drawPath(part.path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant PartPainter oldDelegate) {
    return oldDelegate.part.currentColor != part.currentColor ||
        oldDelegate.part.isCorrect != part.isCorrect;
  }

  @override
  bool? hitTest(Offset position) {
    // Tıklamanın path içine gelip gelmediğini kontrol eder
    return part.path.contains(position);
  }
}

// Başarı Modalı
class SuccessModal extends StatelessWidget {
  final String emoji;
  final String title;
  final String message;
  final VoidCallback onContinue;

  const SuccessModal({
    required this.emoji,
    required this.title,
    required this.message,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF2),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFFFCC00), width: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF233238),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF53666C),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9500),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Devam Et ➡️',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Konfeti Parçacık Modeli
class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  final Color color;
  double radius;
  double alpha = 1.0;
  double rotation = 0.0;
  final double rotationSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.radius,
    required this.rotationSpeed,
  });

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    vy += 100 * dt; // Yerçekimi
    alpha -= 0.5 * dt;
    rotation += rotationSpeed * dt;
  }
}
