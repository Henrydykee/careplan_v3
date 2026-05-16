import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/careplan/presentation/widgets/care_plan_summary_components.dart';
import 'package:careplan/features/careplan/presentation/widgets/care_plan_summary_provider_card.dart';
import 'package:careplan/features/careplan/presentation/widgets/careplan_provider_helpers.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CareplanSummaryScreen extends StatelessWidget {
  final CarePlanHistoryItemModel carePlan;

  const CareplanSummaryScreen({super.key, required this.carePlan});

  @override
  Widget build(BuildContext context) {
    final stressors = careplanActiveStressors(carePlan.stressors);
    final interventions = careplanInterventions(carePlan.therapy);
    final diagnosis = carePlan.diagnosis ?? const [];
    final shortTerm = carePlan.shortTermGoal?.text?.trim() ?? '';
    final longTerm = carePlan.longTermGoal?.trim() ?? '';
    final homework = carePlan.homework?.trim() ?? '';
    final riskSelf = (carePlan.riskToSelf ?? '').trim();
    final riskOthers = (carePlan.riskToOthers ?? '').trim();
    final ability = (carePlan.abilityToCope ?? '').trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F2),
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Care Plan Summary",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarePlanSummaryProviderCard(
              providerType: carePlan.providerType,
              provider: carePlan.provider,
              createdAt: carePlan.createdAt,
              status: carePlan.status ?? '',
            ),
            if (riskSelf.isNotEmpty || riskOthers.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(title: "Risk assessment"),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: CarePlanMetricTile(
                      label: "Risk to self",
                      value: riskSelf.isNotEmpty
                          ? careplanCapitalize(riskSelf)
                          : "—",
                      accent: careplanRiskColor(riskSelf),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: CarePlanMetricTile(
                      label: "Risk to others",
                      value: riskOthers.isNotEmpty
                          ? careplanCapitalize(riskOthers)
                          : "—",
                      accent: careplanRiskColor(riskOthers),
                    ),
                  ),
                ],
              ),
            ],
            if (ability.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(title: "Ability to cope"),
              const Gap(10),
              CarePlanInfoCard(
                child: Row(
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
                      child: TextHolder(
                        title: careplanCapitalize(ability),
                        color: CarePlanColor.grey,
                        size: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (stressors.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(
                  title: "Stressors", count: stressors.length),
              const Gap(10),
              CarePlanInfoCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stressors
                      .map((s) => CarePlanChipBadge(label: s))
                      .toList(),
                ),
              ),
            ],
            if (diagnosis.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(
                  title: "Diagnosis", count: diagnosis.length),
              const Gap(10),
              CarePlanInfoCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: diagnosis
                      .map((d) => CarePlanChipBadge(label: d))
                      .toList(),
                ),
              ),
            ],
            if (shortTerm.isNotEmpty || longTerm.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(title: "Goals"),
              const Gap(10),
              CarePlanInfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (shortTerm.isNotEmpty)
                      CarePlanGoalBlock(label: "Short term", body: shortTerm),
                    if (shortTerm.isNotEmpty && longTerm.isNotEmpty)
                      const Gap(14),
                    if (longTerm.isNotEmpty)
                      CarePlanGoalBlock(label: "Long term", body: longTerm),
                  ],
                ),
              ),
            ],
            if (interventions.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(title: "Therapy & interventions"),
              const Gap(10),
              CarePlanInfoCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interventions
                      .map((i) => CarePlanChipBadge(label: i))
                      .toList(),
                ),
              ),
            ],
            if (homework.isNotEmpty) ...[
              const Gap(20),
              CarePlanSectionHeader(title: "Homework"),
              const Gap(10),
              CarePlanInfoCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: CarePlanColor.orange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: TextHolder(
                        title: homework,
                        color: CarePlanColor.grey,
                        size: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
