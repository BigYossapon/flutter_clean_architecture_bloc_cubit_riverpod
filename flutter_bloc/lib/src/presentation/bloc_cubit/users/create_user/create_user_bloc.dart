import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';

part 'create_user_event.dart';
part 'create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  CreateUserBloc({
    required this.usersUseCases,
  }) : super(const CreateUserInitial()) {
    on<CreateUser>(_onCreateUser);
  }

  final UsersUsecases usersUseCases;

  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<CreateUserState> emit,
  ) async {
    emit(const CreateUserLoading());

    try {
      final response = await usersUseCases.createUser(
        event.userEntity,
      );

      response.fold(
        (error) {
          emit(
            CreateUserFailure(
              message: error.toString(),
            ),
          );
        },
        (success) {
          emit(
            CreateUserSuccess(
              user: success,
            ),
          );
        },
      );
    } catch (error) {
      emit(
        CreateUserFailure(
          message: error.toString(),
        ),
      );
    }
  }
}
