# Gas Safety Monitor

A complete Flutter mobile application for a "Fire & Gas Safety Alert System" utilizing real-time data from Firebase Realtime Database. 

## Features
- **Real-Time Database Syncing**: Uses Firebase to sync `gas_value` (ppm) and `status` ("SAFE" / "DANGER") in real-time.
- **Audio/Vibrate/Push Alerts**: High priority local notifications and device vibration when danger is detected.
- **Network Status Monitoring**: Checks connection and adapts the UI.
- **Clean Architecture & State Management**: Built using `provider` for structured and testable codebase.

## Setup Instructions

Since this repository tracks only the `lib` codebase, you need to set up the Flutter project scaffold and hook it into your Firebase project.

### 1. Re-initialize Flutter Framework
Open your terminal in this repository's folder (`gas_safety_app`) and run:
```bash
flutter create .
```
This generates the necessary Android and iOS runner folders.

### 2. Install Dependencies
Run the command below to fetch all pubspec.yaml dependencies:
```bash
flutter pub get
```

### 3. Initialize Firebase (via FlutterFire CLI)
You must link this app to your own Firebase Project.

1. Ensure the Firebase CLI is installed.
2. Ensure you are logged into Firebase (`firebase login`).
3. Run the FlutterFire configuration command in the root folder:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
4. Select your Firebase project (or create a new one). It will automatically generate `lib/firebase_options.dart` and add `google-services.json` to your platform folders.

### 4. Database Setup
Go to your Firebase Console -> Realtime Database.
Set up the real-time database with the following structure:
```json
{
  "gas_system": {
    "gas_value": 0,
    "status": "SAFE"
  }
}
```

Make sure your Realtime Database rules allow reading without authentication for testing (or implement Firebase Auth later):
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

### 5. Final Initialization
Open `lib/main.dart` and modify the Firebase initialization line to include the options provided by flutterfire:
```dart
import 'firebase_options.dart';

// Inside main():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 6. Run the Application!
Hook up your Android / iOS emulator or a physical device and run:
```bash
flutter run
```
