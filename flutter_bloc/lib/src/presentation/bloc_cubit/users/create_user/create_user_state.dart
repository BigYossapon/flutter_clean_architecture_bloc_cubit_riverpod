part of 'create_user_bloc.dart';

sealed class CreateUserState extends Equatable {
  const CreateUserState();

  @override
  List<Object> get props => [];
}

final class CreateUserInitial extends CreateUserState {
  const CreateUserInitial();
}

final class CreateUserLoading extends CreateUserState {
  const CreateUserLoading();
}

final class CreateUserSuccess extends CreateUserState {
  const CreateUserSuccess({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class CreateUserFailure extends CreateUserState {
  const CreateUserFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
