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
      home: const AppShell(),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Cocuk Oyun',
                style: TextStyle(
                  color: Color(0xFF233238),
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Boyama',
                style: TextStyle(
                  color: Color(0xFF53666C),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 32),
              Expanded(child: ColoringPreviewGrid()),
            ],
          ),
        ),
      ),
    );
  }
}

class ColoringPreviewGrid extends StatelessWidget {
  const ColoringPreviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 560;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 3 : 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: isWide ? 0.9 : 0.82,
          children: const [
            PreviewTile(
              label: 'Sayfa 1',
              color: Color(0xFFFFD166),
              icon: Icons.brush_rounded,
            ),
            PreviewTile(
              label: 'Sayfa 2',
              color: Color(0xFF6BCB77),
              icon: Icons.palette_rounded,
            ),
            PreviewTile(
              label: 'Sayfa 3',
              color: Color(0xFFFF8A65),
              icon: Icons.auto_awesome_rounded,
            ),
          ],
        );
      },
    );
  }
}

class PreviewTile extends StatelessWidget {
  const PreviewTile({
    required this.label,
    required this.color,
    required this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6ECE8), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 48, color: const Color(0xFF233238)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
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
    );
  }
}
