import 'billing_history_item_model.dart';

class BillingHistoryResponseModel {
  final List<BillingHistoryItemModel> history;
  final int totalDocs;
  final int totalPages;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  BillingHistoryResponseModel({
    required this.history,
    required this.totalDocs,
    required this.totalPages,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory BillingHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return BillingHistoryResponseModel(
      history: (json['history'] as List<dynamic>?)
              ?.map((item) => BillingHistoryItemModel.fromJson(item as Map<String, dynamic>))
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
      'history': history.map((item) => item.toJson()).toList(),
      'totalDocs': totalDocs,
      'totalPages': totalPages,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
      'prevPage': prevPage,
      'nextPage': nextPage,
    };
  }
}
