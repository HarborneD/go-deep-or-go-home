import 'package:go_deep_or_go_home/services/rng_service.dart';

class NameGenerator {
  final RngService _rng;

  NameGenerator(this._rng);

  static const _prefixes = [
    'Vor',
    'Thal',
    'Kor',
    'Zan',
    'El',
    'Ar',
    'Myr',
    'Syl',
  ];
  static const _suffixes = ['goth', 'us', 'ian', 'or', 'a', 'ia', 'ra', 'th'];
  static const _titles = ['the Bold', 'the Swift', 'Star-Eye', 'Iron-Heart'];

  String generate() {
    final prefix = _rng.pickOne(_prefixes);
    final suffix = _rng.pickOne(_suffixes);

    // 20% chance for a title
    if (_rng.chance(0.2)) {
      final title = _rng.pickOne(_titles);
      return '$prefix$suffix $title';
    }

    return '$prefix$suffix';
  }
}
