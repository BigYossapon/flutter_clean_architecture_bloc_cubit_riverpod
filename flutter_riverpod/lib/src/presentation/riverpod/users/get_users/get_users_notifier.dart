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
        if (success.isNotEmpty) {
          _usersList.clear();
          _usersList.addAll(success);
        }
        state = GetUsersSuccess(users: _usersList);
      },
    );
  }
}

final getUsersProvider = NotifierProvider<GetUsersNotifier, GetUsersState>(
  GetUsersNotifier.new,
);
