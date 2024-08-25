import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';

class CustomShapePainter extends CustomPainter {
  final BuildContext context;

  CustomShapePainter({super.repaint, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = context.colorScheme.primary // Adjust the color as needed
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, size.height) // Start at the bottom-right corner
      ..lineTo(0, size.height) // Line to the bottom-left corner
      ..cubicTo(
        size.width / 4,
        size.height / 4, // Inverted y-coordinate
        3 * size.width / 4,
        3 * size.height / 4, // Inverted y-coordinate
        size.width,
        0, // Top-right corner after inversion
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
