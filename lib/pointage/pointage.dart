import 'package:flutter/material.dart';

class PointagePage extends StatelessWidget {
  const PointagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pointage')),
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