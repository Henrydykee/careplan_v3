import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/di_config.dart';

class BioMetricManager {
  static final BioMetricManager instance = BioMetricManager._internal();
  factory BioMetricManager() => instance;
  BioMetricManager._internal();
  var localAuth = LocalAuthentication();
  BiometricType? biometricType;
  bool requireAuthentication = true;
  bool canDisableSecurity = false;

  Future checkAvailableBiometrics() async {
    try {
      if (await localAuth.canCheckBiometrics) {
        List<BiometricType> biometrics = await localAuth.getAvailableBiometrics();
        if (biometrics.isNotEmpty) {
          inject<SharedPreferences>().setString("Biometric_Type", biometrics.toString());
          biometricType = biometrics.first;
          return biometricType;
        }
      }
    } catch (e) {
      // Device unable to check biometric
    }
  }

  void enableBiometric(bool value) {
    inject<SharedPreferences>().setBool("enable_biometric", value);
  }

  String getSecurityType(BiometricType biometricType) {
    switch (biometricType) {
      case BiometricType.face:
        return "";
      case BiometricType.fingerprint:
        return "";
      case BiometricType.iris:
      default:
        return "";
    }
  }

  /// Authenticate user base on their device security.
  /// [turnOffSecurity] is true when the authenticate check is required
  /// for changing bundle security settings
  Future<bool> authenticateUser({bool turnOffSecurity = false}) async {
    try {
      bool canAuthenticate = await localAuth.canCheckBiometrics;

      if (canAuthenticate && biometricType != null) {
        // Handle authentication for device with faceId and finger Print
        try {
          bool didAuthenticate = await localAuth.authenticate(
              localizedReason: "Unlock your account",
              options: AuthenticationOptions(biometricOnly: true,stickyAuth: true)
          );
          if (didAuthenticate) {
            if (Platform.isAndroid) {
              localAuth.stopAuthentication();
            }

            if (turnOffSecurity) {
              canDisableSecurity = true;
            } else {
              requireAuthentication = false;
            }
          } else {
            if (!turnOffSecurity) {
              requireAuthentication = true;
            } else {
              canDisableSecurity = false;
            }
          }
        } catch (e) {
          // Authentication failed
        }
      } else {
        // try {
        //   bool deviceAuthenticated = await DeviceUnlock().request(localizedReason: "Enter pin to verify your account");
        //   if (deviceAuthenticated != null && deviceAuthenticated) {
        //     if (turnOffSecurity) {
        //       canDisableSecurity = true;
        //     } else {
        //       requireAuthentication = false;
        //     }
        //   } else {
        //     if (!turnOffSecurity) {
        //       requireAuthentication = true;
        //     } else {
        //       canDisableSecurity = false;
        //     }
        //   }
        // } catch (e) {
        // }
      }
    } catch (e) {
      // Error on authenticateUser
    }
    return requireAuthentication;
  }
}
