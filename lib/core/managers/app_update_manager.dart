import 'dart:io';

import 'package:careplan/core/managers/remote_config_manager.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../di/di_config.dart';

class AppUpdateManager {
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.careplan.mobile';
  static const String _appStoreUrl =
      'https://apps.apple.com/us/app/careplan-365/id1610333007';

  /// Checks if a force update is required.
  /// Returns `true` if the app can continue, `false` if blocked by force update.
  static Future<bool> checkForUpdate(BuildContext context) async {
    try {
      final remoteConfig = inject<RemoteConfigManager>();
      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
      final requiredBuild = int.tryParse(remoteConfig.requiredVersion) ?? 0;

      if (requiredBuild > 0 && currentBuild < requiredBuild) {
        if (context.mounted) {
          await _showForceUpdateDialog(context);
        }
        return false;
      }

      return true;
    } catch (_) {
      return true;
    }
  }

  static Future<void> _openStore() async {
    final Uri url = Uri.parse(
      Platform.isIOS ? _appStoreUrl : _playStoreUrl,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _showForceUpdateDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: CarePlanColor.orange.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.system_update,
                    size: 32,
                    color: CarePlanColor.orange,
                  ),
                ),
                const Gap(20),
                TextHolder(
                  title: 'Update Required',
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: CarePlanColor.brown,
                ),
                const Gap(12),
                TextHolder(
                  title:
                      'A new version of CarePlan is available. Please update to continue using the app.',
                  size: 14,
                  color: CarePlanColor.grey_3,
                ),
                const Gap(24),
                CustomButtom(
                  title: 'Update Now',
                  onTap: _openStore,
                  btnColor: CarePlanColor.orange,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
