import 'package:flutter/material.dart';

void main() {
  print('Hello World');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Hello World m7', style: TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}