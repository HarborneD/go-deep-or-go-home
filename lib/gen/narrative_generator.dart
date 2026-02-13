import 'package:go_deep_or_go_home/models/location.dart';
import 'package:go_deep_or_go_home/services/rng_service.dart';

class NarrativeGenerator {
  final RngService _rng;

  NarrativeGenerator(this._rng);

  String generateLetterBody(LocationId location, int depth, bool isInjured) {
    final intro = _rng.pickOne([
      'The air grows heavy.',
      'Shadows lengthen here.',
      'We press on, despite the danger.',
      'The path twists seemingly without end.',
    ]);

    final environment = location == LocationId.caves
        ? _rng.pickOne([
            'Water drips from unseen stalactites.',
            'The walls hum with a low vibration.',
            'Luminescent fungi light our way.',
          ])
        : _rng.pickOne([
            'Ancient stone blocks block our path.',
            'Dust motes dance in stray beams of light.',
            'The castle groans under its own weight.',
          ]);

    final status = isInjured
        ? _rng.pickOne([
            'Blood has been spilled.',
            'We are weary and wounded.',
            'The darkness takes its toll.',
          ])
        : _rng.pickOne([
            'Our spirits remain high.',
            'We have found good loot.',
            'The party moves as one.',
          ]);

    final closing = _rng.pickOne([
      'We await your command.',
      'Should we continue?',
      'The depths call to us.',
    ]);

    return '$intro $environment $status $closing';
  }
}
