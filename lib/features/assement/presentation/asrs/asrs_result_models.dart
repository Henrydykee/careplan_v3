class AsrsAnswer {
  final String id;
  final String answer;

  const AsrsAnswer({
    required this.id,
    required this.answer,
  });

  factory AsrsAnswer.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawAnswer = json['answer'];
    return AsrsAnswer(
      id: rawId?.toString() ?? '',
      answer: rawAnswer?.toString() ?? '',
    );
  }
}

class AsrsAssessmentItem {
  final String id;
  final String createdAt;
  final List<AsrsAnswer> answers;

  const AsrsAssessmentItem({
    required this.id,
    required this.createdAt,
    required this.answers,
  });

  factory AsrsAssessmentItem.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'];
    return AsrsAssessmentItem(
      id: json['id']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      answers: rawAnswers is List
          ? rawAnswers
              .whereType<Map<String, dynamic>>()
              .map(AsrsAnswer.fromJson)
              .toList()
          : <AsrsAnswer>[],
    );
  }
}

