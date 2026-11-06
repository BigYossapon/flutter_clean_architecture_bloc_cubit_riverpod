import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';
part 'delete_user_event.dart';
part 'delete_user_state.dart';

class DeleteUserBloc extends Bloc<DeleteUserEvent, DeleteUserState> {
  final UsersUsecases usersUseCases;

  DeleteUserBloc({
    required this.usersUseCases,
  }) : super(const DeleteUserInitial()) {
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<DeleteUserState> emit,
  ) async {
    emit(const DeleteUserLoading());

    try {
      final response = await usersUseCases.deleteUser(event.userId);

      response.fold(
        (error) {
          emit(DeleteUserFailure(message: error.toString()));
        },
        (success) {
          emit(DeleteUserSuccess(user: success));
        },
      );
    } catch (error) {
      emit(DeleteUserFailure(message: error.toString()));
    }
  }
}
