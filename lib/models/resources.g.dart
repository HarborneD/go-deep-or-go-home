// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resources.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resources _$ResourcesFromJson(Map<String, dynamic> json) => Resources(
      coin: (json['coin'] as num?)?.toInt() ?? 0,
      wood: (json['wood'] as num?)?.toInt() ?? 0,
      coal: (json['coal'] as num?)?.toInt() ?? 0,
      metal: (json['metal'] as num?)?.toInt() ?? 0,
      leather: (json['leather'] as num?)?.toInt() ?? 0,
      crystals: (json['crystals'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ResourcesToJson(Resources instance) => <String, dynamic>{
      'coin': instance.coin,
      'wood': instance.wood,
      'coal': instance.coal,
      'metal': instance.metal,
      'leather': instance.leather,
      'crystals': instance.crystals,
    };
