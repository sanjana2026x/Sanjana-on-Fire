import 'package:flutter/material.dart';
import 'dart:math';

class CustomGauge extends StatefulWidget {
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
  State<CustomGauge> createState() => _CustomGaugeState();
}

class _CustomGaugeState extends State<CustomGauge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isDanger) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CustomGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDanger && !oldWidget.isDanger) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isDanger && oldWidget.isDanger) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDanger ? Colors.redAccent : const Color(0xFF00FF41);
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isDanger ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(widget.isDanger ? 0.3 : 0.1),
                  blurRadius: widget.isDanger ? 30 : 20,
                  spreadRadius: widget.isDanger ? 5 : 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(250, 250),
                  painter: _DashedCirclePainter(isDanger: widget.isDanger, color: color),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: widget.value.toDouble()),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: color,
                            letterSpacing: -2,
                            fontFamily: 'Roboto',
                            shadows: [
                              Shadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Text(
                      widget.unit,
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
          ),
        );
      }
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final bool isDanger;
  final Color color;

  _DashedCirclePainter({required this.isDanger, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = min(size.width / 2, size.height / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);
    
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.square;

    int dashCount = 36;
    double startAngle = -pi / 2;
    double sweepAngle = (2 * pi / dashCount) * 0.6;

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
    return oldDelegate.isDanger != isDanger || oldDelegate.color != color;
  }
}
