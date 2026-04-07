import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String status;
  final bool animate;

  const StatusIndicator({
    super.key,
    required this.status,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDanger = status == 'DANGER';
    Color bgColor = isDanger ? Colors.redAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2);
    Color coreColor = isDanger ? Colors.redAccent : Colors.green;
    IconData iconData = isDanger ? Icons.warning_rounded : Icons.check_circle_rounded;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: coreColor,
            shape: BoxShape.circle,
            boxShadow: isDanger
                ? [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.6),
                      blurRadius: animate ? 25 : 10,
                      spreadRadius: animate ? 15 : 5,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: Colors.white, size: 50),
              const SizedBox(height: 8),
              Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
