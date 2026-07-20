<div align="center">
  <img src="assets/photos/Chatly.png" alt="Chatly Logo" width="120" height="120" />

  # 💬 Chatly - Flutter Chat Application
  
  **A seamless, real-time messaging experience built with Flutter and Firebase.**

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com/)
  [![BLoC](https://img.shields.io/badge/BLoC-State%20Management-blueviolet?style=for-the-badge)](https://bloclibrary.dev/)

</div>

---

## ✨ Overview

**Chatly** is a modern, real-time chat application developed using Flutter. It implements **Clean Architecture** principles to ensure scalability, maintainability, and testability. The application leverages **Firebase** for robust real-time communication, secure authentication, and scalable data storage.

## 🚀 Key Features

- **Real-time Messaging:** Instant message delivery and reception using Cloud Firestore.
- **User Authentication:** Secure sign-up, sign-in, and session management using Firebase Auth.
- **Media Sharing:** Send and receive images effortlessly using the device camera or gallery.
- **Clean Architecture:** Well-structured codebase neatly separated into Presentation, Domain, Data, and Core layers.
- **State Management:** Reactive and predictable UI state management powered by Flutter BLoC.
- **Responsive UI:** Beautiful, intuitive, and responsive user interface designed for both iOS and Android platforms.

---

## 📸 App Screenshots

<table align="center">
  <tr>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063556.png" width="100%" /><br />
      <b>Sign Up</b>
    </td>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063353.png" width="100%" /><br />
      <b>Login</b>
    </td>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063742.png" width="100%" /><br />
      <b>Chats (Empty State)</b>
    </td>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063751.png" width="100%" /><br />
      <b>Contacts / People</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063800.png" width="100%" /><br />
      <b>Profile & Settings</b>
    </td>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063842.png" width="100%" /><br />
      <b>Update Avatar</b>
    </td>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063901.png" width="100%" /><br />
      <b>Chat Room</b>
    </td>
    <td align="center">
      <img src="app%20screens/Screenshot_20260720_063915.png" width="100%" /><br />
      <b>Recent Chats (Dark Mode)</b>
    </td>
  </tr>
</table>

---

## 🛠️ Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Flutter BLoC (`flutter_bloc`, `bloc`)
- **Backend Services:** Firebase (Cloud Firestore, Firebase Auth, Firebase Core)
- **Utilities & Tools:** 
  - `intl` (Date/Time formatting)
  - `modal_progress_hud_nsn` (Loading indicators)
  - `image_picker` (Image selection)

---

## 📁 Architecture & Folder Structure

The application strictly adheres to **Clean Architecture**, dividing the `lib/` folder into distinct, decoupled modular layers:

```text
lib/
├── core/             # Shared utilities, constants, themes, and network configurations
├── data/             # Repositories implementations, Data Sources (Firebase), and Models
├── domain/           # Entities, Use Cases, and Repository Interfaces
├── presentation/     # UI Layer: Screens, Widgets, and BLoC state managers
├── firebase_options.dart # Generated Firebase environment configuration
└── main.dart         # Entry point of the application
```

---

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `^3.8.1` or compatible)
- [Dart SDK](https://dart.dev/get-dart)
- An IDE like Android Studio, IntelliJ, or VS Code
- A Firebase project set up for this application

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd chat_app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Ensure your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) are correctly placed in their respective directories.
   - Alternatively, you can use the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) to reconfigure `firebase_options.dart` automatically.

4. **Run the Application:**
   ```bash
   flutter run
   ```