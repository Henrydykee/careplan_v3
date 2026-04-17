import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../di/di_config.dart';
import '../../platform/storage/secured_storage.dart';
import '../../platform/string_constants.dart';
import '../../presentation/widgets/router.dart';
import '../../../features/auth/presentation/login_flow/welcome_back_screen.dart';
import 'network_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

/// Tracks whether we are already navigating to the WelcomeBackScreen
/// to prevent multiple 401 responses from stacking duplicate screens.
bool _isNavigatingToWelcomeBack = false;

/// Call this after successful re-authentication to allow future 401 redirects.
void resetUnauthorizedNavigation() {
  _isNavigatingToWelcomeBack = false;
}

/// Can be registered with [NetworkService]
class NetworkInterceptor extends InterceptorsWrapper {
  NetworkConfig? networkConfigInterface;
  DeviceInfoPlugin? deviceInfo;

  /// NOTE: [networkConfigInterface] will be overwritten
  /// on each request. This is by design for now.
  NetworkInterceptor({this.networkConfigInterface, this.deviceInfo});

  /// On request interception goes here
  /// Get token from storage
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final fullUrl = options.uri.toString();
    debugPrint("🌐 [REQUEST] Full URL: $fullUrl");
    debugPrint("🌐 [REQUEST] Body: ${options.data}");

    var authToken = await inject<SecuredStorage>().get(key: SecureStorageStrings.TOKEN) ?? "";
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
      "build_number": packageInfo.buildNumber,
      "os_type": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? "IOS"
              : Platform.isMacOS
                  ? "MACOS"
                  : "Unknown Device",
      "os_version": Platform.operatingSystemVersion.toString(),
    };

    if (skipToken(options.path)) {
      headers.remove("Authorization");
    }

    networkConfigInterface = NetworkConfigImpl(headers: headers);

    options.headers.addAll(networkConfigInterface!.headers!);
    return super.onRequest(options, handler);
  }

  /// When error occurs, this interceptor handles it.
  /// 401 responses are caught here and trigger navigation to WelcomeBackScreen.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint("❌ [ERROR] ${err.requestOptions.method} ${err.requestOptions.uri}");
    debugPrint("❌ Message: ${err.message}");

    if (err.response?.statusCode == 401 && !skipToken(err.requestOptions.path)) {
      _handleUnauthorized();
    }

    super.onError(err, handler);
  }

  /// Navigate to WelcomeBackScreen once. Concurrent 401s are ignored.
  void _handleUnauthorized() {
    if (_isNavigatingToWelcomeBack) return;
    _isNavigatingToWelcomeBack = true;

    debugPrint("🔒 [AUTH] Token expired — navigating to WelcomeBackScreen");

    router.pushAndRemoveUntil(
      const WelcomeBackScreen(fromUnauthorized: true),
      (route) => false,
    );
  }

  /// When it returns a response this interceptor handles it
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("✅ [SUCCESS] ${response.requestOptions.method} ${response.requestOptions.uri}");
    debugPrint("✅ Status: ${response.statusCode}");
    debugPrint("✅ Data: ${response.data}");

    super.onResponse(response, handler);
  }
}

bool skipToken(String path) {
  return [
    "auth/login",
    "auth/login-pin",
    "auth/register",
  ].contains(path);
}
