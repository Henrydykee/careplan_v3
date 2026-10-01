import 'network_exceptions.dart';

/// Wrapper for network responses.
class NetworkServiceResponse {
  /// HTTP result of network access. An enum.
  final NetworkResult? result;

  /// Can be any of the typical REST API response bodies. If an error occurs,
  /// [data] is a [Map] with an `error` key.
  final dynamic data;

  /// May hold an error message if an error has occurred
  final dynamic error;

  /// Response headers if server responded with them
  final Map<String, dynamic>? headers;

  NetworkServiceResponse({this.result, this.data, this.headers, this.error});
}

/// Provides a readable enumeration of
/// the various potential HTTP responses.
enum NetworkResult {
  FAILURE,
  SUCCESS,
  NO_INTERNET_CONNECTION,
  SERVER_ERROR,
  BAD_REQUEST,
  UNAUTHORISED,
  FORBIDDEN,
  NO_SUCH_ENDPOINT,
  METHOD_DISALLOWED,
  SERVER_TIMEOUT,
  TOO_MANY_REQUESTS,
  NOT_IMPLEMENTED
}

/// Collapses whatever the API put in `message` into one readable string.
///
/// Validation errors come back as a list, e.g.
/// `{"message": ["postalCode must be a string", "city should not be empty"]}`,
/// so `error` cannot be assumed to be a String.
String readableApiError(
  dynamic error, {
  String fallback = "Looks like something is wrong, we are working to fix it",
}) {
  if (error is String) return error.isEmpty ? fallback : error;
  if (error is List) {
    final messages = error.map((e) => "$e").where((e) => e.isNotEmpty).toList();
    return messages.isEmpty ? fallback : messages.join("\n");
  }
  return error == null ? fallback : "$error";
}

handleNetworkResponse(NetworkServiceResponse response) {
  if (response.result != NetworkResult.SUCCESS) {
    if (response.result == NetworkResult.FAILURE  || response.result == NetworkResult.NO_INTERNET_CONNECTION) {
     // bugsnag.notify(response.error, response.data);
      throw NetworkConnectivityException(exceptionMessage: "${response.error}");
    }
   // bugsnag.notify(response.error, response.data);
    throw ApiResponseException(exceptionMessage: readableApiError(response.error), data: response.data);
  }
  return response.data;
}
