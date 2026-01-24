

import 'package:careplan/features/auth/domain/usecases/resend_verification_code.dart';
import 'package:careplan/features/auth/domain/usecases/verify_bvn.dart';
import 'package:careplan/features/auth/domain/usecases/verify_document.dart';
import 'package:careplan/features/auth/domain/usecases/verify_email.dart';

import 'create_user.dart';
import 'get_kyc_status.dart';
import 'login_user.dart';

class AuthenticationUseCases {

  CreateUser createUser;
  GetKycStatus getKycStatus;
  LoginUser loginUser;
  ResendVerificationCode resendVerificationCode;
  VerifyDocument verifyDocument;
  VerifyBvn verifyBvn;
  VerifyEmail verifyEmail;

  AuthenticationUseCases(
      this.createUser,
      this.getKycStatus,
      this.loginUser,
      this.resendVerificationCode,
      this.verifyDocument,
      this.verifyBvn,
      this.verifyEmail,
      );
}
