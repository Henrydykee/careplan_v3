import 'package:dio/dio.dart';
import '../../di/di_config.dart';
import '../../platform/storage/secured_storage.dart';
import '../../platform/string_constants.dart';
import 'network_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

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
    // Log full URL to verify you're hitting the same URL as in Postman
    final fullUrl = options.uri.toString();
    print("🌐 [REQUEST] Full URL: $fullUrl");
    print("🌐 [REQUEST] Body: ${options.data}");


    var authToken = await inject<SecuredStorage>().get(key: SecureStorageStrings.TOKEN) ?? "";
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${authToken}",
      "build_number": packageInfo.buildNumber,
      "os_type": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? "IOS"
              : Platform.isMacOS
                  ? "MACOS"
                  : "Unknown Device",
      // "ip": deviceManager?.deviceModel?.ip ?? "",
      "os_version": Platform.operatingSystemVersion.toString(),
      // "brand": "${Platform.isIOS ? iosInfo?.utsname.machine.toString() : androidInfo?.brand.toString()}",
      // "model":  "${Platform.isIOS ? iosInfo?.model.toString() : androidInfo?.model.toString()}",
    };

    if (skipToken(options.path)) {
      headers.remove("Authorization");
    }

    networkConfigInterface = NetworkConfigImpl(headers: headers);

    options.headers.addAll(networkConfigInterface!.headers!);
    return super.onRequest(options, handler);
  }

  /// When error occurs, this interceptor handles it
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ [ERROR] ${err.requestOptions.method} ${err.requestOptions.uri}");
    print("❌ Message: ${err.message}");

    super.onError(err, handler);
  }

  /// When it returns a response this interceptor handles it
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ [SUCCESS] ${response.requestOptions.method} ${response.requestOptions.uri}");
    print("✅ Status: ${response.statusCode}");
    print("✅ Data: ${response.data}");

    super.onResponse(response, handler);
  }
}

bool skipToken(String path) {
  return [
    // AuthenticationEndpoints.createUser,
    // AuthenticationEndpoints.verifyPhoneNumber,
    // AuthenticationEndpoints.verifyEmail,
    // AuthenticationEndpoints.refreshSession
  ].contains(path);
}
