class CarePlanHistoryItemModel {
  final String? type;
  final String? status;
  final String? createdAt;
  final String? id;
  final String? provider;
  final String? providerType;
  final List<String>? diagnosis;
  final String? riskToSelf;
  final String? riskToOthers;
  final ShortTermGoalModel? shortTermGoal;
  final String? longTermGoal;
  final TherapyModel? therapy;
  final String? homework;
  final String? abilityToCope;
  final StressorsModel? stressors;

  CarePlanHistoryItemModel({
    this.type,
    this.status,
    this.createdAt,
    this.id,
    this.provider,
    this.providerType,
    this.diagnosis,
    this.riskToSelf,
    this.riskToOthers,
    this.shortTermGoal,
    this.longTermGoal,
    this.therapy,
    this.homework,
    this.abilityToCope,
    this.stressors,
  });

  factory CarePlanHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return CarePlanHistoryItemModel(
      type: json['type'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      id: json['id'] as String?,
      provider: json['provider'] as String?,
      providerType: json['providerType'] as String?,
      diagnosis: (json['diagnosis'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      riskToSelf: json['riskToSelf'] as String?,
      riskToOthers: json['riskToOthers'] as String?,
      shortTermGoal: json['shortTermGoal'] != null
          ? ShortTermGoalModel.fromJson(
              json['shortTermGoal'] as Map<String, dynamic>)
          : null,
      longTermGoal: json['longTermGoal'] as String?,
      therapy: json['therapy'] != null
          ? TherapyModel.fromJson(json['therapy'] as Map<String, dynamic>)
          : null,
      homework: json['homework'] as String?,
      abilityToCope: json['abilityToCope'] as String?,
      stressors: json['stressors'] != null
          ? StressorsModel.fromJson(json['stressors'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'createdAt': createdAt,
      'id': id,
      'provider': provider,
      'providerType': providerType,
      'diagnosis': diagnosis,
      'riskToSelf': riskToSelf,
      'riskToOthers': riskToOthers,
      'shortTermGoal': shortTermGoal?.toJson(),
      'longTermGoal': longTermGoal,
      'therapy': therapy?.toJson(),
      'homework': homework,
      'abilityToCope': abilityToCope,
      'stressors': stressors?.toJson(),
    };
  }
}

class ShortTermGoalModel {
  final String? timeline;
  final String? percent;
  final String? text;
  final String? id;

  ShortTermGoalModel({this.timeline, this.percent, this.text, this.id});

  factory ShortTermGoalModel.fromJson(Map<String, dynamic> json) {
    return ShortTermGoalModel(
      timeline: json['timeline'] as String?,
      percent: json['percent'] as String?,
      text: json['text'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeline': timeline,
      'percent': percent,
      'text': text,
      '_id': id,
    };
  }
}

class TherapyModel {
  final bool? hasCBT;
  final String? otherIntervention;
  final bool? hasSafetyPlanning;
  final String? id;

  TherapyModel({
    this.hasCBT,
    this.otherIntervention,
    this.hasSafetyPlanning,
    this.id,
  });

  factory TherapyModel.fromJson(Map<String, dynamic> json) {
    return TherapyModel(
      hasCBT: json['hasCBT'] as bool?,
      otherIntervention: json['otherIntervention'] as String?,
      hasSafetyPlanning: json['hasSafetyPlanning'] as bool?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasCBT': hasCBT,
      'otherIntervention': otherIntervention,
      'hasSafetyPlanning': hasSafetyPlanning,
      '_id': id,
    };
  }
}

class StressorsModel {
  final bool? relationship;
  final bool? work;
  final bool? finances;
  final bool? physicalHealth;
  final bool? school;
  final bool? alcohol;
  final bool? trauma;
  final bool? housing;
  final String? id;

  StressorsModel({
    this.relationship,
    this.work,
    this.finances,
    this.physicalHealth,
    this.school,
    this.alcohol,
    this.trauma,
    this.housing,
    this.id,
  });

  factory StressorsModel.fromJson(Map<String, dynamic> json) {
    return StressorsModel(
      relationship: json['relationship'] as bool?,
      work: json['work'] as bool?,
      finances: json['finances'] as bool?,
      physicalHealth: json['physicalHealth'] as bool?,
      school: json['school'] as bool?,
      alcohol: json['alcohol'] as bool?,
      trauma: json['trauma'] as bool?,
      housing: json['housing'] as bool?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationship': relationship,
      'work': work,
      'finances': finances,
      'physicalHealth': physicalHealth,
      'school': school,
      'alcohol': alcohol,
      'trauma': trauma,
      'housing': housing,
      '_id': id,
    };
  }
}
