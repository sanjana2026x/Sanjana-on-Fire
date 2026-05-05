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
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(widget.isDanger ? 0.2 : 0.05),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Track
                CustomPaint(
                  size: const Size(220, 220),
                  painter: _GaugePainter(
                    percentage: 1.0,
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 4,
                  ),
                ),
                // Progress Arc
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: (widget.value / 1000).clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CustomPaint(
                      size: const Size(220, 220),
                      painter: _GaugePainter(
                        percentage: value,
                        color: color,
                        strokeWidth: 10,
                        isDanger: widget.isDanger,
                      ),
                    );
                  },
                ),
                // Center Text
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
                            fontSize: 72,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -2,
                            height: 1,
                            shadows: [
                              Shadow(
                                color: color.withOpacity(0.8),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.unit,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: color.withOpacity(0.7),
                        letterSpacing: 4,
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

class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double strokeWidth;
  final bool isDanger;

  _GaugePainter({
    required this.percentage,
    required this.color,
    required this.strokeWidth,
    this.isDanger = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (percentage < 1.0 || !isDanger) {
       canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * percentage,
        false,
        paint,
      );
    } else {
      // Glow effect for danger
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      canvas.drawCircle(center, radius, glowPaint);
      canvas.drawCircle(center, radius, paint);
    }

    // Add some ticks
    final tickPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 2;
    
    for (int i = 0; i < 60; i++) {
      final angle = (2 * pi / 60) * i;
      final outerPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - (i % 5 == 0 ? 10 : 5)) * cos(angle),
        center.dy + (radius - (i % 5 == 0 ? 10 : 5)) * sin(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
