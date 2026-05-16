import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AbilityToCopeCard extends StatelessWidget {
  final String value;

  const AbilityToCopeCard({super.key, required this.value});

  Color _accentFor(int? score) {
    if (score == null) return CarePlanColor.brown;
    if (score >= 7) return Colors.green;
    if (score >= 4) return CarePlanColor.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = int.tryParse(value.trim());
    final accent = _accentFor(score);
    final progress = score == null ? 0.0 : (score.clamp(0, 10)) / 10;

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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: CarePlanColor.light_orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.self_improvement_rounded,
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
                        title: "Ability to cope",
                        color: CarePlanColor.grey_3,
                        size: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      const Gap(2),
                      TextHolder(
                        title: "How you're managing right now",
                        color: CarePlanColor.grey_3,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TextHolder(
                      title: value,
                      color: accent,
                      size: 26,
                      fontWeight: FontWeight.w900,
                    ),
                    TextHolder(
                      title: " / 10",
                      color: accent.withValues(alpha: 0.7),
                      size: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
            const Gap(14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: accent.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
