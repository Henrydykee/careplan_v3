

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/appointment/data/models/appointment_model.dart';
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

  K10ScoreHolder({
    this.k10Date,
    this.kycStatus,
    this.score,
    required this.width,
  });

  final double width;

  // Mock data
  final String _mockScore = "75";
  final String _mockK10Date = "Last completed: Jan 15, 2024";

  String getK10Date() {
    // Return mock date if k10Date is not provided
    return k10Date ?? _mockK10Date;
  }

  String getMockScore() {
    // Return mock score if score is not provided
    return score ?? _mockScore;
  }

  @override
  Widget build(BuildContext context) {
    final mockScore = getMockScore();
    final displayScore = mockScore == "0" || mockScore.isEmpty;
    
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF6A451A), borderRadius: BorderRadius.circular(5)),
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayScore
                        ? TextHolder(
                            title: "Complete your assessments.",
                            color: Colors.white,
                            size: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : TextHolder(
                            title: "Review your assessments.",
                            color: Colors.white,
                            size: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    Gap(8),
                    TextHolder(
                      title: getK10Date(),
                      color: Colors.white,
                      size: 12,
                    ),
                    Gap(8),
                    CustomButtom(
                      title: "Click Here",
                      onTap: () {
                        // Placeholder navigation
                      },
                      btnColor: Colors.white.withOpacity(0.2),
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
              SvgPicture.asset(Assets.test_icon),
            ],
          ),
        ),
      ),
    );
  }
}

class KycPending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Divider(),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.hour_glass),
              Gap(20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: "Your Profile is being reviewed",
                      size: 16,
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.brown,
                    ),
                    Gap(8),
                    TextHolder(
                      title: "You will get a notification when your Profile has been approved.",
                      size: 14,
                      color: CarePlanColor.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(10),
          Divider(),
        ],
      ),
    );
  }
}

class VerifyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(Assets.notification_icon_2),
                Gap(20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: "Complete User Verification",
                        size: 16,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                      Gap(10),
                      TextHolder(
                        title: "Afterwards you will be able to take the mental health assessment.",
                        size: 14,
                        color: CarePlanColor.brown,
                      ),
                      Gap(10),
                      CustomButtom(
                        title: "Begin User Verification",
                        //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => KycVerificatonScreen2())),
                        btnColor: CarePlanColor.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(20),
        Divider(),
      ],
    );
  }
}




class UpcomingAppointmentWidget extends StatefulWidget {
  final String? patientId;

  const UpcomingAppointmentWidget({Key? key, this.patientId}) : super(key: key);

