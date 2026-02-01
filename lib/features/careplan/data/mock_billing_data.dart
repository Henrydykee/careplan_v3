/// Mock data for careplan and billing screens (dev only).

class MockBillingHistory {
  final String? practitionerName;
  final double? totalAmount;
  final String? dateOfBilling;
  final String? type;
  final String? patientName;
  final String? medicareNum;
  final String? irn;
  final String? transactionId;
  final String? status;
  final String? claimPdfUrl;
  final String? cardType;
  final String? lastFourDigits;
  final double? totalCardAmount;
  final String? providerTaxURL;
  final String? receiptURL;
  final String? stripeChargeId;
  final String? claimId;
  final String? locationId;
  final String? source;

  MockBillingHistory({
    this.practitionerName,
    this.totalAmount,
    this.dateOfBilling,
    this.type,
    this.patientName,
    this.medicareNum,
    this.irn,
    this.transactionId,
    this.status,
    this.claimPdfUrl,
    this.cardType,
    this.lastFourDigits,
    this.totalCardAmount,
    this.providerTaxURL,
    this.receiptURL,
    this.stripeChargeId,
    this.claimId,
    this.locationId,
    this.source,
  });
}

class MockCarePlanHistory {
  final String? sId;
  final String? createdAt;
  final String? doctorType;

  MockCarePlanHistory({this.sId, this.createdAt, this.doctorType});
}

class MockBillingData {
  static final List<MockBillingHistory> billingHistory = [
    MockBillingHistory(
      practitionerName: "Dr. Sarah Johnson",
      totalAmount: 150.00,
      dateOfBilling: "2024-01-15",
      type: "Medicare",
      patientName: "John Smith",
      medicareNum: "1234 56789 0",
      irn: "IRN-001",
      transactionId: "TXN-2024-001",
      status: "Processed",
      claimId: "CLM-001",
      locationId: "LOC-001",
      source: "session",
      cardType: "Visa",
      lastFourDigits: "4242",
      totalCardAmount: 85.00,
    ),
    MockBillingHistory(
      practitionerName: "Dr. Michael Brown",
      totalAmount: 200.00,
      dateOfBilling: "2024-01-10",
      type: "BulkBill",
      patientName: "Jane Doe",
      medicareNum: "9876 54321 1",
      irn: "IRN-002",
      transactionId: "TXN-2024-002",
      status: "Submitted",
      cardType: "Mastercard",
      lastFourDigits: "5555",
      totalCardAmount: 0,
    ),
  ];

  static final List<MockCarePlanHistory> carePlanHistory = [
    MockCarePlanHistory(
      sId: "cp-001",
      createdAt: "2024-01-20T10:30:00",
      doctorType: "General Practitioner",
    ),
    MockCarePlanHistory(
      sId: "cp-002",
      createdAt: "2024-01-15T14:00:00",
      doctorType: "ADHD Coach",
    ),
  ];

  static final List<MockNote> notes = [
    MockNote(
      sessionId: "SES-001",
      providerFirstName: "Sarah",
      providerLastName: "Johnson",
      providerType: "Psychiatrist",
      createdAt: "2024-01-18T09:30:00",
      noteContent: "Patient showed significant improvement in managing anxiety symptoms. Continuing current medication plan.",
    ),
    MockNote(
      sessionId: "SES-002",
      providerFirstName: "Michael",
      providerLastName: "Brown",
      providerType: "ADHD Coach",
      createdAt: "2024-01-12T14:00:00",
      noteContent: "Reviewed daily routines and implemented new time management strategies.",
    ),
    MockNote(
      sessionId: "SES-003",
      providerFirstName: "Emily",
      providerLastName: "Davis",
      providerType: "Mental Health Nurse",
      createdAt: "2024-01-05T11:15:00",
      noteContent: "Follow-up care coordination session. Discussed upcoming appointments and medication refills.",
    ),
  ];
}

