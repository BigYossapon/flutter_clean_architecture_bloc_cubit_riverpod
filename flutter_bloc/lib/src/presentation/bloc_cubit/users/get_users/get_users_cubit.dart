import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/export_entities.dart';

import '../../../../domain/usecases/export_usecases.dart';
part 'get_users_state.dart';

class GetUsersCubit extends Cubit<GetUsersState> {
  final UsersUsecases usersUseCases;

  final List<UserEntity> _usersList = [];

  GetUsersCubit({
    required this.usersUseCases,
  }) : super(const GetUsersInitial());

  Future<void> getUsers() async {
    emit(const GetUsersLoading());

    try {
      final response = await usersUseCases.getUsers();

      response.fold(
        (error) {
          emit(GetUsersFailure(message: error.toString()));
        },
        (success) {
          _usersList
            ..clear()
            ..addAll(success);

          emit(
            GetUsersSuccess(
              users: List.unmodifiable(_usersList),
            ),
          );
        },
      );
    } catch (error) {
      emit(GetUsersFailure(message: error.toString()));
    }
  }
}
