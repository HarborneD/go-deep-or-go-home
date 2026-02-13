import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/adventurer_card.dart';
import 'package:go_deep_or_go_home/ui/widgets/resource_bar.dart';

class RecruitmentScreen extends ConsumerWidget {
  const RecruitmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recruits = ref.watch(gameProvider.select((s) => s.availableRecruits));
    final resources = ref.watch(gameProvider.select((s) => s.resources));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
        backgroundColor: AppTheme.organicDarkGreen,
      ),
      body: Column(
        children: [
          const ResourceBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Recruits',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppTheme.accentGold),
                  onPressed: () {
                    // Logic to refresh (maybe cost?)
                    ref
                        .read(gameProvider.notifier)
                        .clearRecruits(); // Cheat refresh
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: recruits.isEmpty
                ? Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(gameProvider.notifier).refreshRecruits();
                      },
                      child: const Text('Find Recruits'),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: recruits.length,
                    itemBuilder: (context, index) {
                      final recruit = recruits[index];
                      final canAfford = resources.coin >= recruit.hireCost;

                      return AdventurerCard(
                        adventurer: recruit,
                        actionLabel: '${recruit.hireCost} Gold',
                        enableAction: canAfford,
                        onAction: () {
                          ref
                              .read(gameProvider.notifier)
                              .recruitAdventurer(recruit);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Recruited ${recruit.name}!'),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
