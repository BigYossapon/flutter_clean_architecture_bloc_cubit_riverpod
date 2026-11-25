import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/usecases/users/user_usecase.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/injector.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/create_user/create_user_notifier.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/create_user/create_user_state.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/delete_user/delete_user_notifier.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/delete_user/delete_user_state.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/get_user/get_user_notifier.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/get_user/get_user_state.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/get_users/get_users_notifier.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/get_users/get_users_state.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/update_user/update_user_notifier.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/riverpod/users/update_user/update_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

ProviderContainer _container(FakeUsersRepo repo, {bool autoDispose = true}) {
  final container = ProviderContainer(
    overrides: [
      usersUseCasesProvider.overrideWithValue(
        UsersUsecases(usersRepository: repo),
      ),
    ],
  );
  if (autoDispose) {
    addTearDown(container.dispose);
  }
  return container;
}

void main() {
  const user = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');
  const failure = NormalException(message: 'boom', statusCode: 500);

  group('GetUsersNotifier', () {
    test('starts in GetUsersInitial', () {
      final container = _container(FakeUsersRepo());
      expect(container.read(getUsersProvider), const GetUsersInitial());
    });

    test('transitions [Loading, Success] with fetched users', () async {
      final container = _container(
        FakeUsersRepo(onGetUsers: () async => const Right([user])),
      );
      final states = <GetUsersState>[];
      container.listen(getUsersProvider, (_, next) => states.add(next));

      await container.read(getUsersProvider.notifier).getUsers();

      expect(states, [
        const GetUsersLoading(),
        const GetUsersSuccess(users: [user]),
      ]);
    });

    test('clears previous users when subsequent getUsers returns empty list',
        () async {
      var callCount = 0;
      final container = _container(
        FakeUsersRepo(
          onGetUsers: () async {
            callCount++;
            return callCount == 1 ? const Right([user]) : const Right([]);
          },
        ),
      );

      await container.read(getUsersProvider.notifier).getUsers();
      expect(
        container.read(getUsersProvider),
        const GetUsersSuccess(users: [user]),
      );

      await container.read(getUsersProvider.notifier).getUsers();
      expect(
        container.read(getUsersProvider),
        const GetUsersSuccess(users: []),
      );
    });

    test('transitions [Loading, Failure] on Left', () async {
      final container = _container(
        FakeUsersRepo(onGetUsers: () async => const Left(failure)),
      );
      final states = <GetUsersState>[];
      container.listen(getUsersProvider, (_, next) => states.add(next));

      await container.read(getUsersProvider.notifier).getUsers();

      expect(states, [
        const GetUsersLoading(),
        GetUsersFailure(message: failure.toString()),
      ]);
    });

    test('transitions [Loading, Failure] when usecase throws', () async {
      final thrown = Exception('unexpected');
      final container = _container(
        FakeUsersRepo(onGetUsers: () async => throw thrown),
      );
      final states = <GetUsersState>[];
      container.listen(getUsersProvider, (_, next) => states.add(next));

      await container.read(getUsersProvider.notifier).getUsers();

      expect(states, [
        const GetUsersLoading(),
        GetUsersFailure(message: thrown.toString()),
      ]);
    });

    test('ignores response safely if container is disposed mid-flight',
        () async {
      final completer = Completer<Either<BaseException, List<UserEntity>>>();
      final container = _container(
        FakeUsersRepo(onGetUsers: () => completer.future),
        autoDispose: false,
      );

      final future = container.read(getUsersProvider.notifier).getUsers();
      container.dispose();
      completer.complete(const Right([user]));

      await expectLater(future, completes);
    });
  });

  group('GetUserNotifier', () {
    test('transitions [Loading, Success] and passes id', () async {
      String? receivedId;
      final container = _container(
        FakeUsersRepo(
          onGetUser: (id) async {
            receivedId = id;
            return const Right(user);
          },
        ),
      );
      final states = <GetUserState>[];
      container.listen(getUserProvider, (_, next) => states.add(next));

      await container.read(getUserProvider.notifier).getUser('1');

      expect(receivedId, '1');
      expect(states, [
        const GetUserLoading(),
        const GetUserSuccess(user: user),
      ]);
    });

    test('transitions [Loading, Failure] on Left', () async {
      final container = _container(
        FakeUsersRepo(onGetUser: (_) async => const Left(failure)),
      );
      final states = <GetUserState>[];
      container.listen(getUserProvider, (_, next) => states.add(next));

      await container.read(getUserProvider.notifier).getUser('1');

      expect(states, [
        const GetUserLoading(),
        GetUserFailure(message: failure.toString()),
      ]);
    });

    test('transitions [Loading, Failure] on throw', () async {
      final thrown = Exception('unexpected');
      final container = _container(
        FakeUsersRepo(onGetUser: (_) async => throw thrown),
      );

      await container.read(getUserProvider.notifier).getUser('1');

      expect(
        container.read(getUserProvider),
        GetUserFailure(message: thrown.toString()),
      );
    });
  });

  group('CreateUserNotifier', () {
    test('transitions [Loading, Success] with created user', () async {
      final container = _container(
        FakeUsersRepo(onCreateUser: (u) async => Right(u)),
      );
      final states = <CreateUserState>[];
      container.listen(createUserProvider, (_, next) => states.add(next));

      await container.read(createUserProvider.notifier).createUser(user);

      expect(states, [
        const CreateUserLoading(),
        const CreateUserSuccess(user: user),
      ]);
    });

    test('transitions [Loading, Failure] on Left', () async {
      final container = _container(
        FakeUsersRepo(onCreateUser: (_) async => const Left(failure)),
      );
      final states = <CreateUserState>[];
      container.listen(createUserProvider, (_, next) => states.add(next));

      await container.read(createUserProvider.notifier).createUser(user);

      expect(states, [
        const CreateUserLoading(),
        CreateUserFailure(message: failure.toString()),
      ]);
    });

    test('transitions [Loading, Failure] on throw', () async {
      final thrown = Exception('unexpected');
      final container = _container(
        FakeUsersRepo(onCreateUser: (_) async => throw thrown),
      );
      final states = <CreateUserState>[];
      container.listen(createUserProvider, (_, next) => states.add(next));

      await container.read(createUserProvider.notifier).createUser(user);

      expect(states, [
        const CreateUserLoading(),
        CreateUserFailure(message: thrown.toString()),
      ]);
    });
  });

  group('UpdateUserNotifier', () {
    test('transitions [Loading, Success] and passes id', () async {
      String? receivedId;
      final container = _container(
        FakeUsersRepo(
          onUpdateUser: (id, u) async {
            receivedId = id;
            return Right(u);
          },
        ),
      );
      final states = <UpdateUserState>[];
      container.listen(updateUserProvider, (_, next) => states.add(next));

      await container.read(updateUserProvider.notifier).updateUser('1', user);

      expect(receivedId, '1');
      expect(states, [
        const UpdateUserLoading(),
        const UpdateUserSuccess(user: user),
      ]);
    });

    test('transitions [Loading, Failure] on Left', () async {
      final container = _container(
        FakeUsersRepo(onUpdateUser: (_, __) async => const Left(failure)),
      );
      final states = <UpdateUserState>[];
      container.listen(updateUserProvider, (_, next) => states.add(next));

      await container.read(updateUserProvider.notifier).updateUser('1', user);

      expect(states, [
        const UpdateUserLoading(),
        UpdateUserFailure(message: failure.toString()),
      ]);
    });

    test('transitions [Loading, Failure] on throw', () async {
      final thrown = Exception('unexpected');
      final container = _container(
        FakeUsersRepo(onUpdateUser: (_, __) async => throw thrown),
      );
      final states = <UpdateUserState>[];
      container.listen(updateUserProvider, (_, next) => states.add(next));

      await container.read(updateUserProvider.notifier).updateUser('1', user);

      expect(states, [
        const UpdateUserLoading(),
        UpdateUserFailure(message: thrown.toString()),
      ]);
    });
  });

  group('DeleteUserNotifier', () {
    test('transitions [Loading, Success] and passes id', () async {
      String? receivedId;
      final container = _container(
        FakeUsersRepo(
          onDeleteUser: (id) async {
            receivedId = id;
            return const Right(user);
          },
        ),
      );
      final states = <DeleteUserState>[];
      container.listen(deleteUserProvider, (_, next) => states.add(next));

      await container.read(deleteUserProvider.notifier).deleteUser('1');

      expect(receivedId, '1');
      expect(states, [
        const DeleteUserLoading(),
        const DeleteUserSuccess(user: user),
      ]);
    });

    test('transitions [Loading, Failure] on Left', () async {
      final container = _container(
        FakeUsersRepo(onDeleteUser: (_) async => const Left(failure)),
      );
      final states = <DeleteUserState>[];
      container.listen(deleteUserProvider, (_, next) => states.add(next));

      await container.read(deleteUserProvider.notifier).deleteUser('1');

      expect(states, [
        const DeleteUserLoading(),
        DeleteUserFailure(message: failure.toString()),
      ]);
    });

    test('transitions [Loading, Failure] on throw', () async {
      final thrown = Exception('unexpected');
      final container = _container(
        FakeUsersRepo(onDeleteUser: (_) async => throw thrown),
      );

      await container.read(deleteUserProvider.notifier).deleteUser('1');

      expect(
        container.read(deleteUserProvider),
        DeleteUserFailure(message: thrown.toString()),
      );
    });
  });
}
