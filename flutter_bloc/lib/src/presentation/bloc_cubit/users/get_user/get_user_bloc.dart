import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/export_entities.dart';
import '../../../../domain/usecases/export_usecases.dart';
part 'get_user_event.dart';
part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final UsersUsecases usersUseCases;

  GetUserBloc({
    required this.usersUseCases,
  }) : super(const GetUserInitial()) {
    on<GetUser>(_onGetUser);
  }

  Future<void> _onGetUser(
    GetUser event,
    Emitter<GetUserState> emit,
  ) async {
    emit(const GetUserLoading());

    try {
      final response = await usersUseCases.getUser(event.userId);

      response.fold(
        (error) {
          emit(GetUserFailure(message: error.toString()));
        },
        (success) {
          emit(GetUserSuccess(user: success));
        },
      );
    } catch (error) {
      emit(GetUserFailure(message: error.toString()));
    }
  }
}
