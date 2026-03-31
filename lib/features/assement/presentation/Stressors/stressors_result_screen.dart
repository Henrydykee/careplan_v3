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
            child: FutureBuilder<_StressorsApiData?>(
              future: _stressorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const StressorsResultShimmer();
                }

                final stressorsData = snapshot.data;
                final abilityToCope = (_overrideAbilityToCope ??
                    (stressorsData?.abilityToCope ?? _mockAbilityToCope)
                        .toString());
                final stressorList = _overrideStressors ??
                    stressorsData?.selectedStressors ??
                    _mockStressors;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextHolder(
                                  title: "Ability to cope",
                                  fontWeight: FontWeight.w500,
                                  size: 12,
                                ),
                                TextHolder(
                                  title: abilityToCope,
                                  fontWeight: FontWeight.w700,
                                  size: 18,
                                  color: CarePlanColor.brown,
                                ),
                              ],
                            ),
                          ),
                        ),
                        StressorsCard(stressors: stressorList),
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

class StressorsCard extends StatelessWidget {
  final List<String> stressors;

  const StressorsCard({super.key, this.stressors = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stressors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (stressors.isEmpty)
              const Text(
                "No stressors reported.",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              )
            else
              ...List.generate(stressors.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor:
                            CarePlanColor.black_3.withValues(alpha: 0.2),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CarePlanColor.brown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        stressors[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
