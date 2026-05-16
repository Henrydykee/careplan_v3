import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/widgets/assessment_nav_buttons.dart';
import 'package:careplan/features/assement/presentation/widgets/assessment_option_tile.dart';
import 'package:careplan/features/assement/presentation/widgets/assessment_question_header.dart';
import 'package:careplan/features/assement/data/models/assessment_test_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AsrsTestScreen extends StatefulWidget {
  const AsrsTestScreen({super.key});

  @override
  State<AsrsTestScreen> createState() => _AsrsTestScreenState();
}

class _AsrsTestScreenState extends State<AsrsTestScreen> {
  late Future<List<AssessmentQuestion>> _questionsFuture;
  int _currentIndex = 0;
  final Map<int, int> _selectedOptionIndexByQuestionId = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = loadAssessmentQuestions('assets/asrs_questions.json');
  }

  void _goToNext(int total) {
    if (_currentIndex < total - 1) {
      setState(() => _currentIndex += 1);
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex -= 1);
    }
  }

  String _normalizeAnswer(String answer) {
    return answer.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '_');
  }

  Future<void> _submit(List<AssessmentQuestion> questions) async {
    final dataSource = AssessmentRemoteDataSourceImpl(inject());

    final List<Map<String, dynamic>> questionPayload =
        questions.map((question) {
      final selectedIndex =
          _selectedOptionIndexByQuestionId[question.id] ?? 0;
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
      router.pop();
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'ASRS Submission Error', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleNextTap(List<AssessmentQuestion> questions, int? selectedIndex) {
    if (selectedIndex == null) {
      GlobalSnackBar.show(context, 'Please select an option to continue.');
      return;
    }
    final total = questions.length;
    if (_currentIndex == total - 1) {
      if (_selectedOptionIndexByQuestionId.length != total) {
        GlobalSnackBar.show(
            context, 'Please answer all questions before submitting.');
        return;
      }
      _submit(questions);
    } else {
      _goToNext(total);
    }
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
        body: FutureBuilder<List<AssessmentQuestion>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: AppLoadingIndicator());
            }

            final questions = snapshot.data ?? const <AssessmentQuestion>[];
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
            final selectedIndex =
                _selectedOptionIndexByQuestionId[question.id];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AssessmentQuestionHeader(
                  title: 'ASRS Test',
                  currentIndex: _currentIndex,
                  total: total,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AssessmentOptionTile(
                              label: question.options[index],
                              isSelected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  _selectedOptionIndexByQuestionId[
                                      question.id] = index;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                AssessmentNavButtons(
                  showPrevious: _currentIndex > 0,
                  isLast: _currentIndex == total - 1,
                  onPrevious: _goToPrevious,
                  onNext: () => _handleNextTap(questions, selectedIndex),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
