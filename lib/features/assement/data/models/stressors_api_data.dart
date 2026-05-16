class StressorsApiData {
  final StressorsFlags stressors;
  final int? abilityToCope;

  StressorsApiData({
    required this.stressors,
    required this.abilityToCope,
  });

  List<String> get selectedStressors {
    final result = <String>[];
    if (stressors.work == true) result.add("Work");
    if (stressors.relationship == true) result.add("Relationship");
    if (stressors.finances == true) result.add("Finances");
    if (stressors.physicalHealth == true) {
      result.add("Physical health or pain");
    }
    if (stressors.alcohol == true) {
      result.add("Alcohol or drugs");
    }
    if (stressors.trauma == true) result.add("Trauma");
    if (stressors.housing == true) result.add("Housing");
    if (stressors.school == true) result.add("School");
    return result;
  }

  factory StressorsApiData.fromJson(Map<String, dynamic> json) {
    final stressorsJson =
        json['stressors'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return StressorsApiData(
      stressors: StressorsFlags.fromJson(stressorsJson),
      abilityToCope: json['abilityToCope'] is int
          ? json['abilityToCope'] as int
          : int.tryParse(json['abilityToCope']?.toString() ?? ''),
    );
  }
}

class StressorsFlags {
  final bool? relationship;
  final bool? work;
  final bool? finances;
  final bool? physicalHealth;
  final bool? school;
  final bool? alcohol;
  final bool? trauma;
  final bool? housing;

  StressorsFlags({
    this.relationship,
    this.work,
    this.finances,
    this.physicalHealth,
    this.school,
    this.alcohol,
    this.trauma,
    this.housing,
  });

  factory StressorsFlags.fromJson(Map<String, dynamic> json) {
    return StressorsFlags(
      relationship: json['relationship'] as bool?,
      work: json['work'] as bool?,
      finances: json['finances'] as bool?,
      physicalHealth: json['physicalHealth'] as bool?,
      school: json['school'] as bool?,
      alcohol: json['alcohol'] as bool?,
      trauma: json['trauma'] as bool?,
      housing: json['housing'] as bool?,
    );
  }
}
