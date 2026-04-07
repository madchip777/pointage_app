import 'package:flutter/material.dart';

import '../pointage/pointage_repository.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  late Future<List<PointageEntry>> _futurePointages;
  late DateTime _displayedMonth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);
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

  DateTime? _parseDateFromEntry(PointageEntry item) {
    final DateTime? fromIso = DateTime.tryParse(item.timestampIso);
    if (fromIso != null) {
      return DateTime(fromIso.year, fromIso.month, fromIso.day);
    }

    final List<String> parts = item.date.split('/');
    if (parts.length == 3) {
      final int? day = int.tryParse(parts[0]);
      final int? month = int.tryParse(parts[1]);
      final int? year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  Set<int> _presenceDaysForMonth(List<PointageEntry> entries) {
    final Set<int> days = <int>{};
    for (final PointageEntry item in entries) {
      final DateTime? d = _parseDateFromEntry(item);
      if (d == null) {
        continue;
      }
      if (d.year == _displayedMonth.year && d.month == _displayedMonth.month) {
        days.add(d.day);
      }
    }
    return days;
  }

  String _monthLabel(DateTime value) {
    const List<String> months = <String>[
      'Janvier',
      'Fevrier',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Aout',
      'Septembre',
      'Octobre',
      'Novembre',
      'Decembre',
    ];
    return '${months[value.month - 1]} ${value.year}';
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
      );
    });
  }

  Widget _buildCalendar(List<PointageEntry> entries) {
    final Set<int> activeDays = _presenceDaysForMonth(entries);
    final int firstWeekday = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    ).weekday;
    final int offset = firstWeekday - 1;
    final int daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    _monthLabel(_displayedMonth),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: <Widget>[
                Expanded(child: Center(child: Text('Lun'))),
                Expanded(child: Center(child: Text('Mar'))),
                Expanded(child: Center(child: Text('Mer'))),
                Expanded(child: Center(child: Text('Jeu'))),
                Expanded(child: Center(child: Text('Ven'))),
                Expanded(child: Center(child: Text('Sam'))),
                Expanded(child: Center(child: Text('Dim'))),
              ],
            ),
            const SizedBox(height: 6),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.3,
              ),
              itemCount: offset + daysInMonth,
              itemBuilder: (BuildContext context, int index) {
                if (index < offset) {
                  return const SizedBox.shrink();
                }

                final int day = index - offset + 1;
                final bool isActive = activeDays.contains(day);
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueGrey.shade100),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isActive
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.black87,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Les jours colores correspondent aux presences enregistrees.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  List<PointageEntry> _entriesForDisplayedMonth(List<PointageEntry> entries) {
    return entries.where((PointageEntry item) {
      final DateTime? d = _parseDateFromEntry(item);
      if (d == null) {
        return false;
      }
      return d.year == _displayedMonth.year && d.month == _displayedMonth.month;
    }).toList();
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
                final List<PointageEntry> monthEntries =
                    _entriesForDisplayedMonth(pointages);

                return RefreshIndicator(
                  onRefresh: _rafraichir,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: <Widget>[
                      _buildCalendar(pointages),
                      const SizedBox(height: 12),
                      const Text(
                        'Historique du mois selectionne',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (monthEntries.isEmpty)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Aucun pointage pour ce mois.'),
                          ),
                        )
                      else
                        ...monthEntries.map((PointageEntry item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Card(
                              child: ListTile(
                                leading: const Icon(Icons.event_available),
                                title: Text(item.employeeName),
                                subtitle: Text(
                                  'Date: ${item.date} | Heure: ${item.heure}',
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                );
              },
        ),
      ),
    );
  }
}
