import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StressorsListCard extends StatelessWidget {
  final List<String> stressors;

  const StressorsListCard({super.key, required this.stressors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: CarePlanColor.brown,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(8),
                TextHolder(
                  title: "Stressors",
                  color: CarePlanColor.brown,
                  size: 15,
                  fontWeight: FontWeight.w800,
                ),
                if (stressors.isNotEmpty) ...[
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextHolder(
                      title: "${stressors.length}",
                      color: CarePlanColor.brown,
                      size: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
            const Gap(14),
            if (stressors.isEmpty)
              TextHolder(
                title: "No stressors reported.",
                color: CarePlanColor.grey_3,
                size: 13,
                fontWeight: FontWeight.w500,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: stressors
                    .map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextHolder(
                          title: s,
                          color: CarePlanColor.brown,
                          size: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
