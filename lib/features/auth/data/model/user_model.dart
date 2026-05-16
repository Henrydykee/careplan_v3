class UserModel {
  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.otp,
    this.phone,
    this.kycStatus,
    this.isOtpVerified,
    this.type,
    this.multiFactorAuth,
    this.isPinSet,
    this.createdAt,
    this.city,
    this.country,
    this.medicareNum,
    this.medicareReferralNumber,
    this.postalCode,
    this.sex,
    this.state,
    this.street,
    this.dateOfApproval,
    this.isDeleted,
    this.address,
    this.businessInformation,
    this.education,
    this.id,
    this.primaryCalendarId,
    this.paymentMethods,
    this.entityInformation,
    this.roles,
    this.practice,
    this.careplanTeam,
    this.documents,
    this.permissions,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? otp;
  final String? phone;
  final String? kycStatus;
  final bool? isOtpVerified;
  final String? type;
  final bool? multiFactorAuth;
  final bool? isPinSet;
  final String? createdAt;
  final String? city;
  final String? country;
  final String? medicareNum;
  final String? medicareReferralNumber;
  final String? postalCode;
  final String? sex;
  final String? state;
  final String? street;
  final String? dateOfApproval;
  final bool? isDeleted;
  final String? address;
  final BusinessInformation? businessInformation;
  final List<dynamic>? education;
  final String? id;
  final String? primaryCalendarId;
  final List<dynamic>? paymentMethods;
  final Map<String, dynamic>? entityInformation;
  final List<String>? roles;
  final List<dynamic>? practice;
  final List<CarePlanTeamMember>? careplanTeam;
  final List<dynamic>? documents;
  final List<String>? permissions;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      otp: json['otp'] as String?,
      phone: json['phone'] as String?,
      kycStatus: json['kycStatus'] as String?,
      isOtpVerified: json['isOtpVerified'] as bool?,
      type: json['type'] as String?,
      multiFactorAuth: json['multiFactorAuth'] as bool?,
      isPinSet: json['isPinSet'] as bool?,
      createdAt: json['createdAt'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      medicareNum: json['medicareNum'] as String?,
      medicareReferralNumber: json['medicareReferralNumber'] as String?,
      postalCode: json['postalCode'] as String?,
      sex: json['sex'] as String?,
      state: json['state'] as String?,
      street: json['street'] as String?,
      dateOfApproval: json['dateOfApproval'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      address: json['address'] as String?,
      businessInformation: json['businessInformation'] != null
          ? BusinessInformation.fromJson(
              json['businessInformation'] as Map<String, dynamic>)
          : null,
      education: json['education'] as List<dynamic>?,
      id: json['id'] as String?,
      primaryCalendarId: json['primaryCalendarId'] as String?,
      paymentMethods: json['paymentMethods'] as List<dynamic>?,
      entityInformation: json['entityInformation'] as Map<String, dynamic>?,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      practice: json['practice'] as List<dynamic>?,
      careplanTeam: (json['careplanTeam'] as List<dynamic>?)
          ?.map((e) => CarePlanTeamMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      documents: json['documents'] as List<dynamic>?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'otp': otp,
      'phone': phone,
      'kycStatus': kycStatus,
      'isOtpVerified': isOtpVerified,
      'type': type,
      'multiFactorAuth': multiFactorAuth,
      'isPinSet': isPinSet,
      'createdAt': createdAt,
      'city': city,
      'country': country,
      'medicareNum': medicareNum,
      'medicareReferralNumber': medicareReferralNumber,
      'postalCode': postalCode,
      'sex': sex,
      'state': state,
      'street': street,
      'dateOfApproval': dateOfApproval,
      'isDeleted': isDeleted,
      'address': address,
      'businessInformation': businessInformation?.toJson(),
      'education': education,
      'id': id,
      'primaryCalendarId': primaryCalendarId,
      'paymentMethods': paymentMethods,
      'entityInformation': entityInformation,
      'roles': roles,
      'practice': practice,
      'careplanTeam': careplanTeam?.map((e) => e.toJson()).toList(),
      'documents': documents,
      'permissions': permissions,
    };
  }
}

class BusinessInformation {
  BusinessInformation({
    this.bank,
    this.director,
  });

  final Map<String, dynamic>? bank;
  final Map<String, dynamic>? director;

  factory BusinessInformation.fromJson(Map<String, dynamic> json) {
    return BusinessInformation(
      bank: json['bank'] as Map<String, dynamic>?,
      director: json['director'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'director': director,
    };
  }
}

class CarePlanTeamMember {
  CarePlanTeamMember({
    this.id,
    this.name,
    this.imageUrl,
    this.type,
    this.email,
  });

  final String? id;
  final String? name;
  final String? imageUrl;
  final String? type;
  final String? email;

  factory CarePlanTeamMember.fromJson(Map<String, dynamic> json) {
    String? readString(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }
      return null;
    }

    final firstName = readString(['firstName']);
    final lastName = readString(['lastName']);
    final composedName = [firstName, lastName]
        .where((e) => e != null && e.isNotEmpty)
        .join(' ')
        .trim();

    return CarePlanTeamMember(
      id: json['id'] as String?,
      name: readString(['name']) ??
          (composedName.isNotEmpty ? composedName : null),
      imageUrl: readString(['imageUrl', 'avatar', 'profilePicture']),
      type: readString(['type', 'providerType', 'role']),
      email: readString(['email']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'type': type,
      'email': email,
    };
  }
}
