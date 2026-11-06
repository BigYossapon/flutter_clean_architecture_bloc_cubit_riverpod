part of 'get_user_bloc.dart';

abstract class GetUserEvent extends Equatable {
  const GetUserEvent();

  @override
  List<Object?> get props => [];
}

class GetUser extends GetUserEvent {
  final String userId;

  const GetUser(this.userId);

  @override
  List<Object?> get props => [userId];
}
