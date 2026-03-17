import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'asrs_result_models.dart';

class AsrsResultInsightScreen extends StatelessWidget {
  final AsrsAssessmentItem assessment;

  AsrsResultInsightScreen({
    super.key,
    required this.assessment,
  });

  static const _questions = [
    "How often do you have trouble wrapping up the final details of a project, once the challenging parts have been done?",
    "How often do you have difficulty getting things in order when you have to do a task that requires organization?",
    "How often do you have problems remembering appointments or obligations?",
    "When you have a task that requires a lot of thought, how often do you avoid or delay getting started?",
    "How often do you fidget or squirm with your hands or feet when you have to sit down for a long time?",
    "How often do you feel overly active and compelled to do things, like you were driven by a motor?",
    "How often do you make careless mistakes when you have to work on a boring or difficult project?",
    "How often do you have difficulty keeping your attention when you are doing boring or repetitive work?",
    "How often do you have difficulty concentrating on what people say to you, even when they are speaking to you directly?",
    "How often do you misplace or have difficulty finding things at home or at work?",
    "How often are you distracted by activity or noise around you?",
    "How often do you leave your seat in meetings or other situations in which you are expected to remain seated?",
    "How often do you feel restless or fidgety?",
    "How often do you have difficulty unwinding and relaxing when you have time to yourself?",
    "How often do you find yourself talking too much when you are in social situations?",
    "When you're in a conversation, how often do you find yourself finishing the sentences of the people you are talking to, before they can finish them themselves?",
    "How often do you have difficulty waiting your turn in situations when turn taking is required?",
    "How often do you interrupt others when they are busy?",
  ];

  String _answerForIndex(int index) {
    final questionId = (index + 1).toString();
    final match = assessment.answers.firstWhere(
      (a) => a.id == questionId,
      orElse: () => const AsrsAnswer(id: '', answer: ''),
    );
    final value = match.answer.trim();
    if (value.isEmpty) {
      return 'No answer';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM d, y').format(
      DateTime.tryParse(assessment.createdAt) ?? DateTime.now(),
    );

    return Scaffold(
      backgroundColor: CarePlanColor.brown,
      appBar: CustomAppBar(
        showBackIcon: true,
        color: CarePlanColor.brown,
        backButtonColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: CarePlanColor.brown,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "ASRS Result",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: formattedDate,
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final rawAnswer = _answerForIndex(index);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: QuestionCard(
                      question: _questions[index],
                      answer: rawAnswer,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String answer;
  final String question;

  const QuestionCard({
    super.key,
    required this.answer,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF5F5F5), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4E4F51),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
                activeColor: CarePlanColor.orange,
              ),
              Text(
                toBeginningOfSentenceCase(answer.replaceAll("_", " ")),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
