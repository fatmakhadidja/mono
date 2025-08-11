import 'package:flutter/material.dart';

class CustomRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xffEEF8F7)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0 ,0) // top left
      ..lineTo(size.width, 0) // top right
      ..lineTo(size.width, size.height /1.001)
      ..lineTo(0,size.height/1.16) // Bottom right
      ..close();

    canvas.drawPath(path, paint);
  }

  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
