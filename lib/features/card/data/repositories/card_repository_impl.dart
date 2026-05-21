import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/card_repository.dart';
import '../datasources/card_remote_datasource.dart';
import '../models/card_model.dart';

class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource _remoteDataSource;

  CardRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CardModel>> getCards() async {
    return guardedApiCall<List<CardModel>>(
      () => _remoteDataSource.getCards(),
      source: 'getCards',
      showNetworkError: true,
    );
  }

  @override
  Future<String> markDefaultCard({required String cardId}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.markDefaultCard(cardId: cardId),
      source: 'markDefaultCard',
      showNetworkError: true,
    );
  }

  @override
  Future<String> deleteCard({required String cardId}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.deleteCard(cardId: cardId),
      source: 'deleteCard',
      showNetworkError: true,
    );
  }

  @override
  Future<String> addCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    required String cardholderName,
  }) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.addCard(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvc,
        cardholderName: cardholderName,
      ),
      source: 'addCard',
      showNetworkError: true,
    );
  }
}
