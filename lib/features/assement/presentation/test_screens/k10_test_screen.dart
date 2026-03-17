import 'dart:convert';

import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gap/gap.dart';

class K10TestScreen extends StatefulWidget {
  const K10TestScreen({super.key});

  @override
  State<K10TestScreen> createState() => _K10TestScreenState();
}

class _K10TestScreenState extends State<K10TestScreen> {
  late Future<List<_K10Question>> _questionsFuture;
  int _currentIndex = 0;
  final Map<int, int> _selectedOptionIndexByQuestionId = {};

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
  }

  Future<List<_K10Question>> _loadQuestions() async {
    final raw = await rootBundle.loadString('assets/k10_questions.json');
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      final list = decoded['questions'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map(_K10Question.fromJson)
            .toList();
      }
    }
    return <_K10Question>[];
  }

  void _goToNext(int total) {
    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex += 1;
      });
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        color: CarePlanColor.brown,
        backButtonColor: Colors.white,
      ),
      body: FutureBuilder<List<_K10Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }

          final questions = snapshot.data ?? const <_K10Question>[];
          if (questions.isEmpty) {
            return Center(
              child: TextHolder(
                title: 'No questions available.',
                size: 14,
                fontWeight: FontWeight.w500,
                color: CarePlanColor.black_3,
              ),
            );
          }

          final question = questions[_currentIndex];
          final total = questions.length;
          final selectedIndex = _selectedOptionIndexByQuestionId[question.id];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                color: CarePlanColor.brown,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: 'K10 Test',
                      size: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    const Gap(4),
                    TextHolder(
                      title: 'Question ${_currentIndex + 1} of $total',
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: question.text,
                        size: 16,
                        fontWeight: FontWeight.w700,
                        color: CarePlanColor.black_3,
                      ),
                      const Gap(24),
                      ...List.generate(question.options.length, (index) {
                        final option = question.options[index];
                        final isSelected = selectedIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOptionIndexByQuestionId[question.id] = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isSelected ? CarePlanColor.light_orange : Colors.white,
                                border: Border.all(
                                  color: isSelected ? CarePlanColor.orange : const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? CarePlanColor.orange : CarePlanColor.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CarePlanColor.orange,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: TextHolder(
                                      title: option,
                                      size: 14,
                                      fontWeight: FontWeight.w500,
                                      color: CarePlanColor.black_3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    if (_currentIndex > 0)
                      Expanded(
                        child: CustomButtom(
                          title: 'Previous',
                          btnColor: CarePlanColor.brown,
                          onTap: _goToPrevious,
                        ),
                      ),
                    if (_currentIndex > 0) const Gap(12),
                    Expanded(
                      child: CustomButtom(
                        title: _currentIndex == total - 1 ? 'Finish' : 'Next',
                        btnColor: CarePlanColor.brown,
                        onTap: () {
                          if (selectedIndex == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an option to continue.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          if (_currentIndex == total - 1) {
                            Navigator.of(context).pop();
                          } else {
                            _goToNext(total);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _K10Question {
  final int id;
  final String text;
  final List<String> options;

  const _K10Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory _K10Question.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return _K10Question(
      id: (json['id'] is int) ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      text: json['text']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList()
          : <String>[],
    );
  }
}

