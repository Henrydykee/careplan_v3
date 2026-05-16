import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/k10/k10_dsiclaimer_screen.dart';
import 'package:careplan/features/assement/presentation/k10/k10_models.dart';
import 'package:careplan/features/assement/presentation/widgets/k10_result_card.dart';
import 'package:careplan/features/assement/presentation/widgets/k10_result_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class K10ResultScreen extends StatefulWidget {
  /// When provided (and has assessments), real API data is used. Otherwise mock data is used.
  final List<K10AssessmentItem>? assessments;

  const K10ResultScreen({super.key, this.assessments});

  @override
  State<K10ResultScreen> createState() => _K10ResultScreenState();
}

class _K10ResultScreenState extends State<K10ResultScreen> {
  late Future<List<K10AssessmentItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItems();
  }

  Future<List<K10AssessmentItem>> _loadItems() async {
    if (widget.assessments != null && widget.assessments!.isNotEmpty) {
      return widget.assessments!;
    }

    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      final raw = await dataSource.getK10AssessmentHistory();
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic>) {
        final success = decoded['success'] == true;
        final data = decoded['data'];
        if (success && data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(K10AssessmentItem.fromJson)
              .toList();
        }
      }
    } catch (_) {
      // Fall back to empty list in UI.
    }

    return <K10AssessmentItem>[];
  }

  Future<void> _refresh() async {
    setState(() {
      _itemsFuture = _loadItems();
    });
    await _itemsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: CarePlanColor.brown,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButtom(
                        title: 'Take Test',
                        btnColor: CarePlanColor.brown,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => K10DisclaimerScreen(),
                            ),
                          );
                          if (!mounted) return;
                          await _refresh();
                        },
                      ),
                    ),
                    const Gap(20),
                    _buildAssessmentList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentList() {
    return FutureBuilder<List<K10AssessmentItem>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AssessmentHistoryListShimmer();
        }

        final items = snapshot.data ?? const <K10AssessmentItem>[];

        if (items.isEmpty) {
          return const K10ResultEmptyState();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) => K10ResultCard(item: items[index]),
        );
      },
    );
  }
}
