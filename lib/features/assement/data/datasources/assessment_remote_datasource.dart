import 'dart:convert';

import '../../../../core/data/cache/api_cache_service.dart';
import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class AssessmentRemoteDataSource extends RemoteDataSource {
  Future<String> completeAssessment({
    required String stressors,
    required String longTermGoal,
    required String shortTermGoal,
  });
  Future<String> getAssessment();
  Future<String> getAssessmentById({required String assessmentId});
  Future<String> activeAssessment();
  Future<String> createAssessment();
  Future<String> sendAssessment({required Map<String, dynamic> body});
  Future<String> getK10AssessmentHistory({int page, int limit});
  Future<String> getAsrsHistory({int page, int limit});
  Future<String> getGoalsHistory();
  Future<String> getStressorsHistory();
}

class AssessmentRemoteDataSourceImpl implements AssessmentRemoteDataSource {
  final NetworkService _networkService;
  final ApiCacheService _cache = ApiCacheService.instance;
  AssessmentRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> completeAssessment({
    required String stressors,
    required String longTermGoal,
    required String shortTermGoal,
  }) async {
    NetworkServiceResponse response = await _networkService.post(
      AssessmentEndpoints.completeAssessment,
      body: {
        "stressors": stressors,
        "longTermGoal": longTermGoal,
        "shortTermGoal": shortTermGoal,
      },
    );
    final data = handleNetworkResponse(response);
    // Invalidate all assessment caches since data changed
    _cache.invalidateGroup('assessment');
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> getAssessment() async {
    NetworkServiceResponse response = await _networkService.get(AssessmentEndpoints.getAssessment);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> getAssessmentById({required String assessmentId}) async {
    NetworkServiceResponse response = await _networkService.get("${AssessmentEndpoints.getAssessmentById}/$assessmentId");
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> activeAssessment() async {
    NetworkServiceResponse response = await _networkService.get(AssessmentEndpoints.activeAssessment);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> createAssessment() async {
    NetworkServiceResponse response = await _networkService.post(
      AssessmentEndpoints.createAssessment,
      body: {},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> sendAssessment({required Map<String, dynamic> body}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AssessmentEndpoints.sendAssessment,
      body: body,
    );
    final data = handleNetworkResponse(response);
    // Invalidate all assessment caches since data changed
    _cache.invalidateGroup('assessment');
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> getK10AssessmentHistory({int page = 1, int limit = 15}) async {
    final cacheKey = '${ApiCacheService.k10History}:$page:$limit';
    final cached = _cache.get<String>(cacheKey);
    if (cached != null) return cached;

    NetworkServiceResponse response = await _networkService.get(
      AssessmentEndpoints.getK10AssessmentHistory,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = handleNetworkResponse(response);
    final encoded = jsonEncode(data);
    _cache.put(cacheKey, encoded);
    return encoded;
  }

  @override
  Future<String> getAsrsHistory({int page = 1, int limit = 15}) async {
    final cacheKey = '${ApiCacheService.asrsHistory}:$page:$limit';
    final cached = _cache.get<String>(cacheKey);
    if (cached != null) return cached;

    NetworkServiceResponse response = await _networkService.get(
      AssessmentEndpoints.getAsrsHistory,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = handleNetworkResponse(response);
    final encoded = jsonEncode(data);
    _cache.put(cacheKey, encoded);
    return encoded;
  }

  @override
  Future<String> getGoalsHistory() async {
    final cached = _cache.get<String>(ApiCacheService.goalsHistory);
    if (cached != null) return cached;

    NetworkServiceResponse response = await _networkService.get(AssessmentEndpoints.getGoalsHistory);
    final data = handleNetworkResponse(response);
    final encoded = jsonEncode(data);
    _cache.put(ApiCacheService.goalsHistory, encoded);
    return encoded;
  }

  @override
  Future<String> getStressorsHistory() async {
    final cached = _cache.get<String>(ApiCacheService.stressorsHistory);
    if (cached != null) return cached;

    NetworkServiceResponse response = await _networkService.get(AssessmentEndpoints.getStressorsHistory);
    final data = handleNetworkResponse(response);
    final encoded = jsonEncode(data);
    _cache.put(ApiCacheService.stressorsHistory, encoded);
    return encoded;
  }
}


