import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/usecases/users/user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

void main() {
  const userEntity = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');
  const error = NormalException(message: 'boom', statusCode: 500);

  group('UsersUsecases.getUsers', () {
    test('returns Right from repository', () async {
      const expected = Right<BaseException, List<UserEntity>>([userEntity]);
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(onGetUsers: () async => expected),
      );

      expect(await usecase.getUsers(), expected);
    });

    test('returns Left from repository', () async {
      const expected = Left<BaseException, List<UserEntity>>(error);
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(onGetUsers: () async => expected),
      );

      expect(await usecase.getUsers(), expected);
    });
  });

  group('UsersUsecases.getUser', () {
    test('passes id and returns Right from repository', () async {
      String? receivedId;
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onGetUser: (id) async {
            receivedId = id;
            return const Right(userEntity);
          },
        ),
      );

      final result = await usecase.getUser('1');

      expect(receivedId, '1');
      expect(result, const Right<BaseException, UserEntity>(userEntity));
    });

    test('returns Left from repository', () async {
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onGetUser: (_) async => const Left(error),
        ),
      );

      expect(
        await usecase.getUser('1'),
        const Left<BaseException, UserEntity>(error),
      );
    });
  });

  group('UsersUsecases.createUser', () {
    test('passes entity and returns Right from repository', () async {
      UserEntity? received;
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onCreateUser: (user) async {
            received = user;
            return Right(user);
          },
        ),
      );

      final result = await usecase.createUser(userEntity);

      expect(received, userEntity);
      expect(result, const Right<BaseException, UserEntity>(userEntity));
    });

    test('passes entity and returns Left from repository', () async {
      UserEntity? received;
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onCreateUser: (user) async {
            received = user;
            return const Left(error);
          },
        ),
      );

      final result = await usecase.createUser(userEntity);

      expect(received, userEntity);
      expect(result, const Left<BaseException, UserEntity>(error));
    });
  });

  group('UsersUsecases.updateUser', () {
    test('passes id and entity and returns Right from repository', () async {
      String? receivedId;
      UserEntity? received;
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onUpdateUser: (id, user) async {
            receivedId = id;
            received = user;
            return Right(user);
          },
        ),
      );

      final result = await usecase.updateUser('1', userEntity);

      expect(receivedId, '1');
      expect(received, userEntity);
      expect(result, const Right<BaseException, UserEntity>(userEntity));
    });

    test('returns Left from repository', () async {
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onUpdateUser: (_, __) async => const Left(error),
        ),
      );

      expect(
        await usecase.updateUser('1', userEntity),
        const Left<BaseException, UserEntity>(error),
      );
    });
  });

  group('UsersUsecases.deleteUser', () {
    test('passes id and returns Right from repository', () async {
      String? receivedId;
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onDeleteUser: (id) async {
            receivedId = id;
            return const Right(userEntity);
          },
        ),
      );

      final result = await usecase.deleteUser('1');

      expect(receivedId, '1');
      expect(result, const Right<BaseException, UserEntity>(userEntity));
    });

    test('passes id and returns Left from repository', () async {
      String? receivedId;
      final usecase = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onDeleteUser: (id) async {
            receivedId = id;
            return const Left(error);
          },
        ),
      );

      final result = await usecase.deleteUser('1');

      expect(receivedId, '1');
      expect(result, const Left<BaseException, UserEntity>(error));
    });
  });
}
