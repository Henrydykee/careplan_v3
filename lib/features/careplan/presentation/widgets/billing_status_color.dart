import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';

Color billingStatusColor(String status) {
  final s = status.toLowerCase();
  if (s.contains("paid") || s.contains("complete") || s.contains("success")) {
    return Colors.green;
  }
  if (s.contains("fail") || s.contains("declin") || s.contains("refund")) {
    return Colors.red;
  }
  return CarePlanColor.brown;
}
