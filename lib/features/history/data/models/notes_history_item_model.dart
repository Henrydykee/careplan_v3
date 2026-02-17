class NotesHistoryItemModel {
  final String id;
  final String patientNote;
  final DateTime createdAt;
  final String? editedBy;
  final int editVersion;
  final bool isEdited;
  final String provider;
  final String providerId;
  final String? sessionId;
  final String providerType;
  final bool isStandalone;
  final String? patientNoteParentId;
  final String? providerNumber;

  NotesHistoryItemModel({
    required this.id,
    required this.patientNote,
    required this.createdAt,
    this.editedBy,
    required this.editVersion,
    required this.isEdited,
    required this.provider,
    required this.providerId,
    this.sessionId,
    required this.providerType,
    required this.isStandalone,
    this.patientNoteParentId,
    this.providerNumber,
  });

  factory NotesHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return NotesHistoryItemModel(
      id: json['id'] as String,
      patientNote: json['patientNote'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      editedBy: json['editedBy'] as String?,
      editVersion: json['editVersion'] as int? ?? 1,
      isEdited: json['isEdited'] as bool? ?? false,
      provider: json['provider'] as String,
      providerId: json['providerId'] as String,
      sessionId: json['sessionId'] as String?,
      providerType: json['providerType'] as String,
      isStandalone: json['isStandalone'] as bool? ?? false,
      patientNoteParentId: json['patientNoteParentId'] as String?,
      providerNumber: json['providerNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientNote': patientNote,
      'createdAt': createdAt.toIso8601String(),
      'editedBy': editedBy,
      'editVersion': editVersion,
      'isEdited': isEdited,
      'provider': provider,
      'providerId': providerId,
      'sessionId': sessionId,
      'providerType': providerType,
      'isStandalone': isStandalone,
      'patientNoteParentId': patientNoteParentId,
      'providerNumber': providerNumber,
    };
  }
}
