import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
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
  late Future<_GoalsApiData?> _goalsFuture;
  String? _overrideLongTermGoal;
  bool _didInitOverride = false;

  static const String _shortTermGoalPlaceholder = "No short term goal set yet.";
  static const String _longTermGoalPlaceholder = "No long term goal set yet.";

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

  Future<void> _refresh() async {
    setState(() {
      _goalsFuture = _fetchGoals();
      _overrideLongTermGoal = null;
      _didInitOverride = false;
    });
    await _goalsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButtom(
              title: "Edit Long Term Goal",
              btnColor: CarePlanColor.brown,
              onTap: () async {
                final initialGoal =
                    (_overrideLongTermGoal ?? _longTermGoalPlaceholder).trim();
                final updatedGoal = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => EditLongTermGoalScreen(
                      initialGoal: initialGoal,
                    ),
                  ),
                );
            
                if (!mounted) return;
                if (updatedGoal == null) return;
                final trimmed = updatedGoal.trim();
                if (trimmed.isEmpty) return;
            
                setState(() {
                  _overrideLongTermGoal = trimmed;
                });
              },
            ),
          ),
          const Gap(26),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: CarePlanColor.brown,
              child: FutureBuilder<_GoalsApiData?>(
                future: _goalsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [GoalsResultShimmer()],
                    );
                  }

                  final goals = snapshot.data;
                  final shortTermText = goals?.shortTermGoal?.message ??
                      _shortTermGoalPlaceholder;
                  final longTermText =
                      (goals?.longTermGoal ?? "").trim().isNotEmpty
                          ? goals!.longTermGoal!
                          : _longTermGoalPlaceholder;
                  final displayLongTermText =
                      _overrideLongTermGoal ?? longTermText;

                  if (!_didInitOverride) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      if (_didInitOverride) return;
                      setState(() {
                        _overrideLongTermGoal = longTermText;
                        _didInitOverride = true;
                      });
                    });
                  }

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GoalCard(
                            icon: Icons.flash_on_rounded,
                            label: "Short term",
                            body: shortTermText,
                          ),
                          const Gap(12),
                          _GoalCard(
                            icon: Icons.flag_rounded,
                            label: "Long term",
                            body: displayLongTermText,
                          ),
                        ],
                      ),
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

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String body;

  const _GoalCard({
    required this.icon,
    required this.label,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CarePlanColor.grey_5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CarePlanColor.light_orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: CarePlanColor.brown, size: 22),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: label,
                    color: CarePlanColor.grey_3,
                    size: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  const Gap(4),
                  TextHolder(
                    title: body,
                    color: CarePlanColor.grey,
                    size: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
