import 'package:cached_network_image/cached_network_image.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../data/mock_billing_data.dart';

class CareplanSummaryScreen extends StatelessWidget {
  final String? careplanId;

  const CareplanSummaryScreen({super.key, this.careplanId});

  String _getTitle(String? title) {
    if (title == null) return "";
    if (title.toLowerCase().contains("therapist")) {
      return "";
    }
    if (title.toUpperCase() == "ADHD COACH") {
      return "ADHD Coach ";
    }
    return "Dr. ";
  }

  String _getProviderType(String? type) {
    if (type == null) return "";
    if (type.toUpperCase() == "MENTAL HEALTH NURSE") {
      return "Care Coordinator";
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    final summary = MockCarePlanSummary.sample;

    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Care Plan Summary",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHolder(
                title: "Care Plan Summary - ${FormatUtils.dateTimeFormatter(summary.createdAt, format: "d MMM yyyy")}",
                color: CarePlanColor.grey_1,
                size: 18,
                fontWeight: FontWeight.w800,
              ),
              const Gap(15),
              _buildDoctorPatientCard(context, summary),
              const Gap(15),
              _buildSectionTitle("Stressors"),
              const Gap(8),
              _buildStressorsCard(summary),
              const Gap(15),
              _buildSectionTitle("Assessment"),
              const Gap(8),
              _buildAssessmentCard(summary),
              const Gap(15),
              _buildSectionTitle("Short Term Goal"),
              const Gap(8),
              _GoalsContainer(goal: "- ${summary.assessment?.shortTermGoal ?? "N/A"}"),
              const Gap(15),
              _buildSectionTitle("Long Term Goal"),
              const Gap(8),
              _GoalsContainer(goal: "- ${summary.assessment?.longTermGoal ?? "N/A"}"),
              const Gap(15),
              _buildSectionTitle("Diagnosis"),
              const Gap(8),
              _buildDiagnosisCard(summary),
              const Gap(15),
              _buildSectionTitle("Medication"),
              const Gap(8),
              _buildMedicationList(summary),
              const Gap(15),
              _buildSectionTitle("Therapy"),
              const Gap(8),
              _buildTherapyCard(summary),
              const Gap(15),
              _buildSectionTitle("Schedule"),
              const Gap(8),
              _buildScheduleList(summary),
              const Gap(15),
              _buildSectionTitle("Appointment"),
              const Gap(8),
              _buildAppointmentCard(summary),
              const Gap(15),
              _buildSectionTitle("Request / Orders"),
              const Gap(8),
              _buildRequestsCard(summary),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return TextHolder(
      title: title,
      color: CarePlanColor.brown,
      size: 15,
      fontWeight: FontWeight.w900,
    );
  }

