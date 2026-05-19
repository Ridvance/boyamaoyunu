import 'package:flutter/material.dart';

void main() {
  runApp(const CocukOyunApp());
}

class CocukOyunApp extends StatelessWidget {
  const CocukOyunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cocuk Oyun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2FA7A0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF2),
        useMaterial3: true,
      ),
      home: const ColoringHome(),
    );
  }
}

class ColoringHome extends StatefulWidget {
  const ColoringHome({super.key});

  @override
  State<ColoringHome> createState() => _ColoringHomeState();
}

class _ColoringHomeState extends State<ColoringHome> {
  final Map<String, List<DrawingStroke>> _strokesByPage = {
    for (final page in coloringPages) page.id: <DrawingStroke>[],
  };

  ColoringPage? _selectedPage;
  Color _selectedColor = paletteColors.first;
  bool _isErasing = false;
  bool _showParentArea = false;

  void _openPage(ColoringPage page) {
    setState(() {
      _selectedPage = page;
      _showParentArea = false;
      _isErasing = false;
    });
  }

  void _goHome() {
    setState(() {
      _selectedPage = null;
      _showParentArea = false;
      _isErasing = false;
    });
  }

  void _openParentArea() {
    setState(() {
      _selectedPage = null;
      _showParentArea = true;
      _isErasing = false;
    });
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
      _isErasing = false;
    });
  }

  void _selectEraser() {
    setState(() {
      _isErasing = true;
    });
  }

  void _clearPage() {
    final page = _selectedPage;
    if (page == null) {
      return;
    }
    setState(() {
      _strokesByPage[page.id] = <DrawingStroke>[];
    });
  }

  void _startStroke(Offset point) {
    final page = _selectedPage;
    if (page == null) {
      return;
    }
    setState(() {
      final strokes = _strokesByPage[page.id]!;
      _strokesByPage[page.id] = [
        ...strokes,
        DrawingStroke(
          color: _selectedColor,
          width: _isErasing ? 28 : 16,
          isEraser: _isErasing,
          points: [point],
        ),
      ];
    });
  }

  void _appendStrokePoint(Offset point) {
    final page = _selectedPage;
    if (page == null) {
      return;
    }
    setState(() {
      final strokes = _strokesByPage[page.id]!;
      if (strokes.isEmpty) {
        return;
      }
      final activeStroke = strokes.last;
      final updatedStroke = activeStroke.copyWith(
        points: [...activeStroke.points, point],
      );
      _strokesByPage[page.id] = [
        ...strokes.take(strokes.length - 1),
        updatedStroke,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final page = _selectedPage;
    if (_showParentArea) {
      return ParentSafetyScreen(onBack: _goHome);
    }
    if (page != null) {
      return ColoringScreen(
        page: page,
        strokes: _strokesByPage[page.id]!,
        selectedColor: _selectedColor,
        isErasing: _isErasing,
        onBack: _goHome,
        onClear: _clearPage,
        onColorSelected: _selectColor,
        onEraserSelected: _selectEraser,
        onStrokeStart: _startStroke,
        onStrokeUpdate: _appendStrokePoint,
      );
    }
    return HomeScreen(
      onPageSelected: _openPage,
      onParentUnlocked: _openParentArea,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onPageSelected,
    required this.onParentUnlocked,
    super.key,
  });

  final ValueChanged<ColoringPage> onPageSelected;
  final VoidCallback onParentUnlocked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Cocuk Oyun',
                      style: TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    key: const ValueKey('parent-gate-button'),
                    tooltip: 'Ebeveyn',
                    onPressed:
                        () => showDialog<void>(
                          context: context,
                          builder:
                              (context) => ParentGateDialog(
                                onUnlocked: () {
                                  Navigator.of(context).pop();
                                  onParentUnlocked();
                                },
                              ),
                        ),
                    icon: const Icon(Icons.shield_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Boyama',
                style: TextStyle(
                  color: Color(0xFF53666C),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 560;
                    return GridView.count(
                      crossAxisCount: isWide ? 3 : 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: isWide ? 0.9 : 0.82,
                      children: [
                        for (final page in coloringPages)
                          ColoringPageTile(
                            key: ValueKey('page-${page.id}'),
                            page: page,
                            onTap: () => onPageSelected(page),
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
}

class ParentGateDialog extends StatelessWidget {
  const ParentGateDialog({required this.onUnlocked, super.key});

  final VoidCallback onUnlocked;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ebeveyn alani'),
      content: const Text('Acik tut'),
      actions: [
        GestureDetector(
          key: const ValueKey('parent-unlock-button'),
          onLongPress: onUnlocked,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF2FA7A0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SizedBox(
              width: 132,
              height: 56,
              child: Center(
                child: Icon(
                  Icons.lock_open_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    key: const ValueKey('parent-back-button'),
                    tooltip: 'Geri',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ebeveyn',
                      style: TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SafetyStatusList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SafetyStatusList extends StatelessWidget {
  const SafetyStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SafetyStatusItem(label: 'Reklam yok', icon: Icons.block_rounded),
        SafetyStatusItem(label: 'Odeme yok', icon: Icons.payments_rounded),
        SafetyStatusItem(label: 'Dis link yok', icon: Icons.link_off_rounded),
        SafetyStatusItem(
          label: 'Kamera galeri yok',
          icon: Icons.no_photography_rounded,
        ),
      ],
    );
  }
}

class SafetyStatusItem extends StatelessWidget {
  const SafetyStatusItem({required this.label, required this.icon, super.key});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE6ECE8), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF2FA7A0), size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF233238),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF6BCB77),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColoringPageTile extends StatelessWidget {
  const ColoringPageTile({required this.page, required this.onTap, super.key});

  final ColoringPage page;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE6ECE8), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: page.accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    page.icon,
                    size: 52,
                    color: const Color(0xFF233238),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF233238),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColoringScreen extends StatelessWidget {
  const ColoringScreen({
    required this.page,
    required this.strokes,
    required this.selectedColor,
    required this.isErasing,
    required this.onBack,
    required this.onClear,
    required this.onColorSelected,
    required this.onEraserSelected,
    required this.onStrokeStart,
    required this.onStrokeUpdate,
    super.key,
  });

  final ColoringPage page;
  final List<DrawingStroke> strokes;
  final Color selectedColor;
  final bool isErasing;
  final VoidCallback onBack;
  final VoidCallback onClear;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onEraserSelected;
  final ValueChanged<Offset> onStrokeStart;
  final ValueChanged<Offset> onStrokeUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    key: const ValueKey('back-button'),
                    tooltip: 'Geri',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      page.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    key: const ValueKey('clear-button'),
                    tooltip: 'Temizle',
                    onPressed: onClear,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFDCE7E2),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GestureDetector(
                          key: const ValueKey('drawing-canvas'),
                          behavior: HitTestBehavior.opaque,
                          onPanStart:
                              (details) => onStrokeStart(details.localPosition),
                          onPanUpdate:
                              (details) =>
                                  onStrokeUpdate(details.localPosition),
                          child: CustomPaint(
                            painter: ColoringPainter(
                              page: page,
                              strokes: strokes,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ToolPalette(
                selectedColor: selectedColor,
                isErasing: isErasing,
                onColorSelected: onColorSelected,
                onEraserSelected: onEraserSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolPalette extends StatelessWidget {
  const ToolPalette({
    required this.selectedColor,
    required this.isErasing,
    required this.onColorSelected,
    required this.onEraserSelected,
    super.key,
  });

  final Color selectedColor;
  final bool isErasing;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onEraserSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final color in paletteColors)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ColorButton(
                color: color,
                selected: !isErasing && selectedColor == color,
                onTap: () => onColorSelected(color),
              ),
            ),
          ToolButton(
            key: const ValueKey('eraser-button'),
            selected: isErasing,
            onTap: onEraserSelected,
            icon: Icons.cleaning_services_rounded,
          ),
        ],
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    required this.color,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Renk',
      child: InkWell(
        key: ValueKey('color-${color.toARGB32()}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: selected ? const Color(0xFF233238) : Colors.white,
              width: selected ? 4 : 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class ToolButton extends StatelessWidget {
  const ToolButton({
    required this.selected,
    required this.onTap,
    required this.icon,
    super.key,
  });

  final bool selected;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6F4),
          border: Border.all(
            color: selected ? const Color(0xFF233238) : const Color(0xFFDCE7E2),
            width: selected ? 4 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF233238), size: 30),
      ),
    );
  }
}

class ColoringPainter extends CustomPainter {
  const ColoringPainter({required this.page, required this.strokes});

  final ColoringPage page;
  final List<DrawingStroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    _paintTemplate(canvas, size);

    final layerBounds = Offset.zero & size;
    canvas.saveLayer(layerBounds, Paint());
    for (final stroke in strokes) {
      _paintStroke(canvas, stroke);
    }
    canvas.restore();
  }

  void _paintStroke(Canvas canvas, DrawingStroke stroke) {
    final paint =
        Paint()
          ..color = stroke.color
          ..strokeWidth = stroke.width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.srcOver;

    if (stroke.points.length == 1) {
      canvas.drawCircle(stroke.points.first, stroke.width / 2, paint);
      return;
    }

    final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (final point in stroke.points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _paintTemplate(Canvas canvas, Size size) {
    final line =
        Paint()
          ..color = const Color(0xFF233238)
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

    final thinLine =
        Paint()
          ..color = const Color(0xFF233238)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

    switch (page.template) {
      case LineArtTemplate.cat:
        _paintCat(canvas, size, line, thinLine);
      case LineArtTemplate.shapes:
        _paintShapes(canvas, size, line);
      case LineArtTemplate.toy:
        _paintToy(canvas, size, line, thinLine);
    }
  }

  void _paintCat(Canvas canvas, Size size, Paint line, Paint thinLine) {
    final w = size.width;
    final h = size.height;
    final head = Rect.fromCircle(
      center: Offset(w * 0.5, h * 0.42),
      radius: w * 0.22,
    );
    canvas.drawOval(head, line);

    final leftEar =
        Path()
          ..moveTo(w * 0.34, h * 0.27)
          ..lineTo(w * 0.39, h * 0.12)
          ..lineTo(w * 0.47, h * 0.25);
    final rightEar =
        Path()
          ..moveTo(w * 0.53, h * 0.25)
          ..lineTo(w * 0.61, h * 0.12)
          ..lineTo(w * 0.66, h * 0.27);
    canvas.drawPath(leftEar, line);
    canvas.drawPath(rightEar, line);
    canvas.drawCircle(Offset(w * 0.42, h * 0.39), 5, thinLine);
    canvas.drawCircle(Offset(w * 0.58, h * 0.39), 5, thinLine);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.48), width: 46, height: 32),
      0.2,
      2.7,
      false,
      thinLine,
    );
    canvas.drawLine(
      Offset(w * 0.34, h * 0.46),
      Offset(w * 0.18, h * 0.42),
      thinLine,
    );
    canvas.drawLine(
      Offset(w * 0.34, h * 0.51),
      Offset(w * 0.18, h * 0.52),
      thinLine,
    );
    canvas.drawLine(
      Offset(w * 0.66, h * 0.46),
      Offset(w * 0.82, h * 0.42),
      thinLine,
    );
    canvas.drawLine(
      Offset(w * 0.66, h * 0.51),
      Offset(w * 0.82, h * 0.52),
      thinLine,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.73),
        width: w * 0.34,
        height: h * 0.28,
      ),
      line,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.67, h * 0.71),
        width: w * 0.25,
        height: h * 0.28,
      ),
      -1.2,
      2.5,
      false,
      line,
    );
  }

  void _paintShapes(Canvas canvas, Size size, Paint line) {
    final w = size.width;
    final h = size.height;
    canvas.drawCircle(Offset(w * 0.34, h * 0.34), w * 0.15, line);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.67, h * 0.34),
          width: w * 0.28,
          height: w * 0.28,
        ),
        const Radius.circular(18),
      ),
      line,
    );
    final triangle =
        Path()
          ..moveTo(w * 0.5, h * 0.55)
          ..lineTo(w * 0.25, h * 0.85)
          ..lineTo(w * 0.75, h * 0.85)
          ..close();
    canvas.drawPath(triangle, line);
  }

  void _paintToy(Canvas canvas, Size size, Paint line, Paint thinLine) {
    final w = size.width;
    final h = size.height;
    final bearHead = Rect.fromCircle(
      center: Offset(w * 0.5, h * 0.36),
      radius: w * 0.2,
    );
    canvas.drawCircle(Offset(w * 0.34, h * 0.2), w * 0.08, line);
    canvas.drawCircle(Offset(w * 0.66, h * 0.2), w * 0.08, line);
    canvas.drawOval(bearHead, line);
    canvas.drawCircle(Offset(w * 0.43, h * 0.34), 5, thinLine);
    canvas.drawCircle(Offset(w * 0.57, h * 0.34), 5, thinLine);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.43), width: 40, height: 28),
      0.2,
      2.7,
      false,
      thinLine,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.72),
          width: w * 0.38,
          height: h * 0.28,
        ),
        const Radius.circular(34),
      ),
      line,
    );
    canvas.drawLine(
      Offset(w * 0.31, h * 0.68),
      Offset(w * 0.2, h * 0.78),
      thinLine,
    );
    canvas.drawLine(
      Offset(w * 0.69, h * 0.68),
      Offset(w * 0.8, h * 0.78),
      thinLine,
    );
  }

  @override
  bool shouldRepaint(covariant ColoringPainter oldDelegate) {
    return oldDelegate.page != page || oldDelegate.strokes != strokes;
  }
}

