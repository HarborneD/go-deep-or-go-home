import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_deep_or_go_home/gen/character_generator.dart';
import 'package:go_deep_or_go_home/gen/name_generator.dart';
import 'package:go_deep_or_go_home/gen/narrative_generator.dart';
import 'package:go_deep_or_go_home/services/rng_service.dart';

final nameGeneratorProvider = Provider<NameGenerator>((ref) {
  final rng = ref.watch(rngServiceProvider);
  return NameGenerator(rng);
});

final characterGeneratorProvider = Provider<CharacterGenerator>((ref) {
  final rng = ref.watch(rngServiceProvider);
  final nameGen = ref.watch(nameGeneratorProvider);
  return CharacterGenerator(rng, nameGen);
});

final narrativeGeneratorProvider = Provider<NarrativeGenerator>((ref) {
  final rng = ref.watch(rngServiceProvider);
  return NarrativeGenerator(rng);
});
