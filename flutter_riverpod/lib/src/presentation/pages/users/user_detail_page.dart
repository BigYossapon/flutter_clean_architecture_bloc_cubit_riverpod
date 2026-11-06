import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/export_entities.dart';

import '../../riverpod/users/delete_user/delete_user_notifier.dart';
import '../../riverpod/users/delete_user/delete_user_state.dart';
import '../../riverpod/users/get_user/get_user_notifier.dart';
import '../../riverpod/users/get_user/get_user_state.dart';
import '../../widgets/global/common_widgets.dart';

import 'user_form_page.dart';

class UserDetailPage extends ConsumerStatefulWidget {
  const UserDetailPage({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(getUserProvider.notifier).getUser(widget.userId));
  }

  Future<void> _delete(UserEntity user) async {
    if (await confirmDelete(context, user.name ?? 'ไม่พบชื่อ')) {
      ref.read(deleteUserProvider.notifier).deleteUser(user.id ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    // delete สำเร็จ -> ปิดหน้านี้ (หน้า list จะ refresh + แสดง snackbar เอง)
    ref.listen<DeleteUserState>(deleteUserProvider, (_, next) {
      if (next is DeleteUserSuccess) Navigator.pop(context);
    });

    final state = ref.watch(getUserProvider);
    final deleting = ref.watch(deleteUserProvider) is DeleteUserLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User detail'),
        actions: [
          if (state is GetUserSuccess) ...[
            IconButton(
              tooltip: 'แก้ไข',
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserFormPage(user: state.user)),
              ),
            ),
            IconButton(
              tooltip: 'ลบ',
              icon: deleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.delete_outline),
              onPressed: deleting ? null : () => _delete(state.user),
            ),
          ],
        ],
      ),
      body: switch (state) {
        GetUserInitial() ||
        GetUserLoading() =>
          const Center(child: CircularProgressIndicator()),
        GetUserFailure(:final message) => ErrorView(
            message: message,
            onRetry: () =>
                ref.read(getUserProvider.notifier).getUser(widget.userId),
          ),
        GetUserSuccess(:final user) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: UserAvatar(url: user.avatar ?? '', radius: 56)),
              const SizedBox(height: 16),
              Center(
                child: Text(user.name ?? 'ไม่พบชื่อ',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.tag),
                      title: const Text('ID'),
                      subtitle: Text(user.id ?? 'ไม่พบ ID'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text('Avatar URL'),
                      subtitle: Text(user.avatar ?? 'ไม่พบ URL รูปภาพ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
      },
    );
  }
}
