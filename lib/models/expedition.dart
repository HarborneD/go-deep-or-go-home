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
  final List<String> adventurerIds; // Added field
  final LocationId locationId;
  final int currentDepth;
  final Resources accumulatedLoot;
  final ExpeditionStatus status;
  final List<String> log; // Restored field
  final DateTime startTime; // Added field

  // We might store the current "Letter" or event here too
  // final Letter? currentLetter;

  Expedition({
    String? id,
    required this.partyId,
    required this.adventurerIds,
    required this.locationId,
    this.currentDepth = 1,
    this.accumulatedLoot = const Resources(),
    this.status = ExpeditionStatus.active,
    this.log = const [],
    DateTime? startTime,
  }) : id = id ?? const Uuid().v4(),
       startTime = startTime ?? DateTime.now();

  Expedition copyWith({
    int? currentDepth,
    Resources? accumulatedLoot,
    ExpeditionStatus? status,
    List<String>? log,
    List<String>? adventurerIds,
    DateTime? startTime,
  }) {
    return Expedition(
      id: id,
      partyId: partyId,
      adventurerIds: adventurerIds ?? this.adventurerIds,
      locationId: locationId,
      currentDepth: currentDepth ?? this.currentDepth,
      accumulatedLoot: accumulatedLoot ?? this.accumulatedLoot,
      status: status ?? this.status,
      log: log ?? this.log,
      startTime: startTime ?? this.startTime,
    );
  }

  factory Expedition.fromJson(Map<String, dynamic> json) =>
      _$ExpeditionFromJson(json);

  Map<String, dynamic> toJson() => _$ExpeditionToJson(this);

  // Added equality check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expedition &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          partyId == other.partyId &&
          adventurerIds == other.adventurerIds &&
          locationId == other.locationId &&
          currentDepth == other.currentDepth &&
          accumulatedLoot == other.accumulatedLoot &&
          status == other.status &&
          log == other.log &&
          startTime == other.startTime;

  @override
  int get hashCode =>
      id.hashCode ^
      partyId.hashCode ^
      adventurerIds.hashCode ^
      locationId.hashCode ^
      currentDepth.hashCode ^
      accumulatedLoot.hashCode ^
      status.hashCode ^
      log.hashCode ^
      startTime.hashCode;
}
