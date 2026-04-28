import 'package:cached_network_image/cached_network_image.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/appointment/data/models/appointment_model.dart';
import 'package:careplan/features/appointment/data/models/upcoming_appointments_response_model.dart';
import 'package:careplan/features/appointment/presentation/pages/all_appointments_screen.dart';
import 'package:careplan/features/appointment/presentation/state/appointment_provider.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class K10ScoreHolder extends StatelessWidget {
  final String? k10Date;
  final String? score;
  final String? kycStatus;
  final VoidCallback? onTakeTestTap;

  K10ScoreHolder({
    this.k10Date,
    this.kycStatus,
    this.score,
    this.onTakeTestTap,
    required this.width,
  });

  final double width;

  DateTime? get _lastCompletedDate {
    final raw = k10Date?.trim();
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  bool get _hasCompletion {
    final s = (score ?? '').trim();
    if (s.isNotEmpty && s != "0") return true;
    return _lastCompletedDate != null;
  }

  @override
  Widget build(BuildContext context) {
    final lastCompleted = _lastCompletedDate;
    final completed = _hasCompletion;
    final cream = Colors.white.withValues(alpha: 0.78);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: CarePlanColor.brown,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CarePlanColor.brown.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHolder(
                      title: completed
                          ? "Review your wellbeing"
                          : "Take your first assessment",
                      color: Colors.white,
                      size: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    const Gap(6),
                    if (lastCompleted != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: CarePlanColor.light_orange,
                          ),
                          const Gap(6),
                          Flexible(
                            child: TextHolder(
                              title:
                                  "Last completed ${DateFormat('MMM d, y').format(lastCompleted.toLocal())}",
                              color: cream,
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    else
                      TextHolder(
                        title:
                            "Track your mental wellbeing in just a few minutes.",
                        color: cream,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    const Gap(14),
                    _CtaPill(
                      label: completed ? "Retake test" : "Take test",
                      onTap: onTakeTestTap,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.test_icon,
                    width: 38,
                    height: 38,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaPill extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _CtaPill({required this.label, this.onTap});

  @override
  State<_CtaPill> createState() => _CtaPillState();
}

class _CtaPillState extends State<_CtaPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Smooth in-and-out heartbeat curve: 0 → 1 → 0 each cycle.
          final t = _controller.value;
          final pulse = (1 - (2 * t - 1).abs());
          final scale = 1 + 0.025 * pulse;
          final spread = 6 * pulse;
          final blur = 12 + 6 * pulse;
          final glowAlpha = 0.18 + 0.22 * pulse;

          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color:
                        CarePlanColor.orange.withValues(alpha: glowAlpha),
                    blurRadius: blur,
                    spreadRadius: spread,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: CarePlanColor.orange,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextHolder(
                    title: widget.label,
                    color: Colors.white,
                    size: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  const Gap(6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyAccount extends StatelessWidget {
  final String? kycStatus;
  final VoidCallback? onStartVerification;

  const VerifyAccount({Key? key, this.kycStatus, this.onStartVerification})
      : super(key: key);

  bool get _isVerified {
    final status = kycStatus?.toLowerCase().trim() ?? '';
    return status == 'approved';
  }

  bool get _isPending {
    final status = kycStatus?.toLowerCase().trim() ?? '';
    return status == 'pending';
  }

  bool get _isRejected {
    final status = kycStatus?.toLowerCase().trim() ?? '';
    return status == 'rejected';
  }

  @override
  Widget build(BuildContext context) {
    final title = _isVerified
        ? 'Your KYC is verified'
        : _isPending
            ? 'KYC verification in progress'
            : _isRejected
                ? 'KYC verification rejected'
                : 'Complete User Verification';

    final subtitle = _isVerified
        ? 'You have full access to assessments and care planning features.'
        : _isPending
            ? 'We are reviewing your identity documents. Please wait for confirmation.'
            : _isRejected
                ? 'Your verification was rejected. Please resubmit your KYC details.'
                : 'Submit your identity details to unlock mental health assessments.';

    final iconAsset = _isVerified
        ? Assets.kyc_succesful_image
        : _isPending
            ? Assets.hour_glass
            : Assets.notification_icon_2;

    final btnText = _isVerified
        ? 'Verified'
        : _isPending
            ? 'Pending'
            : _isRejected
                ? 'Re-submit'
                : 'Begin Verification';

    final bool hasAction = _isRejected || (!_isVerified && !_isPending);
    final buttonColor = _isRejected || (!_isVerified && !_isPending)
        ? CarePlanColor.orange
        : CarePlanColor.grey_5;
    final buttonTextColor = hasAction ? Colors.white : CarePlanColor.grey_2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: CarePlanColor.grey_5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isVerified
                      ? CarePlanColor.green.withOpacity(0.13)
                      : _isPending
                          ? CarePlanColor.orange.withOpacity(0.13)
                          : CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconAsset,
                    width: 26,
                    height: 26,
                    color: _isVerified
                        ? CarePlanColor.green
                        : _isPending
                            ? CarePlanColor.brown
                            : CarePlanColor.brown,
                  ),
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: title,
                      size: 16,
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.brown,
                    ),
                    const Gap(8),
                    TextHolder(
                      title: subtitle,
                      size: 14,
                      color: CarePlanColor.grey,
                    ),
                    const Gap(16),
                    CustomButtom(
                      title: btnText,
                      onTap: hasAction ? onStartVerification : null,
                      isdisabled: !hasAction,
                      btnColor: buttonColor,
                      textColor: buttonTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingAppointmentWidget extends StatefulWidget {
  final String? patientId;

  const UpcomingAppointmentWidget({Key? key, this.patientId}) : super(key: key);

  @override
  State<UpcomingAppointmentWidget> createState() =>
      _UpcomingAppointmentWidgetState();
}

class _UpcomingAppointmentWidgetState extends State<UpcomingAppointmentWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.patientId != null && widget.patientId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppointmentProvider>().fetchUpcomingAppointments(
              patientId: widget.patientId!,
              page: 1,
              limit: 20,
            );
      });
    }
  }

  String? getTitle(String? type) {
    if (type == null) return "";
    if (type.toLowerCase().contains("therapist")) {
      return "";
    }
    if (type.toUpperCase() == "ADHD COACH") {
      return "ADHD Coach ";
    }
    return "Dr. ";
  }

  String? getProviderType(String? type) {
    if (type == null) return "";
    if (type.toUpperCase() == "MENTAL HEALTH NURSE") {
      return "Care Coordinator";
    }
    return type;
  }

  List<AppointmentModel> _sortAppointmentsByDate(
      List<AppointmentModel> appointments) {
    return appointments
      ..sort((a, b) {
        try {
          final dateA = DateTime.parse(a.startTime ?? "");
          final dateB = DateTime.parse(b.startTime ?? "");
          return dateA.compareTo(dateB); // Ascending order (earliest first)
        } catch (e) {
          debugPrint("Error sorting appointments: $e");
          return 0;
        }
      });
  }

  Widget _buildAppointmentItem(AppointmentModel appointment) {
    final rawStartTime = appointment.startTime ?? "";
    final rawEndTime = appointment.endTime ?? "";

    DateTime? localStart;
    DateTime? localEnd;

    try {
      final parsedStartTime = DateTime.parse(rawStartTime);
      final parsedEndTime = DateTime.parse(rawEndTime);
      localStart = parsedStartTime.toLocal();
      localEnd = parsedEndTime.toLocal();
    } catch (e) {
      debugPrint("Error parsing date/time: $e");
    }

    final String month =
        localStart != null ? DateFormat("MMM").format(localStart) : "";
    final String day =
        localStart != null ? DateFormat("dd").format(localStart) : "";
    final String timeRange = (localStart != null && localEnd != null)
        ? "${DateFormat.jm().format(localStart)} - ${DateFormat.jm().format(localEnd)}"
        : "Time not available";

    final providerName = appointment.provider?.name ?? "";
    final providerType = appointment.provider?.type ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CarePlanColor.light_orange,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Column(
                children: [
                  TextHolder(
                    title: month,
                    color: CarePlanColor.grey,
                    fontWeight: FontWeight.w500,
                    size: 14,
                  ),
                  TextHolder(
                    title: day,
                    color: CarePlanColor.grey,
                    fontWeight: FontWeight.w800,
                    size: 24,
                  ),
                ],
              ),
              const Gap(20),
              Container(width: 1, height: 50, color: const Color(0xFFEFE2CE)),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: "${getTitle(providerType)}$providerName",
                      color: CarePlanColor.grey,
                      fontWeight: FontWeight.w800,
                      size: 16,
                    ),
                    TextHolder(
                      title: getProviderType(providerType) ?? "",
                      color: CarePlanColor.grey_2,
                      fontWeight: FontWeight.w800,
                      size: 14,
                    ),
                    const Gap(8),
                    TextHolder(
                      title: timeRange,
                      color: CarePlanColor.brown,
                      fontWeight: FontWeight.w800,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppointmentProvider,
        ({bool isLoading, bool hasError, String errorMessage, UpcomingAppointmentsResponseModel? appointments})>(
      selector: (_, p) => (
        isLoading: p.isLoading,
        hasError: p.hasError,
        errorMessage: p.errorMessage,
        appointments: p.appointments,
      ),
      builder: (context, state, child) {
        if (state.isLoading && state.appointments == null) {
          return const HomeUpcomingAppointmentsShimmer();
        }

        if (state.hasError && state.errorMessage.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CarePlanColor.light_orange,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.red.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Column(
                  children: [
                    TextHolder(
                      title: "Error loading appointments",
                      color: Colors.red,
                      size: 14,
                      align: TextAlign.center,
                    ),
                    const Gap(5),
                    TextHolder(
                      title: state.errorMessage,
                      color: CarePlanColor.grey,
                      size: 12,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final appointments = state.appointments?.appointments ?? [];
        final sortedAppointments = _sortAppointmentsByDate([...appointments]);
        final displayAppointments = sortedAppointments.take(2).toList();
        final hasMoreAppointments = sortedAppointments.length > 2;

        if (displayAppointments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CarePlanColor.light_orange,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: CarePlanColor.orange.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Column(
                  children: [
                    SvgPicture.asset(Assets.calender),
                    const Gap(10),
                    TextHolder(
                      title: "No Appointment",
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayAppointments.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildAppointmentItem(displayAppointments[index]);
                },
              ),
            ),
            if (hasMoreAppointments)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    router.push(
                        AllAppointmentsScreen(patientId: widget.patientId));
                  },
                  child: Center(
                    child: TextHolder(
                      title: "See All",
                      color: CarePlanColor.brown,
                      fontWeight: FontWeight.w800,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CareplanTeamWidget extends StatelessWidget {
  final CareplanTeam? careplanTeam;
  final List<CarePlanTeamMember>? careTeamMembers;

  CareplanTeamWidget({this.careplanTeam, this.careTeamMembers});

  String? getTitle(String title) {
    if (title.toLowerCase().contains("therapist")) {
      return "";
    }
    if (title.toUpperCase() == "ADHD COACH") {
      return "ADHD Coach ";
    }
    return "Dr. ";
  }

  String? getProviderType(String type) {
    if (type.toUpperCase() == "MENTAL HEALTH NURSE") {
      return "Care Coordinator";
    }
    return type;
  }

  // Mock care plan team data
  List<MockDoctor> _getMockDoctors() {
    return [
      MockDoctor(
        firstName: "Jane",
        lastName: "Smith",
        type: "Psychiatrist",
        imageUrl: "https://via.placeholder.com/150",
      ),
      MockDoctor(
        firstName: "Michael",
        lastName: "Johnson",
        type: "Therapist",
        imageUrl: "https://via.placeholder.com/150",
      ),
      MockDoctor(
        firstName: "Sarah",
        lastName: "Williams",
        type: "Mental Health Nurse",
        imageUrl: "https://via.placeholder.com/150",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Determine which data source to use
    final List<dynamic> teamList;
    final bool hasRealData;

    if (careTeamMembers != null && careTeamMembers!.isNotEmpty) {
      // Use careTeamMembers from user object
      teamList = careTeamMembers!;
      hasRealData = true;
    } else if (careplanTeam?.data?.doctors != null &&
        careplanTeam!.data!.doctors!.isNotEmpty) {
      // Use careplanTeam data structure
      teamList = careplanTeam!.data!.doctors!;
      hasRealData = true;
    } else {
      // Use mock data
      teamList = _getMockDoctors();
      hasRealData = false;
    }

    final displayCount = teamList.length > 3 ? 3 : teamList.length;
    final showSeeMore = teamList.length > 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextHolder(
                title: "Care Team",
                size: 16,
                fontWeight: FontWeight.w800,
                color: CarePlanColor.brown,
              ),
              const Gap(8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextHolder(
                  title: "${teamList.length}",
                  size: 11,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.brown,
                ),
              ),
            ],
          ),
          const Gap(10),
          ListView.separated(
            itemCount: displayCount,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (c, i) {
              String doctorName;
              String imageUrl;
              String? subtitle;

              if (hasRealData && careTeamMembers != null) {
                final member = careTeamMembers![i];
                doctorName = member.name ?? "";
                imageUrl = member.imageUrl ?? "";
              } else if (hasRealData && careplanTeam != null) {
                final doctor = careplanTeam!.data!.doctors![i];
                final firstName = doctor.firstName ?? "";
                final lastName = doctor.lastName ?? "";
                final doctorType = doctor.type?.toString() ?? "";
                doctorName =
                    "${getTitle(doctorType)} $firstName $lastName".trim();
                imageUrl = doctor.imageUrl ?? "";
                subtitle = getProviderType(doctorType);
              } else {
                final doctor = teamList[i] as MockDoctor;
                final firstName = doctor.firstName;
                final lastName = doctor.lastName;
                final doctorType = doctor.type;
                doctorName =
                    "${getTitle(doctorType)} $firstName $lastName".trim();
                imageUrl = doctor.imageUrl;
                subtitle = getProviderType(doctorType);
              }

              return _CareTeamMemberCard(
                name: doctorName,
                subtitle: (subtitle ?? '').isNotEmpty ? subtitle : null,
                imageUrl: imageUrl,
              );
            },
          ),
          if (showSeeMore) ...[
            const Gap(12),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareTeamListScreen(
                          careTeamMembers: careTeamMembers ?? [],
                          careplanTeam: careplanTeam,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextHolder(
                          title: "See all ${teamList.length}",
                          size: 13,
                          fontWeight: FontWeight.w700,
                          color: CarePlanColor.brown,
                        ),
                        const Gap(4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: CarePlanColor.brown,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          const Gap(20),
        ],
      ),
    );
  }
}

class _CareTeamMemberCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String imageUrl;

  const _CareTeamMemberCard({
    required this.name,
    required this.imageUrl,
    this.subtitle,
  });

  String get _initials {
    final cleaned = name
        .replaceFirst(RegExp(r'^(Dr\.?|Mr\.?|Mrs\.?|Ms\.?|ADHD Coach)\s+',
            caseSensitive: false), '')
        .trim();
    if (cleaned.isEmpty) return "?";
    final parts = cleaned.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    final initials = "$first$last".toUpperCase();
    return initials.isEmpty ? "?" : initials;
  }

  Widget _buildAvatar() {
    final placeholder = Container(
      width: 48,
      height: 48,
      color: CarePlanColor.light_orange,
      alignment: Alignment.center,
      child: TextHolder(
        title: _initials,
        color: CarePlanColor.brown,
        size: 16,
        fontWeight: FontWeight.w800,
      ),
    );

    if (imageUrl.isEmpty) return placeholder;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: CarePlanColor.grey_5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildAvatar(),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextHolder(
                        title: name.isNotEmpty ? name : "Care provider",
                        color: CarePlanColor.grey,
                        fontWeight: FontWeight.w800,
                        size: 15,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const Gap(2),
                        TextHolder(
                          title: subtitle!,
                          color: CarePlanColor.grey_3,
                          fontWeight: FontWeight.w500,
                          size: 12,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: CarePlanColor.grey_3,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Mock data classes for placeholder data
class MockDoctor {
  final String firstName;
  final String lastName;
  final String type;
  final String imageUrl;

  MockDoctor({
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.imageUrl,
  });
}

// Mock data class for appointments
class UpcomingAppointmentData {
  final String? providerName;
  final String? providerType;
  final String? startTime;
  final String? endTime;

  UpcomingAppointmentData({
    this.providerName,
    this.providerType,
    this.startTime,
    this.endTime,
  });
}

// Mock data class for UpcomingAppointment
class UpcomingAppointment {
  final List<UpcomingAppointmentData>? upcomingAppointmentData;

  UpcomingAppointment({this.upcomingAppointmentData});
}

// Mock data class for CareplanTeam
class CareplanTeam {
  final CareplanTeamData? data;

  CareplanTeam({this.data});
}

class CareplanTeamData {
  final List<dynamic>? doctors;

  CareplanTeamData({this.doctors});
}

String? getDoctorType(String? value) {
  if (value == "gp") {
    return "General Practitioner";
  }
  if (value == "psychiatrist") {
    return "Psychiatrist";
  }
  return value;
}

class EmptyCareplan extends StatelessWidget {
  const EmptyCareplan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CarePlanColor.grey_5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.folder_open_rounded,
                  color: CarePlanColor.brown,
                  size: 28,
                ),
              ),
              const Gap(14),
              TextHolder(
                title: "No care plan yet",
                color: CarePlanColor.brown,
                size: 16,
                fontWeight: FontWeight.w800,
                align: TextAlign.center,
              ),
              const Gap(6),
              TextHolder(
                title:
                    "Your provider will create your personalised care plan after your first session.",
                color: CarePlanColor.grey_3,
                size: 13,
                fontWeight: FontWeight.w500,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Care Team List Screen
class CareTeamListScreen extends StatelessWidget {
  final List<CarePlanTeamMember> careTeamMembers;
  final CareplanTeam? careplanTeam;

  const CareTeamListScreen({
    Key? key,
    required this.careTeamMembers,
    this.careplanTeam,
  }) : super(key: key);

  String? getTitle(String? name) {
    if (name == null) return "";
    if (name.toLowerCase().contains("therapist")) {
      return "";
    }
    if (name.toUpperCase().contains("ADHD COACH")) {
      return "ADHD Coach ";
    }
    return "Dr. ";
  }

  String? getProviderType(String type) {
    if (type.toUpperCase() == "MENTAL HEALTH NURSE") {
      return "Care Coordinator";
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    // Determine which data source to use
    final List<dynamic> teamList;

    if (careTeamMembers.isNotEmpty) {
      teamList = careTeamMembers;
    } else if (careplanTeam?.data?.doctors != null &&
        careplanTeam!.data!.doctors!.isNotEmpty) {
      teamList = careplanTeam!.data!.doctors!;
    } else {
      teamList = [];
    }

    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Care Team",
      ),
      backgroundColor: Colors.white,
      body: teamList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: CarePlanColor.light_orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.people_alt_outlined,
                        color: CarePlanColor.brown,
                        size: 28,
                      ),
                    ),
                    const Gap(14),
                    TextHolder(
                      title: "No care team members yet",
                      color: CarePlanColor.brown,
                      size: 16,
                      fontWeight: FontWeight.w800,
                      align: TextAlign.center,
                    ),
                    const Gap(6),
                    TextHolder(
                      title:
                          "Your care team will appear here once a provider is assigned to you.",
                      color: CarePlanColor.grey_3,
                      size: 13,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: teamList.length,
              separatorBuilder: (_, __) => const Gap(10),
              itemBuilder: (context, index) {
                String doctorName;
                String imageUrl;
                String? providerType;

                if (careTeamMembers.isNotEmpty) {
                  final member = careTeamMembers[index];
                  doctorName = member.name ?? "";
                  imageUrl = member.imageUrl ?? "";
                } else if (careplanTeam != null) {
                  final doctor = careplanTeam!.data!.doctors![index];
                  final firstName = doctor.firstName ?? "";
                  final lastName = doctor.lastName ?? "";
                  final doctorType = doctor.type?.toString() ?? "";
                  doctorName =
                      "${getTitle(doctorType)} $firstName $lastName".trim();
                  imageUrl = doctor.imageUrl ?? "";
                  providerType = getProviderType(doctorType);
                } else {
                  return const SizedBox();
                }

                return _CareTeamMemberCard(
                  name: doctorName,
                  subtitle: (providerType ?? '').isNotEmpty
                      ? providerType
                      : null,
                  imageUrl: imageUrl,
                );
              },
            ),
    );
  }
}

class WellbeingCheckIn extends StatefulWidget {
  final String question;
  final void Function(String mood) onMoodSelected;

  const WellbeingCheckIn({
    super.key,
    required this.question,
    required this.onMoodSelected,
  });

  @override
  State<WellbeingCheckIn> createState() => _WellbeingCheckInState();
}

class _WellbeingCheckInState extends State<WellbeingCheckIn> {
  static const _moods = <_MoodOption>[
    _MoodOption(emoji: "😞", label: "Awful"),
    _MoodOption(emoji: "😕", label: "Low"),
    _MoodOption(emoji: "😐", label: "Okay"),
    _MoodOption(emoji: "🙂", label: "Good"),
    _MoodOption(emoji: "😄", label: "Great"),
  ];

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CarePlanColor.grey_5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: CarePlanColor.light_orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: CarePlanColor.brown,
                    size: 18,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextHolder(
                        title: "Wellness check-in",
                        color: CarePlanColor.grey_3,
                        size: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      const Gap(2),
                      TextHolder(
                        title: widget.question,
                        color: CarePlanColor.grey,
                        size: 14,
                        fontWeight: FontWeight.w800,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_moods.length, (i) {
                final mood = _moods[i];
                final isSelected = _selectedIndex == i;
                return _MoodButton(
                  emoji: mood.emoji,
                  label: mood.label,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() => _selectedIndex = i);
                    widget.onMoodSelected(mood.label.toLowerCase());
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodOption {
  final String emoji;
  final String label;

  const _MoodOption({required this.emoji, required this.label});
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? CarePlanColor.light_orange : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? CarePlanColor.orange : CarePlanColor.grey_5,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const Gap(4),
              TextHolder(
                title: label,
                color: isSelected ? CarePlanColor.brown : CarePlanColor.grey_3,
                size: 10,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
