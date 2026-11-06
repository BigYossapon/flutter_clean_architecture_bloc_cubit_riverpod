import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../_mapper/entity_convertable.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable
    with EntityConvertible<UserEntity, UserModel> {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "id")
  final String? id;

  UserModel({
    this.name,
    this.avatar,
    this.id,
  });

  UserModel copyWith({
    String? name,
    String? avatar,
    String? id,
  }) =>
      UserModel(
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        id: id ?? this.id,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props => [name, avatar, id];

  @override
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      avatar: avatar,
      id: id,
    );
  }

  @override
  UserModel fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      avatar: entity.avatar,
      id: entity.id,
    );
  }
}
