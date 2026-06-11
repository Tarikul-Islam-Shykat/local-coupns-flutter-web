import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueLogEntry {
  IssueLogEntry({
    required this.title,
    required this.level,
    required this.timestamp,
    this.details,
    this.imageUrl,
  });

  final String title;
  final String level;
  final DateTime timestamp;
  final String? details;
  final String? imageUrl;

  Map<String, dynamic> toJson() => {
    'title': title,
    'level': level,
    'timestamp': timestamp.toIso8601String(),
    'details': details,
    'imageUrl': imageUrl,
  };

  factory IssueLogEntry.fromJson(Map<String, dynamic> json) {
    return IssueLogEntry(
      title: (json['title'] ?? 'Log').toString(),
      level: (json['level'] ?? 'info').toString(),
      timestamp:
          DateTime.tryParse((json['timestamp'] ?? '').toString()) ??
          DateTime.now(),
      details: json['details']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }
}

class IssueLogService {
  IssueLogService._();

  static final IssueLogService instance = IssueLogService._();

  static const _storageKey = 'temp_issue_logs';
  static const _maxEntries = 50;

  final logs = <IssueLogEntry>[].obs;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          logs.assignAll(
            decoded
                .whereType<Map>()
                .map(
                  (entry) =>
                      IssueLogEntry.fromJson(Map<String, dynamic>.from(entry)),
                )
                .toList(),
          );
        }
      } catch (error, stackTrace) {
        log('IssueLogService init error: $error', stackTrace: stackTrace);
      }
    }

    _initialized = true;
  }

  Future<void> add(
    String title, {
    String level = 'info',
    String? details,
    String? imageUrl,
  }) async {
    final entry = IssueLogEntry(
      title: title,
      level: level,
      timestamp: DateTime.now(),
      details: details,
      imageUrl: imageUrl,
    );

    logs.insert(0, entry);
    if (logs.length > _maxEntries) {
      logs.removeRange(_maxEntries, logs.length);
    }

    log('[${entry.level.toUpperCase()}] ${entry.title}');
    if (entry.details != null && entry.details!.isNotEmpty) {
      log(entry.details!);
    }

    await _persist();
  }

  Future<void> clear() async {
    logs.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(logs.map((entry) => entry.toJson()).toList());
    await prefs.setString(_storageKey, payload);
  }
}
