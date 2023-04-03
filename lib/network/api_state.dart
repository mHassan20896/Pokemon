import 'dart:io';

import 'package:equatable/equatable.dart';

import '../exception/custom_exception.dart';

class ApiState<T> extends Equatable {
  const ApiState({
    this.response,
    this.apiResponseState = ApiResponseState.initial,
    this.e,
  });

  final T? response;
  final CustomException? e;
  final ApiResponseState apiResponseState;

  @override
  List<Object?> get props => [response, apiResponseState, e];

  ApiState<T> copyWith(
          {T? response,
          CustomException? e,
          ApiResponseState? apiResponseState}) =>
      ApiState(
        response: response ?? this.response,
        apiResponseState: apiResponseState ?? this.apiResponseState,
        e: e ?? this.e,
      );
}

enum ApiResponseState { initial, loading, success, error }

Future<ApiState<T>> apiCall<T>(
  Future<T> Function() f,
) async {
  try {
    final response = await f();
    return ApiState<T>(
      response: response,
      apiResponseState: ApiResponseState.success,
    );
  } on SocketException catch (_) {
    return ApiState<T>(
      e: const CustomException('Unable to connect to the internet.'),
      apiResponseState: ApiResponseState.error,
    );
  } on Exception catch (e) {
    return ApiState<T>(
      e: CustomException(e.toString()),
      apiResponseState: ApiResponseState.error,
    );
  }
}
