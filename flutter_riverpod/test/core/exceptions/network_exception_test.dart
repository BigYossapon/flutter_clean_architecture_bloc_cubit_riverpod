import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/network/network_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: '/users');

  group('NetworkException.fromDioError', () {
    test('maps cancel', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.cancel,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Request to API server was cancelled');
      expect(result.statusCode, isNull);
      expect(result.cause, dioError);
    });

    test('maps connectionTimeout', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Connection timeout with API server');
    });

    test('maps receiveTimeout', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.receiveTimeout,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Receive timeout in connection with API server');
    });

    test('maps sendTimeout', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.sendTimeout,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Send timeout in connection with API server');
    });

    test('maps transformTimeout', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.transformTimeout,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Timeout while processing data from API server');
    });

    test('maps connectionError with SocketException', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        error: const SocketException('No internet'),
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Please check your internet connection');
    });

    test('maps connectionError without SocketException', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        error: Exception('other'),
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Unexpected error occurred');
    });

    test('maps badCertificate', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badCertificate,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Bad Certificate');
    });

    test('maps badResponse with valid NetworkErrorModel json', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {
            'status_code': 404,
            'status_message': 'User not found',
          },
        ),
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.statusCode, 404);
      expect(result.message, 'User not found');
    });

    test('maps badResponse with null status_message to fallback', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
          data: {'status_code': 500},
        ),
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.statusCode, 500);
      expect(result.message, 'Unexpected bad response');
    });

    test('maps badResponse with non-map data to fallback', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 502,
          data: 'Bad Gateway',
        ),
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.statusCode, 502);
      expect(result.message, 'Unexpected bad response');
    });

    test('maps badResponse with malformed json types to fallback', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {'status_code': 'not-an-int', 'status_message': 123},
        ),
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.statusCode, 400);
      expect(result.message, 'Unexpected bad response');
    });

    test('maps unknown', () {
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.unknown,
      );

      final result = NetworkException.fromDioError(dioError);

      expect(result.message, 'Unexpected error occurred');
    });
  });

  group('Exception equality and formatting', () {
    test('NetworkException compares message and statusCode', () {
      const a = NetworkException(message: 'err', statusCode: 404);
      const b = NetworkException(message: 'err', statusCode: 404);
      const c = NetworkException(message: 'err', statusCode: 500);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.toString(), 'NetworkException(404): err');
    });

    test('NormalException compares message, statusCode, and cause', () {
      const a = NormalException(message: 'boom', statusCode: 0, cause: 'c');
      const b = NormalException(message: 'boom', statusCode: 0, cause: 'c');
      const c = NormalException(message: 'boom', statusCode: 1, cause: 'c');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.toString(), 'NormalException(0): boom');
    });
  });
}
