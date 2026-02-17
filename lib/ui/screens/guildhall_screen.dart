import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_deep_or_go_home/providers/game_provider.dart';
import 'package:go_deep_or_go_home/ui/screens/recruitment_screen.dart';
import 'package:go_deep_or_go_home/ui/screens/roster_screen.dart';
import 'package:go_deep_or_go_home/ui/screens/expedition_screen.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';
import 'package:go_deep_or_go_home/ui/widgets/resource_bar.dart';

class GuildhallScreen extends ConsumerStatefulWidget {
  const GuildhallScreen({super.key});

  @override
  ConsumerState<GuildhallScreen> createState() => _GuildhallScreenState();
}

class _GuildhallScreenState extends ConsumerState<GuildhallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('assets/images/camp_background.png', fit: BoxFit.cover),

          // Resource Bar (Overlay)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: ResourceBar()),
          ),

          // Buildings
          // Tavern (Recruitment) - Built
          _BuildingSlot(
            left: 0.05,
            top: 0.35,
            width: 0.35,
            imagePath: 'assets/images/building_tavern_built.png',
            label: 'Tavern',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecruitmentScreen()),
              );
            },
          ),

          // Gate (Expeditions/Roster) - Built
          _BuildingSlot(
            left: 0.6,
            top: 0.3,
            width: 0.35,
            imagePath: 'assets/images/building_gate_built.png',
            label: 'Gate',
            // Show badge if active expeditions exist?
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RosterScreen()),
              );
            },
          ),

          // Smithy - Under Construction
          _BuildingSlot(
            left: 0.1,
            top: 0.65,
            width: 0.3,
            imagePath: 'assets/images/building_smithy_construction.png',
            label: 'Smithy',
            onTap: () {
              _showComingSoon(context, 'Smithy - Under Construction');
            },
          ),

          // Cartographer - Vacant
          _BuildingSlot(
            left: 0.45,
            top: 0.55,
            width: 0.25,
            imagePath: 'assets/images/building_cartographer_vacant.png',
            label: 'Cartographer', // Label might not be visible for vacant?
            onTap: () {
              _showComingSoon(context, 'Cartographer Plot - Vacant');
            },
          ),

          // Wizard - Vacant
          _BuildingSlot(
            left: 0.65,
            top: 0.65,
            width: 0.25,
            imagePath: 'assets/images/building_wizard_vacant.png',
            label: 'Wizard',
            onTap: () {
              _showComingSoon(context, 'Wizard Tower Plot - Vacant');
            },
          ),

          // Active Expeditions Sidebar
          Positioned(
            left: 0,
            top: 100,
            bottom: 200, // Leave space for bottom buildings
            width: 120, // Narrow sidebar
            child: Consumer(
              builder: (context, ref, _) {
                final activeExpeditions = ref.watch(
                  gameProvider.select((s) => s.activeExpeditions),
                );
                if (activeExpeditions.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border.all(color: AppTheme.organicBrown, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Parties",
                        style: GoogleFonts.cinzel(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: activeExpeditions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final expedition = activeExpeditions[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ExpeditionScreen(
                                      expeditionId: expedition.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.organicBrown,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.textParchment.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expedition.locationId.name.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppTheme.textParchment,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Depth: ${expedition.currentDepth}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                    _ExpeditionTimer(
                                      startTime: expedition.startTime,
                                    ),
                                    if (expedition.log.isNotEmpty)
                                      Text(
                                        expedition.log.last,
                                        style: const TextStyle(
                                          color: AppTheme.accentGold,
                                          fontSize: 9,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.organicBrown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ExpeditionTimer extends StatefulWidget {
  final DateTime startTime;
  const _ExpeditionTimer({required this.startTime});

  @override
  State<_ExpeditionTimer> createState() => _ExpeditionTimerState();
}

class _ExpeditionTimerState extends State<_ExpeditionTimer> {
  late Timer _timer;
  String _elapsed = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final duration = DateTime.now().difference(widget.startTime);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (mounted) {
      setState(() {
        _elapsed = "$minutes:$seconds";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Time: $_elapsed",
      style: const TextStyle(color: Colors.white70, fontSize: 10),
    );
  }
}

class _BuildingSlot extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _BuildingSlot({
    required this.left,
    required this.top,
    required this.width,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * left,
      top: MediaQuery.of(context).size.height * top,
      width: MediaQuery.of(context).size.width * width,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(imagePath, fit: BoxFit.contain),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textParchment,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
