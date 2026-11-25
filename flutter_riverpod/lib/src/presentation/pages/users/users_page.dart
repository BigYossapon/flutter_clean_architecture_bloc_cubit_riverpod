import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../riverpod/users/delete_user/delete_user_notifier.dart';
import '../../riverpod/users/delete_user/delete_user_state.dart';
import '../../riverpod/users/get_users/get_users_notifier.dart';
import '../../riverpod/users/get_users/get_users_state.dart';
import '../../widgets/global/common_widgets.dart';
import 'user_detail_page.dart';
import 'user_form_page.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(getUsersProvider.notifier).getUsers());
  }

  @override
  Widget build(BuildContext context) {
    // ผลลัพธ์ของ delete: แจ้งเตือน + โหลดรายการใหม่
    ref.listen<DeleteUserState>(deleteUserProvider, (_, next) {
      switch (next) {
        case DeleteUserSuccess():
          showSnack(context, 'ลบผู้ใช้สำเร็จ');
          ref.read(getUsersProvider.notifier).getUsers(); // refresh list
        case DeleteUserFailure(:final message):
          showSnack(context, message, error: true);
        default:
          break;
      }
    });

    final state = ref.watch(getUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'รีเฟรช',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(getUsersProvider.notifier).getUsers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserFormPage()),
        ),
        icon: const Icon(Icons.person_add),
        label: const Text('เพิ่มผู้ใช้'),
      ),
      body: switch (state) {
        GetUsersInitial() ||
        GetUsersLoading() =>
          const Center(child: CircularProgressIndicator()),
        GetUsersFailure(:final message) => ErrorView(
            message: message,
            onRetry: () => ref.read(getUsersProvider.notifier).getUsers(),
          ),
        GetUsersSuccess(:final users) when users.isEmpty =>
          const Center(child: Text('ยังไม่มีผู้ใช้')),
        GetUsersSuccess(:final users) => RefreshIndicator(
            onRefresh: () => ref.read(getUsersProvider.notifier).getUsers(),
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 88.sp),
              itemCount: users.length,
              separatorBuilder: (_, __) => Divider(height: 1.sp),
              itemBuilder: (context, i) {
                final user = users[i];
                return Dismissible(
                  key: ValueKey(user.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.sp),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  // ถามยืนยันก่อน แล้วค่อยให้ list รีเฟรชเองหลัง delete สำเร็จ
                  confirmDismiss: (_) async {
                    final ok =
                        await confirmDelete(context, user.name ?? 'ไม่พบชื่อ');
                    if (ok) {
                      ref
                          .read(deleteUserProvider.notifier)
                          .deleteUser(user.id ?? '');
                    }
                    return false;
                  },
                  child: ListTile(
                    leading: UserAvatar(url: user.avatar ?? '', radius: 24.sp),
                    title: Text(user.name ?? 'ไม่พบชื่อ'),
                    subtitle: Text('ID ${user.id ?? 'ไม่พบ ID'}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              UserDetailPage(userId: user.id ?? '')),
                    ),
                  ),
                );
              },
            ),
          ),
      },
    );
  }
}
