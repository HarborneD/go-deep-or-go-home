// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expedition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expedition _$ExpeditionFromJson(Map<String, dynamic> json) => Expedition(
      id: json['id'] as String?,
      partyId: json['partyId'] as String,
      adventurerIds: (json['adventurerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      locationId: $enumDecode(_$LocationIdEnumMap, json['locationId']),
      currentDepth: (json['currentDepth'] as num?)?.toInt() ?? 1,
      accumulatedLoot: json['accumulatedLoot'] == null
          ? const Resources()
          : Resources.fromJson(json['accumulatedLoot'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$ExpeditionStatusEnumMap, json['status']) ??
          ExpeditionStatus.active,
      log: (json['log'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
    );

Map<String, dynamic> _$ExpeditionToJson(Expedition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partyId': instance.partyId,
      'adventurerIds': instance.adventurerIds,
      'locationId': _$LocationIdEnumMap[instance.locationId]!,
      'currentDepth': instance.currentDepth,
      'accumulatedLoot': instance.accumulatedLoot,
      'status': _$ExpeditionStatusEnumMap[instance.status]!,
      'log': instance.log,
      'startTime': instance.startTime.toIso8601String(),
    };

const _$LocationIdEnumMap = {
  LocationId.caves: 'caves',
  LocationId.castleRuins: 'castleRuins',
};

const _$ExpeditionStatusEnumMap = {
  ExpeditionStatus.active: 'active',
  ExpeditionStatus.returning: 'returning',
  ExpeditionStatus.completed: 'completed',
  ExpeditionStatus.failed: 'failed',
};
