import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/history/data/models/notes_history_item_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
                          title: "Error loading notes history",
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
                          onPressed: _fetchNotesHistory,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final notes = historyProvider.notesHistory?.notes ?? [];

            if (notes.isEmpty) {
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
                          title: "No Notes History",
                          align: TextAlign.center,
                          color: CarePlanColor.grey,
                          size: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        const Gap(10),
                        TextHolder(
                          title: "You don't have any notes yet",
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
              itemCount: notes.length,
              itemBuilder: (context, i) => NotesComponent(note: notes[i]),
            );
          },
        ),
      ),
    );
  }
}

class NotesComponent extends StatelessWidget {
  final NotesHistoryItemModel note;

  const NotesComponent({super.key, required this.note});

  String _getTitle(String? type) {
    if (type == null) return "";
    if (type.toLowerCase().contains("therapist")) {
      return "";
    }
    if (type.toUpperCase() == "ADHD COACH") {
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

  String _stripHtmlTags(String htmlString) {
    // Simple HTML tag removal - you might want to use a package like html_unescape for better handling
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final providerName =
        "${_getTitle(note.providerType)}${note.provider}".trim();
    final providerType = _getProviderType(note.providerType);
    final formattedDate = FormatUtils.dateTimeFormatter(
      note.createdAt.toIso8601String(),
      format: "d MMM yyyy",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showNoteDetail(context, note),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sticky_note_2_outlined,
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
                          children: [
                            Expanded(
                              child: TextHolder(
                                title: providerName.isNotEmpty
                                    ? providerName
                                    : "Provider note",
                                color: CarePlanColor.brown,
                                size: 15,
                                fontWeight: FontWeight.w800,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Gap(8),
                            TextHolder(
                              title: formattedDate,
                              color: CarePlanColor.grey_3,
                              size: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
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

  void _showNoteDetail(BuildContext context, NotesHistoryItemModel note) {
    final noteContent = _stripHtmlTags(note.patientNote);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(16),
                TextHolder(
                  title: "Session Notes",
                  fontWeight: FontWeight.w700,
                  size: 18,
                ),
                const Gap(16),
                const Divider(),
                const Gap(16),
                TextHolder(
                  title: "Provider",
                  fontWeight: FontWeight.w500,
                  size: 12,
                  color: const Color(0xFF848588),
                ),
                const Gap(4),
                TextHolder(
                  title: "${_getTitle(note.providerType)}${note.provider}",
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: const Color(0xFF4E4F51),
                ),
                const Gap(16),
                TextHolder(
                  title: "Provider Type",
                  fontWeight: FontWeight.w500,
                  size: 12,
                  color: const Color(0xFF848588),
                ),
                const Gap(4),
                TextHolder(
                  title: _getProviderType(note.providerType),
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: const Color(0xFF4E4F51),
                ),
                if (note.sessionId != null) ...[
                  const Gap(16),
                  TextHolder(
                    title: "Session ID",
                    fontWeight: FontWeight.w500,
                    size: 12,
                    color: const Color(0xFF848588),
                  ),
                  const Gap(4),
                  TextHolder(
                    title: note.sessionId,
                    fontWeight: FontWeight.w600,
                    size: 14,
                    color: const Color(0xFF4E4F51),
                  ),
                ],
                const Gap(16),
                TextHolder(
                  title: "Date",
                  fontWeight: FontWeight.w500,
                  size: 12,
                  color: const Color(0xFF848588),
                ),
                const Gap(4),
                TextHolder(
                  title: FormatUtils.dateTimeFormatter(
                    note.createdAt.toIso8601String(),
                    format: "d MMM yyyy, hh:mm a",
                  ),
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: const Color(0xFF4E4F51),
                ),
                const Gap(16),
                const Divider(),
                const Gap(16),
                TextHolder(
                  title: "Notes",
                  fontWeight: FontWeight.w500,
                  size: 12,
                  color: const Color(0xFF848588),
                ),
                const Gap(8),
                TextHolder(
                  title: noteContent.isNotEmpty ? noteContent : "No notes available.",
                  fontWeight: FontWeight.w400,
                  size: 14,
                  color: const Color(0xFF4E4F51),
                ),
                const Gap(30),
              ],
            ),
          ),
        );
      },
    );
  }
}
