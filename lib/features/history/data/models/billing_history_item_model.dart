class BillingHistoryItemModel {
  final String id;
  final String amount;
  final DateTime date;
  final String status;
  final String? sessionId;
  final String invoiceURL;
  final PatientInfo? patient;

  BillingHistoryItemModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    this.sessionId,
    required this.invoiceURL,
    this.patient,
  });

  factory BillingHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return BillingHistoryItemModel(
      id: json['id'] as String,
      amount: json['amount'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      sessionId: json['sessionId'] as String?,
      invoiceURL: json['invoiceURL'] as String,
      patient: json['patient'] != null
          ? PatientInfo.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'sessionId': sessionId,
      'invoiceURL': invoiceURL,
      'patient': patient?.toJson(),
    };
  }
}

class PatientInfo {
  final String id;
  final String name;

  PatientInfo({
    required this.id,
    required this.name,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
