
import '../../../../core/di/di_config.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../presentation/state/auth_provider.dart';
import '../repositories /auth_repository.dart';
import '../usecases/auth_usecases.dart';
import '../usecases/create_user.dart';
import '../usecases/get_kyc_status.dart';
import '../usecases/get_user_details.dart';
import '../usecases/login_user.dart';
import '../usecases/resend_verification_code.dart';
import '../usecases/set_password.dart';
import '../usecases/update_pin.dart';
import '../usecases/update_profile.dart';
import '../usecases/verify_bvn.dart';
import '../usecases/verify_document.dart';
import '../usecases/verify_email.dart';

Future<void> authInjector() async {
  inject.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(inject()));
  inject.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(inject()));
  inject.registerLazySingleton<AuthenticationProvider>(() => AuthenticationProvider(inject()));
  inject.registerLazySingleton<CreateUser>(() => CreateUser(inject()));
  inject.registerLazySingleton<GetKycStatus>(() => GetKycStatus(inject()));
  inject.registerLazySingleton<GetUserDetails>(() => GetUserDetails(inject()));
  inject.registerLazySingleton<LoginUser>(() => LoginUser(inject()));
  inject.registerLazySingleton<ResendVerificationCode>(() => ResendVerificationCode(inject()));
  inject.registerLazySingleton<SetPassword>(() => SetPassword(inject()));
  inject.registerLazySingleton<UpdatePin>(() => UpdatePin(inject()));
  inject.registerLazySingleton<UpdateProfile>(() => UpdateProfile(inject()));
  inject.registerLazySingleton<VerifyDocument>(() => VerifyDocument(inject()));
  inject.registerLazySingleton<VerifyBvn>(() => VerifyBvn(inject()));
  inject.registerLazySingleton<VerifyEmail>(() => VerifyEmail(inject()));

  inject.registerLazySingleton<AuthenticationUseCases>(() => AuthenticationUseCases(
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
        inject(),
      ));
}