class DrawingStroke {
  DrawingStroke({
    required this.color,
    required this.width,
    required this.isEraser,
    required this.points,
  });

  final Color color;
  final double width;
  final bool isEraser;
  final List<Offset> points;

  DrawingStroke copyWith({List<Offset>? points}) {
    return DrawingStroke(
      color: color,
      width: width,
      isEraser: isEraser,
      points: points ?? this.points,
    );
  }
}

class ColoringPage {
  const ColoringPage({
    required this.id,
    required this.title,
    required this.icon,
    required this.accent,
    required this.template,
  });

  final String id;
  final String title;
  final IconData icon;
  final Color accent;
  final LineArtTemplate template;
}

enum LineArtTemplate { cat, shapes, toy }

const coloringPages = [
  ColoringPage(
    id: 'cat',
    title: 'Kedi',
    icon: Icons.brush_rounded,
    accent: Color(0xFFFFD166),
    template: LineArtTemplate.cat,
  ),
  ColoringPage(
    id: 'shapes',
    title: 'Sekiller',
    icon: Icons.category_rounded,
    accent: Color(0xFF6BCB77),
    template: LineArtTemplate.shapes,
  ),
  ColoringPage(
    id: 'toy',
    title: 'Oyuncak',
    icon: Icons.toys_rounded,
    accent: Color(0xFFFF8A65),
    template: LineArtTemplate.toy,
  ),
];

const paletteColors = [
  Color(0xFFE94F64),
  Color(0xFFFFC857),
  Color(0xFF2FA7A0),
  Color(0xFF5B8DEF),
  Color(0xFF8E68FF),
  Color(0xFF2F2F2F),
];
