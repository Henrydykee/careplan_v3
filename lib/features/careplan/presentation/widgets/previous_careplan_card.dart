import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/careplan/presentation/careplan/care_plan_summary_screen.dart';
import 'package:careplan/features/careplan/presentation/widgets/careplan_provider_helpers.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PreviousCareplanCard extends StatelessWidget {
  final CarePlanHistoryItemModel item;

  const PreviousCareplanCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final date = FormatUtils.dateTimeFormatter(item.createdAt,
        format: "d MMM yyyy");
    final formattedDate = date.isNotEmpty ? date : "N/A";
    final providerName =
        "${careplanProviderTitle(item.providerType)}${item.provider ?? ""}"
            .trim();
    final providerType = careplanProviderType(item.providerType);
    final stressors = careplanActiveStressors(item.stressors);
    final status = item.status;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => router.push(CareplanSummaryScreen(carePlan: item)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: CarePlanColor.grey_5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHolder(
                      title: formattedDate,
                      size: 13,
                      fontWeight: FontWeight.w600,
                      color: CarePlanColor.grey_3,
                    ),
                    if (status != null && status.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextHolder(
                          title: careplanCapitalize(status),
                          size: 11,
                          fontWeight: FontWeight.w700,
                          color: CarePlanColor.brown,
                        ),
                      ),
                  ],
                ),
              ),
              if (providerName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.person_outline_rounded,
                            size: 20, color: CarePlanColor.brown),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHolder(
                              title: providerName,
                              size: 15,
                              fontWeight: FontWeight.w700,
                              color: CarePlanColor.grey,
                            ),
                            if (providerType.isNotEmpty)
                              TextHolder(
                                title: providerType,
                                size: 12,
                                fontWeight: FontWeight.w500,
                                color: CarePlanColor.grey_3,
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: CarePlanColor.grey_3, size: 22),
                    ],
                  ),
                ),
              if (item.diagnosis != null && item.diagnosis!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.diagnosis!
                        .take(3)
                        .map((d) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F0EB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextHolder(
                                title: d,
                                size: 12,
                                fontWeight: FontWeight.w600,
                                color: CarePlanColor.brown,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              if (stressors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 14, color: CarePlanColor.orange),
                      const Gap(6),
                      Expanded(
                        child: TextHolder(
                          title: stressors.join(", "),
                          size: 12,
                          fontWeight: FontWeight.w500,
                          color: CarePlanColor.grey_3,
                        ),
                      ),
                    ],
                  ),
                ),
              const Gap(14),
            ],
          ),
        ),
      ),
    );
  }
}
