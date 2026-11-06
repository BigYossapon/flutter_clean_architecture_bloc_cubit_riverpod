import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';
import '../flavors.dart';
import 'core/constants/app_constants.dart';
import 'data/datasources/export_datasources.dart';
import 'data/repositories/export_repositories.dart';
import 'domain/repositories/export_repositories.dart';
import 'domain/usecases/export_usecases.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
IOSOptions _getIosOptions() => const IOSOptions();
final FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(), iOptions: _getIosOptions());

final Dio dio = Dio(BaseOptions(
    connectTimeout: Constants.durationConnectTimeout,
    sendTimeout: Constants.durationSendTimeout,
    receiveTimeout: Constants.durationReceiveTimeout))
  ..interceptors.addAll([
    // CertificatePinningInterceptor(allowedSHAFingerprints: [F.sslCertificate]),
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    )
  ]);

//datasource
final userdatasourceProvider = Provider<UsersDatasource>(
    (ref) => UsersDatasource(dio, baseUrl: F.baseUrl));

final userRepositoryProvider = Provider<UsersRepo>(
    (ref) => UsersRepoImpl(usersDatasource: ref.watch(userdatasourceProvider)));

final usersUseCasesProvider = Provider<UsersUsecases>(
    (ref) => UsersUsecases(usersRepository: ref.watch(userRepositoryProvider)));
