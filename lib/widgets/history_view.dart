import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for History
    final List<Map<String, dynamic>> mockHistory = [
      {'time': '2023-10-27 14:30', 'value': 450, 'status': 'DANGER'},
      {'time': '2023-10-27 14:15', 'value': 210, 'status': 'SAFE'},
      {'time': '2023-10-27 12:00', 'value': 180, 'status': 'SAFE'},
      {'time': '2023-10-26 09:30', 'value': 520, 'status': 'DANGER'},
      {'time': '2023-10-26 08:45', 'value': 150, 'status': 'SAFE'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SYSTEM LOGS / HISTORY',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: mockHistory.length,
              itemBuilder: (context, index) {
                final event = mockHistory[index];
                final isDanger = event['status'] == 'DANGER';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(4),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.05)),
                      right: BorderSide(color: Colors.white.withOpacity(0.05)),
                      bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                      left: BorderSide(
                        color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                        width: 4,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: isDanger ? Colors.redAccent.withOpacity(0.1) : const Color(0xFF00FF41).withOpacity(0.1),
                      child: Icon(
                        isDanger ? Icons.warning_rounded : Icons.check_circle_rounded,
                        color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                      ),
                    ),
                    title: Text(
                      'STATUS: ${event['status']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                        letterSpacing: 1,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'RECORDED: ${event['time']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 0.5),
                      ),
                    ),
                    trailing: Text(
                      '${event['value']} PPM',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
