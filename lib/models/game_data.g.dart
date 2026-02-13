// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
      resources: json['resources'] == null
          ? const Resources()
          : Resources.fromJson(json['resources'] as Map<String, dynamic>),
      roster: (json['roster'] as List<dynamic>?)
              ?.map((e) => Adventurer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentParty: json['currentParty'] == null
          ? null
          : Party.fromJson(json['currentParty'] as Map<String, dynamic>),
      currentExpedition: json['currentExpedition'] == null
          ? null
          : Expedition.fromJson(
              json['currentExpedition'] as Map<String, dynamic>),
      unlockedLocations: (json['unlockedLocations'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$LocationIdEnumMap, e))
              .toList() ??
          const [LocationId.caves, LocationId.castleRuins],
      guildhallLevel: (json['guildhallLevel'] as num?)?.toInt() ?? 1,
      lastSaveTime: json['lastSaveTime'] == null
          ? null
          : DateTime.parse(json['lastSaveTime'] as String),
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'resources': instance.resources,
      'roster': instance.roster,
      'currentParty': instance.currentParty,
      'currentExpedition': instance.currentExpedition,
      'unlockedLocations': instance.unlockedLocations
          .map((e) => _$LocationIdEnumMap[e]!)
          .toList(),
      'guildhallLevel': instance.guildhallLevel,
      'lastSaveTime': instance.lastSaveTime?.toIso8601String(),
    };

const _$LocationIdEnumMap = {
  LocationId.caves: 'caves',
  LocationId.castleRuins: 'castleRuins',
};
