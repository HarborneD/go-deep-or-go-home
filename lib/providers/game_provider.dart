import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_deep_or_go_home/gen/narrative_generator.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/models/expedition.dart';
import 'package:go_deep_or_go_home/models/game_data.dart';
import 'package:go_deep_or_go_home/models/location.dart';
import 'package:go_deep_or_go_home/models/party.dart';
import 'package:go_deep_or_go_home/models/resources.dart';
import 'package:go_deep_or_go_home/providers/providers.dart';
import 'package:go_deep_or_go_home/services/rng_service.dart';
import 'package:go_deep_or_go_home/services/storage_service.dart';

import 'dart:async'; // Add this

class GameNotifier extends Notifier<GameData> {
  static const String _storageKey = 'game_data';
  late StorageService _storage;
  Timer? _timer;

  @override
  GameData build() {
    _storage = ref.watch(storageServiceProvider);
    _load();

    // Start background loop
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      processExpeditions();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    return const GameData();
  }

  Future<void> _load() async {
    final jsonString = _storage.getString(_storageKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString);
        state = GameData.fromJson(json);
      } catch (e) {
        // print('Error loading game data: $e');
      }
    }
  }

  Future<void> _save() async {
    final json = state.toJson();
    await _storage.setString(_storageKey, jsonEncode(json));
  }

  // --- Resources ---

  void addResources(Resources amount) {
    state = state.copyWith(resources: state.resources + amount);
    _save();
  }

  void subtractResources(Resources amount) {
    state = state.copyWith(resources: state.resources - amount);
    _save();
  }

  // --- Recruitment ---

  void refreshRecruits() {
    final charGen = ref.read(characterGeneratorProvider);
    final currentCount = state.availableRecruits.length;
    final needed = 6 - currentCount;

    if (needed > 0) {
      final newRecruits = List.generate(needed, (_) => charGen.generate());
      state = state.copyWith(
        availableRecruits: [...state.availableRecruits, ...newRecruits],
      );
      _save();
    }
  }

  void clearRecruits() {
    state = state.copyWith(availableRecruits: []);
    refreshRecruits();
  }

  void recruitAdventurer(Adventurer adventurer) {
    if (state.resources.coin < adventurer.hireCost) return;

    state = state.copyWith(
      roster: [...state.roster, adventurer],
      availableRecruits: state.availableRecruits
          .where((a) => a.id != adventurer.id)
          .toList(),
      resources: state.resources - Resources(coin: adventurer.hireCost),
    );
    _save();
  }

  // --- Party & Expedition ---

  void setParty(List<String> adventurerIds) {
    state = state.copyWith(currentParty: Party(adventurerIds: adventurerIds));
    _save();
  }

  void startExpedition(LocationId locationId) {
    if (state.currentParty == null) return;

    final updatedRoster = state.roster.map((a) {
      if (state.currentParty!.adventurerIds.contains(a.id)) {
        return a.copyWith(status: AdventurerStatus.expedition);
      }
      return a;
    }).toList();

    final newExpedition = Expedition(
      partyId: state.currentParty!.id,
      adventurerIds: state.currentParty!.adventurerIds,
      locationId: locationId,
      startTime: DateTime.now(),
    );

    state = state.copyWith(
      roster: updatedRoster,
      activeExpeditions: [...state.activeExpeditions, newExpedition],
      currentParty: null, // Clear selection after processing
    );
    _save();
  }

  // Called periodically to progress all active expeditions
  Future<void> processExpeditions() async {
    if (state.activeExpeditions.isEmpty) return;

    final rng = ref.read(rngServiceProvider);
    final narrative = ref.read(narrativeGeneratorProvider);

    List<Expedition> updatedExpeditions = [];
    List<Adventurer> updatedRoster = [...state.roster];
    bool stateChanged = false;

    for (final expedition in state.activeExpeditions) {
      if (expedition.status != ExpeditionStatus.active) {
        updatedExpeditions.add(expedition);
        continue;
      }

      // Simple progression: 20% chance per tick to trigger an event/step
      if (rng.nextInt(100) < 20) {
        final result = _processExpeditionStep(
          expedition,
          updatedRoster,
          rng,
          narrative,
        );
        updatedExpeditions.add(result.expedition);
        updatedRoster = result.roster;
        stateChanged = true;
      } else {
        updatedExpeditions.add(expedition);
      }
    }

    if (stateChanged) {
      state = state.copyWith(
        activeExpeditions: updatedExpeditions,
        roster: updatedRoster,
      );
      _save();
    }
  }

  ({Expedition expedition, List<Adventurer> roster}) _processExpeditionStep(
    Expedition expedition,
    List<Adventurer> roster,
    RngService rng,
    NarrativeGenerator narrative,
  ) {
    final partyMembers = roster
        .where((a) => expedition.adventurerIds.contains(a.id))
        .toList();

    // If party is dead, mark failed
    if (partyMembers.every((a) => a.stats.currentHealth <= 0)) {
      return (
        expedition: expedition.copyWith(status: ExpeditionStatus.failed),
        roster: roster,
      );
    }

    // 1. Calculate Stats
    int totalPower = partyMembers.fold(
      0,
      (sum, a) => sum + (a.status != AdventurerStatus.dead ? a.stats.power : 0),
    );
    int totalDodge = partyMembers.fold(
      0,
      (sum, a) => sum + (a.status != AdventurerStatus.dead ? a.stats.dodge : 0),
    );

    // 2. Determine Event
    final depth = expedition.currentDepth;
    // Location base threat (Stub)
    final baseThreat = expedition.locationId == LocationId.caves ? 5 : 10;

    double threat = baseThreat + 0.6 * depth + 0.12 * (depth * depth);
    double partyStrength = totalPower + (totalDodge * 0.5);

    bool isSuccess = partyStrength + rng.nextInt(20) > threat;
    // bool isInjured = false;
    List<String> logs = [];

    List<Adventurer> nextRoster = [...roster];

    // 3. Resolve Outcome
    if (!isSuccess) {
      // Damage
      final livingMembers = partyMembers
          .where((a) => a.status != AdventurerStatus.dead)
          .toList();
      if (livingMembers.isNotEmpty) {
        final victim = rng.pickOne(livingMembers);
        final damage = (threat * 0.5).round().clamp(1, 20);
        final newHealth = victim.stats.currentHealth - damage;

        // Update roster
        nextRoster = nextRoster.map((a) {
          if (a.id == victim.id) {
            final newStatus = newHealth <= 0
                ? AdventurerStatus.dead
                : AdventurerStatus.expedition;
            return a.copyWith(
              status: newStatus,
              stats: a.stats.copyWith(currentHealth: newHealth),
            );
          }
          return a;
        }).toList();

        // isInjured = true;
        logs.add('${victim.name} took $damage damage!');
        if (newHealth <= 0) {
          logs.add('${victim.name} has fallen!');
        }
      }
    } else {
      logs.add('The party advanced safely.');
    }

    // 4. Loot
    int lootMult = (1 + 0.35 * depth + 0.08 * (depth * depth)).round();
    int coinFound = rng.nextInt(10 * lootMult);
    int materialFound = rng.nextInt(5 * lootMult);

    Resources loot = Resources(coin: coinFound, metal: materialFound);
    final newAccumulated = expedition.accumulatedLoot + loot;

    // 5. Letter/Progression
    final nextDepth = expedition.currentDepth + 1;

    // Update Expedition
    final updatedExpedition = expedition.copyWith(
      currentDepth: nextDepth,
      accumulatedLoot: newAccumulated,
      log: [...expedition.log, ...logs],
    );

    return (expedition: updatedExpedition, roster: nextRoster);
  }

  void returnExpedition(String expeditionId) {
    final expedition = state.activeExpeditions.firstWhere(
      (e) => e.id == expeditionId,
      orElse: () => throw Exception("Expedition not found"),
    );
    // If it's already failed, we just dismiss/end it as failed.
    // If it is active, we treat it as a safe return.
    final isSuccess = expedition.status != ExpeditionStatus.failed;
    endExpedition(expeditionId: expeditionId, success: isSuccess);
  }

  void endExpedition({required String expeditionId, required bool success}) {
    final expedition = state.activeExpeditions.firstWhere(
      (e) => e.id == expeditionId,
      orElse: () => throw Exception("Expedition not found"),
    );

    final loot = expedition.accumulatedLoot;
    if (success) {
      state = state.copyWith(resources: state.resources + loot);
    }

    final updatedRoster = state.roster.map((a) {
      if (expedition.adventurerIds.contains(a.id)) {
        if (a.status != AdventurerStatus.dead) {
          return a.copyWith(status: AdventurerStatus.idle);
        }
      }
      return a;
    }).toList();

    // Mark as completed/failed
    final finalExpedition = expedition.copyWith(
      status: success ? ExpeditionStatus.completed : ExpeditionStatus.failed,
      log: [
        ...expedition.log,
        success ? "Expedition Returned Safely." : "Expedition Ended.",
      ],
    );
    print(
      "DEBUG: Ending Expedition ${expedition.id}. Status: ${finalExpedition.status}",
    );

    state = state.copyWith(
      roster: updatedRoster,
      activeExpeditions: state.activeExpeditions
          .where((e) => e.id != expeditionId)
          .toList(),
      completedExpeditions: [...state.completedExpeditions, finalExpedition],
    );
    _save();
  }

  void dismissCompletedExpedition(String expeditionId) {
    state = state.copyWith(
      completedExpeditions: state.completedExpeditions
          .where((e) => e.id != expeditionId)
          .toList(),
    );
    _save();
  }

  void resetGame() {
    state = const GameData();
    _storage.remove(_storageKey);
  }
}

final gameProvider = NotifierProvider<GameNotifier, GameData>(GameNotifier.new);
