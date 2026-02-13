import 'package:go_deep_or_go_home/gen/name_generator.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/services/rng_service.dart';

class CharacterGenerator {
  final RngService _rng;
  final NameGenerator _nameGen;

  CharacterGenerator(this._rng, this._nameGen);

  Adventurer generate({int level = 1}) {
    final name = _nameGen.generate();
    final cls = _rng.pickOne(AdventurerClass.values);

    // Base stats based on class
    int power = 10;
    int speed = 10;
    int health = 50;
    int dodge = 5;

    switch (cls) {
      case AdventurerClass.vanguard:
        power = 12;
        health = 70;
        speed = 8;
        break;
      case AdventurerClass.striker:
        power = 15;
        health = 50;
        speed = 12;
        break;
      case AdventurerClass.scout:
        speed = 15;
        dodge = 15;
        health = 40;
        break;
      case AdventurerClass.mystic:
        power = 8;
        health = 35;
        dodge = 10;
        // logic for magic?
        break;
    }

    // Variance
    power += _rng.nextInt(5) - 2;
    health += _rng.nextInt(10) - 5;
    speed += _rng.nextInt(4) - 2;

    final stats = AdventurerStats(
      power: power,
      carryCapacity: 10 + (power ~/ 2),
      dodge: dodge,
      speed: speed,
      maxHealth: health,
      currentHealth: health,
      maxStamina: 100,
      currentStamina: 100,
    );

    final visualDNA = VisualDNA(
      seed: _rng.nextInt(1000000),
      traits: {
        'hair': _rng.nextInt(5),
        'skin': _rng.nextInt(5),
        'acc': _rng.nextInt(5),
      },
    );

    return Adventurer(
      name: name,
      adventurerClass: cls,
      level: level,
      stats: stats,
      visualDNA: visualDNA,
      hireCost: 100 + (level * 50) + _rng.nextInt(50),
    );
  }
}
