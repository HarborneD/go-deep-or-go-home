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
  final bool compact;

  const AdventurerCard({
    super.key,
    required this.adventurer,
    this.onAction,
    this.actionLabel = 'Select',
    this.enableAction = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Character Visualization
            SizedBox(
              height: compact ? 60 : 80,
              width: compact ? 60 : 80,
              child: CustomPaint(
                painter: CharacterPainter(
                  visualDNA: adventurer.visualDNA,
                  adventurerClass: adventurer.adventurerClass,
                ),
              ),
            ),
            const Gap(4),

            // Name
            Text(
              adventurer.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: compact ? 14 : 16,
                color: AppTheme.accentGold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

            // Class
            Text(
              adventurer.adventurerClass.name.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 10),
            ),
            const Divider(color: AppTheme.organicFlesh),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CompactStat(label: 'PWR', value: adventurer.stats.power),
                _CompactStat(label: 'SPD', value: adventurer.stats.speed),
                _CompactStat(
                  label: 'HP',
                  value: adventurer.stats.currentHealth,
                  maxValue: adventurer.stats.maxHealth,
                ),
              ],
            ),

            if (onAction != null) ...[
              const Gap(8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enableAction ? onAction : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: enableAction
                        ? AppTheme.accentGold
                        : Colors.grey,
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final String label;
  final int value;
  final int? maxValue;

  const _CompactStat({required this.label, required this.value, this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontSize: 9, color: Colors.white70),
        ),
        Text(
          maxValue != null ? '$value/$maxValue' : '$value',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: (maxValue != null && value < maxValue!)
                ? AppTheme.riskRed
                : AppTheme.textParchment,
          ),
        ),
      ],
    );
  }
}
