import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/gas_data.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';

class GasProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final NotificationService _notificationService = NotificationService();
  final Connectivity _connectivity = Connectivity();

  GasData _currentData = GasData(gasValue: 0, status: 'CONNECTING...');
  bool _isConnected = true;
  bool _hasTriggeredAlertForCurrentDanger = false;
  
  StreamSubscription? _gasDataSub;
  StreamSubscription? _connectivitySub;

  GasData get currentData => _currentData;
  bool get isConnected => _isConnected;

  GasProvider() {
    _initConnectivity();
    _connectToFirebase();
  }

  void _initConnectivity() {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        _isConnected = false;
        notifyListeners();
      } else {
        _isConnected = true;
        notifyListeners();
      }
    });
  }

  void _connectToFirebase() {
    _gasDataSub = _firebaseService.gasDataStream.listen(
      (data) {
        _currentData = data;
        
        // Alert Logic
        if (_currentData.isDanger) {
          if (!_hasTriggeredAlertForCurrentDanger) {
            _notificationService.triggerDangerAlert();
            _hasTriggeredAlertForCurrentDanger = true;
          }
        } else {
          // Reset when back to safe
          _hasTriggeredAlertForCurrentDanger = false;
        }

        notifyListeners();
      },
      onError: (error) {
        _currentData = GasData(gasValue: 0, status: 'ERROR');
        notifyListeners();
      },
    );
  }

  Future<void> refreshConnection() async {
    _gasDataSub?.cancel();
    _currentData = GasData(gasValue: _currentData.gasValue, status: 'REFRESHING...');
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1)); // UX simulation
    _connectToFirebase();
  }

  @override
  void dispose() {
    _gasDataSub?.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }
}
