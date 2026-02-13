import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/models/expedition.dart';
import 'package:go_deep_or_go_home/models/location.dart';
import 'package:go_deep_or_go_home/models/party.dart';
import 'package:go_deep_or_go_home/models/resources.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_data.g.dart';

@JsonSerializable()
class GameData {
  final Resources resources;
  final List<Adventurer> roster;
  final Party? currentParty;
  final Expedition? currentExpedition;
  final List<LocationId> unlockedLocations;
  final int guildhallLevel;
  final List<Adventurer> availableRecruits;
  final DateTime? lastSaveTime;

  const GameData({
    this.resources = const Resources(),
    this.roster = const [],
    this.currentParty,
    this.currentExpedition,
    this.unlockedLocations = const [LocationId.caves, LocationId.castleRuins],
    this.guildhallLevel = 1,
    this.availableRecruits = const [],
    this.lastSaveTime,
  });

  GameData copyWith({
    Resources? resources,
    List<Adventurer>? roster,
    Party? currentParty,
    Expedition? currentExpedition,
    List<LocationId>? unlockedLocations,
    int? guildhallLevel,
    List<Adventurer>? availableRecruits,
    DateTime? lastSaveTime,
  }) {
    return GameData(
      resources: resources ?? this.resources,
      roster: roster ?? this.roster,
      currentParty: currentParty ?? this.currentParty,
      currentExpedition: currentExpedition ?? this.currentExpedition,
      unlockedLocations: unlockedLocations ?? this.unlockedLocations,
      guildhallLevel: guildhallLevel ?? this.guildhallLevel,
      availableRecruits: availableRecruits ?? this.availableRecruits,
      lastSaveTime: lastSaveTime ?? this.lastSaveTime,
    );
  }

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameDataToJson(this);
}
