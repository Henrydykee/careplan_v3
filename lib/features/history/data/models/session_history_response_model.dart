import 'care_plan_history_item_model.dart';

class SessionHistoryResponseModel {
  final List<CarePlanHistoryItemModel> carePlanHistory;
  final int totalDocs;
  final int totalPages;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  SessionHistoryResponseModel({
    required this.carePlanHistory,
    this.totalDocs = 0,
    this.totalPages = 0,
    this.hasPrevPage = false,
    this.hasNextPage = false,
    this.prevPage,
    this.nextPage,
  });

  factory SessionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryResponseModel(
      carePlanHistory:
          (json['carePlanHistory'] as List<dynamic>?)
              ?.map((item) =>
                  CarePlanHistoryItemModel.fromJson(item as Map<String, dynamic>))
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
      'carePlanHistory':
          carePlanHistory.map((item) => item.toJson()).toList(),
      'totalDocs': totalDocs,
      'totalPages': totalPages,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
      'prevPage': prevPage,
      'nextPage': nextPage,
    };
  }
}
