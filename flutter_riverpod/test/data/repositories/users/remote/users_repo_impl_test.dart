import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/network/network_exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/models/remote/users/user_model.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/repositories/users/remote/users_repo_impl.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  final userModel = UserModel(id: '1', name: 'Alice', avatar: 'a.png');
  const userEntity = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');
  final dioError = DioException(
    requestOptions: RequestOptions(path: '/users'),
    type: DioExceptionType.connectionTimeout,
  );

  void expectRight<T>(Either<BaseException, T> result, T expected) {
    result.fold(
      (error) => fail('expected Right, got $error'),
      (value) => expect(value, expected),
    );
  }

  void expectLeft<T>(Either<BaseException, T> result, Matcher matcher) {
    result.fold(
      (error) => expect(error, matcher),
      (_) => fail('expected Left'),
    );
  }

  group('getUsers', () {
    test('returns Right with mapped entities on success', () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(onGetUsers: () async => [userModel]),
      );

      expectRight<List<UserEntity>>(await repo.getUsers(), [userEntity]);
    });

    test('returns Right with empty list when datasource returns empty',
        () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(onGetUsers: () async => []),
      );

      expectRight<List<UserEntity>>(await repo.getUsers(), const []);
    });

    test('maps DioException to NetworkException', () async {
      final repo = UsersRepoImpl(
        usersDatasource:
            FakeUsersDatasource(onGetUsers: () async => throw dioError),
      );

      final result = await repo.getUsers();

      result.fold(
        (error) {
          expect(error, isA<NetworkException>());
          expect(error.message, 'Connection timeout with API server');
          expect(error.cause, dioError);
        },
        (_) => fail('expected Left'),
      );
    });

    test('maps other errors to NormalException with statusCode 0', () async {
      final stateError = StateError('bad state');
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onGetUsers: () async => throw stateError,
        ),
      );

      final result = await repo.getUsers();

      result.fold(
        (error) {
          expect(error, isA<NormalException>());
          expect(error.statusCode, 0);
          expect(error.message, contains('bad state'));
          expect(error.cause, stateError);
        },
        (_) => fail('expected Left'),
      );
    });
  });

  group('getUser', () {
    test('passes id to datasource and returns Right with entity', () async {
      String? receivedId;
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onGetUser: (id) async {
            receivedId = id;
            return userModel;
          },
        ),
      );

      expectRight<UserEntity>(await repo.getUser('1'), userEntity);
      expect(receivedId, '1');
    });

    test('maps DioException to NetworkException', () async {
      final repo = UsersRepoImpl(
        usersDatasource:
            FakeUsersDatasource(onGetUser: (_) async => throw dioError),
      );

      expectLeft(await repo.getUser('1'), isA<NetworkException>());
    });

    test('maps other errors to NormalException', () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onGetUser: (_) async => throw StateError('bad state'),
        ),
      );

      expectLeft(await repo.getUser('1'), isA<NormalException>());
    });
  });

  group('createUser', () {
    test('sends model built from entity and returns Right', () async {
      UserModel? sent;
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onCreateUser: (user) async {
            sent = user;
            return userModel;
          },
        ),
      );

      final result = await repo.createUser(userEntity);

      expect(sent, userModel);
      expectRight<UserEntity>(result, userEntity);
    });

    test('maps DioException to NetworkException', () async {
      final repo = UsersRepoImpl(
        usersDatasource:
            FakeUsersDatasource(onCreateUser: (_) async => throw dioError),
      );

      expectLeft(await repo.createUser(userEntity), isA<NetworkException>());
    });

    test('maps other errors to NormalException', () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onCreateUser: (_) async => throw StateError('bad state'),
        ),
      );

      expectLeft(await repo.createUser(userEntity), isA<NormalException>());
    });
  });

  group('updateUser', () {
    test('passes id and model to datasource and returns Right', () async {
      String? receivedId;
      UserModel? sent;
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onUpdateUser: (id, user) async {
            receivedId = id;
            sent = user;
            return userModel;
          },
        ),
      );

      final result = await repo.updateUser('1', userEntity);

      expect(receivedId, '1');
      expect(sent, userModel);
      expectRight<UserEntity>(result, userEntity);
    });

    test('maps DioException to NetworkException', () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onUpdateUser: (_, __) async => throw dioError,
        ),
      );

      expectLeft(
        await repo.updateUser('1', userEntity),
        isA<NetworkException>(),
      );
    });

    test('maps other errors to NormalException', () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onUpdateUser: (_, __) async => throw StateError('bad state'),
        ),
      );

      expectLeft(
        await repo.updateUser('1', userEntity),
        isA<NormalException>(),
      );
    });
  });

  group('deleteUser', () {
    test('passes id to datasource and returns Right', () async {
      String? receivedId;
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onDeleteUser: (id) async {
            receivedId = id;
            return userModel;
          },
        ),
      );

      expectRight<UserEntity>(await repo.deleteUser('1'), userEntity);
      expect(receivedId, '1');
    });

    test('maps DioException to NetworkException', () async {
      final repo = UsersRepoImpl(
        usersDatasource:
            FakeUsersDatasource(onDeleteUser: (_) async => throw dioError),
      );

      expectLeft(await repo.deleteUser('1'), isA<NetworkException>());
    });

    test('maps other errors to NormalException', () async {
      final repo = UsersRepoImpl(
        usersDatasource: FakeUsersDatasource(
          onDeleteUser: (_) async => throw StateError('bad state'),
        ),
      );

      expectLeft(await repo.deleteUser('1'), isA<NormalException>());
    });
  });
}
