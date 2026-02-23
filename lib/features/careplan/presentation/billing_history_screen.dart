import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/careplan/presentation/billinng_detail_screen.dart';
import 'package:careplan/features/history/data/models/billing_history_item_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BillingHistoryScreen extends StatefulWidget {
  final String? patientId;

  const BillingHistoryScreen({super.key, this.patientId});

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  String? _patientId;

  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  Future<void> _loadPatientId() async {
    if (widget.patientId != null && widget.patientId!.isNotEmpty) {
      setState(() {
        _patientId = widget.patientId;
      });
      _fetchBillingHistory();
      return;
    }

    try {
      final localStorage = inject<LocalStorageService>();
      final userJson = localStorage.getJson('user');
      if (userJson != null) {
        final user = UserModel.fromJson(userJson);
        if (user.id != null && user.id!.isNotEmpty) {
          setState(() {
            _patientId = user.id;
          });
          _fetchBillingHistory();
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _fetchBillingHistory() {
    if (_patientId != null && _patientId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HistoryProvider>().fetchBillingHistory(
              patientId: _patientId!,
              page: 1,
              limit: 15,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          if (historyProvider.isLoading && historyProvider.billingHistory == null) {
            return const Center(
              child: AppLoadingIndicator(),
            );
          }

          if (historyProvider.hasError && historyProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextHolder(
                      title: "Error loading billing history",
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
                      onPressed: _fetchBillingHistory,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          final history = historyProvider.billingHistory?.history ?? [];

          if (history.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextHolder(
                      title: "No Billing History",
                      align: TextAlign.center,
                      color: CarePlanColor.grey,
                      size: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    const Gap(10),
                    TextHolder(
                      title: "You don't have any billing history yet",
                      align: TextAlign.center,
                      color: CarePlanColor.grey_2,
                      size: 14,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (_patientId != null && _patientId!.isNotEmpty) {
                await historyProvider.fetchBillingHistory(
                  patientId: _patientId!,
                  page: 1,
                  limit: 15,
                );
              }
            },
            color: CarePlanColor.brown,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: history.length,
              itemBuilder: (context, i) => BillingHistoryComponent(
                billingHistoryItem: history[i],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BillingHistoryComponent extends StatelessWidget {
  final BillingHistoryItemModel billingHistoryItem;

  const BillingHistoryComponent({super.key, required this.billingHistoryItem});

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryItem;
    final formattedDate = DateFormat('d MMM yyyy').format(data.date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillingDetailScreen(
                billingHistoryItem: data,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.patient?.name != null)
                  TextHolder(
                    title: data.patient!.name,
                    size: 16,
                    color: const Color(0xFF68696C),
                    fontWeight: FontWeight.w600,
                  ),
                const Gap(4),
                TextHolder(
                  title: "\$${data.amount}",
                  size: 18,
                  color: const Color(0xFF4E4F51),
                  fontWeight: FontWeight.w700,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHolder(
                      title: formattedDate,
                      size: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: TextHolder(
                          title: toBeginningOfSentenceCase(data.status),
                          size: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB17F34),
                        ),
                      ),
                    ),
                  ],
                ),
                if (data.sessionId != null) ...[
                  const Gap(4),
                  TextHolder(
                    title: "Session ID: ${data.sessionId}",
                    size: 12,
                    color: const Color(0xFF848588),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
