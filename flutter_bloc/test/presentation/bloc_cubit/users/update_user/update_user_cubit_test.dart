import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/export_entities.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/bloc_cubit/users/update_user/update_user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late UpdateUserCubit cubit;

  const user = UserEntity(id: '1', name: 'Alice Updated', avatar: 'a.png');

  tearDown(() async {
    await cubit.close();
  });

  group('UpdateUserCubit', () {
    test('initial state is UpdateUserInitial', () {
      cubit = UpdateUserCubit(
        usersUseCases: FakeUsersUsecases(
          onUpdateUser: (_, __) async => const Right(user),
        ),
      );

      expect(cubit.state, const UpdateUserInitial());
    });

    test('emits [Loading, Success] and passes id and entity on Right',
        () async {
      String? receivedId;
      UserEntity? receivedUser;
      cubit = UpdateUserCubit(
        usersUseCases: FakeUsersUsecases(
          onUpdateUser: (id, u) async {
            receivedId = id;
            receivedUser = u;
            return Right(u);
          },
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const UpdateUserLoading(),
          const UpdateUserSuccess(user: user),
        ]),
      );

      await cubit.updateUser('1', user);
      await expectation;
      expect(receivedId, '1');
      expect(receivedUser, user);
    });

    test('emits [Loading, Failure] when usecase returns Left', () async {
      const error = NormalException(message: 'update failed', statusCode: 500);
      cubit = UpdateUserCubit(
        usersUseCases: FakeUsersUsecases(
          onUpdateUser: (_, __) async =>
              const Left<BaseException, UserEntity>(error),
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const UpdateUserLoading(),
          UpdateUserFailure(message: error.toString()),
        ]),
      );

      await cubit.updateUser('1', user);
      await expectation;
    });

    test('emits [Loading, Failure] when usecase throws', () async {
      final error = Exception('unexpected');
      cubit = UpdateUserCubit(
        usersUseCases: FakeUsersUsecases(
          onUpdateUser: (_, __) async => throw error,
        ),
      );

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const UpdateUserLoading(),
          UpdateUserFailure(message: error.toString()),
        ]),
      );

      await cubit.updateUser('1', user);
      await expectation;
    });

    test('state equality works', () {
      cubit = UpdateUserCubit(usersUseCases: FakeUsersUsecases());
      expect(
        const UpdateUserSuccess(user: user),
        const UpdateUserSuccess(user: user),
      );
      expect(
        const UpdateUserFailure(message: 'err'),
        const UpdateUserFailure(message: 'err'),
      );
    });
  });
}
