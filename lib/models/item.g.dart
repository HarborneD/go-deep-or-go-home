// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as String?,
      name: json['name'] as String,
      slot: $enumDecode(_$ItemSlotEnumMap, json['slot']),
      stats: AdventurerStats.fromJson(json['stats'] as Map<String, dynamic>),
      visualData: json['visualData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slot': _$ItemSlotEnumMap[instance.slot]!,
      'stats': instance.stats,
      'visualData': instance.visualData,
    };

const _$ItemSlotEnumMap = {
  ItemSlot.helm: 'helm',
  ItemSlot.amulet: 'amulet',
  ItemSlot.body: 'body',
  ItemSlot.arms: 'arms',
  ItemSlot.legs: 'legs',
  ItemSlot.handMain: 'handMain',
  ItemSlot.handOff: 'handOff',
};
