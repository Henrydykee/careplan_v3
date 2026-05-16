

import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/careplan/presentation/careplan/care_plan_summary_screen.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MentalHealthCarePlanWidget extends StatelessWidget {
  final CarePlanHistoryItemModel carePlan;

  const MentalHealthCarePlanWidget({
    Key? key,
    required this.carePlan,
  }) : super(key: key);

  String _getTitle(String? type) {
    if (type == null) return "";
    if (type.toLowerCase().contains("therapist")) return "";
    if (type.toUpperCase() == "ADHD COACH") return "ADHD Coach ";
    return "Dr. ";
  }

  String _getProviderType(String? type) {
    if (type == null) return "";
    if (type.toUpperCase() == "MENTAL HEALTH NURSE") return "Care Coordinator";
    return type;
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final createdOn = FormatUtils.dateTimeFormatter(
      carePlan.createdAt,
      format: "d MMM yyyy",
    );
    final providerName =
        "${_getTitle(carePlan.providerType)}${carePlan.provider ?? ''}".trim();
    final providerType = _getProviderType(carePlan.providerType);
    final status = (carePlan.status ?? '').trim();
    final shortTerm = carePlan.shortTermGoal?.text?.trim() ?? '';
    final longTerm = carePlan.longTermGoal?.trim() ?? '';
    final hasGoals = shortTerm.isNotEmpty || longTerm.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () =>
              router.push(CareplanSummaryScreen(carePlan: carePlan)),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CarePlanColor.grey_5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medical_services_outlined,
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
                              title: "Care plan",
                              color: CarePlanColor.grey_3,
                              size: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            const Gap(2),
                            TextHolder(
                              title: providerName.isNotEmpty
                                  ? providerName
                                  : "Your care team",
                              color: CarePlanColor.brown,
                              size: 16,
                              fontWeight: FontWeight.w800,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                            if (providerType.isNotEmpty) ...[
                              const Gap(2),
                              TextHolder(
                                title: providerType,
                                color: CarePlanColor.grey_3,
                                size: 12,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (status.isNotEmpty) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: CarePlanColor.light_orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextHolder(
                            title: _capitalize(status),
                            color: CarePlanColor.brown,
                            size: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (createdOn.isNotEmpty) ...[
                    const Gap(12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: CarePlanColor.grey_3,
                        ),
                        const Gap(6),
                        TextHolder(
                          title: "Created $createdOn",
                          color: CarePlanColor.grey_3,
                          size: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                  if (hasGoals) ...[
                    const Gap(14),
                    Container(
                      height: 1,
                      color: CarePlanColor.grey_5,
                    ),
                    const Gap(14),
                    if (shortTerm.isNotEmpty)
                      _GoalBlock(label: "Short term goal", body: shortTerm),
                    if (shortTerm.isNotEmpty && longTerm.isNotEmpty)
                      const Gap(12),
                    if (longTerm.isNotEmpty)
                      _GoalBlock(label: "Long term goal", body: longTerm),
                  ],
                  const Gap(14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextHolder(
                        title: "View details",
                        color: CarePlanColor.brown,
                        size: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      const Gap(4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: CarePlanColor.brown,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalBlock extends StatelessWidget {
  final String label;
  final String body;

  const _GoalBlock({required this.label, required this.body});

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

class PreApprovedCarePlanComponent extends StatelessWidget {
  final String title;
  final String subtitle;

  const PreApprovedCarePlanComponent({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextHolder(
          title: title,
          color: CarePlanColor.brown,
          size: 13,
          fontWeight: FontWeight.w700,
        ),
        const Gap(6),
        TextHolder(
          title: subtitle,
          color: CarePlanColor.grey_2,
          size: 13,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
