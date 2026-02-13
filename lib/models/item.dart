import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'item.g.dart';

enum ItemSlot { helm, amulet, body, arms, legs, handMain, handOff }

@JsonSerializable()
class Item {
  final String id;
  final String name;
  final ItemSlot slot;
  final AdventurerStats stats; // Bonus stats
  final Map<String, dynamic> visualData; // For procedural icon

  Item({
    String? id,
    required this.name,
    required this.slot,
    required this.stats,
    this.visualData = const {},
  }) : id = id ?? const Uuid().v4();

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
