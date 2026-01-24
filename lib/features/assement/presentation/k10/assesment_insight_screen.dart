import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/assement/presentation/k10/k10_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AssessmentK10Insight extends StatefulWidget {
  final K10Questions? k10questions;
  final String? date;
  final String? score;

  const AssessmentK10Insight({
    super.key,
    this.k10questions,
    this.date,
    this.score,
  });

  @override
  State<AssessmentK10Insight> createState() => _AssessmentK10InsightState();
}

class _AssessmentK10InsightState extends State<AssessmentK10Insight> {
  static const List<_Q> _questions = [
    _Q('1', 'About how often did you feel tired out for no good reason?'),
    _Q('2', 'About how often did you feel nervous?'),
    _Q('3', 'About how often did you feel so nervous that nothing could calm you down?'),
    _Q('4', 'About how often did you feel hopeless?'),
    _Q('5', 'About how often did you feel restless or fidgety?'),
    _Q('6', 'About how often did you feel so restless you could not sit still?'),
    _Q('7', 'About how often did you feel depressed?'),
    _Q('8', 'About how often did you feel that everything was an effort?'),
    _Q('9', 'About how often did you feel so sad that nothing could cheer you up?'),
    _Q('10', 'About how often did you feel worthless?'),
  ];

  int? _scoreAt(int i) {
    final q = widget.k10questions;
    if (q == null) return null;
    switch (i) {
      case 0: return q.first;
      case 1: return q.second;
      case 2: return q.third;
      case 3: return q.fourth;
      case 4: return q.fifth;
      case 5: return q.sixth;
      case 6: return q.seventh;
      case 7: return q.eighth;
      case 8: return q.ninth;
      case 9: return q.tenth;
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = FormatUtils.dateTimeFormatter(widget.date);
    return Scaffold(
      backgroundColor: CarePlanColor.grey_5,
      appBar: CustomAppBar(showBackIcon: true, color: CarePlanColor.brown,backButtonColor: Colors.white),
      body: Column(
        children: [
          _buildHeader(dateStr),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: 'Question breakdown',
                    size: 16,
                    fontWeight: FontWeight.w700,
                    color: CarePlanColor.grey,
                  ),
                  const Gap(16),
                  ...List.generate(_questions.length, (i) {
                    return _K10InsightRow(
                      number: _questions[i].number,
                      question: _questions[i].question,
                      score: _scoreAt(i),
                    );
                  }),
                  const Gap(24),
                  _buildTotalCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String dateStr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: CarePlanColor.brown,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextHolder(
            title: 'K10 Insights',
            size: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          const Gap(6),
          TextHolder(
            title: dateStr.isEmpty
                ? 'Here is how you scored across each question.'
                : 'On $dateStr — here is how you scored across each question.',
            size: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: CarePlanColor.light_orange,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CarePlanColor.orange.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          TextHolder(
            title: 'Total score',
            size: 14,
            fontWeight: FontWeight.w600,
            color: CarePlanColor.grey,
          ),
          const Gap(8),
          TextHolder(
            title: '${widget.score ?? "—"} / 50',
            size: 28,
            fontWeight: FontWeight.w800,
            color: CarePlanColor.brown,
          ),
        ],
      ),
    );
  }
}

class _Q {
  final String number;
  final String question;
  const _Q(this.number, this.question);
}

class _K10InsightRow extends StatelessWidget {
  final String number;
  final String question;
  final int? score;

  const _K10InsightRow({
    required this.number,
    required this.question,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CarePlanColor.brown,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextHolder(
              title: number,
              size: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: question,
                  size: 14,
                  fontWeight: FontWeight.w500,
                  color: CarePlanColor.grey,
                  maxLines: 4,
                  textOverflow: TextOverflow.ellipsis,
                ),
                if (score != null) ...[
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextHolder(
                      title: 'Score: $score',
                      size: 13,
                      fontWeight: FontWeight.w600,
                      color: CarePlanColor.brown,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
