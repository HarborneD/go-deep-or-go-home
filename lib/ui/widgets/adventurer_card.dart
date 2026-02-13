import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/ui/painters/character_painter.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';

class AdventurerCard extends StatelessWidget {
  final Adventurer adventurer;
  final VoidCallback? onAction;
  final String actionLabel;
  final bool enableAction;

  const AdventurerCard({
    super.key,
    required this.adventurer,
    this.onAction,
    this.actionLabel = 'Select',
    this.enableAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CustomPaint(
                painter: CharacterPainter(
                  visualDNA: adventurer.visualDNA,
                  adventurerClass: adventurer.adventurerClass,
                ),
              ),
            ),
            const Gap(8),
            Text(
              adventurer.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 18,
                color: AppTheme.accentGold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              adventurer.adventurerClass.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const Divider(color: AppTheme.organicFlesh),
            _StatRow(label: 'PWR', value: adventurer.stats.power),
            _StatRow(label: 'SPD', value: adventurer.stats.speed),
            _StatRow(
              label: 'HP',
              value: adventurer.stats.currentHealth,
              maxValue: adventurer.stats.maxHealth,
            ),
            const Spacer(),
            if (onAction != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enableAction ? onAction : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: enableAction
                        ? AppTheme.accentGold
                        : Colors.grey,
                  ),
                  child: Text(actionLabel),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int value;
  final int? maxValue;

  const _StatRow({required this.label, required this.value, this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            maxValue != null ? '$value/$maxValue' : '$value',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: (maxValue != null && value < maxValue!)
                  ? AppTheme.riskRed
                  : AppTheme.textParchment,
            ),
          ),
        ],
      ),
    );
  }
}
