import 'package:equatable/equatable.dart';

import '../../../../domain/entities/export_entities.dart';

sealed class GetUsersState extends Equatable {
  const GetUsersState();

  @override
  List<Object> get props => [];
}

final class GetUsersInitial extends GetUsersState {
  const GetUsersInitial();
}

final class GetUsersLoading extends GetUsersState {
  const GetUsersLoading();
}

final class GetUsersSuccess extends GetUsersState {
  const GetUsersSuccess({required this.users});

  final List<UserEntity> users;

  @override
  List<Object> get props => [users];
}

final class GetUsersFailure extends GetUsersState {
  const GetUsersFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
