import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/careplan/presentation/widgets/history_states.dart';
import 'package:careplan/features/careplan/presentation/widgets/notes_list_item.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  final String? patientId;

  const NotesScreen({super.key, this.patientId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
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
      _fetchNotesHistory();
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
          _fetchNotesHistory();
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _fetchNotesHistory() {
    if (_patientId != null && _patientId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HistoryProvider>().fetchNotesHistory(
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
    await context.read<HistoryProvider>().fetchNotesHistory(
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
                historyProvider.notesHistory == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [NotesListShimmer()],
              );
            }

            if (historyProvider.hasError &&
                historyProvider.errorMessage.isNotEmpty &&
                historyProvider.notesHistory == null) {
              return HistoryErrorState(
                title: "Error loading notes history",
                message: historyProvider.errorMessage,
                onRetry: _fetchNotesHistory,
              );
            }

            final notes = historyProvider.notesHistory?.notes ?? [];

            if (notes.isEmpty) {
              return const HistoryEmptyState(
                title: "No Notes History",
                message: "You don't have any notes yet",
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: notes.length,
              itemBuilder: (context, i) => NotesListItem(note: notes[i]),
            );
          },
        ),
      ),
    );
  }
}
