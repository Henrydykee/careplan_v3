import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'care_plan_summary_screen.dart';

String _formatDate(String? dateStr) {
  final d = FormatUtils.dateTimeFormatter(dateStr, format: "d MMM yyyy");
  return d.isNotEmpty ? d : "N/A";
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
              limit: 10,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_patientId == null || _patientId!.isEmpty) {
      return Center(
        child: TextHolder(
          title: "You don't have any history",
          color: Colors.black,
        ),
      );
    }

    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        if (historyProvider.isLoading &&
            historyProvider.sessionHistory == null) {
          return const Center(
            child: AppLoadingIndicator(),
          );
        }

        if (historyProvider.hasError &&
            historyProvider.sessionHistory == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextHolder(
                    title: "Error loading care plan history",
                    color: Colors.red,
                    size: 16,
                  ),
                  const Gap(10),
                  TextHolder(
                    title: historyProvider.errorMessage,
                    color: CarePlanColor.grey,
                    size: 14,
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed: _fetchSessionHistory,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final history =
            historyProvider.sessionHistory?.carePlanHistory ?? [];

        if (history.isEmpty) {
          return Center(
            child: TextHolder(
              title: "You don't have any history",
              color: Colors.black,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, i) {
              final item = history[i];
              return _PreviousCareplanComponent(
                date: _formatDate(item.createdAt),
                id: item.id,
                doctorType: item.providerType,
              );
            },
          ),
        );
      },
    );
  }
}

class _PreviousCareplanComponent extends StatelessWidget {
  final String? date;
  final String? id;
  final String? doctorType;

  const _PreviousCareplanComponent({
    this.date,
    this.id,
    this.doctorType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CareplanSummaryScreen(careplanId: id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHolder(
                          title: "Created on:",
                          size: 13,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.grey_2.withValues(alpha: 0.7),
                        ),
                        TextHolder(
                          title: date ?? "N/A",
                          size: 13,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.grey_2,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/brown_check_icon.svg"),
                    const Gap(5),
                    TextHolder(
                      title: doctorType ?? "",
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: CarePlanColor.grey_2.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
