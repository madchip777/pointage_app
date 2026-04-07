import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PointageEntry {
  const PointageEntry({
    required this.employeeName,
    required this.date,
    required this.heure,
    required this.timestampIso,
  });

  final String employeeName;
  final String date;
  final String heure;
  final String timestampIso;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'employeeName': employeeName,
      'date': date,
      'heure': heure,
      'timestampIso': timestampIso,
    };
  }

  factory PointageEntry.fromJson(Map<String, dynamic> json) {
    return PointageEntry(
      employeeName: (json['employeeName'] ?? '') as String,
      date: (json['date'] ?? '') as String,
      heure: (json['heure'] ?? '') as String,
      timestampIso: (json['timestampIso'] ?? '') as String,
    );
  }
}

class PointageRepository {
  PointageRepository._();

  static const String _storageKey = 'pointage_entries_v1';

  static Future<List<PointageEntry>> getAllPointages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> rawEntries =
        prefs.getStringList(_storageKey) ?? <String>[];

    final List<PointageEntry> entries = rawEntries
        .map(
          (String raw) =>
              PointageEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        )
        .toList();

    entries.sort(
      (PointageEntry a, PointageEntry b) =>
          b.timestampIso.compareTo(a.timestampIso),
    );
    return entries;
  }

  static Future<List<PointageEntry>> getPointagesForEmployee(
    String employeeName,
  ) async {
    final String normalized = employeeName.trim().toLowerCase();
    final List<PointageEntry> all = await getAllPointages();
    if (normalized.isEmpty) {
      return all;
    }
    return all
        .where(
          (PointageEntry item) => item.employeeName.toLowerCase() == normalized,
        )
        .toList();
  }

  static Future<PointageEntry> enregistrerPointage(String employeeName) async {
    final String name = employeeName.trim();
    if (name.isEmpty) {
      throw ArgumentError('Le nom de l\'employe ne peut pas etre vide.');
    }

    final DateTime now = DateTime.now();
    final PointageEntry entry = PointageEntry(
      employeeName: name,
      date: _formatDate(now),
      heure: _formatHeure(now),
      timestampIso: now.toIso8601String(),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> rawEntries =
        prefs.getStringList(_storageKey) ?? <String>[];
    rawEntries.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_storageKey, rawEntries);

    return entry;
  }

  static String _formatDate(DateTime value) {
    final String day = value.day.toString().padLeft(2, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String year = value.year.toString();
    return '$day/$month/$year';
  }

  static String _formatHeure(DateTime value) {
    final String hour = value.hour.toString().padLeft(2, '0');
    final String minute = value.minute.toString().padLeft(2, '0');
    final String second = value.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}
