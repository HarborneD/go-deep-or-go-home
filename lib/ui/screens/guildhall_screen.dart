import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/ui/screens/recruitment_screen.dart';
import 'package:go_deep_or_go_home/ui/screens/roster_screen.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/resource_bar.dart';

class GuildhallScreen extends ConsumerWidget {
  const GuildhallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guildhall'),
        centerTitle: true,
        backgroundColor: AppTheme.organicDarkGreen,
      ),
      body: Column(
        children: [
          const ResourceBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _GuildButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecruitmentScreen(),
                        ),
                      );
                    },
                    title: 'Notice Board',
                    subtitle: 'Recruit adventurers',
                    icon: Icons.assignment,
                  ),
                  const Gap(16),
                  _GuildButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RosterScreen()),
                      );
                    },
                    title: 'Expeditions',
                    subtitle: 'Form party and explore',
                    icon: Icons.map,
                  ),
                  const Gap(16),
                  _GuildButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Smith - Coming Soon')),
                      );
                    },
                    title: 'Smith',
                    subtitle: 'Craft equipment',
                    icon: Icons.build,
                  ),
                  const Gap(16),
                  _GuildButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cartographer - Coming Soon'),
                        ),
                      );
                    },
                    title: 'Cartographer',
                    subtitle: 'Unlock locations',
                    icon: Icons.explore,
                  ),
                  const Gap(16),
                  _GuildButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wizard - Coming Soon')),
                      );
                    },
                    title: 'Wizard',
                    subtitle: 'Purchase blessings',
                    icon: Icons.auto_awesome,
                  ),
                  const Gap(24),
                  const Divider(color: AppTheme.organicFlesh),
                  const Gap(8),
                  Text(
                    'Guild Upgrades:',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // List upgrades here
                  const ListTile(
                    title: Text('Storage I'),
                    subtitle: Text('Capacity: 100'),
                    trailing: Icon(Icons.check, color: AppTheme.accentGold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuildButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;

  const _GuildButton({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.organicBrown,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.organicFlesh.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 48, color: AppTheme.accentGold),
            const Gap(24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: AppTheme.organicFlesh),
          ],
        ),
      ),
    );
  }
}
