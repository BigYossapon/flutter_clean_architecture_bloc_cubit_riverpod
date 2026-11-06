import 'package:equatable/equatable.dart';

abstract class BaseException extends Equatable implements Exception {
  const BaseException({
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  List<Object?> get props => [
        message,
        statusCode,
        cause,
      ];

  @override
  String toString() {
    return '$runtimeType($statusCode): $message';
  }
}

class NormalException extends BaseException {
  const NormalException({
    required super.message,
    super.statusCode,
    super.cause,
  });
}
