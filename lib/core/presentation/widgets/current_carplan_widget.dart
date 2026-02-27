

import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/careplan/presentation/care_plan_summary_screen.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class MentalHealthCarePlanWidget extends StatelessWidget {
  final CarePlanHistoryItemModel carePlan;

  const MentalHealthCarePlanWidget({
    Key? key,
    required this.carePlan,
  }) : super(key: key);

  String _getTitle(String? type) {
    if (type == null) return "";
    if (type.toLowerCase().contains("therapist")) {
      return "";
    }
    if (type.toUpperCase() == "ADHD COACH") {
      return "ADHD Coach ";
    }
    return "Dr. ";
  }

  @override
  Widget build(BuildContext context) {
    final createdOn = FormatUtils.dateTimeFormatter(
      carePlan.createdAt,
      format: "d MMM yyyy",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CareplanSummaryScreen(
              carePlan: carePlan,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(Assets.folder_icon),
                    const Gap(15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHolder(
                            title: "Created on:",
                            color: CarePlanColor.brown,
                            size: 13,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHolder(
                                title: createdOn.isNotEmpty ? createdOn : "N/A",
                                color: CarePlanColor.grey_2,
                                size: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFF333333),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: TextHolder(
                                    title:
                                        "by ${_getTitle(carePlan.providerType)}${carePlan.provider ?? ""}",
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                              const Gap(10),
                            ],
                          ),
                          const Gap(10),
                          Container(
                            height: 0.5,
                            color: CarePlanColor.grey_3,
                            width: MediaQuery.of(context).size.width / 1.6,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Gap(10),
                PreApprovedCarePlanComponent(
                  title: "Short term goal:",
                  subtitle: carePlan.shortTermGoal?.text ??
                      "(1) Reduce level of depression & anxiety by 50% by 8 weeks after starting treatment as measured by K10.\n(2) Improve your ability to cope with your stressors by 20% after your third therapy session.",
                ),
                const Gap(20),
                PreApprovedCarePlanComponent(
                  title: "Long term goal:",
                  subtitle: carePlan.longTermGoal ?? "",
                ),
              ],
            ),
          ),
        ),
      ),
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
