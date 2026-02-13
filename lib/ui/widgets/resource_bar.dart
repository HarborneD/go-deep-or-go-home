import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/models/resources.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';

class ResourceBar extends ConsumerWidget {
  const ResourceBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resources = ref.watch(gameProvider.select((s) => s.resources));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppTheme.organicDarkGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ResourceItem(
            label: 'C',
            value: resources.coin,
            color: AppTheme.accentGold,
          ),
          _ResourceItem(
            label: 'W',
            value: resources.wood,
            color: Colors.brown[300]!,
          ),
          _ResourceItem(
            label: 'M',
            value: resources.metal,
            color: Colors.blueGrey,
          ),
          _ResourceItem(
            label: 'L',
            value: resources.leather,
            color: Colors.orange[800]!,
          ),
          _ResourceItem(
            label: 'K',
            value: resources.coal,
            color: Colors.black87,
          ),
          _ResourceItem(
            label: 'Cry',
            value: resources.crystals,
            color: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }
}

class _ResourceItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ResourceItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(2),
        Text(
          '$value',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
