import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_deep_or_go_home/models/expedition.dart';
import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class GameEventListener extends ConsumerStatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const GameEventListener({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  ConsumerState<GameEventListener> createState() => _GameEventListenerState();
}

class _GameEventListenerState extends ConsumerState<GameEventListener> {
  bool _isShowingDialog = false;

  @override
  Widget build(BuildContext context) {
    // Listen for completed expeditions
    ref.listen<
      List<Expedition>
    >(gameProvider.select((s) => s.completedExpeditions), (prev, next) {
      // print("DEBUG: Completed Expeditions Changed: ${prev?.length} -> ${next.length}");
      if (next.isNotEmpty && !_isShowingDialog) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isShowingDialog) {
            _showExpeditionResult(next.first);
          }
        });
      }
    });

    // Initial check
    final completed = ref.read(gameProvider).completedExpeditions;
    if (completed.isNotEmpty && !_isShowingDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isShowingDialog) {
          final currentCompleted = ref.read(gameProvider).completedExpeditions;
          if (currentCompleted.isNotEmpty) {
            _showExpeditionResult(currentCompleted.first);
          }
        }
      });
    }

    return widget.child;
  }

  Future<void> _showExpeditionResult(Expedition expedition) async {
    // We use the navigatorKey to show the dialog
    final navContext = widget.navigatorKey.currentState?.context;
    // Check if navigator is mounted
    if (navContext == null || !widget.navigatorKey.currentState!.mounted)
      return;

    _isShowingDialog = true;

    await showDialog(
      context: navContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF4E4BC), // Parchment
          title: Text(
            expedition.status == ExpeditionStatus.completed
                ? "Expedition Returned!"
                : "Expedition Report",
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Location: ${expedition.locationId.name.toUpperCase()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Depth Reached: ${expedition.currentDepth}"),
                const Divider(color: Colors.black54),

                Text(
                  "Loot Recovered:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("🪙 ${expedition.accumulatedLoot.coin} Gold"),
                Text("⚒️ ${expedition.accumulatedLoot.metal} Metal"),
                const Divider(color: Colors.black54),

                Text(
                  "Log:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...expedition.log
                    .take(5)
                    .map(
                      (l) => Text("- $l", style: const TextStyle(fontSize: 12)),
                    ),
                if (expedition.log.length > 5)
                  Text(
                    "...and ${expedition.log.length - 5} more.",
                    style: const TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Dismiss",
                style: TextStyle(
                  color: AppTheme.organicDarkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    _isShowingDialog = false;
    // Dismiss from state
    if (mounted) {
      ref.read(gameProvider.notifier).dismissCompletedExpedition(expedition.id);
    }
  }
}
