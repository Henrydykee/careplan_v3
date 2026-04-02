class NotificationModel {
  final String? id;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? timestamp;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      isRead: json['isRead'] as bool?,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }
}
