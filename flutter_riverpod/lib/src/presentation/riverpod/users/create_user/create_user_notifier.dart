import 'package:riverpod/riverpod.dart';
import '../../../../domain/entities/export_entities.dart';
import '../../../../injector.dart';
import 'create_user_state.dart';

class CreateUserNotifier extends Notifier<CreateUserState> {
  @override
  CreateUserState build() => const CreateUserInitial();

  Future<void> createUser(UserEntity userEntity) async {
    state = const CreateUserLoading();

    try {
      final usersUseCases = ref.read(usersUseCasesProvider);
      final response = await usersUseCases.createUser(userEntity);

      // provider อาจถูก dispose ระหว่าง await
      if (!ref.mounted) return;

      await response.fold(
        (error) async {
          state = CreateUserFailure(message: error.toString());
        },
        (success) async {
          if (!ref.mounted) return;
          state = CreateUserSuccess(user: success);
        },
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = CreateUserFailure(message: error.toString());
    }
  }
}

final createUserProvider =
    NotifierProvider.autoDispose<CreateUserNotifier, CreateUserState>(
  CreateUserNotifier.new,
);
