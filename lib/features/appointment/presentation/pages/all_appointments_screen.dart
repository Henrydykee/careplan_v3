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
      final parsedStartTime = DateTime.parse(rawStartTime);
      final parsedEndTime = DateTime.parse(rawEndTime);
      localStart = parsedStartTime.toLocal();
      localEnd = parsedEndTime.toLocal();
    } catch (e) {
      debugPrint("Error parsing date/time: $e");
    }

    final String month = localStart != null ? DateFormat("MMM").format(localStart) : "";
    final String day = localStart != null ? DateFormat("dd").format(localStart) : "";
    final String date = localStart != null ? DateFormat("EEE, MMM dd, yyyy").format(localStart) : "";
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
                    const Gap(4),
                    TextHolder(
                      title: date,
                      color: CarePlanColor.grey_2,
                      fontWeight: FontWeight.w500,
                      size: 12,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Upcoming Appointments",
        showBackIcon: true,
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, child) {
          if (appointmentProvider.isLoading && appointmentProvider.appointments == null) {
            return const AppointmentListShimmer(
              itemCount: 6,
              padding: EdgeInsets.all(20),
            );
          }

          if (appointmentProvider.hasError && appointmentProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
            );
          }

          final appointments = appointmentProvider.appointments?.appointments ?? [];
          final sortedAppointments = _sortAppointmentsByDate([...appointments]);

          if (sortedAppointments.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
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
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (widget.patientId != null && widget.patientId!.isNotEmpty) {
                await appointmentProvider.fetchUpcomingAppointments(
                  patientId: widget.patientId!,
                  page: 1,
                  limit: 100,
                );
              }
            },
            color: CarePlanColor.brown,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sortedAppointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentItem(sortedAppointments[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
