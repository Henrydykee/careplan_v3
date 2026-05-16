import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CarePlanSectionHeader extends StatelessWidget {
  final String title;
  final int? count;

  const CarePlanSectionHeader({super.key, required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          title: title,
          color: CarePlanColor.brown,
          size: 15,
          fontWeight: FontWeight.w800,
        ),
        if (count != null) ...[
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: CarePlanColor.light_orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextHolder(
              title: "$count",
              color: CarePlanColor.brown,
              size: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ],
    );
  }
}

class CarePlanInfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CarePlanInfoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

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
        padding: padding,
        child: child,
      ),
    );
  }
}

class CarePlanChipBadge extends StatelessWidget {
  final String label;

  const CarePlanChipBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: CarePlanColor.light_orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextHolder(
        title: label,
        color: CarePlanColor.brown,
        size: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class CarePlanMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const CarePlanMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Gap(6),
              Flexible(
                child: TextHolder(
                  title: label,
                  color: CarePlanColor.grey_3,
                  size: 11,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Gap(8),
          TextHolder(
            title: value,
            color: accent,
            size: 18,
            fontWeight: FontWeight.w900,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CarePlanGoalBlock extends StatelessWidget {
  final String label;
  final String body;

  const CarePlanGoalBlock({super.key, required this.label, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: CarePlanColor.orange,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHolder(
                title: label,
                color: CarePlanColor.brown,
                size: 12,
                fontWeight: FontWeight.w800,
              ),
              const Gap(4),
              TextHolder(
                title: body,
                color: CarePlanColor.grey_2,
                size: 13,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
