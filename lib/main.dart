import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_project/authentication/welcome.dart';
import 'package:school_project/const_files/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kütüphane App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintStyle: const TextStyle(
            fontSize: 12,
            color: blueTextColor,
          ),
          filled: true,
          fillColor: whiteColor,
          labelStyle: const TextStyle(color: primaryColor),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
