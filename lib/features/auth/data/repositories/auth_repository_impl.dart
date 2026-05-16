

import 'package:careplan/features/auth/data/models/user_model.dart';

import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/create_user_model.dart';
import '../models/kyc_status_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  // ignore: unused_field
  final AuthenticationRemoteDataSource _remoteDataSource;

  AuthenticationRepositoryImpl(
      this._remoteDataSource,
      ) {}



  @override
  Future<UserModel> CreateUser(CreateUserModel createUserModel) async =>
      await guardedApiCall<UserModel>(() => _remoteDataSource.CreateUser(createUserModel), source: "CreateUser", showNetworkError: true);

  @override
  Future<KycStatusResponse> getKycStatus() async =>
      await guardedApiCall<KycStatusResponse>(() => _remoteDataSource.getKycStatus(), source: "getKycStatus", showNetworkError: true);

  @override
  Future<UserModel> loginUser({required String email, required String password}) async =>
      await guardedApiCall<UserModel>(() => _remoteDataSource.loginUser(email: email, password: password), source: "loginUser" , showNetworkError: true);

  @override
  Future<UserModel> loginWithPin({required String email, required String pin}) async =>
      await guardedApiCall<UserModel>(() => _remoteDataSource.loginWithPin(email: email, pin: pin), source: "loginWithPin", showNetworkError: true);

  @override
  Future<String> setPassword({required String newPassword}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.setPassword(newPassword: newPassword), source: "setPassword", showNetworkError: true);

  @override
  Future<String> setPin({required String pin}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.setPin(pin: pin), source: "setPin", showNetworkError: true);

  @override
  Future<String> resendVerificationCode({required String email, String verificationType = "registration"}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.resendVerificationCode(email: email, verificationType: verificationType), source: "resendVerificationCode", showNetworkError: true);

  @override
  Future<String> verifyBvn({required String bvnNumber}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.verifyBvn(bvnNumber: bvnNumber), source: "verifyBvn",showNetworkError: true);

  @override
  Future<String> verifyDocument({required String idImage, required String selfieImage, required String idCardType}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.verifyDocument(idImage: idImage, selfieImage: selfieImage, idCardType: idCardType), source: "verifyDocument",showNetworkError: true);

  @override
  Future<String> verifyEmail({required String email, required String verificationCode, String verificationType = "registration"}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.verifyEmail(email: email, verificationCode: verificationCode, verificationType: verificationType), source: "verifyEmail", showNetworkError: true);

  @override
  Future<UserModel> getUserDetails() async =>
      await guardedApiCall<UserModel>(() => _remoteDataSource.getUserDetails(), source: "getUserDetails", showNetworkError: true);

  @override
  Future<UserModel> updateProfile({required Map<String, dynamic> payload}) async =>
      await guardedApiCall<UserModel>(() => _remoteDataSource.updateProfile(payload: payload), source: "updateProfile", showNetworkError: true);

  @override
  Future<String> updatePin({required String oldPin, required String newPin}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.updatePin(oldPin: oldPin, newPin: newPin), source: "updatePin", showNetworkError: true);

  @override
  Future<String> recoverPassword({required String email, required String otp, required String newPassword}) async =>
      await guardedApiCall<String>(() => _remoteDataSource.recoverPassword(email: email, otp: otp, newPassword: newPassword), source: "recoverPassword", showNetworkError: true);
}