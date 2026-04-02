import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationsRead implements UseCase<VoidType, MarkNotificationsReadParams> {
  final NotificationRepository _repository;

  MarkNotificationsRead(this._repository);

  @override
  Future<Either<UIError, VoidType>> call([MarkNotificationsReadParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      await _repository.markAsRead(notificationIds: params!.notificationIds);
      return const Right(VoidType());
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    }
  }
}

class MarkNotificationsReadParams {
  final List<String> notificationIds;

  MarkNotificationsReadParams({required this.notificationIds});
}
