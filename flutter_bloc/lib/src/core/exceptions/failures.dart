import 'package:equatable/equatable.dart';

import '../constants/enum_constants.dart';

//use for repository call throw

// class ServerFailure extends Failure {}

// class ConnectionFailure extends Failure {}

// class DatabaseFailure extends Failure {}

// class SharedPreferencesFailure extends Failure {}

// class CacheFailure extends Failure {
//   CacheFailure({required super.message, required super.code, required super.status, required super.errorFailureType});
// }

abstract class Failure extends Equatable {
  final int code;
  final String message;
  final ErrorFailureType errorFailureType;
  final String status;
  const Failure(
      {required this.message,
      required this.code,
      required this.status,
      required this.errorFailureType});

  @override
  List<Object?> get props => [];
}

class BaseFailure extends Failure {
  final int code;
  final String message;
  final ErrorFailureType errorFailureType;
  final String status;
  const BaseFailure(
      {required this.message,
      required this.code,
      required this.status,
      required this.errorFailureType})
      : super(
            message: message,
            code: code,
            errorFailureType: errorFailureType,
            status: status);
}
