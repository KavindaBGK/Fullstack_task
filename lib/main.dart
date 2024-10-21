import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Dashboard.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC2ugP_fb-gNtd8nuZHK9GJlHnzvD49oKM",
          authDomain: "inhouse-flutter.firebaseapp.com",
          projectId: "inhouse-flutter",
          storageBucket: "inhouse-flutter.appspot.com",
          messagingSenderId: "62311234461",
          appId: "1:62311234461:web:5e7d6e759938d4b8404d74",
          measurementId: "G-K2ESS8DVG5"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 5000,
        splash: Center(
          child: Container(
            child: Image.asset('assets/images/healthcare_logo.png'),
          ),
        ),
        splashIconSize: 240,
        nextScreen: Dashboard(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
