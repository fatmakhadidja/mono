
import 'package:flutter/material.dart';
import 'package:mono/ui/widgets/custom_curved_shape.dart';


class CurvedTop extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  CurvedTop({super.key,required this.screenHeight,required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
                  children: [
                    CustomPaint(
                      size: Size(screenWidth, screenHeight * 0.4),
                      painter: CustomCurvedShape(),
                    ),
                    Image.asset("assets/images/login_shapes.png"),
                    
                  ],
                );
  }
}
