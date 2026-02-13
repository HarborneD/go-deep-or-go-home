import 'package:flutter/material.dart';
import 'package:go_deep_or_go_home/models/adventurer.dart';
import 'package:go_deep_or_go_home/ui/theme/app_theme.dart';

class CharacterPainter extends CustomPainter {
  final VisualDNA visualDNA;
  final AdventurerClass adventurerClass;

  CharacterPainter({required this.visualDNA, required this.adventurerClass});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Seed-based random for consistent drawing
    // In a real app, we'd use the seed to pick shapes/colors.
    // For now, just a placeholder silhouette based on class.

    // Background circle
    paint.color = AppTheme.organicBrown.withOpacity(0.5);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // Body
    paint.color = AppTheme.textParchment;
    switch (adventurerClass) {
      case AdventurerClass.vanguard:
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width * 0.6,
            height: size.height * 0.8,
          ),
          paint,
        );
        break;
      case AdventurerClass.striker:
        final path = Path()
          ..moveTo(size.width / 2, size.height * 0.1)
          ..lineTo(size.width * 0.8, size.height * 0.9)
          ..lineTo(size.width * 0.2, size.height * 0.9)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case AdventurerClass.scout:
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width * 0.5,
            height: size.height * 0.7,
          ),
          paint,
        );
        break;
      case AdventurerClass.mystic:
        paint.color = Colors.purple[200]!;
        canvas.drawCircle(
          Offset(size.width / 2, size.height * 0.4),
          size.width * 0.3,
          paint,
        );
        paint.color = AppTheme.textParchment;
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height * 0.8),
            width: size.width * 0.4,
            height: size.height * 0.4,
          ),
          paint,
        );
        break;
    }

    // Eyes (simple)
    paint.color = AppTheme.backgroundBlack;
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.4), 2, paint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
