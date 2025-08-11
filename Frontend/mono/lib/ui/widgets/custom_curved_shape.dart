import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors.dart';

class CustomCurvedShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); 
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 1.3);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 1.01, 
      0,
      size.height / 1.3, 
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
