import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/current_carplan_widget.dart';
import 'package:careplan/core/presentation/widgets/home_screen_widgets.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Load from local storage only
      final localStorage = inject<LocalStorageService>();
      final userJson = localStorage.getJson('user');
      
      if (userJson != null) {
        try {
          final loadedUser = UserModel.fromJson(userJson);
          setState(() {
            _user = loadedUser;
          });
          if (mounted && loadedUser.id != null && loadedUser.id!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<HistoryProvider>()
                  .fetchCurrentCarePlan(patientId: loadedUser.id!);
            });
          }
        } catch (e) {
          // Handle error silently
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _onRefresh() async {
    await _loadUserData();
  }

  String _getUserName() {
    if (_user?.firstName != null || _user?.lastName != null) {
      final firstName = _user?.firstName ?? '';
      final lastName = _user?.lastName ?? '';
      return "${firstName} ${lastName}".trim();
    }
    return "User";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: CarePlanColor.brown,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: CarePlanColor.black_3,
                          child: CircleAvatar(
                            radius: 24.5,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              Assets.account_icon,
                              color: CarePlanColor.brown,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHolder(
                              title: getTodayDate(),
                              color: CarePlanColor.grey,
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            TextHolder(
                              title: "Hello, ${_getUserName()}",
                              size: 18,
                              fontWeight: FontWeight.w800,
                              color: CarePlanColor.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        Assets.notification_icon,
                        color: CarePlanColor.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(25),
              K10ScoreHolder(
                width: width,
                kycStatus: "",
                score: "",
                onTakeTestTap: () => router.push(CarePlanNavBar(index: 1)),
              ),
              const Gap(30),
              // KYC Status - using mock data
              VerifyAccount(),
              // Care Plan Team - using user data
              if (_user?.careplanTeam != null && _user!.careplanTeam!.isNotEmpty)
                CareplanTeamWidget(
                  careTeamMembers: _user!.careplanTeam!,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextHolder(
                  title: "Appointment",
                  size: 16,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.brown,
                ),
              ),
              const Gap(10),
              // Upcoming Appointment - using real data
              UpcomingAppointmentWidget(patientId: _user?.id),
              const Gap(40),
              Row(
                children: [
                  Gap(20),
                  TextHolder(
                    title: "Care Plan",
                    size: 16,
                    fontWeight: FontWeight.w800,
                    color: CarePlanColor.brown,
                  ),
                ],
              ),
              const Gap(10),
              // Care Plan - show current care plan if available, otherwise empty state
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Consumer<HistoryProvider>(
                  builder: (context, historyProvider, child) {
                    final carePlan = historyProvider.currentCarePlan;

                    if (historyProvider.isLoading && carePlan == null) {
                      return const HomeCarePlanShimmer();
                    }

                    if (carePlan != null) {
                      return MentalHealthCarePlanWidget(carePlan: carePlan);
                    }

                    return const EmptyCareplan();
                  },
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
  
  String getTodayDate() {
    final now = DateTime.now();
    return DateFormat('EEE, d MMM yyyy').format(now);
  }
}
