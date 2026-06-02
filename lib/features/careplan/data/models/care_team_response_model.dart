import '../../../auth/data/models/user_model.dart';

/// Response for GET {{base_url}}/careteams/:id?page=1&limit=10
///
/// ```json
/// { "data": { "careTeam": [ { "provider": "...", "email": "...",
///   "role": "...", "type": "...", "providerType": "..." } ] } }
/// ```
class CareTeamResponseModel {
  final List<CarePlanTeamMember> careTeam;
  final int? page;
  final int? limit;
  final int? total;

  CareTeamResponseModel({
    this.careTeam = const [],
    this.page,
    this.limit,
    this.total,
  });

  factory CareTeamResponseModel.fromJson(Map<String, dynamic> json) {
    final members = (json['careTeam'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map((e) => CarePlanTeamMember.fromJson(e))
            .toList() ??
        const <CarePlanTeamMember>[];

    return CareTeamResponseModel(
      careTeam: members,
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );
  }
}
