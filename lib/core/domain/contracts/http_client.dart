import 'package:celta_inventario/core/domain/contracts/contracts.dart';

abstract class HttpClient {
  Future<dynamic> request({
    required String url,
    required String method,
    dynamic body,
    Map? headers,
    bool? addDefaultHeaders,
    bool? decodeBody,
    CancelToken? cancelToken,
  });
}
