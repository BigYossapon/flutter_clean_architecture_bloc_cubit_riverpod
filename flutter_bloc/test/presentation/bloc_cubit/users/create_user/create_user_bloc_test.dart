import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/export_entities.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/bloc_cubit/users/create_user/create_user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late CreateUserBloc bloc;

  const user = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');

  tearDown(() async {
    await bloc.close();
  });

  group('CreateUserBloc', () {
    test('initial state is CreateUserInitial', () {
      bloc = CreateUserBloc(
        usersUseCases: FakeUsersUsecases(
          onCreateUser: (_) async => const Right(user),
        ),
      );

      expect(bloc.state, const CreateUserInitial());
    });

    test('emits [Loading, Success] and passes entity when usecase returns Right',
        () async {
      UserEntity? receivedUser;
      bloc = CreateUserBloc(
        usersUseCases: FakeUsersUsecases(
          onCreateUser: (u) async {
            receivedUser = u;
            return Right(u);
          },
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const CreateUserLoading(),
          const CreateUserSuccess(user: user),
        ]),
      );

      bloc.add(const CreateUser(user));
      await expectation;
      expect(receivedUser, user);
    });

    test('emits [Loading, Failure] when usecase returns Left', () async {
      const error = NormalException(message: 'validation failed', statusCode: 400);
      bloc = CreateUserBloc(
        usersUseCases: FakeUsersUsecases(
          onCreateUser: (_) async => const Left<BaseException, UserEntity>(error),
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const CreateUserLoading(),
          CreateUserFailure(message: error.toString()),
        ]),
      );

      bloc.add(const CreateUser(user));
      await expectation;
    });

    test('emits [Loading, Failure] when usecase throws', () async {
      final error = Exception('unexpected');
      bloc = CreateUserBloc(
        usersUseCases: FakeUsersUsecases(
          onCreateUser: (_) async => throw error,
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const CreateUserLoading(),
          CreateUserFailure(message: error.toString()),
        ]),
      );

      bloc.add(const CreateUser(user));
      await expectation;
    });

    test('event and state equality work', () {
      bloc = CreateUserBloc(usersUseCases: FakeUsersUsecases());
      expect(const CreateUser(user), const CreateUser(user));
      expect(
        const CreateUserSuccess(user: user),
        const CreateUserSuccess(user: user),
      );
      expect(
        const CreateUserFailure(message: 'err'),
        const CreateUserFailure(message: 'err'),
      );
    });
  });
}