class MockNote {
  final String? sessionId;
  final String? providerFirstName;
  final String? providerLastName;
  final String? providerType;
  final String? createdAt;
  final String? noteContent;

  MockNote({
    this.sessionId,
    this.providerFirstName,
    this.providerLastName,
    this.providerType,
    this.createdAt,
    this.noteContent,
  });
}

class MockCarePlanSummary {
  final String? createdAt;
  final MockDoctor? doctor;
  final MockAssessment? assessment;
  final String? riskToSelf;
  final String? riskToOthers;
  final List<String>? diagnosis;
  final List<MockMedication>? medication;
  final MockTherapy? therapy;
  final List<MockHomework>? homework;
  final MockAppointment? appointment;
  final List<String>? requests;

  MockCarePlanSummary({
    this.createdAt,
    this.doctor,
    this.assessment,
    this.riskToSelf,
    this.riskToOthers,
    this.diagnosis,
    this.medication,
    this.therapy,
    this.homework,
    this.appointment,
    this.requests,
  });

  static MockCarePlanSummary get sample => MockCarePlanSummary(
        createdAt: "2024-01-20T10:30:00",
        doctor: MockDoctor(
          firstName: "Sarah",
          lastName: "Johnson",
          type: "Psychiatrist",
        ),
        assessment: MockAssessment(
          score: 24,
          shortTermGoal: "Reduce anxiety symptoms and improve sleep quality",
          longTermGoal: "Achieve stable mental health and develop coping mechanisms",
          stressors: MockStressors(
            work: true,
            relationship: true,
            finances: false,
            trauma: false,
            housing: false,
            alcohol: false,
            physicalhealth: true,
            school: false,
          ),
        ),
        riskToSelf: "Low",
        riskToOthers: "Low",
        diagnosis: [
          "Generalized Anxiety Disorder (GAD)",
          "Mild Depression",
        ],
        medication: [
          MockMedication(
            drugName: "Sertraline",
            description: "Selective serotonin reuptake inhibitor (SSRI)",
            dosage: "50mg once daily",
          ),
        ],
        therapy: MockTherapy(therapyType: "Cognitive Behavioral Therapy (CBT)"),
        homework: [
          MockHomework(task: "Practice mindfulness meditation", duration: "15 minutes daily"),
          MockHomework(task: "Keep a mood journal", duration: "Daily entries"),
        ],
        appointment: MockAppointment(
          appointmentDate: "2024-02-01T14:00:00",
          meetingLink: "Video consultation scheduled",
        ),
        requests: [
          "Blood test for thyroid function",
          "Sleep study referral",
        ],
      );
}

class MockDoctor {
  final String? firstName;
  final String? lastName;
  final String? type;

  MockDoctor({this.firstName, this.lastName, this.type});
}

class MockAssessment {
  final int? score;
  final String? shortTermGoal;
  final String? longTermGoal;
  final MockStressors? stressors;

  MockAssessment({this.score, this.shortTermGoal, this.longTermGoal, this.stressors});
}

class MockStressors {
  final bool? work;
  final bool? relationship;
  final bool? finances;
  final bool? trauma;
  final bool? housing;
  final bool? alcohol;
  final bool? physicalhealth;
  final bool? school;

  MockStressors({
    this.work,
    this.relationship,
    this.finances,
    this.trauma,
    this.housing,
    this.alcohol,
    this.physicalhealth,
    this.school,
  });
}

class MockMedication {
  final String? drugName;
  final String? description;
  final String? dosage;

  MockMedication({this.drugName, this.description, this.dosage});
}

class MockTherapy {
  final String? therapyType;

  MockTherapy({this.therapyType});
}

class MockHomework {
  final String? task;
  final String? duration;

  MockHomework({this.task, this.duration});
}

class MockAppointment {
  final String? appointmentDate;
  final String? meetingLink;

  MockAppointment({this.appointmentDate, this.meetingLink});
}
