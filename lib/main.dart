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
    await Firebase.initializeApp();
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
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto', // Modern readable font
          scaffoldBackgroundColor: Colors.grey[50], // Consistent clean background
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
