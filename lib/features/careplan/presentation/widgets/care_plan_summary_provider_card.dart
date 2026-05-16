import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/careplan/presentation/widgets/care_plan_summary_components.dart';
import 'package:careplan/features/careplan/presentation/widgets/careplan_provider_helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CarePlanSummaryProviderCard extends StatelessWidget {
  final String? providerType;
  final String? provider;
  final String? createdAt;
  final String status;

  const CarePlanSummaryProviderCard({
    super.key,
    required this.providerType,
    required this.provider,
    required this.createdAt,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final providerName =
        "${careplanProviderTitle(providerType)}${provider ?? ''}".trim();
    final formattedType = careplanProviderType(providerType);
    final createdOn = FormatUtils.dateTimeFormatter(
      createdAt,
      format: "d MMM yyyy",
    );
    final trimmedStatus = status.trim();

    return CarePlanInfoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: TextHolder(
                  title: providerName.isNotEmpty
                      ? careplanInitialsFor(providerName)
                      : "—",
                  color: CarePlanColor.brown,
                  size: 16,
                  fontWeight: FontWeight.w800,
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
                      fontWeight: FontWeight.w700,
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
                    if (formattedType.isNotEmpty) ...[
                      const Gap(2),
                      TextHolder(
                        title: formattedType,
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
              if (trimmedStatus.isNotEmpty) ...[
                const Gap(8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: CarePlanColor.light_orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextHolder(
                    title: careplanCapitalize(trimmedStatus),
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
        ],
      ),
    );
  }
}
