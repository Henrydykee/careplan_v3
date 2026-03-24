import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/goals/edit_long_term_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GoalsResultScreen extends StatefulWidget {
  const GoalsResultScreen({super.key});

  @override
  State<GoalsResultScreen> createState() => _GoalsResultScreenState();
}

class _GoalsResultScreenState extends State<GoalsResultScreen> {
  static const _mockShortTermGoal =
      "Improve sleep schedule and get at least 7 hours of rest each night.";
  static const _mockLongTermGoal =
      "Complete professional certification within the next 12 months.";

  late Future<_GoalsApiData?> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = _fetchGoals();
  }

  Future<_GoalsApiData?> _fetchGoals() async {
    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      final raw = await dataSource.getGoalsHistory();
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic>) {
        final success = decoded['success'] == true;
        final data = decoded['data'];
        if (success && data is Map<String, dynamic>) {
          return _GoalsApiData.fromJson(data);
        }
      }
    } catch (_) {
      // Swallow errors and fall back to mock values in UI.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  title: "Goals",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: "See your current goals",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/take_test_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: "💡 Edit goals",
                        size: 14,
                        fontWeight: FontWeight.w600,
                        color: CarePlanColor.brown,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditLongTermGoalScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CarePlanColor.brown,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: TextHolder(
                      title: "Edit Goals",
                      size: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(26),
          Expanded(
            child: FutureBuilder<_GoalsApiData?>(
              future: _goalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const GoalsResultShimmer();
                }

                final goals = snapshot.data;
                final shortTermText =
                    goals?.shortTermGoal?.message ?? _mockShortTermGoal;
                final longTermText =
                    (goals?.longTermGoal ?? "").trim().isNotEmpty
                        ? goals!.longTermGoal!
                        : _mockLongTermGoal;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: ExpansionTile(
                            iconColor: CarePlanColor.brown,
                            collapsedIconColor: CarePlanColor.brown,
                            title: TextHolder(
                              title: "Short Term Goals",
                              fontWeight: FontWeight.w800,
                              size: 15,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: TextHolder(
                                  title: shortTermText,
                                  fontWeight: FontWeight.w500,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),
                        Card(
                          child: ExpansionTile(
                            iconColor: CarePlanColor.brown,
                            collapsedIconColor: CarePlanColor.brown,
                            title: TextHolder(
                              title: "Long Term Goals",
                              fontWeight: FontWeight.w800,
                              size: 15,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextHolder(
                                    title: longTermText,
                                    fontWeight: FontWeight.w500,
                                    align: TextAlign.left,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsApiData {
  final _ShortTermGoalData? shortTermGoal;
  final String? longTermGoal;

  const _GoalsApiData({
    this.shortTermGoal,
    this.longTermGoal,
  });

  factory _GoalsApiData.fromJson(Map<String, dynamic> json) {
    return _GoalsApiData(
      shortTermGoal: json['shortTermGoal'] is Map<String, dynamic>
          ? _ShortTermGoalData.fromJson(
              json['shortTermGoal'] as Map<String, dynamic>,
            )
          : null,
      longTermGoal: json['longTermGoal'] as String?,
    );
  }
}

class _ShortTermGoalData {
  final String? message;
  final String? reductionLevel;
  final String? period;

  const _ShortTermGoalData({
    this.message,
    this.reductionLevel,
    this.period,
  });

  factory _ShortTermGoalData.fromJson(Map<String, dynamic> json) {
    return _ShortTermGoalData(
      message: json['message'] as String?,
      reductionLevel: json['reductionLevel']?.toString(),
      period: json['period']?.toString(),
    );
  }
}

