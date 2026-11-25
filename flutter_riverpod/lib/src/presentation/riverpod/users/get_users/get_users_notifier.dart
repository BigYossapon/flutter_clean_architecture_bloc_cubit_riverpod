import 'package:riverpod/riverpod.dart';
import '../../../../injector.dart';
import '../../../../domain/entities/export_entities.dart';
import 'get_users_state.dart';

class GetUsersNotifier extends Notifier<GetUsersState> {
  @override
  GetUsersState build() => const GetUsersInitial();
  final List<UserEntity> _usersList = [];
  Future<void> getUsers() async {
    state = const GetUsersLoading();

    try {
      final usersUseCases = ref.read(usersUseCasesProvider);
      final response = await usersUseCases.getUsers();

      // provider อาจถูก dispose ระหว่าง await
      if (!ref.mounted) return;

      await response.fold(
        (error) async {
          state = GetUsersFailure(message: error.toString());
        },
        (success) async {
          if (!ref.mounted) return;
          _usersList
            ..clear()
            ..addAll(success);
          state = GetUsersSuccess(users: List.unmodifiable(_usersList));
        },
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = GetUsersFailure(message: error.toString());
    }
  }
}

final getUsersProvider = NotifierProvider<GetUsersNotifier, GetUsersState>(
  GetUsersNotifier.new,
);
