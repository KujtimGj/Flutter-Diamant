import 'package:flutter/material.dart';

class CurvePainterWidget extends StatelessWidget {
  const CurvePainterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvePainter(), // Your CurvePainter instance
    );
  }
}
class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.grey[600]!;
    paint.style = PaintingStyle.stroke; // Change this to fill
    paint.strokeWidth = 2;

    var path = Path();

    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
        size.width / 2, size.height / -1, size.width, size.height * 0);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}