import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

enum LocationId { caves, castleRuins }

@JsonSerializable()
class Location {
  final LocationId id;
  final String name;
  final String description;
  final int baseThreat;
  // Could add resource weights here later

  const Location({
    required this.id,
    required this.name,
    required this.description,
    required this.baseThreat,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
