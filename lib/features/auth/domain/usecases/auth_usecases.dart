

import 'package:careplan/features/auth/domain/usecases/resend_verification_code.dart';
import 'package:careplan/features/auth/domain/usecases/verify_bvn.dart';
import 'package:careplan/features/auth/domain/usecases/verify_document.dart';
import 'package:careplan/features/auth/domain/usecases/verify_email.dart';

import 'create_user.dart';
import 'get_kyc_status.dart';
import 'get_user_details.dart';
import 'login_user.dart';
import 'login_with_pin.dart';
import 'set_password.dart';
import 'set_pin.dart';
import 'update_pin.dart';
import 'update_profile.dart';

class AuthenticationUseCases {
  CreateUser createUser;
  GetKycStatus getKycStatus;
  GetUserDetails getUserDetails;
  LoginUser loginUser;
  LoginWithPin loginWithPin;
  ResendVerificationCode resendVerificationCode;
  SetPassword setPassword;
  SetPin setPin;
  UpdatePin updatePin;
  UpdateProfile updateProfile;
  VerifyDocument verifyDocument;
  VerifyBvn verifyBvn;
  VerifyEmail verifyEmail;

  AuthenticationUseCases(
    this.createUser,
    this.getKycStatus,
    this.getUserDetails,
    this.loginUser,
    this.loginWithPin,
    this.resendVerificationCode,
    this.setPassword,
    this.setPin,
    this.updatePin,
    this.updateProfile,
    this.verifyDocument,
    this.verifyBvn,
    this.verifyEmail,
  );
}
