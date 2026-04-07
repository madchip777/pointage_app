import 'package:flutter/material.dart';

import '../pointage/pointage_repository.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  bool _isSaving = false;

  String _employeeNameFromArgs(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) {
      return args.trim();
    }
    return 'Employe';
  }

  Future<void> _pointerMaintenant(String employeeName) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final PointageEntry entry = await PointageRepository.enregistrerPointage(
        employeeName,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pointage enregistre pour ${entry.employeeName} le ${entry.date} a ${entry.heure}.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Echec de l\'enregistrement du pointage.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String employeeName = _employeeNameFromArgs(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Bienvenue, $employeeName',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Selectionnez une action :'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving
                    ? null
                    : () => _pointerMaintenant(employeeName),
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.access_time),
                label: const Text('Se pointer'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/historique',
                    arguments: employeeName,
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Voir l\'historique'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/pointage',
                    arguments: employeeName,
                  );
                },
                child: const Text('Page pointage (detail)'),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/connection',
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Se deconnecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
