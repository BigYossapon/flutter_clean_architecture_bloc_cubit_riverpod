import 'package:riverpod/riverpod.dart';
import '../../../../injector.dart';

import '../../../../domain/entities/export_entities.dart';

import 'update_user_state.dart';

class UpdateUserNotifier extends Notifier<UpdateUserState> {
  @override
  UpdateUserState build() => const UpdateUserInitial();

  Future<void> updateUser(String userId, UserEntity userEntity) async {
    state = const UpdateUserLoading();

    final usersUseCases = ref.read(usersUseCasesProvider);
    final response = await usersUseCases.updateUser(userId, userEntity);

    // provider อาจถูก dispose ระหว่าง await
    if (!ref.mounted) return;

    await response.fold(
      (error) async {
        state = UpdateUserFailure(message: error.toString());
      },
      (success) async {
        if (!ref.mounted) return;
        state = UpdateUserSuccess(user: success);
      },
    );
  }
}

final updateUserProvider =
    NotifierProvider.autoDispose<UpdateUserNotifier, UpdateUserState>(
  UpdateUserNotifier.new,
);
