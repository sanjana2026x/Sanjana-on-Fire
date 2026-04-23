import 'package:flutter/material.dart';
import 'dart:math';

class CustomGauge extends StatelessWidget {
  final int value;
  final String unit;
  final bool isDanger;

  const CustomGauge({
    super.key,
    required this.value,
    required this.unit,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(250, 250),
            painter: _DashedCirclePainter(isDanger: isDanger),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                  letterSpacing: -2,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final bool isDanger;

  _DashedCirclePainter({required this.isDanger});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = min(size.width / 2, size.height / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);
    
    final Paint paint = Paint()
      ..color = isDanger ? Colors.redAccent : const Color(0xFF00FF41)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.square;

    int dashCount = 36;
    double startAngle = -pi / 2;
    double sweepAngle = (2 * pi / dashCount) * 0.6; // 60% of the slice is painted, 40% gap

    for (int i = 0; i < dashCount; i++) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
        startAngle += 2 * pi / dashCount;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.isDanger != isDanger;
  }
}
