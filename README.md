# 🔥 Sanjana-on-Fire: Smart Safety Monitoring System 🛡️

A state-of-the-art Flutter mobile application and ESP32 hardware system designed for real-time monitoring of gas levels, air quality, and fire safety.

---

## ✨ Key Features

- 🛰️ **Real-Time Monitoring**: Instant updates from Firebase showing MQ-2 and MQ-135 sensor data.
- 📊 **Multi-Sensor Dashboard**: Dedicated indicators for Smoke/LPG (MQ-2) and Air Quality (MQ-135).
- 🚨 **Remote Buzzer Control**: Arm or mute the hardware buzzer directly from the mobile app.
- 📜 **Alert History**: Detailed logs of every danger incident with accurate timestamps.
- 🎨 **Premium Cyber-HUD UI**: A sleek, dark-themed interface with glowing danger animations.

---

## 🛠️ Hardware Requirements

- **Microcontroller**: ESP32 (Any variant)
- **Gas Sensor**: MQ-2 (Smoke, LPG, CO)
- **Air Quality Sensor**: MQ-135 (NH3, Benzene, Alcohol, CO2)
- **Output**: 5V Active Buzzer
- **Others**: Breadboard and Jumper Wires

### 🔌 Wiring Diagram (Pinout)

| Component | ESP32 Pin | Type |
| :--- | :--- | :--- |
| **MQ-2 (VCC)** | 5V / VIN | Power |
| **MQ-2 (GND)** | GND | Ground |
| **MQ-2 (AO)** | **GPIO 34** | Analog Input |
| **MQ-135 (VCC)** | 5V / VIN | Power |
| **MQ-135 (GND)** | GND | Ground |
| **MQ-135 (AO)** | **GPIO 35** | Analog Input |
| **Buzzer (+)** | **GPIO 25** | Digital Output |
| **Buzzer (-)** | GND | Ground |

---

## 🚀 Software Setup

### 1. Firebase Configuration
1. Create a project in [Firebase Console](https://console.firebase.google.com/).
2. Enable **Realtime Database**.
3. Set **Rules** to allow public access (for testing):
   ```json
   {
     "rules": {
       ".read": true,
       ".write": true
     }
   }
   ```
4. Add an Android app with package name `com.example.gas_safety_app`.
5. Download `google-services.json` and place it in `android/app/`.

### 2. Database Schema (Firebase)
The hardware and software communicate using this structure:
```json
{
  "gas_system": {
    "mq2_value": 0,
    "mq135_value": 0,
    "status": "SAFE",
    "buzzer_enabled": true
  }
}
```

---

## 📟 ESP32 Firmware (Arduino Code)

Copy and upload this code using Arduino IDE. **Requires "Firebase ESP32 Client" by Mobizt.**

```cpp
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

#define WIFI_SSID "YOUR_WIFI_NAME"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"
#define API_KEY "YOUR_FIREBASE_API_KEY"
#define DATABASE_URL "YOUR_DATABASE_URL"

const int mq2Pin = 34;    
const int mq135Pin = 35;  
const int buzzerPin = 25; 
int mq2Threshold = 500;

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
//  f
void setup() {
  Serial.begin(115200);
  pinMode(mq2Pin, INPUT);
  pinMode(mq135Pin, INPUT);
  pinMode(buzzerPin, OUTPUT);
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(300);

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  Firebase.begin(&config, &auth);
}

void loop() {
  if (Firebase.ready()) {
    int mq2 = analogRead(mq2Pin);
    int mq135 = analogRead(mq135Pin);
    String status = (mq2 > mq2Threshold) ? "DANGER" : "SAFE";

    Firebase.RTDB.setInt(&fbdo, "gas_system/mq2_value", mq2);
    Firebase.RTDB.setInt(&fbdo, "gas_system/mq135_value", mq135);
    Firebase.RTDB.setString(&fbdo, "gas_system/status", status);

    if (Firebase.RTDB.getBool(&fbdo, "gas_system/buzzer_enabled")) {
      if (fbdo.to<bool>() && status == "DANGER") digitalWrite(buzzerPin, HIGH);
      else digitalWrite(buzzerPin, LOW);
    }
  }
  delay(2000);
}
```

---

## 📱 Mobile App Setup

1. Install Flutter dependencies: `flutter pub get`.
2. Connect your Android device.
3. Run the app: `flutter run --release`.

---

## 👤 Author
**Sanjana-on-Fire** 🛡️
Designed for safety and real-time monitoring.
