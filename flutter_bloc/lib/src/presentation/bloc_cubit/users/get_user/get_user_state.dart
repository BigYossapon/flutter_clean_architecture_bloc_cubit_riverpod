part of 'get_user_bloc.dart';

sealed class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<Object> get props => [];
}

final class GetUserInitial extends GetUserState {
  const GetUserInitial();
}

final class GetUserLoading extends GetUserState {
  const GetUserLoading();
}

final class GetUserSuccess extends GetUserState {
  const GetUserSuccess({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class GetUserFailure extends GetUserState {
  const GetUserFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