  Widget _buildDoctorPatientCard(BuildContext context, MockCarePlanSummary summary) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CarePlanColor.grey_1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: "${_getTitle(summary.doctor?.type)}${summary.doctor?.firstName ?? ""} ${summary.doctor?.lastName ?? ""}",
                      color: Colors.white,
                      size: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    TextHolder(
                      title: _getProviderType(summary.doctor?.type),
                      color: Colors.white,
                      size: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/new_image_place_holder.png",
                        fit: BoxFit.contain,
                      ),
                      imageUrl: "",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(5),
            const Divider(color: Color(0xFF464442)),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: "You",
                      color: Colors.white,
                      size: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    TextHolder(
                      title: "PATIENT",
                      color: Colors.white,
                      size: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            child: TextHolder(
                              title: "K10 Score",
                              color: CarePlanColor.grey_1,
                              size: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Gap(6),
                        TextHolder(
                          title: "${summary.assessment?.score ?? "N/A"}",
                          color: Colors.white,
                          size: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/new_image_place_holder.png",
                        fit: BoxFit.contain,
                      ),
                      imageUrl: "",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressorsCard(MockCarePlanSummary summary) {
    final stressors = summary.assessment?.stressors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stressors?.work == true) _StressorItem(title: "- Work"),
            if (stressors?.relationship == true) _StressorItem(title: "- Relationship"),
            if (stressors?.finances == true) _StressorItem(title: "- Finances"),
            if (stressors?.trauma == true) _StressorItem(title: "- Trauma"),
            if (stressors?.housing == true) _StressorItem(title: "- Housing"),
            if (stressors?.alcohol == true) _StressorItem(title: "- Alcohol"),
            if (stressors?.physicalhealth == true) _StressorItem(title: "- Physical Health"),
            if (stressors?.school == true) _StressorItem(title: "- School"),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(MockCarePlanSummary summary) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextHolder(
                  title: "Risk to Self",
                  color: const Color(0xFF575151),
                  size: 13,
                  fontWeight: FontWeight.w900,
                ),
                TextHolder(
                  title: "Risk to Others",
                  color: const Color(0xFF575151),
                  size: 13,
                  fontWeight: FontWeight.w900,
                ),
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextHolder(
                  title: summary.riskToSelf ?? "N/A",
                  color: CarePlanColor.grey_1,
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
                TextHolder(
                  title: summary.riskToOthers ?? "N/A",
                  color: CarePlanColor.grey_1,
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(MockCarePlanSummary summary) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: summary.diagnosis?.length ?? 0,
          itemBuilder: (c, i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFF2F2F2).withValues(alpha: 0.2),
                border: Border.all(color: const Color(0xFFF2F2F2)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextHolder(
                  title: summary.diagnosis?[i] ?? "",
                  color: CarePlanColor.grey_1,
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationList(MockCarePlanSummary summary) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: summary.medication?.length ?? 0,
      itemBuilder: (c, i) {
        final med = summary.medication![i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: med.drugName ?? "",
                    color: CarePlanColor.grey_1,
                    size: 14,
                    fontWeight: FontWeight.w900,
                  ),
                  TextHolder(
                    title: med.description ?? "",
                    color: CarePlanColor.grey_1,
                    size: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const Gap(12),
                  TextHolder(
                    title: "Dose",
                    color: CarePlanColor.grey_1,
                    size: 14,
                    fontWeight: FontWeight.w900,
                  ),
                  TextHolder(
                    title: med.dosage ?? "",
                    color: CarePlanColor.grey_1,
                    size: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTherapyCard(MockCarePlanSummary summary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHolder(
              title: "Type of therapy",
              color: CarePlanColor.grey_1,
              size: 14,
              fontWeight: FontWeight.w900,
            ),
            const Gap(6),
            TextHolder(
              title: summary.therapy?.therapyType ?? "N/A",
              color: CarePlanColor.grey_1,
              size: 13,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(MockCarePlanSummary summary) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: summary.homework?.length ?? 0,
      itemBuilder: (c, i) {
        final hw = summary.homework![i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: "Task ${i + 1}",
                    color: CarePlanColor.grey_1,
                    size: 14,
                    fontWeight: FontWeight.w900,
                  ),
                  TextHolder(
                    title: hw.task ?? "",
                    color: CarePlanColor.grey_1,
                    size: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const Gap(12),
                  TextHolder(
                    title: "Duration",
                    color: CarePlanColor.grey_1,
                    size: 14,
                    fontWeight: FontWeight.w900,
                  ),
                  TextHolder(
                    title: hw.duration ?? "",
                    color: CarePlanColor.grey_1,
                    size: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(MockCarePlanSummary summary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHolder(
              title: FormatUtils.dateTimeFormatter(summary.appointment?.appointmentDate),
              color: CarePlanColor.grey_1,
              size: 14,
              fontWeight: FontWeight.w900,
            ),
            const Gap(6),
            TextHolder(
              title: summary.appointment?.meetingLink ?? "",
              color: CarePlanColor.grey_1,
              size: 13,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsCard(MockCarePlanSummary summary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: summary.requests?.length ?? 0,
          itemBuilder: (c, i) => TextHolder(
            title: summary.requests?[i] ?? "",
            color: CarePlanColor.grey_1,
            size: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _StressorItem extends StatelessWidget {
  final String? title;

  const _StressorItem({this.title});

  @override
  Widget build(BuildContext context) {
    return TextHolder(
      title: title ?? "",
      fontWeight: FontWeight.w500,
      size: 15,
    );
  }
}

class _GoalsContainer extends StatelessWidget {
  final String? goal;

  const _GoalsContainer({this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: TextHolder(
          title: goal ?? "",
          size: 14,
          fontWeight: FontWeight.w500,
          color: CarePlanColor.black_3,
        ),
      ),
    );
  }
}
