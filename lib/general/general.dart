import 'package:flutter/material.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('General')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/accueil', (Route route) => false);
          },
          child: const Text('Se deconecter'),
        ),
      ),
    );
  }
}   