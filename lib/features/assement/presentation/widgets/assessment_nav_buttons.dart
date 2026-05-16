import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AssessmentNavButtons extends StatelessWidget {
  final bool showPrevious;
  final bool isLast;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AssessmentNavButtons({
    super.key,
    required this.showPrevious,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          if (showPrevious)
            Expanded(
              child: CustomButtom(
                title: 'Previous',
                btnColor: CarePlanColor.brown,
                onTap: onPrevious,
              ),
            ),
          if (showPrevious) const Gap(12),
          Expanded(
            child: CustomButtom(
              title: isLast ? 'Finish' : 'Next',
              btnColor: CarePlanColor.brown,
              onTap: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
