import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/careplan/presentation/widgets/previous_careplan_card.dart';
import 'package:careplan/features/careplan/presentation/widgets/previous_careplan_states.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            return const PreviousCareplanEmptyState();
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
            return PreviousCareplanErrorState(
              message: historyProvider.errorMessage,
              onRetry: _fetchSessionHistory,
            );
          }

          final history =
              historyProvider.sessionHistory?.carePlanHistory ?? [];

          if (history.isEmpty) {
            return const PreviousCareplanEmptyState();
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: history.length,
            itemBuilder: (context, i) =>
                PreviousCareplanCard(item: history[i]),
          );
        },
      ),
    );
  }
}
