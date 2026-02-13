import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'adventurer.g.dart';

enum AdventurerClass { vanguard, striker, scout, mystic }

enum AdventurerStatus { idle, party, expedition, injured, dead }

@JsonSerializable()
class AdventurerStats {
  final int power;
  final int carryCapacity;
  final int dodge;
  final int speed;
  final int maxHealth;
  final int currentHealth;
  final int maxStamina;
  final int currentStamina;

  const AdventurerStats({
    required this.power,
    required this.carryCapacity,
    required this.dodge,
    required this.speed,
    required this.maxHealth,
    required this.currentHealth,
    required this.maxStamina,
    required this.currentStamina,
  });

  AdventurerStats copyWith({
    int? power,
    int? carryCapacity,
    int? dodge,
    int? speed,
    int? maxHealth,
    int? currentHealth,
    int? maxStamina,
    int? currentStamina,
  }) {
    return AdventurerStats(
      power: power ?? this.power,
      carryCapacity: carryCapacity ?? this.carryCapacity,
      dodge: dodge ?? this.dodge,
      speed: speed ?? this.speed,
      maxHealth: maxHealth ?? this.maxHealth,
      currentHealth: currentHealth ?? this.currentHealth,
      maxStamina: maxStamina ?? this.maxStamina,
      currentStamina: currentStamina ?? this.currentStamina,
    );
  }

  factory AdventurerStats.fromJson(Map<String, dynamic> json) =>
      _$AdventurerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$AdventurerStatsToJson(this);
}

@JsonSerializable()
class VisualDNA {
  // Store indices or seeds for procedural generation
  final int seed;
  final Map<String, int> traits; // e.g., {'hair': 2, 'skin': 5}

  const VisualDNA({required this.seed, required this.traits});

  factory VisualDNA.fromJson(Map<String, dynamic> json) =>
      _$VisualDNAFromJson(json);

  Map<String, dynamic> toJson() => _$VisualDNAToJson(this);
}

@JsonSerializable()
class Adventurer {
  final String id;
  final String name;
  final AdventurerClass adventurerClass;
  final int level;
  final int xp;
  final AdventurerStats stats;
  final List<String> feats; // IDs of feats
  final AdventurerStatus status;
  final VisualDNA visualDNA;
  final int hireCost;

  Adventurer({
    String? id,
    required this.name,
    required this.adventurerClass,
    this.level = 1,
    this.xp = 0,
    required this.stats,
    this.feats = const [],
    this.status = AdventurerStatus.idle,
    required this.visualDNA,
    required this.hireCost,
  }) : id = id ?? const Uuid().v4();

  Adventurer copyWith({
    String? name,
    int? level,
    int? xp,
    AdventurerStats? stats,
    List<String>? feats,
    AdventurerStatus? status,
    VisualDNA? visualDNA,
  }) {
    return Adventurer(
      id: id,
      name: name ?? this.name,
      adventurerClass: adventurerClass,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      stats: stats ?? this.stats,
      feats: feats ?? this.feats,
      status: status ?? this.status,
      visualDNA: visualDNA ?? this.visualDNA,
      hireCost: hireCost,
    );
  }

  factory Adventurer.fromJson(Map<String, dynamic> json) =>
      _$AdventurerFromJson(json);

  Map<String, dynamic> toJson() => _$AdventurerToJson(this);
}
