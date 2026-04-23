import 'package:flutter/material.dart';

class AlertsView extends StatefulWidget {
  const AlertsView({super.key});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  bool pushNotifications = true;
  bool smsAlerts = false;
  bool soundAlarm = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ALERT CONFIGURATION',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Settings Container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Receive alerts on your device', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: pushNotifications,
                  activeColor: const Color(0xFF00FF41),
                  onChanged: (bool value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),
                Divider(color: Colors.white.withOpacity(0.1), height: 1),
                SwitchListTile(
                  title: const Text('SMS Alerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Send texts to emergency contacts', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: smsAlerts,
                  activeColor: const Color(0xFF00FF41),
                  onChanged: (bool value) {
                    setState(() {
                      smsAlerts = value;
                    });
                  },
                ),
                Divider(color: Colors.white.withOpacity(0.1), height: 1),
                SwitchListTile(
                  title: const Text('Sound Alarm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Play siren on critical danger', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: soundAlarm,
                  activeColor: const Color(0xFF00FF41),
                  onChanged: (bool value) {
                    setState(() {
                      soundAlarm = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          const Text(
            'ACTIVE NOTIFICATIONS',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Dummy Active Notification
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SENSOR MAINTENANCE',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Primary CO2 sensor requires recalibration within 5 days.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
