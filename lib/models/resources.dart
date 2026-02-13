import 'package:json_annotation/json_annotation.dart';

part 'resources.g.dart';

@JsonSerializable()
class Resources {
  final int coin;
  final int wood;
  final int coal;
  final int metal;
  final int leather;
  final int crystals;

  const Resources({
    this.coin = 0,
    this.wood = 0,
    this.coal = 0,
    this.metal = 0,
    this.leather = 0,
    this.crystals = 0,
  });

  Resources copyWith({
    int? coin,
    int? wood,
    int? coal,
    int? metal,
    int? leather,
    int? crystals,
  }) {
    return Resources(
      coin: coin ?? this.coin,
      wood: wood ?? this.wood,
      coal: coal ?? this.coal,
      metal: metal ?? this.metal,
      leather: leather ?? this.leather,
      crystals: crystals ?? this.crystals,
    );
  }

  Resources operator +(Resources other) {
    return Resources(
      coin: coin + other.coin,
      wood: wood + other.wood,
      coal: coal + other.coal,
      metal: metal + other.metal,
      leather: leather + other.leather,
      crystals: crystals + other.crystals,
    );
  }

  Resources operator -(Resources other) {
    return Resources(
      coin: (coin - other.coin).clamp(0, double.infinity).toInt(),
      wood: (wood - other.wood).clamp(0, double.infinity).toInt(),
      coal: (coal - other.coal).clamp(0, double.infinity).toInt(),
      metal: (metal - other.metal).clamp(0, double.infinity).toInt(),
      leather: (leather - other.leather).clamp(0, double.infinity).toInt(),
      crystals: (crystals - other.crystals).clamp(0, double.infinity).toInt(),
    );
  }

  factory Resources.fromJson(Map<String, dynamic> json) =>
      _$ResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$ResourcesToJson(this);
}
