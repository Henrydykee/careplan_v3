import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
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
                  title: "ASRS Test",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: "See results for all ASRS tests",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButtom(
                      title: "Take Test",
                      btnColor: CarePlanColor.brown,
                      onTap: () {
                        router.push(const AsrsTestScreen());
                      },
                    ),
                  ),
                  const Gap(20),
                  _buildAssessmentList(context),
                ],
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
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: AppLoadingIndicator(),
            ),
          );
        }

        final items = snapshot.data ?? const <AsrsAssessmentItem>[];

        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextHolder(
                title: 'No ASRS results found.',
                size: 14,
                fontWeight: FontWeight.w500,
                color: CarePlanColor.black_3,
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            final item = items[index];
            final formattedDate = DateFormat('EEEE, MMM d, y').format(
              DateTime.tryParse(item.createdAt) ?? DateTime.now(),
            );

            return GestureDetector(
              onTap: () {
                router.push(
                  AsrsResultInsightScreen(
                    assessment: item,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: formattedDate,
                        fontWeight: FontWeight.w800,
                        size: 13,
                      ),
                      Icon(Icons.arrow_forward_ios, color: CarePlanColor.grey),
                    ],
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

