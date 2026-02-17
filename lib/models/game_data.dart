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
  // currentParty is now just for the UI selection state before embarking
  final Party? currentParty;
  // List of active expeditions
  final List<Expedition> activeExpeditions;
  final List<Expedition> completedExpeditions;
  final List<LocationId> unlockedLocations;
  final int guildhallLevel;
  final List<Adventurer> availableRecruits;
  final DateTime? lastSaveTime;

  const GameData({
    this.resources = const Resources(coin: 300),
    this.roster = const [],
    this.currentParty,
    this.activeExpeditions = const [],
    this.completedExpeditions = const [],
    this.unlockedLocations = const [LocationId.caves, LocationId.castleRuins],
    this.guildhallLevel = 1,
    this.availableRecruits = const [],
    this.lastSaveTime,
  });

  GameData copyWith({
    Resources? resources,
    List<Adventurer>? roster,
    Party? currentParty,
    List<Expedition>? activeExpeditions,
    List<Expedition>? completedExpeditions,
    List<LocationId>? unlockedLocations,
    int? guildhallLevel,
    List<Adventurer>? availableRecruits,
    DateTime? lastSaveTime,
  }) {
    return GameData(
      resources: resources ?? this.resources,
      roster: roster ?? this.roster,
      currentParty: currentParty ?? this.currentParty,
      activeExpeditions: activeExpeditions ?? this.activeExpeditions,
      completedExpeditions: completedExpeditions ?? this.completedExpeditions,
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
