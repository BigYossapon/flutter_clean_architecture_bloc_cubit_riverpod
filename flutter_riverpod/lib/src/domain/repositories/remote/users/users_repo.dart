import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/exception.dart';

import '../../../entities/user_entity.dart';

abstract class UsersRepo {
  Future<Either<BaseException, List<UserEntity>>> getUsers();
  Future<Either<BaseException, UserEntity>> getUser(String id);
  Future<Either<BaseException, UserEntity>> createUser(UserEntity user);
  Future<Either<BaseException, UserEntity>> updateUser(
      String id, UserEntity user);
  Future<Either<BaseException, UserEntity>> deleteUser(String id);
}
