import '../../data/models/card_model.dart';

abstract class CardRepository {
  Future<List<CardModel>> getCards();
  Future<String> markDefaultCard({required String cardId});
  Future<String> deleteCard({required String cardId});
}
