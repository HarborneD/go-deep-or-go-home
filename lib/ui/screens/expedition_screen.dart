import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_deep_or_go_home/models/expedition.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpeditionScreen extends ConsumerWidget {
  final String expeditionId;

  const ExpeditionScreen({super.key, required this.expeditionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(gameProvider);

    // Find our expedition safely
    Expedition? safeExpedition;
    try {
      safeExpedition = gameData.activeExpeditions.firstWhere(
        (e) => e.id == expeditionId,
      );
    } catch (e) {
      safeExpedition = null;
    }

    if (safeExpedition == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Expedition Finished")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("This expedition has concluded."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Return to Camp"),
              ),
            ],
          ),
        ),
      );
    }

    // Identify party members
    final partyMembers = gameData.roster
        .where((a) => safeExpedition!.adventurerIds.contains(a.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black87, // Dark atmosphere
      appBar: AppBar(
        title: Text(
          "Expedition: ${safeExpedition.locationId.name.toUpperCase()}",
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Status Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Depth: ${safeExpedition.currentDepth}",
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Show Accumulated Loot
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${safeExpedition.accumulatedLoot.coin}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Visual / Atmosphere (Placeholder)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/locations/${safeExpedition.locationId.name}.png',
                    ), // Ensure assets exist or fallback
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Party Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: partyMembers.map((member) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Chip(
                              avatar: CircleAvatar(child: Text(member.name[0])),
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(member.name),
                                  Text(
                                    "${member.stats.currentHealth}/${member.stats.maxHealth} HP",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                              backgroundColor: member.stats.currentHealth > 0
                                  ? Colors.white70
                                  : Colors.red.withOpacity(0.7),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Log
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF2C2C2C),
                child: ListView.builder(
                  reverse: true, // Show newest at bottom
                  padding: const EdgeInsets.all(16),
                  itemCount: safeExpedition.log.length,
                  itemBuilder: (context, index) {
                    final logEntry = safeExpedition!
                        .log[safeExpedition.log.length - 1 - index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "> $logEntry",
                        style: GoogleFonts.vt323(
                          color: Colors.greenAccent,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 4. Controls (Recall?)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                  ),
                  onPressed: () {
                    // Recall Logic
                    ref
                        .read(gameProvider.notifier)
                        .returnExpedition(safeExpedition!.id);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Recall Party (End Expedition)"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
