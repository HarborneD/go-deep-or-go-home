import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/models/location.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/adventurer_card.dart';
import 'package:go_deep_or_go_home/ui/screens/expedition_screen.dart';

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
    // Check if expedition is already active - REMOVED for Multi-Expedition support

    final roster = ref.watch(gameProvider.select((s) => s.roster));
    final unlockedLocations = ref.watch(
      gameProvider.select((s) => s.unlockedLocations),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roster & Expedition'),
        backgroundColor: AppTheme.organicDarkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                      iconEnabledColor: AppTheme.accentGold,
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

                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.riskRed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: const Text('EMBARK'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: roster.isEmpty
                ? const Center(
                    child: Text('Recruit adventurers at the Tavern!'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // More dense
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
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
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Party is full!'),
                                        ),
                                      );
                                    }
                                  }
                                });
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(
                                    color: AppTheme.accentGold,
                                    width: 3,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Opacity(
                            opacity: isAvailable ? 1.0 : 0.5,
                            child: AdventurerCard(
                              adventurer: adventurer,
                              compact: true,
                              enableAction: false, // Selection is via tap
                              actionLabel: isSelected
                                  ? 'Selected'
                                  : (isAvailable ? 'Select' : 'Busy'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Active Expeditions Header
          if (ref.watch(
            gameProvider.select((s) => s.activeExpeditions.isNotEmpty),
          ))
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.black87,
              width: double.infinity,
              child: Text(
                "Active Expeditions",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppTheme.accentGold),
              ),
            ),

          // Active Expeditions List
          if (ref.watch(
            gameProvider.select((s) => s.activeExpeditions.isNotEmpty),
          ))
            Container(
              height: 120, // Fixed height for now
              color: Colors.black54,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: ref.watch(
                  gameProvider.select((s) => s.activeExpeditions.length),
                ),
                itemBuilder: (context, index) {
                  final expedition = ref.watch(
                    gameProvider.select((s) => s.activeExpeditions),
                  )[index];
                  return Card(
                    color: AppTheme.organicBrown,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        expedition.locationId.name.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.textParchment,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Depth: ${expedition.currentDepth}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.accentGold,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ExpeditionScreen(expeditionId: expedition.id),
                          ),
                        );
                      },
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
