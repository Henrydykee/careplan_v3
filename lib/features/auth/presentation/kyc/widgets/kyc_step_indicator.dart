import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/text_holder.dart';
import '../../../../../core/resources/color.dart';

/// Segmented progress for the KYC flow: one bar per step, filled up to the
/// step the user is on, with a "Step 2 of 4" caption underneath.
class KycStepIndicator extends StatelessWidget {
  final int step;
  final int total;

  const KycStepIndicator({
    super.key,
    required this.step,
    this.total = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(total, (index) {
            final done = index < step;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == total - 1 ? 0 : 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 6,
                  decoration: BoxDecoration(
                    color: done ? CarePlanColor.orange : CarePlanColor.light_orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        TextHolder(
          title: 'Step $step of $total',
          size: 12,
          fontWeight: FontWeight.w700,
          color: CarePlanColor.grey_3,
        ),
      ],
    );
  }
}
