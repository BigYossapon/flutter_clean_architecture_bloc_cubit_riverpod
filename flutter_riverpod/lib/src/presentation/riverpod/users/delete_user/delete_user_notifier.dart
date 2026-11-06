import 'package:riverpod/riverpod.dart';
import '../../../../injector.dart';
import 'delete_user_state.dart';

class DeleteUserNotifier extends Notifier<DeleteUserState> {
  @override
  DeleteUserState build() => const DeleteUserInitial();

  Future<void> deleteUser(String userId) async {
    state = const DeleteUserLoading();

    final usersUseCases = ref.read(usersUseCasesProvider);
    final response = await usersUseCases.deleteUser(userId);

    // provider อาจถูก dispose ระหว่าง await
    if (!ref.mounted) return;

    await response.fold(
      (error) async {
        state = DeleteUserFailure(message: error.toString());
      },
      (success) async {
        if (!ref.mounted) return;
        state = DeleteUserSuccess(user: success);
      },
    );
  }
}

final deleteUserProvider =
    NotifierProvider<DeleteUserNotifier, DeleteUserState>(
  DeleteUserNotifier.new,
);
