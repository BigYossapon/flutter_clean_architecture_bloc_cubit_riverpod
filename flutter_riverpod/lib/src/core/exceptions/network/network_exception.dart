import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/network_error_model.dart';
import '../exception.dart';

///
/// This class extends [Equatable] and implements [Exception].
/// It contains a [message] and a [statusCode] property.
/// The [message] property contains the error message and the [statusCode]
/// property contains the HTTP status code of the response.
///
/// This class has a constructor [fromDioError] which takes a [DioException]
/// as a parameter and sets the [statusCode] and [message] properties based on
/// the type of the [DioException].
///
/// This class also overrides the [props] getter from [Equatable] to compare
/// instances of this class based on the [message] and [statusCode] properties.
///
/// Example usage:
/// ```dart
/// try {
///   // some network request
/// } on DioException catch (e) {
///   throw NetworkException.fromDioError(e);
/// }
/// ```
///
///
class NetworkException extends BaseException {
  const NetworkException(
      {required super.message, super.statusCode, super.cause});

  factory NetworkException.fromDioError(DioException e) {
    return NetworkException(
      message: _messageFor(e),
      statusCode: e.response?.statusCode,
      cause: e,
    );
  }

  static String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return 'Request to API server was cancelled';
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with API server';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with API server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection with API server';
      case DioExceptionType.transformTimeout:
        return 'Timeout while processing data from API server';
      case DioExceptionType.connectionError:
        return e.error is SocketException
            ? 'Please check your internet connection'
            : 'Unexpected error occurred';
      case DioExceptionType.badCertificate:
        return 'Bad Certificate';
      case DioExceptionType.badResponse:
        return _badResponseMessage(e.response?.data);
      case DioExceptionType.unknown:
        return 'Unexpected error occurred';
    }
  }

  static String _badResponseMessage(Object? data) {
    const fallback = 'Unexpected bad response';
    if (data is! Map<String, dynamic>) return fallback;
    try {
      return NetworkErrorModel.fromJson(data).statusMessage ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'NetworkException($statusCode): $message';
}
