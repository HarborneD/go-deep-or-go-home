import 'package:go_deep_or_go_home/models/resources.dart';
import 'package:go_deep_or_go_home/models/location.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'expedition.g.dart';

enum ExpeditionStatus { active, returning, completed, failed }

@JsonSerializable()
class Expedition {
  final String id;
  final String partyId;
  final LocationId locationId;
  final int currentDepth;
  final Resources accumulatedLoot;
  final ExpeditionStatus status;
  final List<String> log;
  final double progressToNextSegment; // 0.0 to 1.0

  // We might store the current "Letter" or event here too
  // final Letter? currentLetter;

  Expedition({
    String? id,
    required this.partyId,
    required this.locationId,
    this.currentDepth = 1,
    this.accumulatedLoot = const Resources(),
    this.status = ExpeditionStatus.active,
    this.log = const [],
    this.progressToNextSegment = 0.0,
  }) : id = id ?? const Uuid().v4();

  Expedition copyWith({
    int? currentDepth,
    Resources? accumulatedLoot,
    ExpeditionStatus? status,
    List<String>? log,
    double? progressToNextSegment,
  }) {
    return Expedition(
      id: id,
      partyId: partyId,
      locationId: locationId,
      currentDepth: currentDepth ?? this.currentDepth,
      accumulatedLoot: accumulatedLoot ?? this.accumulatedLoot,
      status: status ?? this.status,
      log: log ?? this.log,
      progressToNextSegment:
          progressToNextSegment ?? this.progressToNextSegment,
    );
  }

  factory Expedition.fromJson(Map<String, dynamic> json) =>
      _$ExpeditionFromJson(json);

  Map<String, dynamic> toJson() => _$ExpeditionToJson(this);
}
