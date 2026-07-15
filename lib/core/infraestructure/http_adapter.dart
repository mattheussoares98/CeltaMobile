import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    dynamic body,
    Map? headers,
    bool? addDefaultHeaders = true,
    bool? decodeBody = true,
    CancelToken? cancelToken,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {};
    if (addDefaultHeaders == true) {
      defaultHeaders.addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
    }

    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response>? futureResponse;

    try {
      if (cancelToken?.isCancelled == true) return null;

      String applyedUrl = url;

      //! replace easily when testing the API
      if (kDebugMode && 1 == 2) {
        applyedUrl = url.replaceFirstMapped(
          RegExp(r'(https?://)[^/]+/api'),
          (match) => '${match[1]}localhost:58915',
        );
      }

      if (method == 'post') {
        futureResponse = client.post(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
          body: jsonBody,
        );
      } else if (method == 'get') {
        futureResponse = client.get(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
        );
      } else if (method == 'delete') {
        futureResponse = client.delete(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
        );
      } else if (method == 'put') {
        futureResponse = client.put(
          Uri.parse(applyedUrl),
          headers: defaultHeaders,
          body: jsonBody,
        );
      }

      if (futureResponse != null) {
        response = await futureResponse.timeout(const Duration(minutes: 5));
      }

      if (cancelToken?.isCancelled == true) return null;
    } catch (error) {
      if (cancelToken?.isCancelled == true) return null;
      debugPrint(error.toString());
      throw HttpError.serverError;
    }

    return _handleResponse(response, decodeBody, cancelToken);
  }

  dynamic _handleResponse(
    Response response,
    bool? decodeBody,
    CancelToken? token,
  ) {
    if (token?.isCancelled == true) return null;

    switch (response.statusCode) {
      case 200:
        if (decodeBody != true) return response.body;
        if (response.body.isEmpty) return null;

        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw response.body.isNotEmpty
            ? ApiError(response.body)
            : HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
