import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/usecases/users/user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

void main() {
  const user = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');
  const failure = NormalException(message: 'boom', statusCode: 500);

  group('UsersUsecases.getUsers', () {
    test('returns Right from repository', () async {
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onGetUsers: () async => const Right([user]),
        ),
      );

      final result = await usecases.getUsers();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [user]);
    });

    test('returns Left from repository', () async {
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onGetUsers: () async => const Left(failure),
        ),
      );

      expect(
        await usecases.getUsers(),
        const Left<BaseException, List<UserEntity>>(failure),
      );
    });
  });

  group('UsersUsecases.getUser', () {
    test('passes id and returns Right from repository', () async {
      String? receivedId;
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onGetUser: (id) async {
            receivedId = id;
            return const Right(user);
          },
        ),
      );

      expect(
        await usecases.getUser('1'),
        const Right<BaseException, UserEntity>(user),
      );
      expect(receivedId, '1');
    });

    test('returns Left from repository', () async {
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onGetUser: (_) async => const Left(failure),
        ),
      );

      expect(
        await usecases.getUser('1'),
        const Left<BaseException, UserEntity>(failure),
      );
    });
  });

  group('UsersUsecases.createUser', () {
    test('passes entity and returns Right from repository', () async {
      UserEntity? sent;
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onCreateUser: (u) async {
            sent = u;
            return Right(u);
          },
        ),
      );

      expect(
        await usecases.createUser(user),
        const Right<BaseException, UserEntity>(user),
      );
      expect(sent, user);
    });

    test('returns Left from repository', () async {
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onCreateUser: (_) async => const Left(failure),
        ),
      );

      expect(
        await usecases.createUser(user),
        const Left<BaseException, UserEntity>(failure),
      );
    });
  });

  group('UsersUsecases.updateUser', () {
    test('passes id and entity and returns Right from repository', () async {
      String? receivedId;
      UserEntity? sent;
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onUpdateUser: (id, u) async {
            receivedId = id;
            sent = u;
            return Right(u);
          },
        ),
      );

      expect(
        await usecases.updateUser('1', user),
        const Right<BaseException, UserEntity>(user),
      );
      expect(receivedId, '1');
      expect(sent, user);
    });

    test('returns Left from repository', () async {
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onUpdateUser: (_, __) async => const Left(failure),
        ),
      );

      expect(
        await usecases.updateUser('1', user),
        const Left<BaseException, UserEntity>(failure),
      );
    });
  });

  group('UsersUsecases.deleteUser', () {
    test('passes id and returns Right from repository', () async {
      String? receivedId;
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onDeleteUser: (id) async {
            receivedId = id;
            return const Right(user);
          },
        ),
      );

      expect(
        await usecases.deleteUser('1'),
        const Right<BaseException, UserEntity>(user),
      );
      expect(receivedId, '1');
    });

    test('passes id and forwards Left failure', () async {
      String? receivedId;
      final usecases = UsersUsecases(
        usersRepository: FakeUsersRepo(
          onDeleteUser: (id) async {
            receivedId = id;
            return const Left(failure);
          },
        ),
      );

      expect(
        await usecases.deleteUser('1'),
        const Left<BaseException, UserEntity>(failure),
      );
      expect(receivedId, '1');
    });
  });
}
