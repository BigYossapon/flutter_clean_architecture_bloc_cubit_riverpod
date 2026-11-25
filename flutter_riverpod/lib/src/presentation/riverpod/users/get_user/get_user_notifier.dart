import 'package:riverpod/riverpod.dart';
import '../../../../injector.dart';

import 'get_user_state.dart';

class GetUserNotifier extends Notifier<GetUserState> {
  @override
  GetUserState build() => const GetUserInitial();

  Future<void> getUser(String userId) async {
    state = const GetUserLoading();

    try {
      final usersUseCases = ref.read(usersUseCasesProvider);
      final response = await usersUseCases.getUser(userId);

      // provider อาจถูก dispose ระหว่าง await
      if (!ref.mounted) return;

      await response.fold(
        (error) async {
          state = GetUserFailure(message: error.toString());
        },
        (success) async {
          if (!ref.mounted) return;
          state = GetUserSuccess(user: success);
        },
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = GetUserFailure(message: error.toString());
    }
  }
}

final getUserProvider = NotifierProvider<GetUserNotifier, GetUserState>(
  GetUserNotifier.new,
);
