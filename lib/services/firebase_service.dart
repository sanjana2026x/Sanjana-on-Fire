import 'package:firebase_database/firebase_database.dart';
import '../models/gas_data.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Returns a stream of GasData reflecting real-time updates from 'gas_system'
  Stream<GasData> get gasDataStream {
    return _dbRef.child('gas_system').onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return GasData.fromMap(data);
      } else {
        return GasData(gasValue: 0, status: 'NO_DATA');
      }
    });
  }
}
