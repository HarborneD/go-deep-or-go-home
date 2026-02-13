import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'party.g.dart';

@JsonSerializable()
class Party {
  final String id;
  final List<String> adventurerIds;
  final List<String> activeBlessings; // IDs of blessings

  Party({
    String? id,
    required this.adventurerIds,
    this.activeBlessings = const [],
  }) : id = id ?? const Uuid().v4();

  Party copyWith({List<String>? adventurerIds, List<String>? activeBlessings}) {
    return Party(
      id: id,
      adventurerIds: adventurerIds ?? this.adventurerIds,
      activeBlessings: activeBlessings ?? this.activeBlessings,
    );
  }

  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

  Map<String, dynamic> toJson() => _$PartyToJson(this);
}
