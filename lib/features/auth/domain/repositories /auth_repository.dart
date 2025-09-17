



import '../../data/model/create_user_model.dart';
import '../../data/model/kyc_status_model.dart';
import '../../data/model/login_response_model.dart';

abstract class AuthenticationRepository {
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