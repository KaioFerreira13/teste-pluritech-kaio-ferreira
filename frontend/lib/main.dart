import 'package:flutter/material.dart';
import 'pages/stays_page.dart';
import 'services/stay_service.dart';

void main() => runApp(const PluritechApp());

class PluritechApp extends StatelessWidget {
  const PluritechApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pluritech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 226, 121, 0),
        ),
        useMaterial3: true,
      ),
      home: StaysPage(service: StayService()),
    );
  }
}
