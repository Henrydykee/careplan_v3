class CardModel {
  final String id;
  final String cardName;
  final String firstFourDigits;
  final String lastFourDigits;
  final String expirationDate;
  final String cardType;
  final bool isDefault;

  CardModel({
    required this.id,
    required this.cardName,
    required this.firstFourDigits,
    required this.lastFourDigits,
    required this.expirationDate,
    required this.cardType,
    this.isDefault = false,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String? ?? '',
      cardName: json['cardName'] as String? ?? '',
      firstFourDigits: json['firstFourDigits'] as String? ?? '',
      lastFourDigits: json['lastFourDigits'] as String? ?? '',
      expirationDate: json['expirationDate'] as String? ?? '',
      cardType: json['cardType'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardName': cardName,
      'firstFourDigits': firstFourDigits,
      'lastFourDigits': lastFourDigits,
      'expirationDate': expirationDate,
      'cardType': cardType,
      'isDefault': isDefault,
    };
  }
}
