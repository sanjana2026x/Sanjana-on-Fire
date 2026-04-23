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
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                                          'CARBON DIOXIDE',
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
                                        'LAST UPDATED: ${DateFormat('hh:mm:ss a').format(DateTime.now())}',
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
                      const LinearSensorIndicator(
                        icon: Icons.local_fire_department_outlined,
                        label: 'LPG / Propane',
                        value: '0 PPM',
                        percentage: 0.1,
                        color: Color(0xFF00FF41),
                      ),
                      const LinearSensorIndicator(
                        icon: Icons.air,
                        label: 'Particulate / Smoke',
                        value: '12 PM2.5',
                        percentage: 0.25,
                        color: Colors.amber,
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
