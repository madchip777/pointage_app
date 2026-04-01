import 'package:flutter/material.dart';
import '../accueil/accueil.dart';
import '../connection/connection.dart';
import '../inscription/inscription.dart';
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
        '/': (context) => const AccueilPage(),
        '/connection': (context) => const ConnectionPage(),
        '/inscription': (context) => const InscriptionPage(),
        '/general': (context) => const GeneralPage(),
        '/historique': (context) => const HistoriquePage(),
        '/pointage': (context) => const PointagePage(),
      },
    );
  }
}