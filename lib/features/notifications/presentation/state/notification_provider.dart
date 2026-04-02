import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/di/di_config.dart';
import '../../../../core/managers/device_manager.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/notifications_response_model.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notifications_read.dart';
import '../../domain/usecases/notification_usecases.dart';
import '../../domain/usecases/register_push_token.dart';

class NotificationProvider with ChangeNotifier, ProviderState {
  final NotificationUseCases useCases;

  NotificationProvider(this.useCases);

  List<NotificationModel> _notifications = [];
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isLoadingMore = false;
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;
  int get unreadCount => _unreadCount;

  void _setState({
    loading = false,
    isReady = false,
    hasError = false,
    errorMsg = '',
    payload,
  }) {
    update(
      loading: loading,
      hasErr: hasError,
      errorMsg: errorMsg,
      ready: isReady,
      statePayload: payload,
    );
    notifyListeners();
  }

  Future<void> fetchNotifications({
    int page = 1,
    int limit = 20,
    String status = 'all',
  }) async {
    if (page == 1) {
      _setState(loading: true, hasError: false);
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }

    Either<UIError, NotificationsResponseModel>? response =
        await useCases.getNotifications(
      GetNotificationsParams(page: page, limit: limit, status: status),
    );

    response.fold(
      (l) {
        _isLoadingMore = false;
        _setState(
          loading: false,
          isReady: false,
          hasError: true,
          errorMsg: l.message,
        );
      },
      (r) {
        if (page == 1) {
          _notifications = r.notifications ?? [];
        } else {
          _notifications.addAll(r.notifications ?? []);
        }
        _currentPage = r.page ?? page;
        _hasNextPage = r.hasNextPage ?? false;
        _unreadCount = _notifications.where((n) => n.isRead == false).length;
        _isLoadingMore = false;
        _setState(
          loading: false,
          isReady: true,
          hasError: false,
          payload: r,
        );
      },
    );
  }

  Future<void> loadMore({int limit = 20, String status = 'all'}) async {
    if (_isLoadingMore || !_hasNextPage) return;
    await fetchNotifications(page: _currentPage + 1, limit: limit, status: status);
  }

  Future<void> registerPushToken({required String fcmToken}) async {
    final platform = Platform.isIOS ? 'ios' : 'android';
    final deviceManager = inject<DeviceManager>();
    final deviceId = deviceManager.deviceModel?.deviceId;
    final deviceName = deviceManager.deviceModel?.model;

    String? appVersion;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (_) {}

    await useCases.registerPushToken(
      RegisterPushTokenParams(
        token: fcmToken,
        platform: platform,
        deviceId: deviceId,
        deviceName: deviceName,
        appVersion: appVersion,
      ),
    );
  }

  Future<bool> markAsRead({required List<String> notificationIds}) async {
    Either<UIError, VoidType>? response = await useCases.markNotificationsRead(
      MarkNotificationsReadParams(notificationIds: notificationIds),
    );

    bool success = false;
    response.fold(
      (l) => success = false,
      (r) {
          success = true;
          for (final id in notificationIds) {
            final index = _notifications.indexWhere((n) => n.id == id);
            if (index != -1) {
              final old = _notifications[index];
              _notifications[index] = NotificationModel(
                id: old.id,
                title: old.title,
                message: old.message,
                type: old.type,
                isRead: true,
                timestamp: old.timestamp,
              );
            }
          }
          _unreadCount = _notifications.where((n) => n.isRead == false).length;
          notifyListeners();
        },
      );
    return success;
  }

  Future<bool> markAllAsRead() async {
    final unreadIds = _notifications
        .where((n) => n.isRead == false && n.id != null)
        .map((n) => n.id!)
        .toList();
    if (unreadIds.isEmpty) return true;
    return markAsRead(notificationIds: unreadIds);
  }
}
