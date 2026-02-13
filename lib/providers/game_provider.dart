import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_deep_or_go_home/gen/character_generator.dart';
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

class GameNotifier extends Notifier<GameData> {
  static const String _storageKey = 'game_data';
  late StorageService _storage;

  @override
  GameData build() {
    _storage = ref.watch(storageServiceProvider);
    _load();
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

    state = state.copyWith(
      roster: updatedRoster,
      currentExpedition: Expedition(
        partyId: state.currentParty!.id,
        locationId: locationId,
      ),
    );
    _save();
  }

  void updateExpedition(Expedition expedition) {
    state = state.copyWith(currentExpedition: expedition);
    _save();
  }

  // Core Game Loop Logic
  Future<Map<String, dynamic>> resolveDepthSegment() async {
    final expedition = state.currentExpedition;
    if (expedition == null) return {};

    final rng = ref.read(rngServiceProvider);
    final narrative = ref.read(narrativeGeneratorProvider);
    final partyIds = state.currentParty!.adventurerIds;
    final partyMembers = state.roster
        .where((a) => partyIds.contains(a.id))
        .toList();

    // 1. Calculate Stats
    int totalSpeed = partyMembers.fold(0, (sum, a) => sum + a.stats.speed);
    int totalPower = partyMembers.fold(0, (sum, a) => sum + a.stats.power);
    int totalDodge = partyMembers.fold(0, (sum, a) => sum + a.stats.dodge);
    int avgSpeed = (totalSpeed / partyMembers.length).round();

    // 2. Determine Event
    // Simple logic: Threat vs Power
    final depth = expedition.currentDepth;
    // Location base threat
    final location = Location(
      id: expedition.locationId,
      name: 'Location',
      description: '...',
      baseThreat: expedition.locationId == LocationId.caves ? 5 : 10,
    ); // Stub

    double threat = location.baseThreat + 0.6 * depth + 0.12 * (depth * depth);
    double partyStrength = totalPower + (totalDodge * 0.5);

    bool isSuccess = partyStrength + rng.nextInt(20) > threat;
    bool isInjured = false;
    List<String> logs = [];

    // 3. Resolve Outcome
    if (!isSuccess) {
      // Damage
      final victim = rng.pickOne(partyMembers);
      final damage = (threat * 0.5).round().clamp(1, 20);

      final newHealth = victim.stats.currentHealth - damage;
      // Update roster
      final updatedRoster = state.roster.map((a) {
        if (a.id == victim.id) {
          return a.copyWith(stats: a.stats.copyWith(currentHealth: newHealth));
        }
        return a;
      }).toList();
      state = state.copyWith(roster: updatedRoster);

      isInjured = true;
      logs.add('${victim.name} took $damage damage!');
    } else {
      logs.add('The party advanced safely.');
    }

    // 4. Loot
    int lootMult = (1 + 0.35 * depth + 0.08 * (depth * depth)).round();
    int coinFound = rng.nextInt(10 * lootMult);
    int materialFound = rng.nextInt(5 * lootMult);

    Resources loot = Resources(
      coin: coinFound,
      metal: materialFound,
    ); // Simplified

    final newAccumulated = expedition.accumulatedLoot + loot;

    // Update Expedition
    final updatedExpedition = expedition.copyWith(
      accumulatedLoot: newAccumulated,
      log: [...expedition.log, ...logs],
    );
    state = state.copyWith(currentExpedition: updatedExpedition);
    _save();

    // 5. Generate Letter
    final letterBody = narrative.generateLetterBody(
      expedition.locationId,
      depth,
      isInjured,
    );

    return {
      'letter': letterBody,
      'logs': logs,
      'loot': loot,
      'isInjured': isInjured,
    };
  }

  void endExpedition({required bool success}) {
    final expedition = state.currentExpedition;
    if (expedition == null) return; // Should not happen

    final loot = expedition.accumulatedLoot;
    if (success) {
      state = state.copyWith(resources: state.resources + loot);
    }

    final updatedRoster = state.roster.map((a) {
      // Heal logic? Or stay injured?
      // For prototype, restore some health if returning safely?
      if (state.currentParty!.adventurerIds.contains(a.id)) {
        if (a.status != AdventurerStatus.dead) {
          return a.copyWith(status: AdventurerStatus.idle);
        }
      }
      return a;
    }).toList();

    state = state.copyWith(roster: updatedRoster, currentExpedition: null);
    _save();
  }

  void resetGame() {
    state = const GameData();
    _storage.remove(_storageKey);
  }
}

final gameProvider = NotifierProvider<GameNotifier, GameData>(GameNotifier.new);
