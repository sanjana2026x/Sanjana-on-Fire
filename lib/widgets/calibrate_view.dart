import 'package:flutter/material.dart';

class CalibrateView extends StatefulWidget {
  const CalibrateView({super.key});

  @override
  State<CalibrateView> createState() => _CalibrateViewState();
}

class _CalibrateViewState extends State<CalibrateView> {
  double thresholdValue = 300;
  bool isCalibrating = false;

  void _startCalibration() {
    setState(() {
      isCalibrating = true;
    });

    // Simulate calibration delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isCalibrating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF00FF41),
            content: Text(
              'CALIBRATION SUCCESSFUL',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SYSTEM CALIBRATION',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 64,
                  color: isCalibrating ? Colors.amber : const Color(0xFF00FF41),
                ),
                const SizedBox(height: 24),
                Text(
                  isCalibrating ? 'CALIBRATING SENSOR...' : 'ZERO SENSOR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ensure the device is in clean air before zeroing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 32),
                
                if (isCalibrating)
                  const LinearProgressIndicator(
                    color: Colors.amber,
                    backgroundColor: Colors.white10,
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF41).withOpacity(0.1),
                        foregroundColor: const Color(0xFF00FF41),
                        side: const BorderSide(color: Color(0xFF00FF41)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      onPressed: _startCalibration,
                      child: const Text('START CALIBRATION', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            'DANGER THRESHOLD SETTING',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Trigger Level:', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${thresholdValue.toInt()} PPM',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
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
                  label: '${thresholdValue.toInt()}',
                  onChanged: (value) {
                    setState(() {
                      thresholdValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
