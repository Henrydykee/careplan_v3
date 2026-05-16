import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AssessmentQuestionHeader extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int total;

  const AssessmentQuestionHeader({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: CarePlanColor.brown,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextHolder(
            title: title,
            size: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          const Gap(4),
          TextHolder(
            title: 'Question ${currentIndex + 1} of $total',
            size: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
