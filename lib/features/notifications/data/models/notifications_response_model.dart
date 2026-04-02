import 'notification_model.dart';

class NotificationsResponseModel {
  final List<NotificationModel>? notifications;
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  NotificationsResponseModel({
    this.notifications,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      notifications: json['notifications'] != null
          ? (json['notifications'] as List<dynamic>)
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPages: json['totalPages'] as int?,
      hasNextPage: json['hasNextPage'] as bool?,
      hasPrevPage: json['hasPrevPage'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications?.map((e) => e.toJson()).toList(),
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}
