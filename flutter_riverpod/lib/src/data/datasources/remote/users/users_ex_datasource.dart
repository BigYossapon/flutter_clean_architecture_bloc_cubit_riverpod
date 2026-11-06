import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/network/dio_client.dart';

import '../../../../../flavors.dart';
import '../../../models/export_models.dart';
import '../../export_datasources.dart';

class UsersExDatasourceImpl implements UsersExDatasource {
  final DioClient _dioClient;

  const UsersExDatasourceImpl(this._dioClient);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _dioClient.get("${F.baseUrl}/users");

      final model = UserModel.fromJson(response.data as Map<String, dynamic>);

      return [model];
    } catch (_) {
      rethrow;
    }
  }
}
