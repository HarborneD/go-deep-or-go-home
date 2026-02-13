// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      id: $enumDecode(_$LocationIdEnumMap, json['id']),
      name: json['name'] as String,
      description: json['description'] as String,
      baseThreat: (json['baseThreat'] as num).toInt(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': _$LocationIdEnumMap[instance.id]!,
      'name': instance.name,
      'description': instance.description,
      'baseThreat': instance.baseThreat,
    };

const _$LocationIdEnumMap = {
  LocationId.caves: 'caves',
  LocationId.castleRuins: 'castleRuins',
};
