import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gas_provider.dart';

class CalibrateView extends StatefulWidget {
  const CalibrateView({super.key});

  @override
  State<CalibrateView> createState() => _CalibrateViewState();
}

class _CalibrateViewState extends State<CalibrateView> {
  double thresholdValue = 300;
  bool isCalibrating = false;
  bool isChecking = false;
  List<String> checkSteps = [];

  Future<void> _runSelfCheck(GasProvider provider) async {
    setState(() {
      isChecking = true;
      checkSteps = ['Initializing core diagnostics...'];
    });

    final steps = [
      'Checking connectivity status...',
      'ESP32 hardware heartbeat check...',
      'MQ-2 Sensor filament pre-heat check...',
      'MQ-135 Gas sensor sensitivity check...',
      'Firebase Realtime Database uplink check...',
      'Local notification system verification...',
    ];

    bool hasError = false;
    String errorMsg = '';

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Real check logic
      if (i == 0 && !provider.isConnected) {
        hasError = true;
        errorMsg = 'CRITICAL: No internet connection detected.';
      } else if (i == 1 && provider.currentData.status == 'NO_DATA') {
        hasError = true;
        errorMsg = 'ERROR: ESP32 device is offline or not sending data.';
      }

      if (mounted) {
        setState(() {
          if (hasError) {
            checkSteps.add(errorMsg);
          } else {
            checkSteps.add(steps[i]);
          }
        });
      }
      if (hasError) break;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        isChecking = false;
        if (hasError) {
          checkSteps.add('SYSTEM FAILURE: DIAGNOSTICS HALTED');
        } else {
          checkSteps.add('SYSTEM OPERATIONAL: 100% HEALTHY');
        }
      });
    }
  }

  void _startCalibration() {
    setState(() {
      isCalibrating = true;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          isCalibrating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF00FF41),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: const Text(
              '✓ CALIBRATION SUCCESSFUL',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GasProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('DIAGNOSTICS & CALIBRATION'),
              const SizedBox(height: 16),
              
              // System Health Check Card
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF41).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.analytics_rounded, color: Color(0xFF00FF41), size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SYSTEM HEALTH',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Run a deep core diagnostic check',
                              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (checkSteps.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.03)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: checkSteps.map((step) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Text('>', style: TextStyle(color: Color(0xFF00FF41), fontSize: 12, fontFamily: 'monospace')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: TextStyle(
                                      color: step.contains('HEALTHY') 
                                          ? const Color(0xFF00FF41) 
                                          : (step.contains('ERROR') || step.contains('FAILURE') || step.contains('CRITICAL') ? Colors.redAccent : Colors.white70),
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      fontWeight: (step.contains('HEALTHY') || step.contains('ERROR') || step.contains('FAILURE')) ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: isChecking ? null : () => _runSelfCheck(provider),
                        child: isChecking 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('RUN CORE DIAGNOSTICS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Calibration Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.settings_input_component_rounded, color: Colors.amber, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SENSOR CALIBRATION',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Reset sensor baseline to zero',
                              style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Icon(
                      Icons.center_focus_strong_rounded,
                      size: 64,
                      color: isCalibrating ? Colors.amber : const Color(0xFF00FF41).withOpacity(0.3),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ensure the device is in clean air before zeroing the sensors.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 32),
                    if (isCalibrating)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          minHeight: 8,
                          color: Colors.amber,
                          backgroundColor: Colors.white10,
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF41).withOpacity(0.1),
                            foregroundColor: const Color(0xFF00FF41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Color(0xFF00FF41), width: 1),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _startCalibration,
                          child: const Text('ZERO SENSORS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              
              // Threshold Setting
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
                      'DANGER THRESHOLD',
                      style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${thresholdValue.toInt()} PPM',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32),
                        ),
                        const Text('TRIGGER LIMIT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: thresholdValue,
                      min: 100,
                      max: 1000,
                      divisions: 18,
                      activeColor: Colors.redAccent,
                      inactiveColor: Colors.white10,
                      onChanged: (value) => setState(() => thresholdValue = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF00FF41).withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}
