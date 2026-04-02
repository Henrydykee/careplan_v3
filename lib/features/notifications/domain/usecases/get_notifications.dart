import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/notifications_response_model.dart';
import '../repositories/notification_repository.dart';

class GetNotifications implements UseCase<NotificationsResponseModel, GetNotificationsParams> {
  final NotificationRepository _repository;

  GetNotifications(this._repository);

  @override
  Future<Either<UIError, NotificationsResponseModel>> call([GetNotificationsParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final result = await _repository.getNotifications(
        page: params!.page,
        limit: params.limit,
        status: params.status,
      );
      return Right(result);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    }
  }
}

class GetNotificationsParams {
  final int page;
  final int limit;
  final String status;

  GetNotificationsParams({
    this.page = 1,
    this.limit = 20,
    this.status = 'all',
  });
}
