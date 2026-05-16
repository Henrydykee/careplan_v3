import 'dart:convert';
import 'dart:math';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/firebase_cloud_messaging_manager.dart';
import 'package:careplan/core/managers/google_analytics_manager.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/home_screen_widgets.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/appointment/presentation/state/appointment_provider.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/auth/domain/usecases/get_user_details.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_1_screen.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:careplan/features/home/presentation/widgets/home_careplan_section.dart';
import 'package:careplan/features/home/presentation/widgets/home_greeting_header.dart';
import 'package:careplan/features/home/presentation/widgets/home_wellbeing_section.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:careplan/features/notifications/presentation/state/notification_provider.dart';
import 'package:flutter/material.dart';
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
              HomeGreetingHeader(user: _user),
              HomeWellbeingSection(
                visible: _showWellbeingCheckIn,
                question: _wellbeingQuestion,
                onMoodSelected: _onMoodSelected,
              ),
              K10ScoreHolder(
                width: width,
                kycStatus: "",
                score: "",
                k10Date: _lastK10Date,
                onTakeTestTap: () => router.push(CarePlanNavBar(index: 1)),
              ),
              const Gap(30),
              if (_user?.kycStatus?.toLowerCase().trim() != 'approved')
                VerifyAccount(
                  kycStatus: _user?.kycStatus,
                  onStartVerification: () =>
                      router.push(const KycVerificatonScreen1()),
                ),
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
              const HomeCareplanSection(),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
