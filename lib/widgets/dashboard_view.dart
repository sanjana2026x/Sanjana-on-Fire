import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/gas_provider.dart';
import 'custom_gauge.dart';
import 'sensor_card.dart';
import 'linear_sensor_indicator.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

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
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: isDanger ? Colors.redAccent.withOpacity(0.5) : Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      if (isDanger)
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PRIMARY SENSOR',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'GAS MONITOR',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isDanger ? 'DANGER' : 'SAFE',
                                            style: TextStyle(
                                              color: isDanger ? Colors.redAccent : const Color(0xFF00FF41),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: CustomGauge(
                                    value: data.gasValue,
                                    unit: 'PPM',
                                    isDanger: isDanger,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.history, color: Colors.grey, size: 14),
                                      const SizedBox(width: 8),
                                      Text(
                                        'LAST UPDATED: ${DateFormat('hh:mm:ss a').format(data.timestamp)}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Environment Cards
                const Row(
                  children: [
                    Expanded(
                      child: SensorCard(
                        title: 'AMBIENT TEMP',
                        value: '22.4',
                        unit: '°C',
                        icon: Icons.thermostat_outlined,
                        baseColor: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SensorCard(
                        title: 'HUMIDITY',
                        value: '45',
                        unit: '%',
                        icon: Icons.water_drop_outlined,
                        baseColor: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Auxiliary Arrays
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AUXILIARY ARRAYS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      const SizedBox(height: 8),
                      LinearSensorIndicator(
                        icon: Icons.local_fire_department_outlined,
                        label: 'LPG / Propane (MQ-2)',
                        value: '${data.mq2Value} PPM',
                        percentage: (data.mq2Value / 1024).clamp(0.0, 1.0),
                        color: data.mq2Value > 500 ? Colors.redAccent : const Color(0xFF00FF41),
                      ),
                      LinearSensorIndicator(
                        icon: Icons.air,
                        label: 'Air Quality (MQ-135)',
                        value: '${data.mq135Value} AQI',
                        percentage: (data.mq135Value / 1024).clamp(0.0, 1.0),
                        color: data.mq135Value > 300 ? Colors.orangeAccent : Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Buzzer Control Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: data.buzzerEnabled ? const Color(0xFF00FF41).withOpacity(0.3) : Colors.white.withOpacity(0.05)
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            data.buzzerEnabled ? Icons.notifications_active : Icons.notifications_off,
                            color: data.buzzerEnabled ? const Color(0xFF00FF41) : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'REMOTE BUZZER',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                data.buzzerEnabled ? 'SYSTEM ARMED' : 'SYSTEM MUTED',
                                style: TextStyle(
                                  color: data.buzzerEnabled ? Colors.white : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: data.buzzerEnabled,
                        onChanged: (val) => provider.toggleBuzzer(),
                        activeColor: const Color(0xFF00FF41),
                        activeTrackColor: const Color(0xFF00FF41).withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
