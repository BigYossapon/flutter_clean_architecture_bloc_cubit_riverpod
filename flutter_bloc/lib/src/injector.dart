import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import '../flavors.dart';
import 'core/constants/app_constants.dart';
import 'data/datasources/export_datasources.dart';
import 'data/repositories/export_repositories.dart';
import 'domain/repositories/export_repositories.dart';
import 'domain/usecases/export_usecases.dart';
import 'package:get_it/get_it.dart';

import 'presentation/bloc_cubit/users/export_users_bloc_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // ==========================================
  // Secure Storage
  // ==========================================

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(),
    ),
  );

  // ==========================================
  // Dio
  // ==========================================

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: F.baseUrl,
        connectTimeout: Constants.durationConnectTimeout,
        sendTimeout: Constants.durationSendTimeout,
        receiveTimeout: Constants.durationReceiveTimeout,
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );

    return dio;
  });

  // ==========================================
  // Data Source
  // ==========================================

  getIt.registerLazySingleton<UsersDatasource>(
    () => UsersDatasource(
      getIt<Dio>(),
      baseUrl: F.baseUrl,
    ),
  );

  // ==========================================
  // Repository
  // ==========================================

  getIt.registerLazySingleton<UsersRepo>(
    () => UsersRepoImpl(
      usersDatasource: getIt<UsersDatasource>(),
    ),
  );

  // ==========================================
  // UseCases
  // ==========================================

  getIt.registerLazySingleton<UsersUsecases>(
    () => UsersUsecases(
      usersRepository: getIt<UsersRepo>(),
    ),
  );

  // ==========================================
  // BLoC
  // ==========================================

  getIt.registerFactory<CreateUserBloc>(
    () => CreateUserBloc(
      usersUseCases: getIt<UsersUsecases>(),
    ),
  );

  getIt.registerFactory<DeleteUserBloc>(
    () => DeleteUserBloc(
      usersUseCases: getIt<UsersUsecases>(),
    ),
  );

  getIt.registerFactory<GetUserBloc>(
    () => GetUserBloc(
      usersUseCases: getIt<UsersUsecases>(),
    ),
  );

  // ==========================================
  // Cubit
  // ==========================================

  getIt.registerFactory<GetUsersCubit>(
    () => GetUsersCubit(
      usersUseCases: getIt<UsersUsecases>(),
    ),
  );
  getIt.registerFactory<UpdateUserCubit>(
    () => UpdateUserCubit(
      usersUseCases: getIt<UsersUsecases>(),
    ),
  );
}
