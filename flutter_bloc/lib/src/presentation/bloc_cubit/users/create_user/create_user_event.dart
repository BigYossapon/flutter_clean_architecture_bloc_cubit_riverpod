part of 'create_user_bloc.dart';

abstract class CreateUserEvent extends Equatable {
  const CreateUserEvent();

  @override
  List<Object?> get props => [];
}

class CreateUser extends CreateUserEvent {
  final UserEntity userEntity;

  const CreateUser(this.userEntity);

  @override
  List<Object?> get props => [userEntity];
}
