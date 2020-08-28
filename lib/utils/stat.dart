import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polymathic/helpers/database.dart';

double getProductivityIndex(
    {int nUrgentImportantCompleted,
    int nUrgentCompleted,
    int nImportantCompleted,
    int nNoneCompleted,
    int nUrgentImportantAdded,
    int nUrgentAdded,
    int nImportantAdded,
    int nNoneAdded,
    double eps = 1e-5}) {
  double none = (nNoneCompleted / (nNoneAdded + eps)) * 0.5;
  double urgent = (nUrgentCompleted / (nUrgentAdded + eps)) * 1;
  double important = (nImportantCompleted / (nImportantAdded + eps)) * 2;
  double urgentImportant =
      (nUrgentImportantCompleted / (nUrgentImportantAdded + eps)) * 3;

  double score = (none + urgent + important + urgentImportant) / 6.5 * 100;

  return roundDouble(score, 2);
}

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

class Stat {
  static final String date = DateTime.now().toIso8601String();
  int id;
  final int urgent;
  final int important;
  final double duration;
  final int added;

  final int removed;

  final dbHelper = DatabaseHelper.instance;

  Stat({
    this.id,
    @required this.urgent,
    @required this.important,
    @required this.duration,
    @required this.added,
    @required this.removed,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'urgent': urgent,
      'important': important,
      'duration': duration,
      'added': added,
      'removed': removed
    };
  }
}
