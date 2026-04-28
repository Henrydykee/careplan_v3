import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'care_plan_summary_screen.dart';

String _formatDate(String? dateStr) {
  final d = FormatUtils.dateTimeFormatter(dateStr, format: "d MMM yyyy");
  return d.isNotEmpty ? d : "N/A";
}

String _getProviderTitle(String? type) {
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

class PreviousCareplanScreen extends StatefulWidget {
  final String? patientId;

  const PreviousCareplanScreen({super.key, this.patientId});

  @override
  State<PreviousCareplanScreen> createState() => _PreviousCareplanScreenState();
}

class _PreviousCareplanScreenState extends State<PreviousCareplanScreen> {
  String? _patientId;

  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  Future<void> _loadPatientId() async {
    if (widget.patientId != null && widget.patientId!.isNotEmpty) {
      setState(() => _patientId = widget.patientId);
      _fetchSessionHistory();
      return;
    }

    try {
      final localStorage = inject<LocalStorageService>();
      final userJson = localStorage.getJson('user');
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        if (user.id != null && user.id!.isNotEmpty) {
          setState(() => _patientId = user.id);
          _fetchSessionHistory();
        }
      }
    } catch (_) {}
  }

  void _fetchSessionHistory() {
    if (_patientId != null && _patientId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HistoryProvider>().fetchSessionHistory(
              patientId: _patientId!,
              page: 1,
              limit: 15,
            );
      });
    }
  }

  Future<void> _onRefresh() async {
    if (_patientId == null || _patientId!.isEmpty) {
      await _loadPatientId();
      return;
    }
    await context.read<HistoryProvider>().fetchSessionHistory(
          patientId: _patientId!,
          page: 1,
          limit: 15,
        );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: CarePlanColor.brown,
      child: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          if (_patientId == null || _patientId!.isEmpty) {
            return _buildEmptyState();
          }

          if (historyProvider.isLoading &&
              historyProvider.sessionHistory == null) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [CareplanHistoryListShimmer()],
            );
          }

          if (historyProvider.hasError &&
              historyProvider.sessionHistory == null) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 48, color: Colors.red.withValues(alpha: 0.7)),
                      const Gap(16),
                      TextHolder(
                        title: "Error loading care plan history",
                        color: CarePlanColor.grey,
                        size: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      const Gap(8),
                      TextHolder(
                        title: historyProvider.errorMessage,
                        color: CarePlanColor.grey_3,
                        size: 14,
                        align: TextAlign.center,
                      ),
                      const Gap(24),
                      GestureDetector(
                        onTap: _fetchSessionHistory,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: CarePlanColor.brown,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextHolder(
                            title: "Retry",
                            color: Colors.white,
                            size: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final history =
              historyProvider.sessionHistory?.carePlanHistory ?? [];

          if (history.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: history.length,
            itemBuilder: (context, i) {
              final item = history[i];
              return _PreviousCareplanCard(item: item);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined,
                  size: 56, color: CarePlanColor.grey_3),
              const Gap(16),
              TextHolder(
                title: "No Care Plan History",
                color: CarePlanColor.grey,
                size: 16,
                fontWeight: FontWeight.w800,
                align: TextAlign.center,
              ),
              const Gap(8),
              TextHolder(
                title: "Your care plan history will appear here",
                color: CarePlanColor.grey_3,
                size: 14,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviousCareplanCard extends StatelessWidget {
  final CarePlanHistoryItemModel item;

  const _PreviousCareplanCard({required this.item});

  List<String> _getActiveStressors() {
    final stressors = item.stressors;
    if (stressors == null) return [];
    final active = <String>[];
    if (stressors.work == true) active.add("Work");
    if (stressors.relationship == true) active.add("Relationship");
    if (stressors.finances == true) active.add("Finances");
    if (stressors.trauma == true) active.add("Trauma");
    if (stressors.housing == true) active.add("Housing");
    if (stressors.alcohol == true) active.add("Alcohol");
    if (stressors.physicalHealth == true) active.add("Physical Health");
    if (stressors.school == true) active.add("School");
    return active;
  }

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(item.createdAt);
    final providerName =
        "${_getProviderTitle(item.providerType)}${item.provider ?? ""}".trim();
    final providerType = _getProviderType(item.providerType);
    final stressors = _getActiveStressors();
    final status = item.status;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => router.push(CareplanSummaryScreen(carePlan: item)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: CarePlanColor.grey_5),
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
              // Header row: date + status
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHolder(
                      title: date,
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
                          title: status[0].toUpperCase() +
                              status.substring(1).toLowerCase(),
                          size: 11,
                          fontWeight: FontWeight.w700,
                          color: CarePlanColor.brown,
                        ),
                      ),
                  ],
                ),
              ),
              // Provider info
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
              // Diagnosis chips
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
              // Stressors row
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
