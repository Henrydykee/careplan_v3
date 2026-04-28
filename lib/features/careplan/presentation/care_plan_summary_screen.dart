import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CareplanSummaryScreen extends StatelessWidget {
  final CarePlanHistoryItemModel carePlan;

  const CareplanSummaryScreen({super.key, required this.carePlan});

  String _getTitle(String? title) {
    if (title == null) return "";
    if (title.toLowerCase().contains("therapist")) return "";
    if (title.toUpperCase() == "ADHD COACH") return "ADHD Coach ";
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

  String _initialsFor(String name) {
    final cleaned = name
        .replaceFirst(
            RegExp(r'^(Dr\.?|Mr\.?|Mrs\.?|Ms\.?|ADHD Coach)\s+',
                caseSensitive: false),
            '')
        .trim();
    if (cleaned.isEmpty) return "?";
    final parts = cleaned.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    final initials = "$first$last".toUpperCase();
    return initials.isEmpty ? "?" : initials;
  }

  List<String> _activeStressors() {
    final s = carePlan.stressors;
    if (s == null) return const [];
    final list = <String>[];
    if (s.work == true) list.add("Work");
    if (s.relationship == true) list.add("Relationship");
    if (s.finances == true) list.add("Finances");
    if (s.trauma == true) list.add("Trauma");
    if (s.housing == true) list.add("Housing");
    if (s.alcohol == true) list.add("Alcohol");
    if (s.physicalHealth == true) list.add("Physical Health");
    if (s.school == true) list.add("School");
    return list;
  }

  List<String> _interventions() {
    final t = carePlan.therapy;
    if (t == null) return const [];
    final list = <String>[];
    if (t.hasCBT == true) list.add("CBT");
    if (t.hasSafetyPlanning == true) list.add("Safety planning");
    final other = (t.otherIntervention ?? "").trim();
    if (other.isNotEmpty) list.add(other);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final stressors = _activeStressors();
    final interventions = _interventions();
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
            _buildProviderCard(),
            if (riskSelf.isNotEmpty || riskOthers.isNotEmpty) ...[
              const Gap(20),
              _SectionHeader(title: "Risk assessment"),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: "Risk to self",
                      value: riskSelf.isNotEmpty ? _capitalize(riskSelf) : "—",
                      accent: _riskColor(riskSelf),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _MetricTile(
                      label: "Risk to others",
                      value:
                          riskOthers.isNotEmpty ? _capitalize(riskOthers) : "—",
                      accent: _riskColor(riskOthers),
                    ),
                  ),
                ],
              ),
            ],
            if (ability.isNotEmpty) ...[
              const Gap(20),
              _SectionHeader(title: "Ability to cope"),
              const Gap(10),
              _InfoCard(
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
                        title: _capitalize(ability),
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
              _SectionHeader(title: "Stressors", count: stressors.length),
              const Gap(10),
              _InfoCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stressors
                      .map((s) => _ChipBadge(label: s))
                      .toList(),
                ),
              ),
            ],
            if (diagnosis.isNotEmpty) ...[
              const Gap(20),
              _SectionHeader(title: "Diagnosis", count: diagnosis.length),
              const Gap(10),
              _InfoCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: diagnosis
                      .map((d) => _ChipBadge(label: d))
                      .toList(),
                ),
              ),
            ],
            if (shortTerm.isNotEmpty || longTerm.isNotEmpty) ...[
              const Gap(20),
              _SectionHeader(title: "Goals"),
              const Gap(10),
              _InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (shortTerm.isNotEmpty)
                      _GoalBlock(label: "Short term", body: shortTerm),
                    if (shortTerm.isNotEmpty && longTerm.isNotEmpty)
                      const Gap(14),
                    if (longTerm.isNotEmpty)
                      _GoalBlock(label: "Long term", body: longTerm),
                  ],
                ),
              ),
            ],
            if (interventions.isNotEmpty) ...[
              const Gap(20),
              _SectionHeader(title: "Therapy & interventions"),
              const Gap(10),
              _InfoCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interventions
                      .map((i) => _ChipBadge(label: i))
                      .toList(),
                ),
              ),
            ],
            if (homework.isNotEmpty) ...[
              const Gap(20),
              _SectionHeader(title: "Homework"),
              const Gap(10),
              _InfoCard(
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

  Widget _buildProviderCard() {
    final providerName =
        "${_getTitle(carePlan.providerType)}${carePlan.provider ?? ''}".trim();
    final providerType = _getProviderType(carePlan.providerType);
    final createdOn = FormatUtils.dateTimeFormatter(
      carePlan.createdAt,
      format: "d MMM yyyy",
    );
    final status = (carePlan.status ?? '').trim();

    return _InfoCard(
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
                      ? _initialsFor(providerName)
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ],
      ),
    );
  }

  Color _riskColor(String value) {
    final v = value.toLowerCase();
    if (v.contains("high")) return Colors.red;
    if (v.contains("moderate") || v.contains("medium")) {
      return CarePlanColor.orange;
    }
    if (v.contains("low") || v.contains("none") || v.contains("nil")) {
      return Colors.green;
    }
    return CarePlanColor.grey_3;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int? count;

  const _SectionHeader({required this.title, this.count});

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

class _InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _InfoCard({
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

class _ChipBadge extends StatelessWidget {
  final String label;

  const _ChipBadge({required this.label});

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

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _MetricTile({
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
