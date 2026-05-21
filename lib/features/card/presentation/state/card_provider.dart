import 'package:flutter/material.dart';

import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../data/models/card_model.dart';
import '../../domain/usecases/add_card.dart';
import '../../domain/usecases/card_usecases.dart';
import '../../domain/usecases/delete_card.dart';
import '../../domain/usecases/mark_default_card.dart';

class CardProvider with ChangeNotifier, ProviderState<List<CardModel>> {
  final CardUseCases useCases;

  CardProvider(this.useCases);

  List<CardModel> get cards => _cards;
  List<CardModel> _cards = [];

  void _setState({
    bool loading = false,
    bool isReady = false,
    bool hasError = false,
    String errorMsg = '',
    List<CardModel>? cardsPayload,
  }) {
    update(
      loading: loading,
      hasErr: hasError,
      errorMsg: errorMsg,
      ready: isReady,
      statePayload: cardsPayload,
    );
    if (cardsPayload != null) {
      _cards = cardsPayload;
    }
    notifyListeners();
  }

  Future<void> fetchCards() async {
    _setState(loading: true, hasError: false);
    notifyListeners();
    final response = await useCases.getCards(const NoParams());
    response.fold(
      (l) => _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: l.message,
        cardsPayload: [],
      ),
      (r) => _setState(
        loading: false,
        isReady: true,
        hasError: false,
        cardsPayload: r,
      ),
    );
  }

  Future<bool> setDefaultCard(String cardId) async {
    _setState(hasError: false, errorMsg: '');
    final response = await useCases.markDefaultCard
        .call(MarkDefaultCardParams(cardId: cardId));
    return response.fold(
      (l) {
        _setState(hasError: true, errorMsg: l.message);
        return false;
      },
      (_) async {
        await fetchCards();
        return true;
      },
    );
  }

  Future<bool> addCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    required String cardholderName,
  }) async {
    _setState(loading: true, hasError: false, errorMsg: '');
    final response = await useCases.addCard.call(
      AddCardParams(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvc,
        cardholderName: cardholderName,
      ),
    );
    return response.fold(
      (l) {
        _setState(loading: false, hasError: true, errorMsg: l.message);
        return false;
      },
      (_) async {
        await fetchCards();
        return true;
      },
    );
  }

  Future<bool> deleteCard(String cardId) async {
    final response =
        await useCases.deleteCard.call(DeleteCardParams(cardId: cardId));
    return response.fold(
      (l) {
        _setState(hasError: true, errorMsg: l.message);
        return false;
      },
      (_) {
        fetchCards();
        return true;
      },
    );
  }
}
