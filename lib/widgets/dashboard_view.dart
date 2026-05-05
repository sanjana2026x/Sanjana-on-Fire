import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/gas_provider.dart';
import 'custom_gauge.dart';
import 'sensor_card.dart';
import 'linear_sensor_indicator.dart';
import '../services/emergency_service.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  void _showEmergencyOptions(BuildContext context) {
    final emergencyService = EmergencyService();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'EMERGENCY ACTIONS',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
            const SizedBox(height: 32),
            _buildEmergencyButton(
              icon: Icons.phone_in_talk_rounded,
              label: 'CALL EMERGENCY CONTACT',
              color: Colors.white.withOpacity(0.05),
              onTap: () async {
                final contact = await emergencyService.getContact();
                if (contact != null) {
                  emergencyService.makeCall(contact);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No emergency contact set! Go to Profile.')),
                    );
                  }
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildEmergencyButton(
              icon: Icons.message_rounded,
              label: 'SEND SOS SMS',
              color: Colors.white.withOpacity(0.05),
              onTap: () async {
                final contact = await emergencyService.getContact();
                if (contact != null) {
                  emergencyService.sendSMS(contact, 'GAS LEAK DETECTED AT HOME! PLEASE HELP!');
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildEmergencyButton(
              icon: Icons.emergency_share_rounded,
              label: 'CALL 999 (EMERGENCY)',
              color: Colors.redAccent.withOpacity(0.1),
              textColor: Colors.redAccent,
              onTap: () {
                emergencyService.launchEmergencyServices();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GasProvider>(
      builder: (context, provider, child) {
        final data = provider.currentData;
        final isDanger = data.isDanger;
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Primary Sensor Card
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDanger ? Colors.redAccent.withOpacity(0.2) : const Color(0xFF00FF41).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PRIMARY SENSOR',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 11,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'GAS MONITOR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDanger ? Colors.redAccent.withOpacity(0.1) : const Color(0xFF00FF41).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDanger ? Colors.redAccent.withOpacity(0.3) : const Color(0xFF00FF41).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isDanger ? 'DANGER' : 'SECURE',
                                      style: TextStyle(
                                        color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isDanger) ...[
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: () => _showEmergencyOptions(context),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.sos_rounded, color: Colors.white, size: 28),
                                    SizedBox(width: 12),
                                    Text(
                                      'SOS EMERGENCY ACTION',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 48),
                          Center(
                            child: CustomGauge(
                              value: data.gasValue,
                              unit: 'PPM',
                              isDanger: isDanger,
                            ),
                          ),
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.sync_rounded, color: Colors.grey, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'LAST UPDATED: ${DateFormat('hh:mm:ss a').format(data.timestamp)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Auxiliary Arrays
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SENSOR ARRAY STATUS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LinearSensorIndicator(
                        icon: Icons.local_fire_department_outlined,
                        label: 'COMBUSTIBLE GAS (MQ-2)',
                        value: '${data.mq2Value} UNITS',
                        percentage: (data.mq2Value / 4096).clamp(0.0, 1.0),
                        color: data.mq2Value > 1500 ? Colors.redAccent : const Color(0xFF00FF41),
                      ),
                      const SizedBox(height: 16),
                      LinearSensorIndicator(
                        icon: Icons.air_rounded,
                        label: 'AIR POLLUTANTS (MQ-135)',
                        value: '${data.mq135Value} UNITS',
                        percentage: (data.mq135Value / 4096).clamp(0.0, 1.0),
                        color: data.mq135Value > 1200 ? Colors.orangeAccent : Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Buzzer Control Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: data.buzzerEnabled ? const Color(0xFF00FF41).withOpacity(0.2) : Colors.white.withOpacity(0.05)
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: data.buzzerEnabled ? const Color(0xFF00FF41).withOpacity(0.1) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          data.buzzerEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                          color: data.buzzerEnabled ? const Color(0xFF00FF41) : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'REMOTE BUZZER',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.buzzerEnabled ? 'SYSTEM ARMED' : 'SYSTEM MUTED',
                              style: TextStyle(
                                color: data.buzzerEnabled ? Colors.white : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: data.buzzerEnabled,
                        onChanged: (val) => provider.toggleBuzzer(),
                        activeColor: const Color(0xFF00FF41),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // System Info Footer
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.terminal_rounded, color: Colors.white.withOpacity(0.2), size: 14),
                        const SizedBox(width: 8),
                        Text(
                          'HUD v2.0 - SECURE CORE ACTIVE',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Fan and Light Controls
                Row(
                  children: [
                    // Fan Control
                    Expanded(
                      child: _buildToggleCard(
                        icon: data.fanStatus ? Icons.wind_power_rounded : Icons.mode_fan_off_rounded,
                        label: 'EXHAUST FAN',
                        status: data.fanStatus ? 'ON' : 'OFF',
                        value: data.fanStatus,
                        activeColor: Colors.blueAccent,
                        onChanged: (val) => provider.toggleFan(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Light Control
                    Expanded(
                      child: _buildToggleCard(
                        icon: data.lightStatus ? Icons.lightbulb : Icons.lightbulb_outline,
                        label: 'KITCHEN LIGHT',
                        status: data.lightStatus ? 'ON' : 'OFF',
                        value: data.lightStatus,
                        activeColor: Colors.yellowAccent,
                        onChanged: (val) => provider.toggleLight(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required String label,
    required String status,
    required bool value,
    required Color activeColor,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: value ? activeColor.withOpacity(0.3) : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: value ? activeColor : Colors.grey, size: 20),
              SizedBox(
                height: 24,
                width: 40,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: activeColor,
                  activeTrackColor: activeColor.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: value ? Colors.white : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
