import 'appointment_model.dart';

class UpcomingAppointmentsResponseModel {
  final List<AppointmentModel>? appointments;
  final int? totalDocs;
  final int? totalPages;
  final bool? hasPrevPage;
  final bool? hasNextPage;
  final int? prevPage;
  final int? nextPage;

  UpcomingAppointmentsResponseModel({
    this.appointments,
    this.totalDocs,
    this.totalPages,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory UpcomingAppointmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointmentsResponseModel(
      appointments: json['appointments'] != null
          ? (json['appointments'] as List<dynamic>)
              .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      totalDocs: json['totalDocs'] as int?,
      totalPages: json['totalPages'] as int?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      hasNextPage: json['hasNextPage'] as bool?,
      prevPage: json['prevPage'] as int?,
      nextPage: json['nextPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointments': appointments?.map((e) => e.toJson()).toList(),
      'totalDocs': totalDocs,
      'totalPages': totalPages,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
      'prevPage': prevPage,
      'nextPage': nextPage,
    };
  }
}
