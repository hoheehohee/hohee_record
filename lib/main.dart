import 'package:flutter/material.dart';
import 'package:hohee_record/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialApp(
        title: 'Hohee Record',
        theme: ThemeData(),
        home: const SplashScreen()
      ),
    );
  }
}