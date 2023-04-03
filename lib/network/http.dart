import 'dart:convert';

import 'package:http/http.dart';

import 'logs_interceptors.dart';
import 'url.dart' as url;

class HttpService {
  const HttpService({required this.client});

  final Client client;
  final String baseUrl = url.baseUrl;
  final LogsInterceptor logsInterceptor = const LogsInterceptor();

  Future<Map<String, dynamic>> get({
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    required String path,
  }) async {
    logsInterceptor.onRequest(path, 'GET',
        queryParameters: queryParams, headers: headers);

    final rawResponse = await client.get(
      Uri.https(baseUrl, path, queryParams),
      headers: headers,
    );

    final response = jsonDecode(rawResponse.body);

    logsInterceptor.onResponse(path, 'GET',
        body: response, statusCode: rawResponse.statusCode);

    return _handleJsonSerialization(response);
  }

// Triple<Map, List, String>

  Future<Map<String, dynamic>> post({
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    required String path,
  }) async {
    logsInterceptor.onRequest(path, 'POST',
        queryParameters: queryParams, headers: headers, body: body);

    final rawResponse = await client.post(
      Uri.https(baseUrl, path, queryParams),
      body: jsonEncode(body),
    );

    final response = jsonDecode(rawResponse.body);

    logsInterceptor.onResponse(path, 'POST',
        body: response, statusCode: rawResponse.statusCode);

    return _handleJsonSerialization(response);
  }

  Map<String, dynamic> _handleJsonSerialization(dynamic response) {
    final decodedObject = response as Map<String, dynamic>;
    return decodedObject;
  }
}
