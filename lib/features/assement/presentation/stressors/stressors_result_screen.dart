import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/Stressors/select_stressors_screen.dart';
import 'package:careplan/features/assement/presentation/widgets/ability_to_cope_card.dart';
import 'package:careplan/features/assement/presentation/widgets/stressors_api_data.dart';
import 'package:careplan/features/assement/presentation/widgets/stressors_list_card.dart';
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

  late Future<StressorsApiData?> _stressorsFuture;
  String? _overrideAbilityToCope;
  List<String>? _overrideStressors;

  @override
  void initState() {
    super.initState();
    _stressorsFuture = _fetchStressors();
  }

  Future<StressorsApiData?> _fetchStressors() async {
    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      final raw = await dataSource.getStressorsHistory();
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic>) {
        final success = decoded['success'] == true;
        final data = decoded['data'];
        if (success && data is Map<String, dynamic>) {
          return StressorsApiData.fromJson(data);
        }
      }
    } catch (_) {
      // Fall back to mock values in UI.
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

  String _resolveAbility(StressorsApiData? data) {
    return _overrideAbilityToCope ??
        (data?.abilityToCope ?? _mockAbilityToCope).toString();
  }

  List<String> _resolveStressors(StressorsApiData? data) {
    return _overrideStressors ?? data?.selectedStressors ?? _mockStressors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<StressorsApiData?>(
              future: _stressorsFuture,
              builder: (context, snapshot) {
                final abilityToCope = _resolveAbility(snapshot.data);
                final stressorList = _resolveStressors(snapshot.data);
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
              child: FutureBuilder<StressorsApiData?>(
                future: _stressorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [StressorsResultShimmer()],
                    );
                  }

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AbilityToCopeCard(
                              value: _resolveAbility(snapshot.data)),
                          const Gap(16),
                          StressorsListCard(
                              stressors: _resolveStressors(snapshot.data)),
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
