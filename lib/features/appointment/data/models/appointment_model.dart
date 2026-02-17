import 'provider_model.dart';

class AppointmentModel {
  final ProviderModel? provider;
  final String? providerTimezone;
  final String? startTime;
  final String? endTime;
  final String? status;
  final String? createdAt;
  final int? duration;
  final String? id;
  final dynamic session;
  final dynamic practice;
  final String? title;
  final String? notes;
  final String? meetingUrl;

  AppointmentModel({
    this.provider,
    this.providerTimezone,
    this.startTime,
    this.endTime,
    this.status,
    this.createdAt,
    this.duration,
    this.id,
    this.session,
    this.practice,
    this.title,
    this.notes,
    this.meetingUrl,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      provider: json['provider'] != null
          ? ProviderModel.fromJson(json['provider'] as Map<String, dynamic>)
          : null,
      providerTimezone: json['providerTimezone'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      duration: json['duration'] as int?,
      id: json['id'] as String?,
      session: json['session'],
      practice: json['practice'],
      title: json['title'] as String?,
      notes: json['notes'] as String?,
      meetingUrl: json['meetingUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider?.toJson(),
      'providerTimezone': providerTimezone,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'createdAt': createdAt,
      'duration': duration,
      'id': id,
      'session': session,
      'practice': practice,
      'title': title,
      'notes': notes,
      'meetingUrl': meetingUrl,
    };
  }
}
