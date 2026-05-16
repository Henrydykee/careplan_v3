import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/careplan/presentation/widgets/billing_history_card.dart';
import 'package:careplan/features/careplan/presentation/widgets/history_states.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
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
              return HistoryErrorState(
                title: "Error loading billing history",
                message: historyProvider.errorMessage,
                onRetry: _fetchBillingHistory,
              );
            }

            final history = historyProvider.billingHistory?.history ?? [];

            if (history.isEmpty) {
              return const HistoryEmptyState(
                title: "No Billing History",
                message: "You don't have any billing history yet",
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: history.length,
              itemBuilder: (context, i) => BillingHistoryCard(
                billingHistoryItem: history[i],
              ),
            );
          },
        ),
      ),
    );
  }
}
