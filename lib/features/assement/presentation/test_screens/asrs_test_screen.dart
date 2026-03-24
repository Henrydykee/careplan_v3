import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gap/gap.dart';

class AsrsTestScreen extends StatefulWidget {
  const AsrsTestScreen({super.key});

  @override
  State<AsrsTestScreen> createState() => _AsrsTestScreenState();
}

class _AsrsTestScreenState extends State<AsrsTestScreen> {
  late Future<List<_AsrsQuestion>> _questionsFuture;
  int _currentIndex = 0;
  final Map<int, int> _selectedOptionIndexByQuestionId = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
  }

  Future<List<_AsrsQuestion>> _loadQuestions() async {
    final raw = await rootBundle.loadString('assets/asrs_questions.json');
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      final list = decoded['questions'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map(_AsrsQuestion.fromJson)
            .toList();
      }
    }
    return <_AsrsQuestion>[];
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

  Future<void> _submitAsrs(List<_AsrsQuestion> questions) async {
    final dataSource = AssessmentRemoteDataSourceImpl(inject());

    final List<Map<String, dynamic>> questionPayload = questions.map((question) {
      final selectedIndex = _selectedOptionIndexByQuestionId[question.id] ?? 0;
      final answer = question.options[selectedIndex];
      return {
        'id': question.id.toString(),
        'text': question.text,
        'answer': _normalizeAnswer(answer),
      };
    }).toList();

    final Map<String, dynamic> payload = {
      'assessmentType': 'ASRS',
      'questions': questionPayload,
    };

    setState(() => _isLoading = true);
    try {
      await dataSource.sendAssessment(body: payload);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'ASRS Submission Error', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _normalizeAnswer(String answer) {
    return answer.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '_');
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
        appBar: CustomAppBar(
          showBackIcon: true,
          color: CarePlanColor.brown,
          backButtonColor: Colors.white,
        ),
        body: FutureBuilder<List<_AsrsQuestion>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: AppLoadingIndicator());
            }

            final questions = snapshot.data ?? const <_AsrsQuestion>[];
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
                        title: 'ASRS Test',
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
                          onTap: () async {
                            if (selectedIndex == null) {
                              GlobalSnackBar.show(context, 'Please select an option to continue.');
                              return;
                            }
                            if (_currentIndex == total - 1) {
                              if (_selectedOptionIndexByQuestionId.length != total) {
                                GlobalSnackBar.show(
                                  context,
                                  'Please answer all questions before submitting.',
                                );
                                return;
                              }
                              await _submitAsrs(questions);
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
      ),
    );
  }
}

class _AsrsQuestion {
  final int id;
  final String text;
  final List<String> options;

  const _AsrsQuestion({
    required this.id,
    required this.text,
    required this.options,
  });

  factory _AsrsQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return _AsrsQuestion(
      id: (json['id'] is int) ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      text: json['text']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList()
          : <String>[],
    );
  }
}

