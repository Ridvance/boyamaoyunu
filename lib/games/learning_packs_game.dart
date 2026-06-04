import 'package:flutter/material.dart';
import 'coloring_game.dart';
import 'habits_game.dart';
import 'magic_colors_game.dart';

class LearningPackActivity {
  final String id;
  final String title;
  final String skill;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;

  const LearningPackActivity({
    required this.id,
    required this.title,
    required this.skill,
    required this.icon,
    required this.color,
    required this.builder,
  });
}

class LearningPack {
  final String id;
  final String title;
  final String focus;
  final IconData icon;
  final Color color;
  final List<LearningPackActivity> activities;

  const LearningPack({
    required this.id,
    required this.title,
    required this.focus,
    required this.icon,
    required this.color,
    required this.activities,
  });
}

class LearningPacksGame extends StatefulWidget {
  const LearningPacksGame({super.key});

  @override
  State<LearningPacksGame> createState() => _LearningPacksGameState();
}

class _LearningPacksGameState extends State<LearningPacksGame> {
  static final List<LearningPack> _packs = [
    LearningPack(
      id: 'first-skills',
      title: 'İlk Beceriler',
      focus: 'Renkler, hikaye, günlük alışkanlık',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF8B5CF6),
      activities: [
        LearningPackActivity(
          id: 'story-coloring',
          title: 'Hikayeli Boyama',
          skill: 'Görsel takip',
          icon: Icons.brush_rounded,
          color: const Color(0xFFFF4B4B),
          builder: (_) => const ColoringGame(),
        ),
        LearningPackActivity(
          id: 'color-mix',
          title: 'Renk Karışımı',
          skill: 'Renk sonucu',
          icon: Icons.science_rounded,
          color: const Color(0xFFFF9500),
          builder: (_) => const MagicColorsGame(),
        ),
        LearningPackActivity(
          id: 'habits',
          title: 'İyi Alışkanlıklar',
          skill: 'Günlük görev',
          icon: Icons.volunteer_activism_rounded,
          color: const Color(0xFF2FA7A0),
          builder: (_) => const HabitsGame(),
        ),
      ],
    ),
  ];

  LearningPack? _selectedPack;

  void _openActivity(LearningPackActivity activity) {
    Navigator.push<void>(context, MaterialPageRoute(builder: activity.builder));
  }

  @override
  Widget build(BuildContext context) {
    final selectedPack = _selectedPack;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    key: const ValueKey('learning-packs-back-button'),
                    onPressed:
                        selectedPack == null
                            ? () => Navigator.pop(context)
                            : () => setState(() => _selectedPack = null),
                    icon: Icon(
                      selectedPack == null
                          ? Icons.arrow_back_rounded
                          : Icons.grid_view_rounded,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      selectedPack?.title ?? 'Öğrenme Paketleri',
                      style: const TextStyle(
                        color: Color(0xFF233238),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    selectedPack == null
                        ? _PackList(
                          packs: _packs,
                          onSelect:
                              (pack) => setState(() => _selectedPack = pack),
                        )
                        : _PackDetail(
                          pack: selectedPack,
                          onActivityTap: _openActivity,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackList extends StatelessWidget {
  final List<LearningPack> packs;
  final ValueChanged<LearningPack> onSelect;

  const _PackList({required this.packs, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: packs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final pack = packs[index];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            key: ValueKey('learning-pack-${pack.id}'),
            onTap: () => onSelect(pack),
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  const SizedBox(width: 22),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: pack.color.withValues(alpha: 0.16),
                    child: Icon(pack.icon, color: pack.color, size: 48),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pack.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF233238),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pack.focus,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF53666C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 42,
                    color: Color(0xFF53666C),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PackDetail extends StatelessWidget {
  final LearningPack pack;
  final ValueChanged<LearningPackActivity> onActivityTap;

  const _PackDetail({required this.pack, required this.onActivityTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children:
          pack.activities.map((activity) {
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                key: ValueKey('learning-activity-${activity.id}'),
                onTap: () => onActivityTap(activity),
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(activity.icon, color: activity.color, size: 72),
                      const SizedBox(height: 14),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          activity.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF233238),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activity.skill,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF53666C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
