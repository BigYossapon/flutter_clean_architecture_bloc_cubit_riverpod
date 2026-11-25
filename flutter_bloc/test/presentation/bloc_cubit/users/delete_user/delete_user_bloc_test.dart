import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/export_entities.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/bloc_cubit/users/delete_user/delete_user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late DeleteUserBloc bloc;

  const user = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');

  tearDown(() async {
    await bloc.close();
  });

  group('DeleteUserBloc', () {
    test('initial state is DeleteUserInitial', () {
      bloc = DeleteUserBloc(
        usersUseCases: FakeUsersUsecases(
          onDeleteUser: (_) async => const Right(user),
        ),
      );

      expect(bloc.state, const DeleteUserInitial());
    });

    test('emits [Loading, Success] and passes userId on Right', () async {
      String? receivedId;
      bloc = DeleteUserBloc(
        usersUseCases: FakeUsersUsecases(
          onDeleteUser: (id) async {
            receivedId = id;
            return const Right(user);
          },
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const DeleteUserLoading(),
          const DeleteUserSuccess(user: user),
        ]),
      );

      bloc.add(const DeleteUser('1'));
      await expectation;
      expect(receivedId, '1');
    });

    test('emits [Loading, Failure] when usecase returns Left', () async {
      const error = NormalException(message: 'delete failed', statusCode: 500);
      bloc = DeleteUserBloc(
        usersUseCases: FakeUsersUsecases(
          onDeleteUser: (_) async =>
              const Left<BaseException, UserEntity>(error),
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const DeleteUserLoading(),
          DeleteUserFailure(message: error.toString()),
        ]),
      );

      bloc.add(const DeleteUser('1'));
      await expectation;
    });

    test('emits [Loading, Failure] when usecase throws', () async {
      final error = Exception('unexpected');
      bloc = DeleteUserBloc(
        usersUseCases: FakeUsersUsecases(
          onDeleteUser: (_) async => throw error,
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const DeleteUserLoading(),
          DeleteUserFailure(message: error.toString()),
        ]),
      );

      bloc.add(const DeleteUser('1'));
      await expectation;
    });

    test('event and state equality work', () {
      bloc = DeleteUserBloc(usersUseCases: FakeUsersUsecases());
      expect(const DeleteUser('1'), const DeleteUser('1'));
      expect(const DeleteUser('1'), isNot(const DeleteUser('2')));
      expect(
        const DeleteUserSuccess(user: user),
        const DeleteUserSuccess(user: user),
      );
      expect(
        const DeleteUserFailure(message: 'err'),
        const DeleteUserFailure(message: 'err'),
      );
    });
  });
}
