



import '../../data/model/create_user_model.dart';
import '../../data/model/kyc_status_model.dart';
import '../../data/model/user_model.dart';

abstract class AuthenticationRepository {
  Future<UserModel> loginUser({required String email, required String password});
  Future<UserModel> loginWithPin({required String email, required String pin});
  Future<String> setPin({required String pin});
  Future<String> setPassword({required String newPassword});
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
  Future<UserModel> getUserDetails();
  Future<UserModel> updateProfile({required Map<String, dynamic> payload});
  Future<String> updatePin({required String oldPin, required String newPin});
}