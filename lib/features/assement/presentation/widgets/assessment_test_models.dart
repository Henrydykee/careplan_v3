import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class AssessmentQuestion {
  final int id;
  final String text;
  final List<String> options;

  const AssessmentQuestion({
    required this.id,
    required this.text,
    required this.options,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return AssessmentQuestion(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      text: json['text']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList()
          : <String>[],
    );
  }
}

Future<List<AssessmentQuestion>> loadAssessmentQuestions(
    String assetPath) async {
  final raw = await rootBundle.loadString(assetPath);
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) {
    final list = decoded['questions'];
    if (list is List) {
      return list
          .whereType<Map<String, dynamic>>()
          .map(AssessmentQuestion.fromJson)
          .toList();
    }
  }
  return <AssessmentQuestion>[];
}
