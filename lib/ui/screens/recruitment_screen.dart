import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/notice_card.dart';
import 'package:go_deep_or_go_home/ui/widgets/resource_bar.dart';

class RecruitmentScreen extends ConsumerWidget {
  const RecruitmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recruits = ref.watch(gameProvider.select((s) => s.availableRecruits));
    final resources = ref.watch(gameProvider.select((s) => s.resources));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notice Board'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Wood Background
          Image.asset('assets/images/notice_board_bg.png', fit: BoxFit.cover),

          SafeArea(
            child: Column(
              children: [
                const ResourceBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'For Hire',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: AppTheme.textParchment,
                              shadows: [
                                const Shadow(
                                  blurRadius: 4,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: AppTheme.accentGold,
                        ),
                        onPressed: () {
                          ref.read(gameProvider.notifier).clearRecruits();
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.organicBrown,
                              foregroundColor: AppTheme.textParchment,
                            ),
                            child: const Text('Check for New Notices'),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.15, // Wider/Shorter cards
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 8, // Reduced spacing
                              ),
                          itemCount: recruits.length,
                          itemBuilder: (context, index) {
                            final recruit = recruits[index];
                            final canAfford =
                                resources.coin >= recruit.hireCost;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: NoticeCard(
                                adventurer: recruit,
                                rotation:
                                    (index % 2 == 0 ? 0.02 : -0.02) +
                                    (index * 0.01 % 0.05),
                                onRecruit: canAfford
                                    ? () {
                                        ref
                                            .read(gameProvider.notifier)
                                            .recruitAdventurer(recruit);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Recruited ${recruit.name}!',
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
