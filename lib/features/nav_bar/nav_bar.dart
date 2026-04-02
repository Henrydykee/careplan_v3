

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/managers/google_analytics_manager.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/color.dart';
import '../../core/resources/string.dart';
import '../account/presentation/account_screen.dart';
import '../assement/presentation/assement_screen.dart';
import '../careplan/presentation/careplan_screen.dart';
import '../home/presentation/home_screen.dart';

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
  late final List<FABBottomAppBarItem> _bottomNavItems;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.index ?? 0;
    _pageController = PageController(initialPage: selectedTab);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialCurrentCareplan();
    });

    // Initialize bottom nav items once
    _bottomNavItems = [
      FABBottomAppBarItem(iconName: Assets.home_icon, name: Strings.home),
      FABBottomAppBarItem(iconName: Assets.appointment_icon, name: "Assessments"),
      FABBottomAppBarItem(iconName: Assets.care_plan_icon, name: "History"),
      FABBottomAppBarItem(iconName: Assets.account_icon, name: Strings.account),
    ];

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

  void _onTabSelected(int? index) {
    if (index == null || index == selectedTab) return;
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
    return Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: const CircularNotchedRectangle(),
        selectedColor: CarePlanColor.brown,
        color: CarePlanColor.black_3.withOpacity(0.5),
        onTabSelected: _onTabSelected,
        initialIndex: selectedTab,
        items: _bottomNavItems,
      ),
      body: PageView(
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
    );
  }
}

class FABBottomAppBarItem {
  const FABBottomAppBarItem({this.iconName, this.name});

  final String? iconName;
  final String? name;
}

class FABBottomAppBar extends StatefulWidget {
  final List<FABBottomAppBarItem>? items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int?>? onTabSelected;
  final int? initialIndex;

  const FABBottomAppBar({
    super.key,
    this.items,
    this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
    this.initialIndex = 0,
  }) : assert(items == null || items.length == 2 || items.length == 4);

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _updateIndex(int? index) {
    if (index == _selectedIndex) return; // Prevent unnecessary updates

    widget.onTabSelected?.call(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: SizedBox(
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            widget.items!.length,
                (index) => _TabItem(
              item: widget.items![index],
              index: index,
              isSelected: _selectedIndex == index,
              selectedColor: widget.selectedColor,
              unselectedColor: widget.color,
              height: widget.height,
              onPressed: _updateIndex,
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted as separate widget to optimize rebuilds
class _TabItem extends StatelessWidget {
  final FABBottomAppBarItem item;
  final int index;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double height;
  final ValueChanged<int?> onPressed;

  const _TabItem({
    required this.item,
    required this.index,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onPressed(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                item.iconName!,
                height: 24,
                width: 24,
                colorFilter: color != null
                    ? ColorFilter.mode(color, BlendMode.srcIn)
                    : null,
              ),
              TextHolder(
                title: item.name,
                color: color,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}