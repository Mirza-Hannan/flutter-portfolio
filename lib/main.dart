import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_auth/screens/home_screen.dart';
import 'package:login_signup_auth/screens/signup_screen.dart';

import 'authentications/auth_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: AppAuthService.auth.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const HomeScreen();
          }else {
            return const SignupScreen();
          }
        },),
    );
  }
}