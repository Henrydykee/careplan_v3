import '../../data/models/card_model.dart';

abstract class CardRepository {
  Future<List<CardModel>> getCards();
  Future<String> markDefaultCard({required String cardId});
  Future<String> deleteCard({required String cardId});
  Future<String> addCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    required String cardholderName,
  });
}
