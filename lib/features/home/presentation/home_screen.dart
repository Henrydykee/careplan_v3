import 'dart:convert';
import 'dart:math';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/current_carplan_widget.dart';
import 'package:careplan/core/presentation/widgets/home_screen_widgets.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/appointment/presentation/state/appointment_provider.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/auth/domain/usecases/get_user_details.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_1_screen.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:careplan/features/notifications/presentation/pages/notification_center_screen.dart';
import 'package:careplan/features/notifications/presentation/state/notification_provider.dart';
import 'package:careplan/core/managers/firebase_cloud_messaging_manager.dart';
import 'package:careplan/core/managers/google_analytics_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? _user;
  String? _lastK10Date;
  late final String _wellbeingQuestion;
  bool _showWellbeingCheckIn = false;

  static const _wellbeingQuestions = [
    "How are you feeling today?",
    "How did you sleep last night?",
    "How's your energy right now?",
    "How's your stress level today?",
    "Feeling balanced today?",
    "How's your mood right now?",
    "How well are you coping today?",
    "How calm do you feel?",
  ];

  static const _wellbeingDismissedKey = 'wellbeing_check_in_dismissed_at';
  static const _wellbeingCooldown = Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    _wellbeingQuestion =
        _wellbeingQuestions[Random().nextInt(_wellbeingQuestions.length)];
    _loadUserData();
    _loadLatestK10Date();
    _evaluateWellbeingVisibility();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications(limit: 20);
      FirebaseCloudMessagingManager.instance.initialize();
    });
  }

  Future<void> _loadLatestK10Date() async {
    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      final raw = await dataSource.getK10AssessmentHistory();
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic> &&
          decoded['success'] == true &&
          decoded['data'] is List) {
        final data = decoded['data'] as List;
        DateTime? latest;
        for (final item in data) {
          if (item is! Map<String, dynamic>) continue;
          final createdAt = item['createdAt']?.toString();
          if (createdAt == null) continue;
          final parsed = DateTime.tryParse(createdAt);
          if (parsed == null) continue;
          if (latest == null || parsed.isAfter(latest)) {
            latest = parsed;
          }
        }
        if (mounted) {
          setState(() {
            _lastK10Date = latest?.toIso8601String();
          });
        }
      }
    } catch (_) {
      // Leave _lastK10Date null; banner will hide the line.
    }
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
            if (loadedUser.id != null) {
              googleAnalytics.setUserId(loadedUser.id!);
            }
            googleAnalytics.logScreenView(screenName: 'Home');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<HistoryProvider>()
                  .fetchCurrentCarePlan(patientId: loadedUser.id!);
            });
          
        } catch (e) {
          // Handle error silently
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _onRefresh() async {
    final userDetailsResult = await inject<GetUserDetails>().call();
    UserModel? refreshedUser;
    userDetailsResult.fold(
      (_) {},
      (user) => refreshedUser = user,
    );

    if (refreshedUser != null && mounted) {
      setState(() {
        _user = refreshedUser;
      });
    }

    final user = refreshedUser ?? _user;
    final patientId = user?.id;

    final futures = <Future<void>>[
      context.read<NotificationProvider>().fetchNotifications(limit: 20),
      _loadLatestK10Date(),
    ];

    if (patientId != null && patientId.isNotEmpty) {
      futures.add(
        context
            .read<HistoryProvider>()
            .fetchCurrentCarePlan(patientId: patientId, forceRefresh: true),
      );
      futures.add(
        context.read<AppointmentProvider>().fetchUpcomingAppointments(
              patientId: patientId,
              page: 1,
              limit: 20,
            ),
      );
    }

    await Future.wait(futures);
  }


  String _getFirstName() {
    final first = _user?.firstName?.trim();
    if (first != null && first.isNotEmpty) return first;
    return "there";
  }

  String _getInitials() {
    final first =
        (_user?.firstName?.isNotEmpty ?? false) ? _user!.firstName![0] : '';
    final last =
        (_user?.lastName?.isNotEmpty ?? false) ? _user!.lastName![0] : '';
    final initials = "$first$last".toUpperCase();
    return initials.isEmpty ? "?" : initials;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  void _evaluateWellbeingVisibility() {
    final stored = inject<LocalStorageService>().getString(
      _wellbeingDismissedKey,
    );
    final lastDismissed =
        stored != null ? DateTime.tryParse(stored) : null;
    final shouldShow = lastDismissed == null ||
        DateTime.now().difference(lastDismissed) >= _wellbeingCooldown;
    if (shouldShow != _showWellbeingCheckIn) {
      setState(() => _showWellbeingCheckIn = shouldShow);
    }
  }

  Future<void> _onMoodSelected(String mood) async {
    if (!mounted) return;
    await inject<LocalStorageService>().setString(
      _wellbeingDismissedKey,
      DateTime.now().toIso8601String(),
    );
    if (!mounted) return;
    setState(() => _showWellbeingCheckIn = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: CarePlanColor.brown,
        content: Text(
          "Thanks for sharing — we noted you're feeling $mood.",
          style: const TextStyle(fontFamily: 'avenir'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
              const Gap(70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: CarePlanColor.light_orange,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: TextHolder(
                        title: _getInitials(),
                        color: CarePlanColor.brown,
                        size: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextHolder(
                            title: _getGreeting(),
                            color: CarePlanColor.grey_3,
                            size: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          const Gap(2),
                          TextHolder(
                            title: "${_getFirstName()} 👋",
                            size: 20,
                            fontWeight: FontWeight.w800,
                            color: CarePlanColor.brown,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          router.push(const NotificationCenterScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Consumer<NotificationProvider>(
                            builder: (context, notifProvider, child) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  SvgPicture.asset(
                                    Assets.notification_icon,
                                    color: CarePlanColor.grey,
                                  ),
                                  if (notifProvider.unreadCount > 0)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: CarePlanColor.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            notifProvider.unreadCount > 99
                                                ? '99+'
                                                : '${notifProvider.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'avenir',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _showWellbeingCheckIn
                      ? Column(
                          key: const ValueKey('wellbeing-visible'),
                          children: [
                            const Gap(20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: WellbeingCheckIn(
                                question: _wellbeingQuestion,
                                onMoodSelected: _onMoodSelected,
                              ),
                            ),
                            const Gap(24),
                          ],
                        )
                      : const SizedBox(
                          key: ValueKey('wellbeing-hidden'),
                          width: double.infinity,
                          height: 20,
                        ),
                ),
              ),
              K10ScoreHolder(
                width: width,
                kycStatus: "",
                score: "",
                k10Date: _lastK10Date,
                onTakeTestTap: () => router.push(CarePlanNavBar(index: 1)),
              ),
              const Gap(30),
              // KYC Status
              if (_user?.kycStatus?.toLowerCase().trim() != 'approved')
                VerifyAccount(
                  kycStatus: _user?.kycStatus,
                  onStartVerification: () =>
                      router.push(const KycVerificatonScreen1()),
                ),
              // Care Plan Team - using user data
              if (_user?.careplanTeam != null &&
                  _user!.careplanTeam!.isNotEmpty)
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
                child: Selector<HistoryProvider, ({CarePlanHistoryItemModel? carePlan, bool isLoading})>(
                  selector: (_, provider) => (
                    carePlan: provider.currentCarePlan,
                    isLoading: provider.isLoading,
                  ),
                  builder: (context, state, child) {
                    if (state.isLoading && state.carePlan == null) {
                      return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: HomeCarePlanShimmer());
                    }

                    if (state.carePlan != null) {
                      return MentalHealthCarePlanWidget(carePlan: state.carePlan!);
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

}

