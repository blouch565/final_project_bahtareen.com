import 'package:flutter/material.dart';

class ElegantBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    
    // Define colors
    const Color primaryColor = Color(0xFF1E2A78);
    const Color secondaryColor = Color(0xFF192655);
    const Color accentColor = Color(0xFF0F1C55);
    
    // Create gradient paint
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor,
          secondaryColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    
    // Draw main background
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
    
    // Create accent paint
    final Paint accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    
    // Draw decorative shapes
    // Top right corner shape
    Path topRightPath = Path()
      ..moveTo(width * 0.7, 0)
      ..quadraticBezierTo(width * 0.85, height * 0.15, width, height * 0.1)
      ..lineTo(width, 0)
      ..close();
    
    // Bottom left corner shape
    Path bottomLeftPath = Path()
      ..moveTo(0, height * 0.8)
      ..quadraticBezierTo(width * 0.15, height * 0.85, width * 0.2, height)
      ..lineTo(0, height)
      ..close();
    
    canvas.drawPath(topRightPath, accentPaint);
    canvas.drawPath(bottomLeftPath, accentPaint);
    
    // Add subtle circles for depth
    final Paint circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(width * 0.8, height * 0.3), width * 0.15, circlePaint);
    canvas.drawCircle(Offset(width * 0.2, height * 0.7), width * 0.2, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
