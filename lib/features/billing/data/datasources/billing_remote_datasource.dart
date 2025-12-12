import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class BillingRemoteDataSource extends RemoteDataSource {
  Future<String> getBillingHistory();
  Future<String> downloadLodgementForm({required String claimId});
  Future<String> checkClaimStatus({required String claimId, required String locationId});
}

class BillingRemoteDataSourceImpl implements BillingRemoteDataSource {
  final NetworkService _networkService;
  BillingRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> getBillingHistory() async {
    NetworkServiceResponse response = await _networkService.get(BillingEndpoints.getBillingHistory);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> downloadLodgementForm({required String claimId}) async {
    NetworkServiceResponse response = await _networkService.get(
      BillingEndpoints.downloadLodgementForm,
      queryParameters: {"claimId": claimId},
    );
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> checkClaimStatus({required String claimId, required String locationId}) async {
    NetworkServiceResponse response = await _networkService.post(
      BillingEndpoints.checkClaimStatus,
      queryParameters: {
        "locationId": locationId,
        "claimId": claimId,
      },
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }
}

