import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/appointment/data/models/appointment_model.dart';
import 'package:careplan/features/appointment/presentation/state/appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllAppointmentsScreen extends StatefulWidget {
  final String? patientId;

  const AllAppointmentsScreen({Key? key, this.patientId}) : super(key: key);

  @override
  State<AllAppointmentsScreen> createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.patientId != null && widget.patientId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppointmentProvider>().fetchUpcomingAppointments(
          patientId: widget.patientId!,
          page: 1,
          limit: 100, // Fetch more appointments for the "all" screen
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

  List<AppointmentModel> _sortAppointmentsByDate(List<AppointmentModel> appointments) {
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
      localStart = DateTime.parse(rawStartTime).toLocal();
      localEnd = DateTime.parse(rawEndTime).toLocal();
    } catch (e) {
      debugPrint("Error parsing date/time: $e");
    }

    final weekday = localStart != null
        ? DateFormat("EEE").format(localStart).toUpperCase()
        : "";
    final day =
        localStart != null ? DateFormat("dd").format(localStart) : "--";
    final month = localStart != null
        ? DateFormat("MMM").format(localStart).toUpperCase()
        : "";
    final timeRange = (localStart != null && localEnd != null)
        ? "${DateFormat.jm().format(localStart)} – ${DateFormat.jm().format(localEnd)}"
        : "Time not available";

    final providerName = appointment.provider?.name ?? "";
    final providerType = appointment.provider?.type ?? "";
    final providerSubtitle = getProviderType(providerType) ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CarePlanColor.grey_5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHolder(
                      title: weekday,
                      color: CarePlanColor.brown,
                      size: 10,
                      fontWeight: FontWeight.w800,
                    ),
                    const Gap(2),
                    TextHolder(
                      title: day,
                      color: CarePlanColor.brown,
                      size: 22,
                      fontWeight: FontWeight.w900,
                    ),
                    TextHolder(
                      title: month,
                      color: CarePlanColor.brown,
                      size: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHolder(
                      title: "${getTitle(providerType)}$providerName",
                      color: CarePlanColor.grey,
                      fontWeight: FontWeight.w800,
                      size: 15,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    if (providerSubtitle.isNotEmpty) ...[
                      const Gap(2),
                      TextHolder(
                        title: providerSubtitle,
                        color: CarePlanColor.grey_3,
                        fontWeight: FontWeight.w600,
                        size: 12,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Gap(10),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: CarePlanColor.brown,
                        ),
                        const Gap(6),
                        Flexible(
                          child: TextHolder(
                            title: timeRange,
                            color: CarePlanColor.brown,
                            fontWeight: FontWeight.w800,
                            size: 13,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Future<void> _onRefresh() async {
    if (widget.patientId == null || widget.patientId!.isEmpty) return;
    await context.read<AppointmentProvider>().fetchUpcomingAppointments(
          patientId: widget.patientId!,
          page: 1,
          limit: 100,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Upcoming Appointments",
        showBackIcon: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: CarePlanColor.brown,
        child: Consumer<AppointmentProvider>(
          builder: (context, appointmentProvider, child) {
            if (appointmentProvider.isLoading &&
                appointmentProvider.appointments == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  AppointmentListShimmer(
                    itemCount: 6,
                    padding: EdgeInsets.all(20),
                  ),
                ],
              );
            }

            if (appointmentProvider.hasError &&
                appointmentProvider.errorMessage.isNotEmpty &&
                appointmentProvider.appointments == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextHolder(
                          title: "Error loading appointments",
                          color: Colors.red,
                          size: 16,
                        ),
                        const Gap(10),
                        TextHolder(
                          title: appointmentProvider.errorMessage,
                          color: CarePlanColor.grey,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final appointments =
                appointmentProvider.appointments?.appointments ?? [];
            final sortedAppointments =
                _sortAppointmentsByDate([...appointments]);

            if (sortedAppointments.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.calender),
                        const Gap(20),
                        TextHolder(
                          title: "No Upcoming Appointments",
                          align: TextAlign.center,
                          color: CarePlanColor.grey,
                          size: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: sortedAppointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentItem(sortedAppointments[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
