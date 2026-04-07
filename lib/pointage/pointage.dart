import 'package:flutter/material.dart';

import 'pointage_repository.dart';

class PointagePage extends StatefulWidget {
  const PointagePage({super.key});

  @override
  State<PointagePage> createState() => _PointagePageState();
}

class _PointagePageState extends State<PointagePage> {
  bool _isSaving = false;
  late Future<List<PointageEntry>> _futurePointages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _futurePointages = _chargerPointages();
  }

  String _employeeName() {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) {
      return args.trim();
    }
    return 'Employe';
  }

  Future<List<PointageEntry>> _chargerPointages() {
    return PointageRepository.getPointagesForEmployee(_employeeName());
  }

  Future<void> _enregistrerPointage() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final PointageEntry entry = await PointageRepository.enregistrerPointage(
        _employeeName(),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _futurePointages = _chargerPointages();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pointage enregistre le ${entry.date} a ${entry.heure}.',
          ),
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
    final String employeeName = _employeeName();

    return Scaffold(
      appBar: AppBar(title: const Text('Pointage')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Employe: $employeeName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _enregistrerPointage,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.fingerprint),
                label: const Text('Enregistrer un pointage'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Derniers pointages',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<PointageEntry>>(
                  future: _futurePointages,
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<List<PointageEntry>> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Erreur: ${snapshot.error}'),
                          );
                        }

                        final List<PointageEntry> pointages =
                            snapshot.data ?? <PointageEntry>[];
                        if (pointages.isEmpty) {
                          return const Center(
                            child: Text('Aucun pointage pour cet employe.'),
                          );
                        }

                        return ListView.separated(
                          itemCount: pointages.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (BuildContext context, int index) {
                            final PointageEntry item = pointages[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.access_time),
                                title: Text(item.date),
                                subtitle: Text('Heure: ${item.heure}'),
                              ),
                            );
                          },
                        );
                      },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
