import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A service to handle random number generation.
/// Can be seeded for deterministic behavior (e.g., daily runs).
class RngService {
  final Random _random;

  RngService(int? seed) : _random = Random(seed);

  /// Returns a random integer between 0 (inclusive) and [max] (exclusive).
  int nextInt(int max) => _random.nextInt(max);

  /// Returns a random boolean.
  bool nextBool() => _random.nextBool();

  /// Returns a random double between 0.0 (inclusive) and 1.0 (exclusive).
  double nextDouble() => _random.nextDouble();

  /// Returns true with a probability of [probability] (0.0 to 1.0).
  bool chance(double probability) => _random.nextDouble() < probability;

  /// Returns a random element from the list.
  T pickOne<T>(List<T> items) {
    if (items.isEmpty) {
      throw ArgumentError('Cannot pick from an empty list');
    }
    return items[_random.nextInt(items.length)];
  }

  /// Returns a weighted random element from the list.
  /// [weights] must be the same length as [items].
  T pickWeighted<T>(List<T> items, List<int> weights) {
    if (items.length != weights.length) {
      throw ArgumentError('Items and weights must be the same length');
    }
    if (items.isEmpty) return items.first; // Should not happen if guarded

    int totalWeight = weights.fold(0, (sum, item) => sum + item);
    int randomWeight = _random.nextInt(totalWeight);
    int currentWeight = 0;

    for (int i = 0; i < items.length; i++) {
      currentWeight += weights[i];
      if (randomWeight < currentWeight) {
        return items[i];
      }
    }
    return items.last; // Fallback
  }
}

final rngServiceProvider = Provider<RngService>((ref) {
  // TODO: Load seed from storage or generate a daily seed.
  // For now, use a random seed.
  return RngService(DateTime.now().millisecondsSinceEpoch);
});
