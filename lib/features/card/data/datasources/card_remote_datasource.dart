import 'dart:convert';

import '../../../../core/data/datasources/remote_datasource_base.dart';
import '../../../../core/data/network/network_service.dart';
import '../../../../core/data/network/network_service_response.dart';
import '../models/card_model.dart';
import 'endpoint.dart';

abstract class CardRemoteDataSource extends RemoteDataSource {
  Future<String> addCard({
    required String cardNumber,
    required String expirationDate,
    required String cvv,
    required String cardholderName,
  });
  Future<List<CardModel>> getCards();
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
    required String expirationDate,
    required String cvv,
    required String cardholderName,
  }) async {
    NetworkServiceResponse response = await _networkService.post(
      CardEndpoints.addCard,
      body: {
        "cardNumber": cardNumber,
        "cvv": cvv,
        "expirationDate": expirationDate,
        "cardholderName": cardholderName,
      },
    );
    final data = handleNetworkResponse(response);
    if (data is Map && data["message"] != null) {
      return data["message"] as String;
    }
    return jsonEncode(data);
  }

  @override
  Future<List<CardModel>> getCards() async {
    NetworkServiceResponse response =
        await _networkService.get(CardEndpoints.getCards);
    final data = handleNetworkResponse(response);
    final raw = data is Map<String, dynamic> && data.containsKey('data')
        ? data['data']
        : data;
    final list = raw is List<dynamic> ? raw : <dynamic>[];
    return list
        .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
        .toList();
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


