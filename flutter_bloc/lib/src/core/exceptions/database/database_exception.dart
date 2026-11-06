import 'package:flutter/services.dart';

import '../exception.dart';
// import 'package:isar/isar.dart';

class DatabaseException extends BaseException {
  const DatabaseException(this.message) : super(message: '');

  factory DatabaseException.fromSecureStorageError(PlatformException e) =>
      DatabaseException(e.message ?? 'Secure storage error');

  // factory DatabaseException.fromIsarError(IsarError e) =>
  //     DatabaseException(e.message);

  factory DatabaseException.fromSharedPreferencesError(Object e) =>
      DatabaseException(
        e is PlatformException
            ? (e.message ?? 'Shared preferences error')
            : e.toString(),
      );

  /// สำหรับกรณี setString/setBool ฯลฯ คืนค่า false
  const DatabaseException.sharedPreferencesWriteFailed(String key)
      : message = 'Failed to write "$key" to shared preferences',
        super(message: '');

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'DatabaseException: $message';
}
