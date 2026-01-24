import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
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
  List<K10AssessmentItem> get _items =>
      (widget.assessments != null && widget.assessments!.isNotEmpty)
          ? widget.assessments!
          : mockK10Assessments;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackIcon: true,color: CarePlanColor.brown ,backButtonColor: Colors.white),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: CarePlanColor.brown,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextHolder(
            title: 'K10 Test',
            size: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          TextHolder(
            title: 'See results for all K10 tests',
            size: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => K10DisclaimerScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssessmentList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (context, index) {
        final item = _items[index];
        final severity = _severity(item.score);
        final color = severity['color'] as Color;
        final bg = severity['bg'] as Color;
        final label = severity['label'] as String;
        final formattedDate = DateFormat('EEEE, MMM d, y').format(
          DateTime.tryParse(item.createdAt) ?? DateTime.now(),
        );

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AssessmentK10Insight(
                  k10questions: item.questions,
                  score: item.score.toString(),
                  date: item.createdAt,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: '${item.score}/50',
                      size: 16,
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.grey,
                    ),
                    TextHolder(
                      title: formattedDate,
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: CarePlanColor.black_3,
                    ),
                    const Gap(10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: bg,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: color, size: 10),
                          const Gap(4),
                          TextHolder(
                            title: label,
                            color: color,
                            size: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: CarePlanColor.grey, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
