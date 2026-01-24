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
}

/// Minimal model for K10 assessment list items. Used for mock data and display.
class K10AssessmentItem {
  final int score;
  final String createdAt;
  final K10Questions? questions;

  const K10AssessmentItem({
    required this.score,
    required this.createdAt,
    this.questions,
  });
}

/// Mock K10 assessments for when API data is null or empty.
List<K10AssessmentItem> get mockK10Assessments => [
      K10AssessmentItem(
        score: 12,
        createdAt:
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        questions: const K10Questions(
          first: 1,
          second: 1,
          third: 1,
          fourth: 1,
          fifth: 1,
          sixth: 1,
          seventh: 1,
          eighth: 1,
          ninth: 1,
          tenth: 1,
        ),
      ),
      K10AssessmentItem(
        score: 19,
        createdAt:
            DateTime.now().subtract(const Duration(days: 9)).toIso8601String(),
        questions: const K10Questions(
          first: 2,
          second: 2,
          third: 1,
          fourth: 2,
          fifth: 2,
          sixth: 1,
          seventh: 2,
          eighth: 2,
          ninth: 1,
          tenth: 2,
        ),
      ),
      K10AssessmentItem(
        score: 25,
        createdAt:
            DateTime.now().subtract(const Duration(days: 16)).toIso8601String(),
        questions: const K10Questions(
          first: 3,
          second: 2,
          third: 2,
          fourth: 3,
          fifth: 2,
          sixth: 3,
          seventh: 3,
          eighth: 2,
          ninth: 2,
          tenth: 3,
        ),
      ),
      K10AssessmentItem(
        score: 33,
        createdAt:
            DateTime.now().subtract(const Duration(days: 23)).toIso8601String(),
        questions: const K10Questions(
          first: 4,
          second: 3,
          third: 3,
          fourth: 3,
          fifth: 3,
          sixth: 4,
          seventh: 4,
          eighth: 3,
          ninth: 3,
          tenth: 3,
        ),
      ),
      K10AssessmentItem(
        score: 40,
        createdAt:
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        questions: const K10Questions(
          first: 4,
          second: 4,
          third: 4,
          fourth: 4,
          fifth: 4,
          sixth: 4,
          seventh: 4,
          eighth: 4,
          ninth: 4,
          tenth: 4,
        ),
      ),
    ];
