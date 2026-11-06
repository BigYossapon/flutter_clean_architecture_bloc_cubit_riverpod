part of 'delete_user_bloc.dart';

abstract class DeleteUserEvent extends Equatable {
  const DeleteUserEvent();

  @override
  List<Object?> get props => [];
}

class DeleteUser extends DeleteUserEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}
