import 'notes_history_item_model.dart';

class NotesHistoryResponseModel {
  final List<NotesHistoryItemModel> notes;
  final int totalDocs;
  final int totalPages;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  NotesHistoryResponseModel({
    required this.notes,
    required this.totalDocs,
    required this.totalPages,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory NotesHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return NotesHistoryResponseModel(
      notes: (json['notes'] as List<dynamic>?)
              ?.map((item) => NotesHistoryItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalDocs: json['totalDocs'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      prevPage: json['prevPage'] as int?,
      nextPage: json['nextPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes.map((item) => item.toJson()).toList(),
      'totalDocs': totalDocs,
      'totalPages': totalPages,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
      'prevPage': prevPage,
      'nextPage': nextPage,
    };
  }
}
