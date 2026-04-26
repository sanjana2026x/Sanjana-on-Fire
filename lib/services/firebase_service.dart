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
      return Stream.value(GasData(gasValue: 412, status: 'SAFE')); // Mock data if Firebase fails
    }
    return _dbRef!.child('gas_system').onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return GasData.fromMap(data);
      } else {
        return GasData(gasValue: 10, status: 'NO_DATA');
      }
    });
  }

  /// Updates the buzzer status in Firebase
  Future<void> updateBuzzer(bool enabled) async {
    if (_dbRef == null) return;
    await _dbRef!.child('gas_system').update({'buzzer_enabled': enabled});
  }
}
