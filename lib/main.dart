import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/gas_provider.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDsPHtnfXomV0DhJfPpldkz0-J4LiYiB9A',
        appId: '1:884072465646:web:d630ab56af859a2eadfff',
        messagingSenderId: '884072465646',
        projectId: 'smartgasmonitor-bb0ed',
        databaseURL: 'https://smartgasmonitor-bb0ed-default-rtdb.asia-southeast1.firebasedatabase.app/',
        storageBucket: 'smartgasmonitor-bb0ed.firebasestorage.app',
      ),
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // For a real app, you might want to handle this gracefully if the google-services.json is missing
  }

  // Initialize Local Notifications
  await NotificationService().init();

  runApp(const GasSafetyApp());
}

class GasSafetyApp extends StatelessWidget {
  const GasSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GasProvider()),
      ],
      child: MaterialApp(
        title: 'Gas Safety Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF00FF41),
          scaffoldBackgroundColor: const Color(0xFF151515),
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
