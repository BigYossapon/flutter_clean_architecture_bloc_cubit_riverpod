import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/export_entities.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/bloc_cubit/users/get_users/get_users_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late GetUsersCubit cubit;

  const users = [
    UserEntity(id: '1', name: 'Alice', avatar: 'a.png'),
    UserEntity(id: '2', name: 'Bob', avatar: 'b.png'),
  ];

  tearDown(() async {
    await cubit.close();
  });

  group('GetUsersCubit', () {
    test('initial state is GetUsersInitial', () {
      cubit = GetUsersCubit(
        usersUseCases: FakeUsersUsecases(
          onGetUsers: () async => const Right(users),
        ),
      );

      expect(cubit.state, const GetUsersInitial());
    });

    test('emits [Loading, Success] when usecase returns Right', () async {
      cubit = GetUsersCubit(
        usersUseCases: FakeUsersUsecases(
          onGetUsers: () async => const Right(users),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const GetUsersLoading(),
          const GetUsersSuccess(users: users),
        ]),
      );

      await cubit.getUsers();
      await expectation;
    });

    test('clears previous users when subsequent getUsers returns empty list',
        () async {
      var callCount = 0;
      cubit = GetUsersCubit(
        usersUseCases: FakeUsersUsecases(
          onGetUsers: () async {
            callCount++;
            return callCount == 1 ? const Right(users) : const Right([]);
          },
        ),
      );

      await cubit.getUsers();
      expect(cubit.state, const GetUsersSuccess(users: users));

      await cubit.getUsers();
      expect(cubit.state, const GetUsersSuccess(users: []));
    });

    test('emits [Loading, Failure] when usecase returns Left', () async {
      const error = NormalException(message: 'boom', statusCode: 500);
      cubit = GetUsersCubit(
        usersUseCases: FakeUsersUsecases(
          onGetUsers: () async =>
              const Left<BaseException, List<UserEntity>>(error),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const GetUsersLoading(),
          GetUsersFailure(message: error.toString()),
        ]),
      );

      await cubit.getUsers();
      await expectation;
    });

    test('emits [Loading, Failure] when usecase throws', () async {
      final error = Exception('unexpected');
      cubit = GetUsersCubit(
        usersUseCases: FakeUsersUsecases(
          onGetUsers: () async => throw error,
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const GetUsersLoading(),
          GetUsersFailure(message: error.toString()),
        ]),
      );

      await cubit.getUsers();
      await expectation;
    });

    test('state equality works for Success and Failure', () {
      expect(
        const GetUsersSuccess(users: users),
        const GetUsersSuccess(users: users),
      );
      expect(
        const GetUsersFailure(message: 'x'),
        const GetUsersFailure(message: 'x'),
      );
      expect(
        const GetUsersFailure(message: 'x'),
        isNot(const GetUsersFailure(message: 'y')),
      );
    });
  });
}
