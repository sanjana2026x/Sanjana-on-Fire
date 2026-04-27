class GasData {
  final int mq2Value;
  final int mq135Value;
  final String status;
  final bool buzzerEnabled;
  final DateTime timestamp;

  GasData({
    required this.mq2Value,
    required this.mq135Value,
    required this.status,
    required this.buzzerEnabled,
    required this.timestamp,
  });

  // Combined value for general display if needed, or just use mq2
  int get gasValue => mq2Value;

  factory GasData.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return GasData(
        mq2Value: 0,
        mq135Value: 0,
        status: 'UNKNOWN',
        buzzerEnabled: true,
        timestamp: DateTime.now(),
      );
    }
    
    return GasData(
      mq2Value: (map['mq2_value'] ?? map['gas_value'] ?? 0) as int,
      mq135Value: (map['mq135_value'] ?? 0) as int,
      status: (map['status'] ?? 'UNKNOWN').toString().toUpperCase(),
      buzzerEnabled: (map['buzzer_enabled'] ?? true) as bool,
      timestamp: DateTime.now(),
    );
  }

  bool get isDanger => status == 'DANGER' || mq2Value > 500;
  bool get isSafe => !isDanger;
}

class AlertLog {
  final String message;
  final int mq2Value;
  final int mq135Value;
  final DateTime timestamp;

  AlertLog({
    required this.message,
    required this.mq2Value,
    required this.mq135Value,
    required this.timestamp,
  });
}
