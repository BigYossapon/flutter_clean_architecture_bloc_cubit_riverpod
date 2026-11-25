import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/models/network_error_model.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/models/remote/users/user_model.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    final json = {
      'id': '1',
      'name': 'Alice',
      'avatar': 'https://example.com/a.png',
    };

    test('fromJson and toJson round-trip cleanly', () {
      final model = UserModel.fromJson(json);

      expect(model.id, '1');
      expect(model.name, 'Alice');
      expect(model.avatar, 'https://example.com/a.png');
      expect(model.toJson(), json);
    });

    test('handles null fields in json', () {
      final model = UserModel.fromJson(const {});

      expect(model.id, isNull);
      expect(model.name, isNull);
      expect(model.avatar, isNull);
    });

    test('copyWith updates only specified fields', () {
      final original = UserModel(id: '1', name: 'Alice', avatar: 'a.png');
      final updated = original.copyWith(name: 'Bob');

      expect(updated.id, '1');
      expect(updated.name, 'Bob');
      expect(updated.avatar, 'a.png');
      expect(updated, isNot(equals(original)));
    });

    test('toEntity and fromEntity map all fields', () {
      final model = UserModel(id: '1', name: 'Alice', avatar: 'a.png');
      const entity = UserEntity(id: '1', name: 'Alice', avatar: 'a.png');

      expect(model.toEntity(), entity);
      expect(UserModel().fromEntity(entity), model);
    });

    test('supports value equality via Equatable', () {
      final a = UserModel(id: '1', name: 'Alice', avatar: 'a.png');
      final b = UserModel(id: '1', name: 'Alice', avatar: 'a.png');
      final c = UserModel(id: '2', name: 'Bob', avatar: 'b.png');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  group('NetworkErrorModel', () {
    test('fromJson, toJson, and Equatable equality work', () {
      const json = {'status_code': 401, 'status_message': 'Unauthorized'};
      final model = NetworkErrorModel.fromJson(json);

      expect(
        model,
        const NetworkErrorModel(statusCode: 401, statusMessage: 'Unauthorized'),
      );
      expect(model.toJson(), json);
    });
  });
}
