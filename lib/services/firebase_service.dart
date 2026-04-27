import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/gas_data.dart';

class FirebaseService {
  DatabaseReference? _dbRef;

  FirebaseService() {
    try {
      _dbRef = FirebaseDatabase.instance.ref();
    } catch (e) {
      debugPrint('Firebase Database initialization error: $e');
    }
  }

  /// Returns a stream of GasData reflecting real-time updates from 'gas_system'
  Stream<GasData> get gasDataStream {
    if (_dbRef == null) {
      return Stream.value(GasData(
        mq2Value: 412, 
        mq135Value: 120, 
        status: 'SAFE', 
        buzzerEnabled: true, 
        timestamp: DateTime.now()
      )); // Mock data if Firebase fails
    }
    return _dbRef!.child('gas_system').onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return GasData.fromMap(data);
      } else {
        return GasData(
          mq2Value: 0, 
          mq135Value: 0, 
          status: 'NO_DATA', 
          buzzerEnabled: true, 
          timestamp: DateTime.now()
        );
      }
    });
  }

  /// Updates the buzzer status in Firebase
  Future<void> updateBuzzer(bool enabled) async {
    if (_dbRef == null) return;
    await _dbRef!.child('gas_system').update({'buzzer_enabled': enabled});
  }
}
