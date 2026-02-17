import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';

class NoticeCard extends StatelessWidget {
  final Adventurer adventurer;
  final VoidCallback? onRecruit;
  final double rotation;

  const NoticeCard({
    super.key,
    required this.adventurer,
    this.onRecruit,
    this.rotation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Constrain width
      child: Transform.rotate(
        angle: rotation,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // The Parchment Card
            Container(
              margin: const EdgeInsets.only(top: 12), // Space for the nail
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4E4BC), // Parchment color
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Name & Class
                  Text(
                    adventurer.name,
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    adventurer.adventurerClass.name.toUpperCase(),
                    style: GoogleFonts.cinzel(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(
                    color: Colors.black26,
                    thickness: 1,
                    height: 16,
                  ),

                  // Stats Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat("PWR", adventurer.stats.power),
                      _buildStat("SPD", adventurer.stats.speed),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // HP & Cost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "HP: ${adventurer.stats.maxHealth}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "${adventurer.hireCost} G",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: const Color(0xFFF4E4BC),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onRecruit,
                      child: const Text("RECRUIT"),
                    ),
                  ),
                ],
              ),
            ),

            // The Nail
            Positioned(
              top: 0,
              child: Image.asset(
                'assets/images/notice_nail.png',
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
