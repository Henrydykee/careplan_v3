import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/notification_repository.dart';

class RegisterPushToken implements UseCase<VoidType, RegisterPushTokenParams> {
  final NotificationRepository _repository;

  RegisterPushToken(this._repository);

  @override
  Future<Either<UIError, VoidType>> call([RegisterPushTokenParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      await _repository.registerPushToken(
        token: params!.token,
        platform: params.platform,
        deviceId: params.deviceId,
        deviceName: params.deviceName,
        appVersion: params.appVersion,
      );
      return const Right(VoidType());
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    }
  }
}

class RegisterPushTokenParams {
  final String token;
  final String platform;
  final String? deviceId;
  final String? deviceName;
  final String? appVersion;

  RegisterPushTokenParams({
    required this.token,
    required this.platform,
    this.deviceId,
    this.deviceName,
    this.appVersion,
  });
}
