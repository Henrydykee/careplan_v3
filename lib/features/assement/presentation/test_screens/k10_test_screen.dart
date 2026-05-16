import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/google_analytics_manager.dart';
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
import 'package:careplan/features/assement/presentation/widgets/assessment_test_models.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class K10TestScreen extends StatefulWidget {
  const K10TestScreen({super.key});

  @override
  State<K10TestScreen> createState() => _K10TestScreenState();
}

class _K10TestScreenState extends State<K10TestScreen> {
  late Future<List<AssessmentQuestion>> _questionsFuture;
  int _currentIndex = 0;
  final Map<int, int> _selectedOptionIndexByQuestionId = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = loadAssessmentQuestions('assets/k10_questions.json');
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

  Future<void> _submit(List<AssessmentQuestion> questions) async {
    final dataSource = AssessmentRemoteDataSourceImpl(inject());

    final Map<String, dynamic> payload = {
      'assessmentType': 'K10',
      'k10questions': {
        'first': _scoreAt(questions, 0),
        'second': _scoreAt(questions, 1),
        'third': _scoreAt(questions, 2),
        'fourth': _scoreAt(questions, 3),
        'fifth': _scoreAt(questions, 4),
        'sixth': _scoreAt(questions, 5),
        'seventh': _scoreAt(questions, 6),
        'eighth': _scoreAt(questions, 7),
        'ninth': _scoreAt(questions, 8),
        'tenth': _scoreAt(questions, 9),
      },
    };

    setState(() => _isLoading = true);
    try {
      await dataSource.sendAssessment(body: payload);
      if (!mounted) return;
      googleAnalytics.logEvent(
          eventName: 'assessment_submitted', parameters: {'type': 'K10'});
      router.push(const CarePlanNavBar(index: 1));
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'K10 Submission Error', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _scoreAt(List<AssessmentQuestion> questions, int index) {
    final selectedIndex =
        _selectedOptionIndexByQuestionId[questions[index].id];
    return (selectedIndex ?? 0) + 1;
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
                  title: 'K10 Test',
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
