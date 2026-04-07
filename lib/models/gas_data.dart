class GasData {
  final int gasValue;
  final String status;

  GasData({
    required this.gasValue,
    required this.status,
  });

  // Factory method to parse data from Firebase Realtime Database
  factory GasData.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return GasData(gasValue: 0, status: 'UNKNOWN');
    }
    
    return GasData(
      gasValue: (map['gas_value'] ?? 0) as int,
      status: (map['status'] ?? 'UNKNOWN').toString().toUpperCase(),
    );
  }

  bool get isDanger => status == 'DANGER';
  bool get isSafe => status == 'SAFE';
}
