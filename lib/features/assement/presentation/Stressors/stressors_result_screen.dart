import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/Stressors/select_stressors_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StressorsResultScreen extends StatefulWidget {
  const StressorsResultScreen({super.key});

  @override
  State<StressorsResultScreen> createState() => _StressorsResultScreenState();
}

class _StressorsResultScreenState extends State<StressorsResultScreen> {
  static const _mockAbilityToCope = "6";
  static const _mockStressors = ["Work", "Finances", "Relationship"];

  late Future<_StressorsApiData?> _stressorsFuture;
  String? _overrideAbilityToCope;
  List<String>? _overrideStressors;

  @override
  void initState() {
    super.initState();
    _stressorsFuture = _fetchStressors();
  }

  Future<_StressorsApiData?> _fetchStressors() async {
    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      final raw = await dataSource.getStressorsHistory();
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic>) {
        final success = decoded['success'] == true;
        final data = decoded['data'];
        if (success && data is Map<String, dynamic>) {
          return _StressorsApiData.fromJson(data);
        }
      }
    } catch (_) {
      // Swallow errors and fall back to mock values in UI.
    }
    return null;
  }

  Future<void> _refresh() async {
    setState(() {
      _stressorsFuture = _fetchStressors();
      _overrideStressors = null;
      _overrideAbilityToCope = null;
    });
    await _stressorsFuture;
  }

  Future<void> _onTapUpdate({
    required List<String> stressors,
    required String abilityToCope,
  }) async {
    final result = await Navigator.of(context).push<StressorsSelectionResult>(
      MaterialPageRoute(
        builder: (_) => SelectStressAreasScreen(
          initialStressors: stressors,
          initialAbilityToCope: abilityToCope,
        ),
      ),
    );

    if (!mounted || result == null) return;
    setState(() {
      _overrideStressors = result.stressors;
      _overrideAbilityToCope = result.abilityToCope;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<_StressorsApiData?>(
              future: _stressorsFuture,
              builder: (context, snapshot) {
                final stressorsData = snapshot.data;
                final abilityToCope = _overrideAbilityToCope ??
                    (stressorsData?.abilityToCope ?? _mockAbilityToCope)
                        .toString();
                final stressorList = _overrideStressors ??
                    stressorsData?.selectedStressors ??
                    _mockStressors;
                return CustomButtom(
                  onTap: () => _onTapUpdate(
                    stressors: stressorList,
                    abilityToCope: abilityToCope,
                  ),
                  title: "Update",
                  btnColor: CarePlanColor.brown,
                );
              },
            ),
          ),
          const Gap(26),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: CarePlanColor.brown,
              child: FutureBuilder<_StressorsApiData?>(
                future: _stressorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [StressorsResultShimmer()],
                    );
                  }

                  final stressorsData = snapshot.data;
                  final abilityToCope = (_overrideAbilityToCope ??
                      (stressorsData?.abilityToCope ?? _mockAbilityToCope)
                          .toString());
                  final stressorList = _overrideStressors ??
                      stressorsData?.selectedStressors ??
                      _mockStressors;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AbilityToCopeCard(value: abilityToCope),
                          const Gap(16),
                          _StressorsListCard(stressors: stressorList),
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

class _AbilityToCopeCard extends StatelessWidget {
  final String value;

  const _AbilityToCopeCard({required this.value});

  Color _accentFor(int? score) {
    if (score == null) return CarePlanColor.brown;
    if (score >= 7) return Colors.green;
    if (score >= 4) return CarePlanColor.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = int.tryParse(value.trim());
    final accent = _accentFor(score);
    final progress = score == null ? 0.0 : (score.clamp(0, 10)) / 10;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: CarePlanColor.light_orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.self_improvement_rounded,
                    color: CarePlanColor.brown,
                    size: 22,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextHolder(
                        title: "Ability to cope",
                        color: CarePlanColor.grey_3,
                        size: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      const Gap(2),
                      TextHolder(
                        title: "How you're managing right now",
                        color: CarePlanColor.grey_3,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TextHolder(
                      title: value,
                      color: accent,
                      size: 26,
                      fontWeight: FontWeight.w900,
                    ),
                    TextHolder(
                      title: " / 10",
                      color: accent.withValues(alpha: 0.7),
                      size: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
            const Gap(14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: accent.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StressorsListCard extends StatelessWidget {
  final List<String> stressors;

  const _StressorsListCard({required this.stressors});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: CarePlanColor.brown,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(8),
                TextHolder(
                  title: "Stressors",
                  color: CarePlanColor.brown,
                  size: 15,
                  fontWeight: FontWeight.w800,
                ),
                if (stressors.isNotEmpty) ...[
                  const Gap(8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextHolder(
                      title: "${stressors.length}",
                      color: CarePlanColor.brown,
                      size: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
            const Gap(14),
            if (stressors.isEmpty)
              TextHolder(
                title: "No stressors reported.",
                color: CarePlanColor.grey_3,
                size: 13,
                fontWeight: FontWeight.w500,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: stressors
                    .map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextHolder(
                          title: s,
                          color: CarePlanColor.brown,
                          size: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _StressorsApiData {
  final _StressorsFlags stressors;
  final int? abilityToCope;

  _StressorsApiData({
    required this.stressors,
    required this.abilityToCope,
  });

  List<String> get selectedStressors {
    final result = <String>[];
    if (stressors.work == true) result.add("Work");
    if (stressors.relationship == true) result.add("Relationship");
    if (stressors.finances == true) result.add("Finances");
    if (stressors.physicalHealth == true) {
      result.add("Physical health or pain");
    }
    if (stressors.alcohol == true) {
      result.add("Alcohol or drugs");
    }
    if (stressors.trauma == true) result.add("Trauma");
    if (stressors.housing == true) result.add("Housing");
    if (stressors.school == true) result.add("School");
    return result;
  }

  factory _StressorsApiData.fromJson(Map<String, dynamic> json) {
    final stressorsJson =
        json['stressors'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return _StressorsApiData(
      stressors: _StressorsFlags.fromJson(stressorsJson),
      abilityToCope: json['abilityToCope'] is int
          ? json['abilityToCope'] as int
          : int.tryParse(json['abilityToCope']?.toString() ?? ''),
    );
  }
}

class _StressorsFlags {
  final bool? relationship;
  final bool? work;
  final bool? finances;
  final bool? physicalHealth;
  final bool? school;
  final bool? alcohol;
  final bool? trauma;
  final bool? housing;

  _StressorsFlags({
    this.relationship,
    this.work,
    this.finances,
    this.physicalHealth,
    this.school,
    this.alcohol,
    this.trauma,
    this.housing,
  });

  factory _StressorsFlags.fromJson(Map<String, dynamic> json) {
    return _StressorsFlags(
      relationship: json['relationship'] as bool?,
      work: json['work'] as bool?,
      finances: json['finances'] as bool?,
      physicalHealth: json['physicalHealth'] as bool?,
      school: json['school'] as bool?,
      alcohol: json['alcohol'] as bool?,
      trauma: json['trauma'] as bool?,
      housing: json['housing'] as bool?,
    );
  }
}
