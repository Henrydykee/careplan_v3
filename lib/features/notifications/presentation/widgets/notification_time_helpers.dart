import 'package:intl/intl.dart';

String formatNotificationTimestamp(String? timestamp) {
  if (timestamp == null) return '';
  try {
    final date = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM dd, yyyy').format(date);
  } catch (_) {
    return '';
  }
}

String notificationDateGroupLabel(String? timestamp) {
  if (timestamp == null) return '';
  try {
    final date = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    if (now.difference(date).inDays < 7) return 'This Week';
    return DateFormat('MMMM yyyy').format(date);
  } catch (_) {
    return '';
  }
}
