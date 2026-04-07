import 'dart:convert';

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
      employeeName: (json['employeeName'] as String? ?? '').trim(),
      date: json['date'] as String? ?? '',
      heure: json['heure'] as String? ?? '',
      timestampIso: json['timestampIso'] as String? ?? '',
    );
  }
}

class PointageDuplicateException implements Exception {
  const PointageDuplicateException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PointageRepository {
  PointageRepository._();

  // Stockage local en memoire pour une maquette fonctionnelle simple.
  static final List<PointageEntry> _entries = <PointageEntry>[];

  static Future<PointageEntry> enregistrerPointage(String employeeName) async {
    final String normalizedName = employeeName.trim();
    if (normalizedName.isEmpty) {
      throw const PointageDuplicateException(
        'Nom employe invalide pour le pointage.',
      );
    }

    final DateTime now = DateTime.now();
    final String todayKey = _dayKey(now);

    final List<PointageEntry> existing = await _loadEntries();
    final bool alreadyExists = existing.any((PointageEntry item) {
      return item.employeeName.toLowerCase() == normalizedName.toLowerCase() &&
          _dayKeyFromIso(item.timestampIso) == todayKey;
    });

    if (alreadyExists) {
      throw const PointageDuplicateException(
        'Presence deja enregistree pour aujourd\'hui.',
      );
    }

    final PointageEntry created = PointageEntry(
      employeeName: normalizedName,
      date: _formatDate(now),
      heure: _formatHeure(now),
      timestampIso: now.toIso8601String(),
    );

    final List<PointageEntry> updated = <PointageEntry>[created, ...existing];
    await _saveEntries(updated);
    return created;
  }

  static Future<List<PointageEntry>> getAllPointages() async {
    return _loadEntries();
  }

  static Future<List<PointageEntry>> getPointagesForEmployee(
    String employeeName,
  ) async {
    final String normalizedName = employeeName.trim();
    final List<PointageEntry> all = await _loadEntries();
    return all
        .where(
          (PointageEntry item) =>
              item.employeeName.toLowerCase() == normalizedName.toLowerCase(),
        )
        .toList(growable: false);
  }

  static Future<List<PointageEntry>> _loadEntries() async {
    return List<PointageEntry>.from(_entries, growable: false);
  }

  static Future<void> _saveEntries(List<PointageEntry> entries) async {
    _entries
      ..clear()
      ..addAll(entries);
    // Touch json encode/decode to keep model mapping validated in this mock.
    final String encoded = jsonEncode(
      _entries.map((PointageEntry item) => item.toJson()).toList(),
    );
    jsonDecode(encoded) as List<dynamic>;
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
    return '$hour:$minute';
  }

  static String _dayKey(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  static String _dayKeyFromIso(String iso) {
    final DateTime? parsed = DateTime.tryParse(iso);
    if (parsed == null) {
      return '';
    }
    return _dayKey(parsed);
  }
}
