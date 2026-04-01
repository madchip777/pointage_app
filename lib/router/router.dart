import 'package:flutter/material.dart';
import '../acceuil/acceuil.dart';
import '../connection/connection.dart';
import '../general/general.dart';
import '../historique/historique.dart';
import '../pointage/pointage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const AcceuilPage(),
        '/connection': (context) => const ConnectionPage(),
        '/general': (context) => const ConnectionPage(),
        '/historique': (context) => const ConnectionPage(),
        '/pointage': (context) => const ConnectionPage(),
      },
    );
  }
}