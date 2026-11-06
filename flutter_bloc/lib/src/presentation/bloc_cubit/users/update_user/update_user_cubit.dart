import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';

part 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  final UsersUsecases usersUseCases;

  UpdateUserCubit({
    required this.usersUseCases,
  }) : super(const UpdateUserInitial());

  Future<void> updateUser(
    String userId,
    UserEntity userEntity,
  ) async {
    emit(const UpdateUserLoading());

    try {
      final response = await usersUseCases.updateUser(
        userId,
        userEntity,
      );

      response.fold(
        (error) {
          emit(
            UpdateUserFailure(
              message: error.toString(),
            ),
          );
        },
        (success) {
          emit(
            UpdateUserSuccess(
              user: success,
            ),
          );
        },
      );
    } catch (error) {
      emit(
        UpdateUserFailure(
          message: error.toString(),
        ),
      );
    }
  }
}
