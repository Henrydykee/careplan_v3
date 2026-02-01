import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../data/mock_billing_data.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = MockBillingData.notes;

    if (notes.isEmpty) {
      return Center(
        child: TextHolder(
          title: "You don't have any notes",
          color: Colors.black,
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notes.length,
          itemBuilder: (context, i) => NotesComponent(note: notes[i]),
        ),
      ),
    );
  }
}

class NotesComponent extends StatelessWidget {
  final MockNote? note;

  const NotesComponent({super.key, this.note});

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showNoteDetail(context, note);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                TextHolder(
                  title: "${_getTitle(note?.providerType)}${note?.providerFirstName ?? ""} ${note?.providerLastName ?? ""}",
                  size: 16,
                  color: const Color(0xFF68696C),
                  fontWeight: FontWeight.w600,
                ),
                const Gap(4),
                TextHolder(
                  title: _getProviderType(note?.providerType),
                  size: 16,
                  color: const Color(0xFF68696C),
                  fontWeight: FontWeight.w600,
                ),
                const Gap(4),
                TextHolder(
                  title: "Session ID: ${note?.sessionId ?? "N/A"}",
                  size: 14,
                  color: const Color(0xFF4E4F51),
                  fontWeight: FontWeight.w700,
                ),
                const Gap(4),
                TextHolder(
                  title: FormatUtils.dateTimeFormatter(note?.createdAt, format: "d MMM yyyy"),
                  size: 14,
                  color: const Color(0xFF4E4F51),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNoteDetail(BuildContext context, MockNote? note) {
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
                  title: "${_getTitle(note?.providerType)}${note?.providerFirstName ?? ""} ${note?.providerLastName ?? ""}",
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
                  title: _getProviderType(note?.providerType),
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: const Color(0xFF4E4F51),
                ),
                const Gap(16),
                TextHolder(
                  title: "Session ID",
                  fontWeight: FontWeight.w500,
                  size: 12,
                  color: const Color(0xFF848588),
                ),
                const Gap(4),
                TextHolder(
                  title: note?.sessionId ?? "N/A",
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: const Color(0xFF4E4F51),
                ),
                const Gap(16),
                TextHolder(
                  title: "Date",
                  fontWeight: FontWeight.w500,
                  size: 12,
                  color: const Color(0xFF848588),
                ),
                const Gap(4),
                TextHolder(
                  title: FormatUtils.dateTimeFormatter(note?.createdAt, format: "d MMM yyyy, hh:mm a"),
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
                  title: note?.noteContent ?? "No notes available.",
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
