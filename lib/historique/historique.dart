import 'package:flutter/material.dart';

import '../pointage/pointage_repository.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  late Future<List<PointageEntry>> _futurePointages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _futurePointages = _chargerPointages();
  }

  Future<List<PointageEntry>> _chargerPointages() {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String? employeeName = args is String ? args.trim() : null;
    if (employeeName != null && employeeName.isNotEmpty) {
      return PointageRepository.getPointagesForEmployee(employeeName);
    }
    return PointageRepository.getAllPointages();
  }

  Future<void> _rafraichir() async {
    setState(() {
      _futurePointages = _chargerPointages();
    });
    await _futurePointages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des pointages')),
      body: SafeArea(
        child: FutureBuilder<List<PointageEntry>>(
          future: _futurePointages,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<PointageEntry>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur lors du chargement: ${snapshot.error}'),
                  );
                }

                final List<PointageEntry> pointages =
                    snapshot.data ?? <PointageEntry>[];
                if (pointages.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _rafraichir,
                    child: ListView(
                      children: const <Widget>[
                        SizedBox(height: 120),
                        Center(
                          child: Text(
                            'Aucun pointage enregistre pour le moment.',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _rafraichir,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: pointages.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final PointageEntry item = pointages[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.event_available),
                          title: Text(item.employeeName),
                          subtitle: Text(
                            'Date: ${item.date} | Heure: ${item.heure}',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
        ),
      ),
    );
  }
}
