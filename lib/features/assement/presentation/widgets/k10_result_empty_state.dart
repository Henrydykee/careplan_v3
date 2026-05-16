import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class K10ResultEmptyState extends StatelessWidget {
  const K10ResultEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: CarePlanColor.light_orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.psychology_outlined,
                color: CarePlanColor.brown,
                size: 28,
              ),
            ),
            const Gap(14),
            TextHolder(
              title: 'No K10 results yet',
              color: CarePlanColor.brown,
              size: 16,
              fontWeight: FontWeight.w800,
              align: TextAlign.center,
            ),
            const Gap(6),
            TextHolder(
              title:
                  'Take your first K10 assessment to start tracking how you feel.',
              color: CarePlanColor.grey_3,
              size: 13,
              fontWeight: FontWeight.w500,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
