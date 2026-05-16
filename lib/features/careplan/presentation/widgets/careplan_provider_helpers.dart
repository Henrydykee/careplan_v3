import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:flutter/material.dart';

String careplanProviderTitle(String? type) {
  if (type == null) return "";
  if (type.toLowerCase().contains("therapist")) return "";
  if (type.toUpperCase() == "ADHD COACH") return "ADHD Coach ";
  return "Dr. ";
}

String careplanProviderType(String? type) {
  if (type == null) return "";
  if (type.toUpperCase() == "MENTAL HEALTH NURSE") return "Care Coordinator";
  return type;
}

String careplanCapitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}

String careplanInitialsFor(String name) {
  final cleaned = name
      .replaceFirst(
          RegExp(r'^(Dr\.?|Mr\.?|Mrs\.?|Ms\.?|ADHD Coach)\s+',
              caseSensitive: false),
          '')
      .trim();
  if (cleaned.isEmpty) return "?";
  final parts = cleaned.split(RegExp(r'\s+'));
  final first = parts.first.isNotEmpty ? parts.first[0] : '';
  final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
  final initials = "$first$last".toUpperCase();
  return initials.isEmpty ? "?" : initials;
}

List<String> careplanActiveStressors(StressorsModel? s) {
  if (s == null) return const [];
  final list = <String>[];
  if (s.work == true) list.add("Work");
  if (s.relationship == true) list.add("Relationship");
  if (s.finances == true) list.add("Finances");
  if (s.trauma == true) list.add("Trauma");
  if (s.housing == true) list.add("Housing");
  if (s.alcohol == true) list.add("Alcohol");
  if (s.physicalHealth == true) list.add("Physical Health");
  if (s.school == true) list.add("School");
  return list;
}

List<String> careplanInterventions(TherapyModel? t) {
  if (t == null) return const [];
  final list = <String>[];
  if (t.hasCBT == true) list.add("CBT");
  if (t.hasSafetyPlanning == true) list.add("Safety planning");
  final other = (t.otherIntervention ?? "").trim();
  if (other.isNotEmpty) list.add(other);
  return list;
}

Color careplanRiskColor(String value) {
  final v = value.toLowerCase();
  if (v.contains("high")) return Colors.red;
  if (v.contains("moderate") || v.contains("medium")) {
    return CarePlanColor.orange;
  }
  if (v.contains("low") || v.contains("none") || v.contains("nil")) {
    return Colors.green;
  }
  return CarePlanColor.grey_3;
}
