import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
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

  Future<void> _onRefresh() async {
    if (_patientId == null || _patientId!.isEmpty) {
      await _loadPatientId();
      return;
    }
    await context.read<HistoryProvider>().fetchBillingHistory(
          patientId: _patientId!,
          page: 1,
          limit: 15,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: CarePlanColor.brown,
        child: Consumer<HistoryProvider>(
          builder: (context, historyProvider, child) {
            if (historyProvider.isLoading &&
                historyProvider.billingHistory == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [BillingHistoryListShimmer()],
              );
            }

            if (historyProvider.hasError &&
                historyProvider.errorMessage.isNotEmpty &&
                historyProvider.billingHistory == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 60),
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
                ],
              );
            }

            final history = historyProvider.billingHistory?.history ?? [];

            if (history.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
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
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: history.length,
              itemBuilder: (context, i) => BillingHistoryComponent(
                billingHistoryItem: history[i],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BillingHistoryComponent extends StatelessWidget {
  final BillingHistoryItemModel billingHistoryItem;

  const BillingHistoryComponent({super.key, required this.billingHistoryItem});

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains("paid") || s.contains("complete") || s.contains("success")) {
      return Colors.green;
    }
    if (s.contains("fail") || s.contains("declin") || s.contains("refund")) {
      return Colors.red;
    }
    return CarePlanColor.brown;
  }

  Color _statusBg(Color accent) => accent.withValues(alpha: 0.12);

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryItem;
    final formattedDate = DateFormat('d MMM yyyy').format(data.date);
    final status = (data.status).trim();
    final statusLabel =
        status.isNotEmpty ? toBeginningOfSentenceCase(status) : '';
    final statusAccent = _statusColor(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
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
          child: Ink(
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
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextHolder(
                                title: "\$${data.amount}",
                                color: CarePlanColor.brown,
                                size: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (statusLabel.isNotEmpty) ...[
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusBg(statusAccent),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextHolder(
                                  title: statusLabel,
                                  color: statusAccent,
                                  size: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const Gap(4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: CarePlanColor.grey_3,
                            ),
                            const Gap(4),
                            TextHolder(
                              title: formattedDate,
                              color: CarePlanColor.grey_3,
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            if (data.sessionId != null &&
                                data.sessionId!.isNotEmpty) ...[
                              const Gap(8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: CarePlanColor.grey_3,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const Gap(8),
                              Flexible(
                                child: TextHolder(
                                  title: "Session #${data.sessionId}",
                                  color: CarePlanColor.grey_3,
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: CarePlanColor.grey_3,
                    size: 22,
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
