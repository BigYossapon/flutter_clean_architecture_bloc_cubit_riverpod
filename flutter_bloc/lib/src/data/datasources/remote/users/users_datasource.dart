import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/network/dio_client.dart';

import '../../../models/remote/users/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
part 'users_datasource.g.dart';

@RestApi(parser: Parser.FlutterCompute)
abstract class UsersDatasource {
  factory UsersDatasource(Dio dio, {String baseUrl}) = _UsersDatasource;

  @GET('/users')
  Future<List<UserModel>> getUsers();

  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);

  @POST('/users')
  Future<UserModel> createUser(@Body() UserModel user);

  @PUT('/users/{id}')
  Future<UserModel> updateUser(@Path('id') String id, @Body() UserModel user);

  @DELETE('/users/{id}')
  Future<UserModel> deleteUser(@Path('id') String id);
}

abstract class UsersExDatasource {
  Future<List<UserModel>> getUsers();
}
