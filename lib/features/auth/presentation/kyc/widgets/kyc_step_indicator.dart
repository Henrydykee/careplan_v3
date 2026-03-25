import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/text_holder.dart';
import '../../../../../core/resources/color.dart';

class KycStepIndicator extends StatelessWidget {
  final String step;
  final String total;

  const KycStepIndicator({
    super.key,
    required this.step,
    this.total = '4',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFFF4EDE3),
        border: Border.all(
          color: const Color(0xFFF9E2C8),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 13),
        child: Row(
          children: [
            TextHolder(
              title: "Step",
              color: CarePlanColor.brown,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(width: 3),
            TextHolder(
              title: step,
              color: CarePlanColor.brown,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(width: 3),
            TextHolder(
              title: "of",
              color: CarePlanColor.brown,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(width: 3),
            TextHolder(
              title: total,
              color: CarePlanColor.brown,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    );
  }
}

