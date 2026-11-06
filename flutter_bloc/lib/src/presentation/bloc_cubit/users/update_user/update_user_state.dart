part of 'update_user_cubit.dart';

sealed class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object> get props => [];
}

final class UpdateUserInitial extends UpdateUserState {
  const UpdateUserInitial();
}

final class UpdateUserLoading extends UpdateUserState {
  const UpdateUserLoading();
}

final class UpdateUserSuccess extends UpdateUserState {
  const UpdateUserSuccess({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class UpdateUserFailure extends UpdateUserState {
  const UpdateUserFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
