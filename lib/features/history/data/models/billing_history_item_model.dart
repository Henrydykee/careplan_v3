class BillingHistoryItemModel {
  final String id;
  final String amount;
  final DateTime date;
  final String status;
  final String? sessionId;
  final String invoiceURL;
  final PatientInfo? patient;
  final String? cardType;
  final String? lastFourDigits;

  BillingHistoryItemModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    this.sessionId,
    required this.invoiceURL,
    this.patient,
    this.cardType,
    this.lastFourDigits,
  });

  factory BillingHistoryItemModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date']?.toString();
    final parsedDate =
        rawDate != null ? DateTime.tryParse(rawDate) : null;

    final card = json['card'] is Map<String, dynamic>
        ? json['card'] as Map<String, dynamic>
        : null;

    String? readString(Map<String, dynamic>? src, List<String> keys) {
      if (src == null) return null;
      for (final k in keys) {
        final v = src[k];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }
      return null;
    }

    return BillingHistoryItemModel(
      id: json['id']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      date: parsedDate ?? DateTime.fromMillisecondsSinceEpoch(0),
      status: json['status']?.toString() ?? '',
      sessionId: json['sessionId']?.toString(),
      invoiceURL: json['invoiceURL']?.toString() ?? '',
      patient: json['patient'] is Map<String, dynamic>
          ? PatientInfo.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      cardType: readString(card, ['cardType', 'brand', 'type']) ??
          readString(json, ['cardType', 'cardBrand']),
      lastFourDigits:
          readString(card, ['lastFourDigits', 'last4', 'lastFour']) ??
              readString(json, ['lastFourDigits', 'last4']),
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
      'cardType': cardType,
      'lastFourDigits': lastFourDigits,
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
