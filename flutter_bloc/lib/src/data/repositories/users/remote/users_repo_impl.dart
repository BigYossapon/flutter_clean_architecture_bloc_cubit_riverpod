import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';

import '../../../../core/exceptions/exception.dart';
import '../../../../core/exceptions/network/network_exception.dart';
import '../../../../domain/repositories/remote/users/users_repo.dart';
import '../../../datasources/remote/users/users_datasource.dart';
import '../../../models/remote/users/user_model.dart';

class UsersRepoImpl extends UsersRepo {
  final UsersDatasource usersDatasource;

  UsersRepoImpl({required this.usersDatasource});

  @override
  Future<Either<BaseException, List<UserEntity>>> getUsers() async {
    try {
      final users = await usersDatasource.getUsers();
      return Right(users.map((user) => user.toEntity()).toList());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
          NormalException(message: e.toString(), statusCode: 0, cause: e));
    }
  }

  @override
  Future<Either<BaseException, UserEntity>> getUser(String id) async {
    try {
      final user = await usersDatasource.getUser(id);
      return Right(user.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
          NormalException(message: e.toString(), statusCode: 0, cause: e));
    }
  }

  @override
  Future<Either<BaseException, UserEntity>> createUser(UserEntity user) async {
    try {
      UserModel userModel = UserModel(
        name: user.name,
        avatar: user.avatar,
        id: user.id,
      );
      final createdUser = await usersDatasource.createUser(userModel);
      return Right(createdUser.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
          NormalException(message: e.toString(), statusCode: 0, cause: e));
    }
  }

  @override
  Future<Either<BaseException, UserEntity>> updateUser(
      String id, UserEntity user) async {
    try {
      UserModel userModel = UserModel(
        name: user.name,
        avatar: user.avatar,
        id: user.id,
      );
      final updatedUser = await usersDatasource.updateUser(id, userModel);
      return Right(updatedUser.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
          NormalException(message: e.toString(), statusCode: 0, cause: e));
    }
  }

  @override
  Future<Either<BaseException, UserEntity>> deleteUser(String id) async {
    try {
      final deletedUser = await usersDatasource.deleteUser(id);
      return Right(deletedUser.toEntity());
    } on DioException catch (e) {
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(
          NormalException(message: e.toString(), statusCode: 0, cause: e));
    }
  }
  // Implementation of the UsersRepoImpl class
}
