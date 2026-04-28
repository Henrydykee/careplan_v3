import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/assement/presentation/k10/assesment_insight_screen.dart';
import 'package:careplan/features/assement/presentation/k10/k10_dsiclaimer_screen.dart';
import 'package:careplan/features/assement/presentation/k10/k10_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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
      // Swallow errors and fall back to empty list in UI.
    }

    return <K10AssessmentItem>[];
  }

  Future<void> _refresh() async {
    setState(() {
      _itemsFuture = _loadItems();
    });
    await _itemsFuture;
  }

  Map<String, dynamic> _severity(int score) {
    if (score <= 15) {
      return {
        'label': 'Low',
        'color': Colors.green,
        'bg': Colors.green.withValues(alpha: 0.1),
      };
    }
    if (score <= 21) {
      return {
        'label': 'Moderate',
        'color': CarePlanColor.orange,
        'bg': CarePlanColor.light_orange,
      };
    }
    if (score <= 29) {
      return {
        'label': 'High',
        'color': Colors.deepOrange,
        'bg': Colors.deepOrange.withValues(alpha: 0.1),
      };
    }
    return {
      'label': 'Very High',
      'color': Colors.red,
      'bg': Colors.red.withValues(alpha: 0.1),
    };
  }

  String _relativeTime(DateTime when) {
    final diff = DateTime.now().difference(when);
    if (diff.inDays == 0) return "Today";
    if (diff.inDays == 1) return "Yesterday";
    if (diff.inDays < 7) return "${diff.inDays} days ago";
    if (diff.inDays < 30) return "${(diff.inDays / 7).floor()} weeks ago";
    if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} months ago";
    return "${(diff.inDays / 365).floor()} years ago";
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
                    _buildTakeTestButton(context),
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

  Widget _buildTakeTestButton(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildAssessmentList(BuildContext context) {
    return FutureBuilder<List<K10AssessmentItem>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AssessmentHistoryListShimmer();
        }

        final items = snapshot.data ?? const <K10AssessmentItem>[];

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
                      Icons.psychology_outlined,
                      color: CarePlanColor.brown,
                      size: 28,
                    ),
                  ),
                  const Gap(14),
                  TextHolder(
                    title: 'No K10 results yet',
                    color: CarePlanColor.brown,
                    size: 16,
                    fontWeight: FontWeight.w800,
                    align: TextAlign.center,
                  ),
                  const Gap(6),
                  TextHolder(
                    title:
                        'Take your first K10 assessment to start tracking how you feel.',
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
            final severity = _severity(item.score);
            final color = severity['color'] as Color;
            final bg = severity['bg'] as Color;
            final label = severity['label'] as String;
            final parsedDate =
                DateTime.tryParse(item.createdAt) ?? DateTime.now();
            final formattedDate = DateFormat('MMM d, y').format(parsedDate);
            final relative = _relativeTime(parsedDate);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  router.push(
                    AssessmentK10Insight(
                      k10questions: item.questions,
                      score: item.score.toString(),
                      date: item.createdAt,
                    ),
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
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: color.withValues(alpha: 0.4),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextHolder(
                                title: '${item.score}',
                                color: color,
                                size: 22,
                                fontWeight: FontWeight.w900,
                              ),
                              TextHolder(
                                title: '/ 50',
                                color: color.withValues(alpha: 0.75),
                                size: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextHolder(
                                  title: label,
                                  color: color,
                                  size: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Gap(6),
                              TextHolder(
                                title: formattedDate,
                                color: CarePlanColor.grey,
                                size: 14,
                                fontWeight: FontWeight.w800,
                              ),
                              const Gap(2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 12,
                                    color: CarePlanColor.grey_3,
                                  ),
                                  const Gap(4),
                                  TextHolder(
                                    title: relative,
                                    color: CarePlanColor.grey_3,
                                    size: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
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