  @override
  State<UpcomingAppointmentWidget> createState() => _UpcomingAppointmentWidgetState();
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
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        if (appointmentProvider.isLoading && appointmentProvider.appointments == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(CarePlanColor.brown),
                ),
              ),
            ),
          );
        }

        if (appointmentProvider.hasError && appointmentProvider.errorMessage.isNotEmpty) {
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
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
                      title: appointmentProvider.errorMessage,
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

        final appointments = appointmentProvider.appointments?.appointments ?? [];
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    router.push(AllAppointmentsScreen(patientId: widget.patientId));
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

  String? getTitle(String title){
    if(title.toLowerCase().contains("therapist")){
      return "";
    }
    if(title.toUpperCase() == "ADHD COACH"){
      return "ADHD Coach ";
    }
    return "Dr. ";
  }

  String? getProviderType(String type){
    if(type.toUpperCase() == "MENTAL HEALTH NURSE"){
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
    } else if (careplanTeam?.data?.doctors != null && careplanTeam!.data!.doctors!.isNotEmpty) {
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
          TextHolder(
            title: "Care Team",
            size: 16,
            fontWeight: FontWeight.w800,
            color: CarePlanColor.brown,
          ),
          Gap(10),
          ListView.builder(
            itemCount: displayCount,
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) {
              String doctorName;
              String imageUrl;
              
              if (hasRealData && careTeamMembers != null) {
                // Use CarePlanTeamMember data
                final member = careTeamMembers![i];
                doctorName = member.name ?? "";
                imageUrl = member.imageUrl ?? "";
              } else if (hasRealData && careplanTeam != null) {
                // Use careplanTeam data structure
                final doctor = careplanTeam!.data!.doctors![i];
                final firstName = doctor.firstName ?? "";
                final lastName = doctor.lastName ?? "";
                final doctorType = doctor.type?.toString() ?? "";
                doctorName = "${getTitle(doctorType)} $firstName $lastName".trim();
                imageUrl = doctor.imageUrl ?? "";
              } else {
                // Use mock data
                final doctor = teamList[i] as MockDoctor;
                final firstName = doctor.firstName;
                final lastName = doctor.lastName;
                final doctorType = doctor.type;
                doctorName = "${getTitle(doctorType)} $firstName $lastName".trim();
                imageUrl = doctor.imageUrl;
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  //  onTap: () => careTeamDoctorDetails(context, careplanTeam?.data?.doctors?[i]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      // ignore: deprecated_member_use
                      // border: Border.all(color: CarePlanColor.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 31,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.0),
                                        child: CachedNetworkImage(
                                          errorWidget: (context, url, error) => Image.asset(
                                            "assets/images/new_image_place_holder.png",
                                            fit: BoxFit.contain,
                                          ),
                                          imageUrl: imageUrl,
                                          fit: BoxFit.fill,
                                        ))
                                    // SvgPicture.asset(
                                    //   Assets.account_icon,
                                    //   color: CarePlanColor.brown,
                                    //   fit: BoxFit.fill,
                                    // ),
                                    ),
                              ),
                              Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextHolder(
                                    title: doctorName,
                                    color: CarePlanColor.grey,
                                    fontWeight: FontWeight.w900,
                                    size: 16,
                                  ),
                                  if (hasRealData && careplanTeam != null)
                                    TextHolder(
                                      title: getProviderType(careplanTeam!.data!.doctors![i].type?.toString() ?? "") ?? "",
                                      color: CarePlanColor.grey,
                                      fontWeight: FontWeight.w500,
                                      size: 11,
                                    ),
                                  Gap(6),
                                ],
                              )
                            ],
                          ),
                          // Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (showSeeMore)
            Center(
              child: GestureDetector(
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
                child: TextHolder(
                  title: "See More",
                  size: 16,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.brown,
                ),
              ),
            ),
          Gap(30),
        ],
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
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color(0xFFF2F2F2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: Column(
          children: [
            SvgPicture.asset(Assets.folder_icon),
            TextHolder(
              title: "You do not have a care plan",
              color: CarePlanColor.brown,
              fontWeight: FontWeight.w800,
            ),
          ],
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
    } else if (careplanTeam?.data?.doctors != null && careplanTeam!.data!.doctors!.isNotEmpty) {
      teamList = careplanTeam!.data!.doctors!;
    } else {
      teamList = [];
    }

    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
      ),
      backgroundColor: Colors.white,
      body: teamList.isEmpty
          ? Center(
              child: TextHolder(
                title: "No care team members found",
                size: 16,
                color: CarePlanColor.grey,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: teamList.length,
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
                  doctorName = "${getTitle(doctorType)} $firstName $lastName".trim();
                  imageUrl = doctor.imageUrl ?? "";
                  providerType = getProviderType(doctorType);
                } else {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) => Image.asset(
                                    "assets/images/new_image_place_holder.png",
                                    fit: BoxFit.contain,
                                  ),
                                  imageUrl: imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextHolder(
                                  title: doctorName,
                                  color: CarePlanColor.grey,
                                  fontWeight: FontWeight.w900,
                                  size: 16,
                                ),
                                if (providerType != null)
                                  TextHolder(
                                    title: providerType,
                                    color: CarePlanColor.grey,
                                    fontWeight: FontWeight.w500,
                                    size: 11,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}


