import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'provider_state.dart';

/// Surfaces Shorebird patches that have already been downloaded in the
/// background and are waiting on an app restart to take effect.
///
/// `auto_update` is left enabled in shorebird.yaml, so the updater downloads
/// patches on its own. This provider only reports whether one is staged — a
/// patch cannot be applied while the app is running.
class AppUpdateProvider with ChangeNotifier, ProviderState {
  AppUpdateProvider({ShorebirdUpdater? updater})
      : _updater = updater ?? ShorebirdUpdater();

  final ShorebirdUpdater _updater;

  bool _patchReady = false;
  bool _prompted = false;

  /// Whether a downloaded patch is waiting for the app to be restarted.
  bool get patchReady => _patchReady;

  /// Whether the restart prompt has already been shown this session.
  bool get prompted => _prompted;

  void markPrompted() => _prompted = true;

  /// Checks for a staged patch. Safe to call on every launch: the updater is
  /// unavailable in debug builds and in builds not produced by
  /// `shorebird release`, in which case this is a no-op.
  Future<void> checkForPatch() async {
    if (!_updater.isAvailable) return;

    try {
      final status = await _updater.checkForUpdate();
      if (status != UpdateStatus.restartRequired) return;

      _patchReady = true;
      notifyListeners();
    } catch (_) {
      // A failed update check must never interrupt the app.
    }
  }
}
