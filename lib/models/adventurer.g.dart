// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventurer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdventurerStats _$AdventurerStatsFromJson(Map<String, dynamic> json) =>
    AdventurerStats(
      power: (json['power'] as num).toInt(),
      carryCapacity: (json['carryCapacity'] as num).toInt(),
      dodge: (json['dodge'] as num).toInt(),
      speed: (json['speed'] as num).toInt(),
      maxHealth: (json['maxHealth'] as num).toInt(),
      currentHealth: (json['currentHealth'] as num).toInt(),
      maxStamina: (json['maxStamina'] as num).toInt(),
      currentStamina: (json['currentStamina'] as num).toInt(),
    );

Map<String, dynamic> _$AdventurerStatsToJson(AdventurerStats instance) =>
    <String, dynamic>{
      'power': instance.power,
      'carryCapacity': instance.carryCapacity,
      'dodge': instance.dodge,
      'speed': instance.speed,
      'maxHealth': instance.maxHealth,
      'currentHealth': instance.currentHealth,
      'maxStamina': instance.maxStamina,
      'currentStamina': instance.currentStamina,
    };

VisualDNA _$VisualDNAFromJson(Map<String, dynamic> json) => VisualDNA(
      seed: (json['seed'] as num).toInt(),
      traits: Map<String, int>.from(json['traits'] as Map),
    );

Map<String, dynamic> _$VisualDNAToJson(VisualDNA instance) => <String, dynamic>{
      'seed': instance.seed,
      'traits': instance.traits,
    };

Adventurer _$AdventurerFromJson(Map<String, dynamic> json) => Adventurer(
      id: json['id'] as String?,
      name: json['name'] as String,
      adventurerClass:
          $enumDecode(_$AdventurerClassEnumMap, json['adventurerClass']),
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      stats: AdventurerStats.fromJson(json['stats'] as Map<String, dynamic>),
      feats:
          (json['feats'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      status: $enumDecodeNullable(_$AdventurerStatusEnumMap, json['status']) ??
          AdventurerStatus.idle,
      visualDNA: VisualDNA.fromJson(json['visualDNA'] as Map<String, dynamic>),
      hireCost: (json['hireCost'] as num).toInt(),
    );

Map<String, dynamic> _$AdventurerToJson(Adventurer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'adventurerClass': _$AdventurerClassEnumMap[instance.adventurerClass]!,
      'level': instance.level,
      'xp': instance.xp,
      'stats': instance.stats,
      'feats': instance.feats,
      'status': _$AdventurerStatusEnumMap[instance.status]!,
      'visualDNA': instance.visualDNA,
      'hireCost': instance.hireCost,
    };

const _$AdventurerClassEnumMap = {
  AdventurerClass.vanguard: 'vanguard',
  AdventurerClass.striker: 'striker',
  AdventurerClass.scout: 'scout',
  AdventurerClass.mystic: 'mystic',
};

const _$AdventurerStatusEnumMap = {
  AdventurerStatus.idle: 'idle',
  AdventurerStatus.party: 'party',
  AdventurerStatus.expedition: 'expedition',
  AdventurerStatus.injured: 'injured',
  AdventurerStatus.dead: 'dead',
};
