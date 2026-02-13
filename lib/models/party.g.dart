// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Party _$PartyFromJson(Map<String, dynamic> json) => Party(
      id: json['id'] as String?,
      adventurerIds: (json['adventurerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activeBlessings: (json['activeBlessings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PartyToJson(Party instance) => <String, dynamic>{
      'id': instance.id,
      'adventurerIds': instance.adventurerIds,
      'activeBlessings': instance.activeBlessings,
    };
