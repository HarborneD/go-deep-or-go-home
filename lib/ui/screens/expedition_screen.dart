import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_deep_or_go_home/models/expedition.dart';
import 'package:go_deep_or_go_home/models/resources.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/adventurer_card.dart';

class ExpeditionScreen extends ConsumerStatefulWidget {
  const ExpeditionScreen({super.key});

  @override
  ConsumerState<ExpeditionScreen> createState() => _ExpeditionScreenState();
}

class _ExpeditionScreenState extends ConsumerState<ExpeditionScreen> {
  Timer? _timer;
  double _localProgress = 0.0;
  List<String> _localLog = [];
  bool _processingEvent = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      if (_processingEvent) return;

      final expedition = ref.read(gameProvider).currentExpedition;
      if (expedition == null) {
        timer.cancel();
        return;
      }

      setState(() {
        _localProgress += 0.02; // 5 seconds
        if (_localProgress >= 1.0) {
          _localProgress = 0.0;
          _processingEvent = true;
          _triggerEvent();
        }
      });
    });
  }

  Future<void> _triggerEvent() async {
    _timer?.cancel();

    // Call Game Logic
    final result = await ref.read(gameProvider.notifier).resolveDepthSegment();
    if (!mounted) return;

    final String letterBody = result['letter'] as String;
    final List<String> logs = result['logs'] as List<String>;
    final Resources loot = result['loot'] as Resources;
    final bool isInjured = result['isInjured'] as bool;

    setState(() {
      _localLog.addAll(logs);
    });

    // Show Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.organicBrown,
          title: Text(
            'A Letter Arrives',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  letterBody,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                ),
                const Gap(16),
                const Divider(color: AppTheme.organicFlesh),
                const Gap(8),
                Text('Events:', style: Theme.of(context).textTheme.labelLarge),
                ...logs.map(
                  (l) => Text(
                    l,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(8),
                if (loot.coin > 0 || loot.metal > 0) ...[
                  Text(
                    'Loot Found:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    '${loot.coin} Coins, ${loot.metal} Metal',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
                if (isInjured)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'PARTY INJURED!',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppTheme.riskRed),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goDeeper();
              },
              child: const Text(
                'GO DEEPER',
                style: TextStyle(
                  color: AppTheme.riskRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _comeHome();
              },
              child: const Text(
                'COME HOME',
                style: TextStyle(
                  color: AppTheme.safeGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _goDeeper() {
    final expedition = ref.read(gameProvider).currentExpedition;
    if (expedition != null) {
      ref
          .read(gameProvider.notifier)
          .updateExpedition(
            expedition.copyWith(currentDepth: expedition.currentDepth + 1),
          );
      setState(() {
        _processingEvent = false;
        _localLog.add('Descended to Depth ${expedition.currentDepth + 1}');
      });
      _startTimer();
    }
  }

  void _comeHome() {
    ref
        .read(gameProvider.notifier)
        .endExpedition(success: true); // Logic handles loot banking
    Navigator.pop(context); // Go back to Guildhall
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expedition = ref.watch(
      gameProvider.select((s) => s.currentExpedition),
    );
    final party = ref.watch(gameProvider.select((s) => s.currentParty));
    final roster = ref.watch(gameProvider.select((s) => s.roster));

    if (expedition == null || party == null) {
      return const Scaffold(body: Center(child: Text("No Active Expedition")));
    }

    final partyMembers = roster
        .where((a) => party.adventurerIds.contains(a.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Depth ${expedition.currentDepth}'),
        backgroundColor: AppTheme.backgroundBlack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cannot leave without a Letter!")),
            );
          },
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _localProgress,
            backgroundColor: AppTheme.organicDarkGreen,
            color: AppTheme.accentGold,
            minHeight: 10,
          ),
          const Gap(16),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: partyMembers.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  padding: const EdgeInsets.all(8),
                  child: AdventurerCard(
                    adventurer: partyMembers[index],
                    enableAction: false,
                    actionLabel: '',
                  ),
                );
              },
            ),
          ),
          Container(
            height: 200,
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: _localLog
                  .map(
                    (l) =>
                        Text(l, style: const TextStyle(color: Colors.white70)),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
