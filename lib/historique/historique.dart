import 'package:flutter/material.dart';

class HistoriquePage extends StatelessWidget {
  const HistoriquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Retour'),
        ),
      ),
    );
  }
}   