import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import 'endpoint.dart';

abstract class CardRemoteDataSource extends RemoteDataSource {
  Future<String> addCard({
    required String cardNumber,
    required String cvv,
    required String expirationDate,
    required String cardName,
    required String cardType,
  });
  Future<String> getCard();
  Future<String> deleteCard({required String cardId});
  Future<String> markDefaultCard({required String cardId});
  Future<String> getStripeDetails({required String chargeId});
  Future<String> getPinPaymentInvoice({required String transactionId});
}

class CardRemoteDataSourceImpl implements CardRemoteDataSource {
  final NetworkService _networkService;
  CardRemoteDataSourceImpl(this._networkService);

  @override
  void dispose() {}

  @override
  Future<String> addCard({
    required String cardNumber,
    required String cvv,
    required String expirationDate,
    required String cardName,
    required String cardType,
  }) async {
    NetworkServiceResponse response = await _networkService.post(
      CardEndpoints.addCard,
      body: {
        "cardNumber": cardNumber,
        "cvv": cvv,
        "expirationDate": expirationDate,
        "cardName": cardName,
        "cardType": cardType,
      },
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> getCard() async {
    NetworkServiceResponse response = await _networkService.get(CardEndpoints.getCard);
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> deleteCard({required String cardId}) async {
    NetworkServiceResponse response = await _networkService.delete(
      CardEndpoints.deleteCard,
      queryParameters: {"cardId": cardId},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> markDefaultCard({required String cardId}) async {
    NetworkServiceResponse response = await _networkService.patch(
      CardEndpoints.markDefaultCard,
      queryParameters: {"cardId": cardId},
    );
    final data = handleNetworkResponse(response);
    return data["message"] ?? jsonEncode(data);
  }

  @override
  Future<String> getStripeDetails({required String chargeId}) async {
    NetworkServiceResponse response = await _networkService.get(
      CardEndpoints.getStripeDetails,
      queryParameters: {"chargeId": chargeId},
    );
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }

  @override
  Future<String> getPinPaymentInvoice({required String transactionId}) async {
    NetworkServiceResponse response = await _networkService.get("${CardEndpoints.getPinPaymentInvoice}/$transactionId");
    final data = handleNetworkResponse(response);
    return jsonEncode(data);
  }
}


