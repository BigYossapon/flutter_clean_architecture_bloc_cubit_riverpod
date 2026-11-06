import 'package:dartz/dartz.dart';

import '../../../core/exceptions/exception.dart';
import '../../entities/user_entity.dart';
import '../../repositories/remote/users/users_repo.dart';

class UsersUsecases {
  final UsersRepo usersRepository;

  UsersUsecases({required this.usersRepository});

  Future<Either<BaseException, List<UserEntity>>> getUsers() async {
    return await usersRepository.getUsers();
  }

  Future<Either<BaseException, UserEntity>> getUser(String id) async {
    return await usersRepository.getUser(id);
  }

  Future<Either<BaseException, UserEntity>> createUser(UserEntity user) async {
    return await usersRepository.createUser(user);
  }

  Future<Either<BaseException, UserEntity>> updateUser(
      String id, UserEntity user) async {
    return await usersRepository.updateUser(id, user);
  }

  Future<Either<BaseException, UserEntity>> deleteUser(String id) async {
    return await usersRepository.deleteUser(id);
  }
}
