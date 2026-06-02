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
  final ScrollController _scrollController = ScrollController();

  static const int _pageLimit = 15;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPatientId();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_patientId == null || _patientId!.isEmpty) return;
    final provider = context.read<HistoryProvider>();
    if (provider.isLoadingMoreBilling || !provider.billingHasNextPage) return;
    provider.loadMoreBilling(patientId: _patientId!, limit: _pageLimit);
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
              limit: _pageLimit,
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
          limit: _pageLimit,
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

            final history = historyProvider.billingItems;

            if (history.isEmpty) {
              return const HistoryEmptyState(
                title: "No Billing History",
                message: "You don't have any billing history yet",
              );
            }

            final showFooterLoader = historyProvider.isLoadingMoreBilling;

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: history.length + (showFooterLoader ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= history.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }
                return BillingHistoryCard(
                  billingHistoryItem: history[i],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
