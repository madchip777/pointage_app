import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PointagePage extends StatefulWidget {
  const PointagePage({super.key});

  @override
  State<PointagePage> createState() => _PointagePageState();
}

class _PointagePageState extends State<PointagePage> {
  static const String _utilisateurPlaceholder = 'Utilisateur (placeholder)';

  final TextEditingController _rechercheController = TextEditingController();

  DateTime _jourFocus = DateTime(2026, 1, 1);
  DateTime _jourSelectionne = DateTime(2026, 1, 1);

  final Map<String, PresenceJour> _presences = <String, PresenceJour>{};

  @override
  void initState() {
    super.initState();
    _rechercheController.text = _formatDateFr(_jourSelectionne);
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  String _cleJour(DateTime date) {
    final DateTime dateOnly = DateTime(date.year, date.month, date.day);
    final String mois = dateOnly.month.toString().padLeft(2, '0');
    final String jour = dateOnly.day.toString().padLeft(2, '0');
    return '${dateOnly.year}-$mois-$jour';
  }

  PresenceJour _presencePour(DateTime date) {
    return _presences[_cleJour(date)] ?? const PresenceJour();
  }

  void _validerPresence({required bool matin, required bool soir}) {
    final String cle = _cleJour(_jourSelectionne);
    setState(() {
      _presences[cle] = PresenceJour(matin: matin, soir: soir);
    });
  }

  String _formatDateFr(DateTime date) {
    final String jour = date.day.toString().padLeft(2, '0');
    final String mois = date.month.toString().padLeft(2, '0');
    return '$jour/$mois/${date.year}';
  }

  DateTime? _parseDateFr(String value) {
    final RegExpMatch? match = RegExp(r'^\s*(\d{1,2})/(\d{1,2})/(\d{4})\s*$').firstMatch(value);
    if (match == null) {
      return null;
    }

    final int? jour = int.tryParse(match.group(1)!);
    final int? mois = int.tryParse(match.group(2)!);
    final int? annee = int.tryParse(match.group(3)!);
    if (jour == null || mois == null || annee == null) {
      return null;
    }

    final DateTime date = DateTime(annee, mois, jour);
    if (date.year != annee || date.month != mois || date.day != jour) {
      return null;
    }

    return date;
  }

  void _rechercherDate() {
    final DateTime? date = _parseDateFr(_rechercheController.text);
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date invalide. Format attendu : JJ/MM/AAAA')),
      );
      return;
    }

    setState(() {
      _jourSelectionne = date;
      _jourFocus = date;
      _rechercheController.text = _formatDateFr(date);
    });
  }

  String _titreMois(DateTime date) {
    const List<String> mois = <String>[
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
    return '${mois[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final PresenceJour presenceSelectionnee = _presencePour(_jourSelectionne);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pointage de presence'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _utilisateurPlaceholder,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _rechercheController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Rechercher une date',
                  hintText: 'JJ/MM/AAAA',
                  prefixIcon: const Icon(Icons.event_outlined),
                  suffixIcon: IconButton(
                    onPressed: _rechercherDate,
                    icon: const Icon(Icons.search),
                  ),
                ),
                onSubmitted: (_) => _rechercherDate(),
              ),
              const SizedBox(height: 12),
              _carteCalendrier(),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Date selectionnee : ${_formatDateFr(_jourSelectionne)}'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () => _validerPresence(matin: true, soir: false),
                            icon: const Icon(Icons.wb_sunny_outlined),
                            label: const Text('Valider Matin'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _validerPresence(matin: false, soir: true),
                            icon: const Icon(Icons.nightlight_round_outlined),
                            label: const Text('Valider Soir'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _validerPresence(matin: true, soir: true),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Valider Journee'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _validerPresence(matin: false, soir: false),
                            icon: const Icon(Icons.clear),
                            label: const Text('Reinitialiser'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Etat actuel : ${presenceSelectionnee.libelle}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carteCalendrier() {
    final PresenceJour presenceSelectionnee = _presencePour(_jourSelectionne);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _titreMois(_jourFocus),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TableCalendar<PresenceJour>(
              firstDay: DateTime(1900, 1, 1),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: _jourFocus,
              calendarFormat: CalendarFormat.month,
              availableGestures: AvailableGestures.horizontalSwipe,
              locale: 'fr_FR',
              selectedDayPredicate: (DateTime day) => isSameDay(_jourSelectionne, day),
              eventLoader: (DateTime day) => <PresenceJour>[_presencePour(day)],
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                setState(() {
                  _jourSelectionne = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                  _jourFocus = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
                  _rechercheController.text = _formatDateFr(_jourSelectionne);
                });
              },
              onPageChanged: (DateTime focusedDay) {
                setState(() {
                  _jourFocus = focusedDay;
                });
              },
              headerVisible: false,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                todayDecoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueGrey.shade700,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: presenceSelectionnee.couleur,
                  shape: BoxShape.circle,
                ),
                markerSize: 10,
                markersMaxCount: 1,
                defaultTextStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
              calendarBuilders: CalendarBuilders<PresenceJour>(
                defaultBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
                  final PresenceJour presence = _presencePour(day);
                  return _caseJour(day, presence, false);
                },
                todayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
                  final PresenceJour presence = _presencePour(day);
                  return _caseJour(day, presence, false, estAujourdHui: true);
                },
                selectedBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
                  final PresenceJour presence = _presencePour(day);
                  return _caseJour(day, presence, true);
                },
                outsideBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
                  final PresenceJour presence = _presencePour(day);
                  return _caseJour(day, presence, false, estHorsMois: true);
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Etat du jour selectionne : ${presenceSelectionnee.libelle}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _caseJour(
    DateTime day,
    PresenceJour presence,
    bool estSelectionne, {
    bool estAujourdHui = false,
    bool estHorsMois = false,
  }) {
    final Color fond = presence.couleur;
    final Color bordure = estSelectionne
        ? Colors.blueGrey.shade800
        : estAujourdHui
            ? Colors.blueGrey.shade300
            : Colors.transparent;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: estHorsMois ? Colors.grey.shade50 : fond,
        shape: BoxShape.circle,
        border: Border.all(color: bordure, width: estSelectionne || estAujourdHui ? 2 : 0),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: presence.texte,
          fontWeight: estSelectionne ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }
}   

class PresenceJour {
  const PresenceJour({this.matin = false, this.soir = false});

  final bool matin;
  final bool soir;

  bool get estVide => !matin && !soir;

  String get libelle {
    if (matin && soir) {
      return 'Matin et Soir valides';
    }
    if (matin) {
      return 'Presence validee le Matin';
    }
    if (soir) {
      return 'Presence validee le Soir';
    }
    return 'Aucune presence validee';
  }

  Color get couleur {
    if (matin && soir) {
      return Colors.green.shade700;
    }
    if (matin || soir) {
      return Colors.green.shade300;
    }
    return Colors.grey.shade100;
  }

  Color get texte {
    if (estVide) {
      return Colors.black87;
    }
    return Colors.white;
  }
}