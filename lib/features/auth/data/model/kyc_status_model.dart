
class KycStatusResponse {
  bool? hasKycProfile;
  bool? bvnVerified;
  bool? idVerified;
  bool? livenessVerified;
  bool? isCompleted;
  String? currentStep;
  bool? canPerformTransactions;
  bool? isEmailVerified;
  bool? isTransactionPinSet;

  KycStatusResponse(
      {this.hasKycProfile,
        this.bvnVerified,
        this.idVerified,
        this.livenessVerified,
        this.isCompleted,
        this.currentStep,
        this.canPerformTransactions,
        this.isEmailVerified,
        this.isTransactionPinSet});

  KycStatusResponse.fromJson(Map<String, dynamic> json) {
    hasKycProfile = json['has_kyc_profile'];
    bvnVerified = json['bvn_verified'];
    idVerified = json['id_verified'];
    livenessVerified = json['liveness_verified'];
    isCompleted = json['is_completed'];
    currentStep = json['current_step'];
    canPerformTransactions = json['can_perform_transactions'];
    isEmailVerified = json['is_email_verified'];
    isTransactionPinSet = json['is_transaction_pin_set'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_kyc_profile'] = this.hasKycProfile;
    data['bvn_verified'] = this.bvnVerified;
    data['id_verified'] = this.idVerified;
    data['liveness_verified'] = this.livenessVerified;
    data['is_completed'] = this.isCompleted;
    data['current_step'] = this.currentStep;
    data['can_perform_transactions'] = this.canPerformTransactions;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_transaction_pin_set'] = this.isTransactionPinSet;
    return data;
  }
}
