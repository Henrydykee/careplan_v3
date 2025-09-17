
import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../model/create_user_model.dart';
import '../model/kyc_status_model.dart';
import '../model/login_response_model.dart';
import 'endpoint.dart';

abstract class AuthenticationRemoteDataSource extends RemoteDataSource {
  Future<LoginResponseModel> loginUser({required String email, required String password});
  Future<String> verifyEmail({required String email, required String verificationCode, String verificationType = "registration"});
  Future<String> resendVerificationCode({required String email, String verificationType = "registration"});
  Future<String> verifyBvn({required String bvnNumber});
  Future<String> verifyDocument({
    required String idImage,
    required String selfieImage,
    required String idCardType,
  });
  Future<KycStatusResponse> getKycStatus();
  Future<String> CreateUser(CreateUserModel createUserModel);
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  final NetworkService _networkService;
  AuthenticationRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> CreateUser(CreateUserModel createUserModel) async {
    NetworkServiceResponse response = await _networkService.post(
      AuthenticationEndpoints.createUser,
      body: {
        "email": createUserModel.email,
        "first_name": createUserModel.firstName,
        "last_name": createUserModel.lastName,
        "phone_number": "${createUserModel.phoneNumber}",
        "password": createUserModel.password,
      }
    );

    final data = handleNetworkResponse(response);
    return data["message"];
  }

  @override
  Future<KycStatusResponse> getKycStatus() async {
    NetworkServiceResponse response = await _networkService.get(AuthenticationEndpoints.getKYCStatus);
    final data = handleNetworkResponse(response);
    return KycStatusResponse.fromJson(json.decode(data));
  }

  @override
  Future<LoginResponseModel> loginUser({required String email, required String password}) async {
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.loginUser, body: {"email": email, "password": password});
    final data = handleNetworkResponse(response);
    return LoginResponseModel.fromJson(json.decode(data));
  }

  @override
  Future<String> resendVerificationCode({required String email, String verificationType = "registration"}) async {
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.resendVerificationCode, body: {"email": email, "verification_type": verificationType});
    final data = handleNetworkResponse(response);
    return data["message"];
  }

  @override
  Future<String> verifyBvn({required String bvnNumber}) async {
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.verifyBvn, body: {"bvn_number": bvnNumber});

    final data = handleNetworkResponse(response);
    return data["message"];
  }

  @override
  Future<String> verifyDocument({required String idImage, required String idCardType, required String selfieImage}) async {
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.verifyId, body: {"id_image": idImage, "id_card_type": idCardType, "selfie_image": selfieImage});
    final data = handleNetworkResponse(response);
    return data["message"];
  }

  @override
  Future<String> verifyEmail({required String email, required String verificationCode, String verificationType = "registration"}) async {
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.verifyEmail, body: {"email": email, "verification_code": verificationCode, "verification_type": verificationType});
    final data = handleNetworkResponse(response);
    return data["message"];
  }
}
