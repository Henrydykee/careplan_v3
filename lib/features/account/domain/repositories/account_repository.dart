abstract class AccountRepository {
  Future<String> sendFcmToken({required String fcm});
  Future<String> registerKyc({required Map<String, dynamic> kycData});
  Future<String> updateUserDetails({required Map<String, dynamic> body});
  Future<String> updateUserNumber({required String number});
  Future<String> verifyUpdateUserNumber({required String otp});
  Future<String> getPatientsNote();
}
