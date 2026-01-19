import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class UserRemoteDataSource extends RemoteDataSource {
  Future<String> sendFcmToken({required String fcm});
  Future<String> registerKyc({required Map<String, dynamic> kycData});
  Future<String> updateUserDetails({required Map<String, dynamic> body});
  Future<String> updateUserNumber({required String number});
  Future<String> verifyUpdateUserNumber({required String otp});
  Future<String> getPatientsNote();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final NetworkService _networkService;
  UserRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> sendFcmToken({required String fcm}) async {
    NetworkServiceResponse response = await _networkService.patch(
      UserEndpoints.sendFcmToken,
      body: {
        "deviceRegistrationToken": fcm,
      },
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> registerKyc({required Map<String, dynamic> kycData}) async {
    NetworkServiceResponse response = await _networkService.patch(
      UserEndpoints.registerKyc,
      body: kycData,
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> updateUserDetails({required Map<String, dynamic> body}) async {
    NetworkServiceResponse response = await _networkService.patch(
      UserEndpoints.updateUserDetails,
      body: body,
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> updateUserNumber({required String number}) async {
    NetworkServiceResponse response = await _networkService.post(
      UserEndpoints.updateUserNumber,
      body: {"newPhoneNumber": number},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> verifyUpdateUserNumber({required String otp}) async {
    NetworkServiceResponse response = await _networkService.patch(
      UserEndpoints.verifyUpdateUserNumber,
      body: {"otp": otp},
      queryParameters: {"type": "changePhoneNumber"},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> getPatientsNote() async {
    NetworkServiceResponse response = await _networkService.get(
      UserEndpoints.getPatientsNote,
      queryParameters: {"page": "1", "limit": "20"},
    );
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }
}


