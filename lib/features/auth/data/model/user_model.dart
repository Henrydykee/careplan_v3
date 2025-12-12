class User {
  User({
    this.type,
    this.hasK10,
    this.hasStressors,
    this.activated,
    this.verified,
    this.lastLoggedIn,
    this.careplan,
    this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.kycStatus,
    this.isPinSet,
    this.isOtpVerified,
    this.isPinPaymentAcctConnected,
  });

  final String? type;
  final bool? hasK10;
  final bool? hasStressors;
  final bool? activated;
  final bool? verified;
  final String? lastLoggedIn;
  final List<dynamic>? careplan;
  final String? id;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? updatedAt;
  final String? kycStatus;
  final bool? isPinSet;
  final bool? isOtpVerified;
  final bool? isPinPaymentAcctConnected;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type: json['type'] as String?,
      hasK10: json['hasK10'] as bool?,
      hasStressors: json['hasStressors'] as bool?,
      activated: json['activated'] as bool?,
      verified: json['verified'] as bool?,
      lastLoggedIn: json['lastLoggedIn'] as String?,
      careplan: json['careplan'] as List<dynamic>?,
      id: json['_id'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      kycStatus: json['kycStatus'] as String?,
      isPinSet: json['isPinSet'] as bool?,
      isOtpVerified: json['isOtpVerified'] as bool?,
      isPinPaymentAcctConnected: json['isPinPaymentAcctConnected'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'hasK10': hasK10,
      'hasStressors': hasStressors,
      'activated': activated,
      'verified': verified,
      'lastLoggedIn': lastLoggedIn,
      'careplan': careplan,
      '_id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'kycStatus': kycStatus,
      'isPinSet': isPinSet,
      'isOtpVerified': isOtpVerified,
      'isPinPaymentAcctConnected': isPinPaymentAcctConnected,
    };
  }
}

