class AuthenticationEndpoints {
  static String registerUser = "auth/register";
  static String loginUser = "auth/login";
  static String loginWithPin = "auth/login-pin";
  static String setPin = "auth/set-pin";
  static String setPassword = "auth/set-password";
  static String verifyOtp = "user/verify";
  static String getUserDetails = "auth/me";
  static String updateProfile = "users/profile";
  static String sendPasswordResetMail = "user/send-otp";
  static String resetPassword = "user/password/reset";
  static String updatePassword = "user/update/password";
  static String updatePin = "auth/update-pin";
  static String resendOTP = "user/resend-otp";
  static String verifyEmail = "auth/verify-otp";
  static String resendVerificationCode = "auth/resend-verification";
  static String verifyBvn = "auth/verify-bvn";
  static String verifyId = "auth/verify-id";
  static String getKYCStatus = "auth/kyc-status";
}
