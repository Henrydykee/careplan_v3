import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/liquid_glass_nav_bar.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import '../../../core/presentation/state/app_update_provider.dart';
import '../../../core/managers/google_analytics_manager.dart';
import '../../../core/resources/assets.dart';
import '../../../core/resources/color.dart';
import '../../../core/resources/string.dart';
import '../../account/presentation/account_screen.dart';
import '../../assement/presentation/pages/assement_screen.dart';
import '../../careplan/presentation/careplan/careplan_screen.dart';
import '../../home/presentation/pages/home_screen.dart';

/// Height of the floating glass bar plus its bottom margin.
const double _navBarFootprint = 74;

class CarePlanNavBar extends StatefulWidget {
  final int? index;
  const CarePlanNavBar({super.key, this.index});

  @override
  State<CarePlanNavBar> createState() => _CarePlanNavBarState();
}

class _CarePlanNavBarState extends State<CarePlanNavBar> with AutomaticKeepAliveClientMixin {
  int selectedTab = 0;
  late final PageController _pageController;

  // Cache for bottom nav bar items to avoid recreating them
  late final List<LiquidGlassNavItem> _bottomNavItems;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.index ?? 0;
    _pageController = PageController(initialPage: selectedTab);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialCurrentCareplan();
      _checkForAppUpdate();
    });

    // Initialize bottom nav items once
    _bottomNavItems = [
      LiquidGlassNavItem(svgAsset: Assets.home_icon, label: Strings.home),
      const LiquidGlassNavItem(
          svgAsset: Assets.appointment_icon, label: "Assessments"),
      const LiquidGlassNavItem(
          svgAsset: Assets.care_plan_icon, label: "History"),
      LiquidGlassNavItem(svgAsset: Assets.account_icon, label: Strings.account),
    ];

  }


  /// Nudges the user to restart when Shorebird has staged a patch.
  ///
  /// Not awaited: the check is a network call and must not hold up the first
  /// frame of the nav bar.
  void _checkForAppUpdate() {
    final provider = context.read<AppUpdateProvider>();
    provider.checkForPatch().then((_) {
      if (!mounted || !provider.patchReady || provider.prompted) return;
      provider.markPrompted();
      showSimpleNotification(
        const Text('Update ready'),
        subtitle: const Text('Close and reopen CP365 to apply the latest version.'),
        background: CarePlanColor.green,
        foreground: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 6),
        slideDismissDirection: DismissDirection.up,
      );
    });
  }

  // Future<void> _initializeApp() async {
  //   if (_isInitialized) return;
  //   _isInitialized = true;
  //
  //   try {
  //     // Run these operations concurrently for better performance
  //     final futures = await Future.wait([
  //       _getUserDetailsFromSharedPreferences(),
  //       MixpanelManager.getInstance(),
  //     ]);
  //
  //     final mixpanel = futures[1] as Mixpanel;
  //
  //     if (mounted) {
  //       // Initialize push notifications
  //       PushNotificationService().initialise(context);
  //
  //       // Get fresh user details and set up mixpanel
  //       AuthViewModel().getUserDetails();
  //
  //       if (_userDetails?.data.id != null) {
  //         mixpanel.identify(_userDetails!.data.id.toString());
  //         _setMixpanelUserProperties(mixpanel);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error during app initialization: $e");
  //   }
  // }
  //
  // void _setMixpanelUserProperties(Mixpanel mixpanel) {
  //   if (_userDetails?.data != null) {
  //     final userDataMap = _userDetails!.data.toJson();
  //     for (final entry in userDataMap.entries) {
  //       final value = entry.value;
  //       if (value != null && value.toString().isNotEmpty) {
  //         mixpanel.getPeople().set(entry.key, value);
  //       }
  //     }
  //   }
  // }

  static const _tabNames = ['Home', 'Assessments', 'History', 'Account'];

  void _onTabSelected(int index) {
    if (index == selectedTab) return;
    googleAnalytics.logScreenView(screenName: _tabNames[index]);
    setState(() {
      selectedTab = index;
    });
    _pageController.jumpToPage(index);
  }
  //
  // Future<void> _getUserDetailsFromSharedPreferences() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final userDetailsJson = prefs.getString('userDetails');
  //
  //     if (userDetailsJson?.isNotEmpty == true) {
  //       final userDetailsMap = json.decode(userDetailsJson!) as Map<String, dynamic>;
  //
  //       if (userDetailsMap.isNotEmpty && mounted) {
  //         final userDetails = UserDetails.fromJson(userDetailsMap);
  //         setState(() {
  //           _userDetails = userDetails;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error decoding user details: $e");
  //   }
  // }

  Future<void> _loadInitialCurrentCareplan() async {
    try {
      final localStorage = inject<LocalStorageService>();
      final userJson = localStorage.getJson('user');
      if (userJson == null) return;

      final loadedUser = UserModel.fromJson(userJson);
      if (loadedUser.id == null || loadedUser.id!.isEmpty) return;

      final historyProvider = context.read<HistoryProvider>();
      if (historyProvider.currentCarePlan == null) {
        await historyProvider.fetchCurrentCarePlan(patientId: loadedUser.id!);
      }
    } catch (_) {
      // ignore errors (safety net)
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mq = MediaQuery.of(context);

    return Scaffold(
      // Content runs under the glass so there is something for it to refract.
      extendBody: true,
      bottomNavigationBar: LiquidGlassNavBar(
        items: _bottomNavItems,
        currentIndex: selectedTab,
        onTap: _onTabSelected,
      ),
      body: MediaQuery(
        // Tell the tab screens how much glass they are flowing under, so
        // their SafeAreas keep the last row clear of it.
        data: mq.copyWith(
          padding: mq.padding.copyWith(
            bottom: mq.padding.bottom + _navBarFootprint,
          ),
        ),
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          children: [
            HomeScreen(),
            SelectAssementHistoryScreen(),
            CarePlanScreen(),
            AccountScreen(),
          ],
        ),
      ),
    );
  }
}
