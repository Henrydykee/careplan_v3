import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/onboarding/data/models/registration_model.dart';
import '../di/di_config.dart';
import '../platform/storage/secured_storage.dart';
import '../platform/string_constants.dart';
import '../utils/string_utils.dart';

class DeviceManager {
  static final DeviceManager instance = DeviceManager._internal();

  factory DeviceManager() => instance;
  RegistrationRequestModel? deviceModel;

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  /// Completes once [deviceModel] has been populated (or populating failed).
  late final Future<void> ready;

  DeviceManager._internal() {
    ready = _getId();
  }

  Future<void> _getId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String ipAddress = "";

    try {
      if (Platform.isIOS) {
        deviceModel = await getiOSDeviceInfo(deviceInfoPlugin, ipAddress);
      } else if (Platform.isAndroid) {
        deviceModel = await getAndroidDeviceInfo(deviceInfoPlugin, ipAddress);
      }
    } catch (e, s) {
      debugPrint('DeviceManager: failed to resolve device info: $e\n$s');
    }
  }

  Future<RegistrationRequestModel> getiOSDeviceInfo(DeviceInfoPlugin deviceInfoPlugin, String ipAddress) async {
    final IosDeviceInfo iosData = await deviceInfoPlugin.iosInfo;
    if (ipAddress.isEmpty) {
      ipAddress = (await _iOSGetIPAddress()) ?? '';
    }
    final String deviceId = await _resolveDeviceId(
      fallback: () async => iosData.identifierForVendor ?? '',
    );
    return RegistrationRequestModel(
      osVersion: iosData.systemVersion,
      osType: AppString.IOS,
      ip: ipAddress,
      deviceId: deviceId,
      brand: iosData.model,
      model: iosData.localizedModel,
    );
  }

  Future<RegistrationRequestModel> getAndroidDeviceInfo(DeviceInfoPlugin deviceInfoPlugin, String ipAddress) async {
    final AndroidDeviceInfo androidData = await deviceInfoPlugin.androidInfo;
    // `androidId` was removed from device_info_plus (Android deprecated ANDROID_ID),
    // so we mint our own identifier and keep it in secure storage.
    final String deviceId = await _resolveDeviceId(fallback: () async => _generateDeviceId());

    return RegistrationRequestModel(
      osVersion: androidData.version.release,
      osType: AppString.ANDROID,
      ip: ipAddress,
      deviceId: deviceId,
      brand: androidData.brand,
      model: androidData.model,
    );
  }

  /// Reads the persisted device id, generating and storing one on first run.
  Future<String> _resolveDeviceId({required Future<String> Function() fallback}) async {
    final storage = inject<SecuredStorage>();
    String? deviceId = await storage.get(key: SecureStorageStrings.DEVICE_ID);
    if (!StringUtils.isNullOrEmpty(deviceId)) return deviceId!;

    deviceId = await fallback();
    if (StringUtils.isNullOrEmpty(deviceId)) {
      deviceId = _generateDeviceId();
    }
    await storage.add(key: SecureStorageStrings.DEVICE_ID, value: deviceId);
    return deviceId;
  }

  /// Random 32-char hex id (128 bits), UUID-strength without the extra dependency.
  String _generateDeviceId() {
    final rng = Random.secure();
    return List<String>.generate(16, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }

  Future<String?> _iOSGetIPAddress() async {
    String? address;
    const platform = MethodChannel(MethodChannelNames.IPADDRESS);
    try {
      address = await platform.invokeMethod(ChannelMethods.GET_IPADDRESS);
    } on PlatformException catch (_) {
      address = "";
    } on MissingPluginException catch (_) {
      address = "";
    } catch (_) {
      address = "";
    }
    return address;
  }
}
