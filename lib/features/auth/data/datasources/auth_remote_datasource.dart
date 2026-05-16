
import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../../../../core/di/di_config.dart';
import '../../../../core/managers/local_storage_service.dart';
import '../../../../core/platform/storage/secured_storage.dart';
import '../../../../core/platform/string_constants.dart';
import '../models/create_user_model.dart';
import '../models/kyc_status_model.dart';
import '../models/user_model.dart';
import 'endpoint.dart';

abstract class AuthenticationRemoteDataSource extends RemoteDataSource {
  Future<UserModel> loginUser({required String email, required String password});
  Future<UserModel> loginWithPin({required String email, required String pin});
  Future<String> setPin({required String pin});
  Future<String> setPassword({required String newPassword});
  Future<String> verifyOtp({required String otp});
  Future<UserModel> getUserDetails();
  Future<UserModel> updateProfile({required Map<String, dynamic> payload});
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
  Future<String> recoverPassword({required String email, required String otp, required String newPassword});
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
      body: createUserModel.toJson(),
    );

    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;

    final responseData = jsonData['data'] as Map<String, dynamic>?;
    final userData = responseData?['user'] as Map<String, dynamic>?;
    final accessToken = responseData?['accessToken'] as String?;
    final refreshToken = responseData?['refreshToken'] as String?;

    final userModel = UserModel.fromJson(userData ?? jsonData);

    if (userData != null) {
      await inject<LocalStorageService>().setJson("user", userModel.toJson());
    }

    if (accessToken != null && accessToken.isNotEmpty) {
      await inject<SecuredStorage>().add(key: SecureStorageStrings.TOKEN, value: accessToken);
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await inject<SecuredStorage>().add(key: SecureStorageStrings.REFRESH_TOKEN, value: refreshToken);
    }

    return userModel;
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
    final jsonData = data is String ? json.decode(data) : data;
    
    // Extract user and tokens from response structure: {success, message, data: {user: {...}, accessToken: "...", refreshToken: "..."}}
    final responseData = jsonData['data'] as Map<String, dynamic>?;
    final userData = responseData?['user'] as Map<String, dynamic>?;
    final accessToken = responseData?['accessToken'] as String?;
    final refreshToken = responseData?['refreshToken'] as String?;
    
    
    // Parse user model
    final userModel = UserModel.fromJson(userData ?? jsonData);
    
    // Save user to localStorage
    if (userData != null) {
      final userJson = userModel.toJson();
      await inject<LocalStorageService>().setJson("user", userJson);
      
      // Verify it was saved
      final saved = inject<LocalStorageService>().getJson("user");
    } else {
      debugPrint('🔴 [Auth] loginUser - userData is null, not saving');
    }
    
    // Save accessToken to secured storage
    if (accessToken != null && accessToken.isNotEmpty) {
      await inject<SecuredStorage>().add(key: SecureStorageStrings.TOKEN, value: accessToken);
    }
    
    // Save refreshToken to secured storage
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await inject<SecuredStorage>().add(key: SecureStorageStrings.REFRESH_TOKEN, value: refreshToken);
    }
    
    return userModel;
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
    NetworkServiceResponse response = await _networkService.post(AuthenticationEndpoints.verifyEmail, body: {"otp": verificationCode});
    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    return jsonData["message"] ?? "Verification successful";
  }

  @override
  Future<UserModel> loginWithPin({required String email, required String pin}) async {
    NetworkServiceResponse response = await _networkService.post(
      AuthenticationEndpoints.loginWithPin,
      body: {"email": email, "pin": pin},
    );
    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    
    // Extract user and tokens from response structure: {success, message, data: {user: {...}, accessToken: "...", refreshToken: "..."}}
    final responseData = jsonData['data'] as Map<String, dynamic>?;
    final userData = responseData?['user'] as Map<String, dynamic>?;
    final accessToken = responseData?['accessToken'] as String?;
    final refreshToken = responseData?['refreshToken'] as String?;
    
    // Parse user model
    final userModel = UserModel.fromJson(userData ?? jsonData);
    
    debugPrint('🟢 [Auth] loginWithPin - Parsed user: ${userModel.firstName} ${userModel.lastName}');
    debugPrint('🟢 [Auth] loginWithPin - Care team count: ${userModel.careplanTeam?.length ?? 0}');
    
    // Save user to localStorage
    if (userData != null) {
      final userJson = userModel.toJson();
      debugPrint('🟢 [Auth] loginWithPin - Saving user to storage');
      await inject<LocalStorageService>().setJson("user", userJson);
      debugPrint('🟢 [Auth] loginWithPin - User saved successfully');
    } else {
      debugPrint('🔴 [Auth] loginWithPin - userData is null, not saving');
    }
    
    // Save accessToken to secured storage
    if (accessToken != null && accessToken.isNotEmpty) {
      await inject<SecuredStorage>().add(key: SecureStorageStrings.TOKEN, value: accessToken);
    }
    
    // Save refreshToken to secured storage
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await inject<SecuredStorage>().add(key: SecureStorageStrings.REFRESH_TOKEN, value: refreshToken);
    }
    
    return userModel;
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
  Future<String> setPassword({required String newPassword}) async {
    NetworkServiceResponse response = await _networkService.patch(
      AuthenticationEndpoints.setPassword,
      body: {"newPassword": newPassword},
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
    final userModel = UserModel.fromJson(userData is Map<String, dynamic> ? userData : jsonData);
    
    debugPrint('🟢 [Auth] getUserDetails - User: ${userModel.firstName} ${userModel.lastName}');
    debugPrint('🟢 [Auth] getUserDetails - Care team count: ${userModel.careplanTeam?.length ?? 0}');
    
    // Save user to localStorage to keep it updated
    if (userData != null && userData is Map<String, dynamic>) {
      final userJson = userModel.toJson();
      debugPrint('🟢 [Auth] Saving user details to storage');
      await inject<LocalStorageService>().setJson("user", userJson);
      debugPrint('🟢 [Auth] User details saved successfully');
    } else {
      debugPrint('🔴 [Auth] getUserDetails - userData is null or not Map');
    }
    
    return userModel;
  }

  @override
  Future<UserModel> updateProfile({required Map<String, dynamic> payload}) async {
    final response = await _networkService.patch(AuthenticationEndpoints.updateProfile, body: payload);
    handleNetworkResponse(response);
    // Fetch latest user (auth/me) and save to local storage
    return getUserDetails();
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
  Future<String> recoverPassword({required String email, required String otp, required String newPassword}) async {
    NetworkServiceResponse response = await _networkService.post(
      AuthenticationEndpoints.recoverPassword,
      body: {"email": email, "otp": otp, "newPassword": newPassword},
    );
    final data = handleNetworkResponse(response);
    final jsonData = data is String ? json.decode(data) : data;
    return jsonData["message"] ?? jsonEncode(data);
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
