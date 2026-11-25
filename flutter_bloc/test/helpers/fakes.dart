import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/datasources/remote/users/users_datasource.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/models/remote/users/user_model.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/repositories/remote/users/users_repo.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/usecases/users/user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hand-written fake datasource: unset callbacks throw if invoked unexpectedly.
class FakeUsersDatasource extends Fake implements UsersDatasource {
  FakeUsersDatasource({
    this.onGetUsers,
    this.onGetUser,
    this.onCreateUser,
    this.onUpdateUser,
    this.onDeleteUser,
  });

  final Future<List<UserModel>> Function()? onGetUsers;
  final Future<UserModel> Function(String id)? onGetUser;
  final Future<UserModel> Function(UserModel user)? onCreateUser;
  final Future<UserModel> Function(String id, UserModel user)? onUpdateUser;
  final Future<UserModel> Function(String id)? onDeleteUser;

  @override
  Future<List<UserModel>> getUsers() => onGetUsers!();

  @override
  Future<UserModel> getUser(String id) => onGetUser!(id);

  @override
  Future<UserModel> createUser(UserModel user) => onCreateUser!(user);

  @override
  Future<UserModel> updateUser(String id, UserModel user) =>
      onUpdateUser!(id, user);

  @override
  Future<UserModel> deleteUser(String id) => onDeleteUser!(id);
}

/// Hand-written fake repository for usecase tests.
class FakeUsersRepo extends Fake implements UsersRepo {
  FakeUsersRepo({
    this.onGetUsers,
    this.onGetUser,
    this.onCreateUser,
    this.onUpdateUser,
    this.onDeleteUser,
  });

  final Future<Either<BaseException, List<UserEntity>>> Function()? onGetUsers;
  final Future<Either<BaseException, UserEntity>> Function(String id)? onGetUser;
  final Future<Either<BaseException, UserEntity>> Function(UserEntity user)?
      onCreateUser;
  final Future<Either<BaseException, UserEntity>> Function(
      String id, UserEntity user)? onUpdateUser;
  final Future<Either<BaseException, UserEntity>> Function(String id)?
      onDeleteUser;

  @override
  Future<Either<BaseException, List<UserEntity>>> getUsers() => onGetUsers!();

  @override
  Future<Either<BaseException, UserEntity>> getUser(String id) =>
      onGetUser!(id);

  @override
  Future<Either<BaseException, UserEntity>> createUser(UserEntity user) =>
      onCreateUser!(user);

  @override
  Future<Either<BaseException, UserEntity>> updateUser(
          String id, UserEntity user) =>
      onUpdateUser!(id, user);

  @override
  Future<Either<BaseException, UserEntity>> deleteUser(String id) =>
      onDeleteUser!(id);
}

/// Hand-written fake usecases for BLoC/Cubit tests.
class FakeUsersUsecases extends Fake implements UsersUsecases {
  FakeUsersUsecases({
    this.onGetUsers,
    this.onGetUser,
    this.onCreateUser,
    this.onUpdateUser,
    this.onDeleteUser,
  });

  final Future<Either<BaseException, List<UserEntity>>> Function()? onGetUsers;
  final Future<Either<BaseException, UserEntity>> Function(String id)? onGetUser;
  final Future<Either<BaseException, UserEntity>> Function(UserEntity user)?
      onCreateUser;
  final Future<Either<BaseException, UserEntity>> Function(
      String id, UserEntity user)? onUpdateUser;
  final Future<Either<BaseException, UserEntity>> Function(String id)?
      onDeleteUser;

  @override
  Future<Either<BaseException, List<UserEntity>>> getUsers() => onGetUsers!();

  @override
  Future<Either<BaseException, UserEntity>> getUser(String id) =>
      onGetUser!(id);

  @override
  Future<Either<BaseException, UserEntity>> createUser(UserEntity user) =>
      onCreateUser!(user);

  @override
  Future<Either<BaseException, UserEntity>> updateUser(
          String id, UserEntity user) =>
      onUpdateUser!(id, user);

  @override
  Future<Either<BaseException, UserEntity>> deleteUser(String id) =>
      onDeleteUser!(id);
}
