import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class CarePlanRemoteDataSource extends RemoteDataSource {
  Future<String> addLongTermGoal({
    required String longTermGoal,
    String? carePlanId,
  });
  Future<String> addStressor({
    bool? work,
    bool? relationship,
    bool? finances,
    bool? physicalHealthOrPain,
    bool? alcoholOrDrugs,
    bool? trauma,
    bool? housing,
    bool? school,
    String? carePlanId,
  });
  Future<String> getCarePlanHistory();
  Future<String> getK10History();
  Future<String> getActiveCarePlan({required String userId});
  Future<String> getActiveCarePlanSummary({required String carePlanId});
  Future<String> getCarePlanTeam();
}

class CarePlanRemoteDataSourceImpl implements CarePlanRemoteDataSource {
  final NetworkService _networkService;
  CarePlanRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> addLongTermGoal({
    required String longTermGoal,
    String? carePlanId,
  }) async {
    NetworkServiceResponse response = await _networkService.patch(
      CarePlanEndpoints.addLongTermGoal,
      body: {
        "longTermGoal": longTermGoal,
        "shortTermGoal":
            "(1) Reduce level of depression & anxiety by 50% by 8 weeks after starting treatment as measured by K10. (2) Improve your ability to cope with your stressors by 20% after your third therapy session."
      },
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> addStressor({
    bool? work,
    bool? relationship,
    bool? finances,
    bool? physicalHealthOrPain,
    bool? alcoholOrDrugs,
    bool? trauma,
    bool? housing,
    bool? school,
    String? carePlanId,
  }) async {
    NetworkServiceResponse response = await _networkService.patch(
      CarePlanEndpoints.addStressor,
      body: {
        "stressors": {
          "work": work,
          "relationship": relationship,
          "finances": finances,
          "physical health or pain": physicalHealthOrPain,
          "alcohol or drugs": alcoholOrDrugs,
          "trauma": trauma,
          "housing": housing,
          "school": school
        },
        "careplanId": carePlanId
      },
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> getCarePlanHistory() async {
    NetworkServiceResponse response = await _networkService.get(CarePlanEndpoints.getCarePlanHistory);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> getK10History() async {
    NetworkServiceResponse response = await _networkService.get(CarePlanEndpoints.getK10History);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> getActiveCarePlan({required String userId}) async {
    NetworkServiceResponse response = await _networkService.get("${CarePlanEndpoints.getActiveCarePlan}/$userId/recent");
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> getActiveCarePlanSummary({required String carePlanId}) async {
    NetworkServiceResponse response = await _networkService.get("${CarePlanEndpoints.getActiveCarePlanSummary}/$carePlanId");
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> getCarePlanTeam() async {
    NetworkServiceResponse response = await _networkService.get(CarePlanEndpoints.getCarePlanTeam);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }
}


