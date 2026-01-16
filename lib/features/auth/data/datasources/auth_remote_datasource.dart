
import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../model/create_user_model.dart';
import '../model/kyc_status_model.dart';
import '../model/user_model.dart';
import 'endpoint.dart';

abstract class AuthenticationRemoteDataSource extends RemoteDataSource {
  Future<UserModel> loginUser({required String email, required String password});
  Future<UserModel> loginWithPin({required String email, required String pin});
  Future<String> setPin({required String pin});
  Future<String> verifyOtp({required String otp});
  Future<UserModel> getUserDetails();
  Future<String> sendPasswordResetMail({required String email});
  Future<String> resetPassword({required String otp, required String password});
  Future<String> updatePassword({required String oldPassword, required String newPassword});
  Future<String> updatePin({required String oldPin, required String newPin});
  Future<String> resendOTP({required String email});
  Future<String> verifyEmail({required String email, required String verificationCode, String verificationType = "registration"});
  Future<String> resendVerificationCode({required String email, String verificationType = "registration"});
  Future<String> verifyBvn({required String bvnNumber});
  Future<String> verifyDocument({
    required String idImage,
    required String selfieImage,
    required String idCardType,
  });
  Future<KycStatusResponse> getKycStatus();
  Future<UserModel> CreateUser(CreateUserModel createUserModel);
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  final NetworkService _networkService;
  AuthenticationRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<UserModel> CreateUser(CreateUserModel createUserModel) async {
    NetworkServiceResponse response = await _networkService.post(
      AuthenticationEndpoints.registerUser,
      body: {
        "email": createUserModel.email,
        "first_name": createUserModel.firstName,
        "last_name": createUserModel.lastName,
        "phone_number": "${createUserModel.phoneNumber}",
        "password": createUserModel.password,
      }
    );

    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    // Handle nested response structure: data.user or data or direct user
    final userData = jsonData['data']?['user'] ?? jsonData['data'] ?? jsonData['user'] ?? jsonData;
    return UserModel.fromJson(userData is Map<String, dynamic> ? userData : jsonData);
  }

  @override
  Future<KycStatusResponse> getKycStatus() async {
    NetworkServiceResponse response = await _networkService.get(AuthenticationEndpoints.getKYCStatus);
    final data = handleNetworkResponse(response);
    return KycStatusResponse.fromJson(json.decode(data));
  }

  @override
  Future<UserModel> loginUser({required String email, required String password}) async {
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.loginUser, body: {"email": email, "password": password});
    final data = handleNetworkResponse(response);
    return UserModel.fromJson(json.decode(data));
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

  @override
  Future<UserModel> loginWithPin({required String email, required String pin}) async {
    NetworkServiceResponse response = await _networkService.post(
      AuthenticationEndpoints.loginWithPin,
      body: {"email": email, "pin": pin},
    );
    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    // Handle nested response structure: data.user or data or direct user
    final userData = jsonData['data']?['user'] ?? jsonData['data'] ?? jsonData['user'] ?? jsonData;
    return UserModel.fromJson(userData is Map<String, dynamic> ? userData : jsonData);
  }

  @override
  Future<String> setPin({required String pin}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AuthenticationEndpoints.setPin,
      body: {"pin": pin},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> verifyOtp({required String otp}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AuthenticationEndpoints.verifyOtp,
      body: {"otp": otp},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<UserModel> getUserDetails() async {
    NetworkServiceResponse response = await _networkService.get(AuthenticationEndpoints.getUserDetails);
    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    // Handle nested response structure: data.user or data or direct user
    final userData = jsonData['data']?['user'] ?? jsonData['data'] ?? jsonData['user'] ?? jsonData;
    return UserModel.fromJson(userData is Map<String, dynamic> ? userData : jsonData);
  }

  @override
  Future<String> sendPasswordResetMail({required String email}) async {
    NetworkServiceResponse response = await _networkService.post(
      AuthenticationEndpoints.sendPasswordResetMail,
      body: {"email": email.toString().toLowerCase()},
      queryParameters: {"type": "resetPassword"},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> resetPassword({required String otp, required String password}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AuthenticationEndpoints.resetPassword,
      body: {"password": password, "otp": otp},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> updatePassword({required String oldPassword, required String newPassword}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AuthenticationEndpoints.updatePassword,
      body: {"oldPassword": oldPassword, "newPassword": newPassword},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> updatePin({required String oldPin, required String newPin}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AuthenticationEndpoints.updatePin,
      body: {"oldPin": oldPin, "newPin": newPin},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> resendOTP({required String email}) async {
    NetworkServiceResponse response = await _networkService.get(
      AuthenticationEndpoints.resendOTP,
      queryParameters: {"email": email},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }
}
