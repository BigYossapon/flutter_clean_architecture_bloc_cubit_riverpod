import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/export_entities.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/bloc_cubit/users/get_user/get_user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

void main() {
  late GetUserBloc bloc;

  const user = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');

  tearDown(() async {
    await bloc.close();
  });

  group('GetUserBloc', () {
    test('initial state is GetUserInitial', () {
      bloc = GetUserBloc(
        usersUseCases: FakeUsersUsecases(
          onGetUser: (_) async => const Right(user),
        ),
      );

      expect(bloc.state, const GetUserInitial());
    });

    test('emits [Loading, Success] and passes userId when usecase returns Right',
        () async {
      String? receivedId;
      bloc = GetUserBloc(
        usersUseCases: FakeUsersUsecases(
          onGetUser: (id) async {
            receivedId = id;
            return const Right(user);
          },
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const GetUserLoading(),
          const GetUserSuccess(user: user),
        ]),
      );

      bloc.add(const GetUser('1'));
      await expectation;
      expect(receivedId, '1');
    });

    test('emits [Loading, Failure] when usecase returns Left', () async {
      const error = NormalException(message: 'not found', statusCode: 404);
      bloc = GetUserBloc(
        usersUseCases: FakeUsersUsecases(
          onGetUser: (_) async => const Left<BaseException, UserEntity>(error),
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const GetUserLoading(),
          GetUserFailure(message: error.toString()),
        ]),
      );

      bloc.add(const GetUser('1'));
      await expectation;
    });

    test('emits [Loading, Failure] when usecase throws', () async {
      final error = Exception('unexpected');
      bloc = GetUserBloc(
        usersUseCases: FakeUsersUsecases(
          onGetUser: (_) async => throw error,
        ),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          const GetUserLoading(),
          GetUserFailure(message: error.toString()),
        ]),
      );

      bloc.add(const GetUser('1'));
      await expectation;
    });

    test('event and state equality work', () {
      bloc = GetUserBloc(usersUseCases: FakeUsersUsecases());
      expect(const GetUser('1'), const GetUser('1'));
      expect(const GetUser('1'), isNot(const GetUser('2')));
      expect(const GetUserSuccess(user: user), const GetUserSuccess(user: user));
      expect(
        const GetUserFailure(message: 'err'),
        const GetUserFailure(message: 'err'),
      );
    });
  });
}
