import 'package:equatable/equatable.dart';

import '../../../../domain/entities/export_entities.dart';

sealed class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object> get props => [];
}

final class DeleteUserInitial extends DeleteUserState {
  const DeleteUserInitial();
}

final class DeleteUserLoading extends DeleteUserState {
  const DeleteUserLoading();
}

final class DeleteUserSuccess extends DeleteUserState {
  const DeleteUserSuccess({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class DeleteUserFailure extends DeleteUserState {
  const DeleteUserFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
