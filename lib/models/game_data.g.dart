// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
      resources: json['resources'] == null
          ? const Resources(coin: 300)
          : Resources.fromJson(json['resources'] as Map<String, dynamic>),
      roster: (json['roster'] as List<dynamic>?)
              ?.map((e) => Adventurer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentParty: json['currentParty'] == null
          ? null
          : Party.fromJson(json['currentParty'] as Map<String, dynamic>),
      activeExpeditions: (json['activeExpeditions'] as List<dynamic>?)
              ?.map((e) => Expedition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      completedExpeditions: (json['completedExpeditions'] as List<dynamic>?)
              ?.map((e) => Expedition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      unlockedLocations: (json['unlockedLocations'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$LocationIdEnumMap, e))
              .toList() ??
          const [LocationId.caves, LocationId.castleRuins],
      guildhallLevel: (json['guildhallLevel'] as num?)?.toInt() ?? 1,
      availableRecruits: (json['availableRecruits'] as List<dynamic>?)
              ?.map((e) => Adventurer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastSaveTime: json['lastSaveTime'] == null
          ? null
          : DateTime.parse(json['lastSaveTime'] as String),
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'resources': instance.resources,
      'roster': instance.roster,
      'currentParty': instance.currentParty,
      'activeExpeditions': instance.activeExpeditions,
      'completedExpeditions': instance.completedExpeditions,
      'unlockedLocations': instance.unlockedLocations
          .map((e) => _$LocationIdEnumMap[e]!)
          .toList(),
      'guildhallLevel': instance.guildhallLevel,
      'availableRecruits': instance.availableRecruits,
      'lastSaveTime': instance.lastSaveTime?.toIso8601String(),
    };

const _$LocationIdEnumMap = {
  LocationId.caves: 'caves',
  LocationId.castleRuins: 'castleRuins',
};
