import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event History'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        itemCount: mockHistory.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final event = mockHistory[index];
          final isDanger = event['status'] == 'DANGER';

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isDanger ? Colors.redAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
                child: Icon(
                  isDanger ? Icons.warning_rounded : Icons.check_circle_rounded,
                  color: isDanger ? Colors.redAccent : Colors.green,
                ),
              ),
              title: Text(
                'Status: ${event['status']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDanger ? Colors.redAccent : Colors.green,
                ),
              ),
              subtitle: Text('Recorded: ${event['time']}'),
              trailing: Text(
                '${event['value']} ppm',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
