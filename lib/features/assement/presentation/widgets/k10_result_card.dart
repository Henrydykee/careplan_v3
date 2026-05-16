import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/presentation/k10/assesment_insight_screen.dart';
import 'package:careplan/features/assement/presentation/k10/k10_models.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class K10ResultCard extends StatelessWidget {
  final K10AssessmentItem item;

  const K10ResultCard({super.key, required this.item});

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
    final severity = _severity(item.score);
    final color = severity['color'] as Color;
    final bg = severity['bg'] as Color;
    final label = severity['label'] as String;
    final parsedDate = DateTime.tryParse(item.createdAt) ?? DateTime.now();
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
  }
}
