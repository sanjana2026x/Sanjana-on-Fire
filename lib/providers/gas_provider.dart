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

  GasData _currentData = GasData(
    mq2Value: 0, 
    mq135Value: 0,
    status: 'CONNECTING...', 
    buzzerEnabled: true,
    timestamp: DateTime.now()
  );
  bool _isConnected = true;
  bool _hasTriggeredAlertForCurrentDanger = false;
  final List<AlertLog> _alertHistory = [];
  
  StreamSubscription? _gasDataSub;
  StreamSubscription? _connectivitySub;

  GasData get currentData => _currentData;
  bool get isConnected => _isConnected;
  List<AlertLog> get alertHistory => List.unmodifiable(_alertHistory);

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
            
            // Add to history
            _alertHistory.insert(0, AlertLog(
              message: 'DANGER DETECTED',
              mq2Value: _currentData.mq2Value,
              mq135Value: _currentData.mq135Value,
              timestamp: DateTime.now(),
            ));
            
            // Keep history limited to 50 items
            if (_alertHistory.length > 50) _alertHistory.removeLast();
          }
        } else {
          // Reset when back to safe
          _hasTriggeredAlertForCurrentDanger = false;
        }

        notifyListeners();
      },
      onError: (error) {
        _currentData = GasData(
          mq2Value: 0, 
          mq135Value: 0,
          status: 'ERROR', 
          buzzerEnabled: true,
          timestamp: DateTime.now()
        );
        notifyListeners();
      },
    );
  }

  Future<void> toggleBuzzer() async {
    bool newStatus = !_currentData.buzzerEnabled;
    await _firebaseService.updateBuzzer(newStatus);
    // Note: Local UI will update via the stream listener from Firebase
  }

  Future<void> refreshConnection() async {
    _gasDataSub?.cancel();
    _currentData = GasData(
      mq2Value: _currentData.mq2Value, 
      mq135Value: _currentData.mq135Value,
      status: 'REFRESHING...', 
      buzzerEnabled: _currentData.buzzerEnabled,
      timestamp: DateTime.now()
    );
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1)); // UX simulation
    _connectToFirebase();
  }

  void clearHistory() {
    _alertHistory.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _gasDataSub?.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }
}
