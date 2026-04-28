import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/test_screens/asrs_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'asrs_result_insight_screen.dart';
import 'asrs_result_models.dart';

class ASRSResultHistoryScreen extends StatefulWidget {
  ASRSResultHistoryScreen({super.key});

  @override
  State<ASRSResultHistoryScreen> createState() => _ASRSResultHistoryScreenState();
}

class _ASRSResultHistoryScreenState extends State<ASRSResultHistoryScreen> {
  late Future<List<AsrsAssessmentItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItems();
  }

  Future<List<AsrsAssessmentItem>> _loadItems() async {
    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      final raw = await dataSource.getAsrsHistory();
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];
        if (data is Map<String, dynamic>) {
          final results = data['results'];
          if (results is List) {
            return results
                .whereType<Map<String, dynamic>>()
                .map(AsrsAssessmentItem.fromJson)
                .toList();
          }
        }
      }
    } catch (_) {
      // Swallow errors and fall back to empty list in UI.
    }

    return <AsrsAssessmentItem>[];
  }

  Future<void> _refresh() async {
    setState(() {
      _itemsFuture = _loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
  
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButtom(
                        title: "Take Test",
                        btnColor: CarePlanColor.brown,
                        onTap: () async {
                          await router.push(const AsrsTestScreen());
                          if (!mounted) return;
                          // Refresh immediately after returning from the test.
                          await _refresh();
                        },
                      ),
                    ),
                    const Gap(20),
                    _buildAssessmentList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentList(BuildContext context) {
    return FutureBuilder<List<AsrsAssessmentItem>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AssessmentHistoryListShimmer();
        }

        final items = snapshot.data ?? const <AsrsAssessmentItem>[];

        if (items.isEmpty) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.checklist_rounded,
                      color: CarePlanColor.brown,
                      size: 28,
                    ),
                  ),
                  const Gap(14),
                  TextHolder(
                    title: 'No ASRS results yet',
                    color: CarePlanColor.brown,
                    size: 16,
                    fontWeight: FontWeight.w800,
                    align: TextAlign.center,
                  ),
                  const Gap(6),
                  TextHolder(
                    title:
                        'Take your first ASRS screening to start tracking attention symptoms.',
                    color: CarePlanColor.grey_3,
                    size: 13,
                    fontWeight: FontWeight.w500,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final item = items[index];
            final parsedDate =
                DateTime.tryParse(item.createdAt) ?? DateTime.now();
            final formattedDate = DateFormat('MMM d, y').format(parsedDate);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  router.push(
                    AsrsResultInsightScreen(assessment: item),
                  );
                },
                child: Ink(
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
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: CarePlanColor.light_orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.checklist_rounded,
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
                                title: 'ASRS assessment',
                                color: CarePlanColor.grey_3,
                                size: 11,
                                fontWeight: FontWeight.w700,
                              ),
                              const Gap(2),
                              TextHolder(
                                title: formattedDate,
                                color: CarePlanColor.grey,
                                size: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                        ),
                        const Gap(6),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: CarePlanColor.grey_3,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

