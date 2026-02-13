import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/models/game_data.dart';
import 'package:go_deep_or_go_home/models/location.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/screens/expedition_screen.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/adventurer_card.dart';

class RosterScreen extends ConsumerStatefulWidget {
  const RosterScreen({super.key});

  @override
  ConsumerState<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends ConsumerState<RosterScreen> {
  final Set<String> _selectedIds = {};
  LocationId _selectedLocation = LocationId.caves;

  @override
  Widget build(BuildContext context) {
    // Check if expedition is already active
    final hasExpedition = ref.watch(
      gameProvider.select((s) => s.currentExpedition != null),
    );
    if (hasExpedition) {
      // Redirect or show active expedition view
      return const ExpeditionScreen(); // Or redirect in initState?
    }

    final roster = ref.watch(gameProvider.select((s) => s.roster));
    final unlockedLocations = ref.watch(
      gameProvider.select((s) => s.unlockedLocations),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Roster & Expedition',
        ), // Should match task? "Expeditions"
        backgroundColor: AppTheme.organicDarkGreen,
      ),
      body: Column(
        children: [
          // Party Selection Info
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.organicBrown,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Party (${_selectedIds.length}/3)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    DropdownButton<LocationId>(
                      value: _selectedLocation,
                      dropdownColor: AppTheme.organicBrown,
                      style: Theme.of(context).textTheme.bodyLarge,
                      items: unlockedLocations.map((loc) {
                        return DropdownMenuItem(
                          value: loc,
                          child: Text(loc.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedLocation = val);
                      },
                    ),
                  ],
                ),
                const Gap(8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedIds.isNotEmpty
                        ? () {
                            // Start Expedition
                            ref
                                .read(gameProvider.notifier)
                                .setParty(_selectedIds.toList());
                            ref
                                .read(gameProvider.notifier)
                                .startExpedition(_selectedLocation);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ExpeditionScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.riskRed,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('EMBARK'), // "GO DEEP"
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: roster.isEmpty
                ? const Center(
                    child: Text('Recruit adventurers at the Notice Board!'),
                  )
                : ListView.builder(
                    itemCount: roster.length,
                    itemBuilder: (context, index) {
                      final adventurer = roster[index];
                      final isSelected = _selectedIds.contains(adventurer.id);
                      final isAvailable =
                          adventurer.status == AdventurerStatus.idle;

                      return GestureDetector(
                        onTap: isAvailable
                            ? () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedIds.remove(adventurer.id);
                                  } else {
                                    if (_selectedIds.length < 3) {
                                      _selectedIds.add(adventurer.id);
                                    }
                                  }
                                });
                              }
                            : null,
                        child: Container(
                          foregroundDecoration: isSelected
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.accentGold,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                )
                              : (isAvailable
                                    ? null
                                    : BoxDecoration(color: Colors.black54)),
                          child: AdventurerCard(
                            adventurer: adventurer,
                            enableAction: false, // Selection is via tap
                            actionLabel: '',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
