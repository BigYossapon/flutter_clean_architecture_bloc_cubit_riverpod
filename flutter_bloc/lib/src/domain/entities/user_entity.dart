import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? avatar;
  final String? id;

  const UserEntity({
    this.name,
    this.avatar,
    this.id,
  });

  @override
  List<Object?> get props => [name, avatar, id];
}
