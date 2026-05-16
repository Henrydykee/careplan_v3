import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:careplan/features/careplan/presentation/widgets/careplan_provider_helpers.dart';
import 'package:careplan/features/history/data/models/notes_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotesListItem extends StatelessWidget {
  final NotesHistoryItemModel note;

  const NotesListItem({super.key, required this.note});

  String _stripHtmlTags(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final providerName =
        "${careplanProviderTitle(note.providerType)}${note.provider}".trim();
    final providerType = careplanProviderType(note.providerType);
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
          onTap: () => _showNoteDetail(context),
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

  void _showNoteDetail(BuildContext context) {
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
                _NoteDetailField(
                  label: "Provider",
                  value:
                      "${careplanProviderTitle(note.providerType)}${note.provider}",
                ),
                const Gap(16),
                _NoteDetailField(
                  label: "Provider Type",
                  value: careplanProviderType(note.providerType),
                ),
                if (note.sessionId != null) ...[
                  const Gap(16),
                  _NoteDetailField(
                    label: "Session ID",
                    value: note.sessionId!,
                  ),
                ],
                const Gap(16),
                _NoteDetailField(
                  label: "Date",
                  value: FormatUtils.dateTimeFormatter(
                    note.createdAt.toIso8601String(),
                    format: "d MMM yyyy, hh:mm a",
                  ),
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
                  title: noteContent.isNotEmpty
                      ? noteContent
                      : "No notes available.",
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

class _NoteDetailField extends StatelessWidget {
  final String label;
  final String value;

  const _NoteDetailField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextHolder(
          title: label,
          fontWeight: FontWeight.w500,
          size: 12,
          color: const Color(0xFF848588),
        ),
        const Gap(4),
        TextHolder(
          title: value,
          fontWeight: FontWeight.w600,
          size: 14,
          color: const Color(0xFF4E4F51),
        ),
      ],
    );
  }
}
