/// Minimal model for K10 question scores. Used when navigating to insight.
class K10Questions {
  final int? first;
  final int? second;
  final int? third;
  final int? fourth;
  final int? fifth;
  final int? sixth;
  final int? seventh;
  final int? eighth;
  final int? ninth;
  final int? tenth;

  const K10Questions({
    this.first,
    this.second,
    this.third,
    this.fourth,
    this.fifth,
    this.sixth,
    this.seventh,
    this.eighth,
    this.ninth,
    this.tenth,
  });

  /// Builds a [K10Questions] instance from the API `questions` array.
  ///
  /// The API returns a list of objects with:
  ///  - `field`: one of `first` ... `tenth`
  ///  - `answer`: numeric value
  factory K10Questions.fromApiQuestions(List<dynamic> questionsJson) {
    int? _scoreFor(String fieldKey) {
      Map<String, dynamic>? match;
      for (final item in questionsJson) {
        if (item is Map<String, dynamic> && item['field'] == fieldKey) {
          match = item;
          break;
        }
      }
      final value = match?['answer'];
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '');
    }

    return K10Questions(
      first: _scoreFor('first'),
      second: _scoreFor('second'),
      third: _scoreFor('third'),
      fourth: _scoreFor('fourth'),
      fifth: _scoreFor('fifth'),
      sixth: _scoreFor('sixth'),
      seventh: _scoreFor('seventh'),
      eighth: _scoreFor('eighth'),
      ninth: _scoreFor('ninth'),
      tenth: _scoreFor('tenth'),
    );
  }
}

/// Minimal model for K10 assessment list items. Used for display.
class K10AssessmentItem {
  final int score;
  final String createdAt;
  final K10Questions? questions;

  const K10AssessmentItem({
    required this.score,
    required this.createdAt,
    this.questions,
  });

  factory K10AssessmentItem.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'];
    return K10AssessmentItem(
      score: (json['score'] is num) ? (json['score'] as num).toInt() : int.tryParse(json['score']?.toString() ?? '') ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
      questions: questionsJson is List
          ? K10Questions.fromApiQuestions(questionsJson)
          : null,
    );
  }
}
