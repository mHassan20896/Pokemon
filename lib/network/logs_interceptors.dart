import 'dart:developer';

import 'package:flutter/material.dart';

@immutable
class LogsInterceptor {
  const LogsInterceptor();

  void onRequest(
    String path,
    String method, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) {
    log('$method $path');
    if (headers != null) log('headers: $headers');
    if (queryParameters != null) log('query params: $queryParameters');
    if (body != null) log('body: $body');
  }

  void onResponse(
    String path,
    String method, {
    int? statusCode,
    dynamic body,
  }) {
    log('$method $path');
    if (statusCode != null) log(statusCode.toString());
    if (body != null) log('response: $body');
  }
}
