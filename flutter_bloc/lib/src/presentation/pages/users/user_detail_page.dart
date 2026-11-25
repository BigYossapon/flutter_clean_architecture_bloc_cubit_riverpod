import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/export_entities.dart';
import '../../../injector.dart';
import '../../bloc_cubit/users/export_users_bloc_cubit.dart';
import '../../widgets/global/common_widgets.dart';

import 'user_form_page.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({
    super.key,
    required this.userId,
    this.onUserChanged,
  });

  final String userId;
  final VoidCallback? onUserChanged;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late final GetUserBloc getUserBloc;
  late final DeleteUserBloc deleteUserBloc;

  @override
  void initState() {
    super.initState();

    getUserBloc = getIt<GetUserBloc>();
    deleteUserBloc = getIt<DeleteUserBloc>();

    getUserBloc.add(GetUser(widget.userId));
  }

  @override
  void dispose() {
    getUserBloc.close();
    deleteUserBloc.close();
    super.dispose();
  }

  Future<void> _delete(UserEntity user) async {
    final ok = await confirmDelete(
      context,
      user.name ?? 'ไม่พบชื่อ',
    );

    if (ok && mounted) {
      deleteUserBloc.add(
        DeleteUser(user.id ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteUserBloc, DeleteUserState>(
      bloc: deleteUserBloc,
      listener: (context, deleteState) {
        switch (deleteState) {
          case DeleteUserSuccess():
            showSnack(context, 'ลบผู้ใช้สำเร็จ');
            widget.onUserChanged?.call();
            Navigator.pop(context, true);
          case DeleteUserFailure(:final message):
            showSnack(context, message, error: true);
          default:
            break;
        }
      },
      builder: (context, deleteState) {
        final deleting = deleteState is DeleteUserLoading;

        return BlocBuilder<GetUserBloc, GetUserState>(
          bloc: getUserBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('User detail'),
                actions: [
                  if (state is GetUserSuccess) ...[
                    IconButton(
                      tooltip: 'แก้ไข',
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserFormPage(
                              user: state.user,
                            ),
                          ),
                        );
                        if (updated == true && mounted) {
                          getUserBloc.add(GetUser(widget.userId));
                          widget.onUserChanged?.call();
                        }
                      },
                    ),
                  IconButton(
                    tooltip: 'ลบ',
                    icon: deleting
                        ? SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.sp,
                            ),
                          )
                        : const Icon(Icons.delete_outline),
                    onPressed: deleting ? null : () => _delete(state.user),
                  ),
                ],
              ],
            ),
            body: switch (state) {
              GetUserInitial() || GetUserLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              GetUserFailure(:final message) => ErrorView(
                  message: message,
                  onRetry: () {
                    getUserBloc.add(
                      GetUser(widget.userId),
                    );
                  },
                ),
              GetUserSuccess(:final user) => ListView(
                  padding: EdgeInsets.all(24.sp),
                  children: [
                    Center(
                      child: UserAvatar(
                        url: user.avatar ?? '',
                        radius: 56.sp,
                      ),
                    ),
                    SizedBox(height: 16.sp),
                    Center(
                      child: Text(
                        user.name ?? 'ไม่พบชื่อ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(height: 24.sp),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.tag),
                            title: const Text('ID'),
                            subtitle: Text(
                              user.id ?? 'ไม่พบ ID',
                            ),
                          ),
                          Divider(height: 1.sp),
                          ListTile(
                            leading: const Icon(Icons.link),
                            title: const Text('Avatar URL'),
                            subtitle: Text(
                              user.avatar ?? 'ไม่พบ URL รูปภาพ',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            },
            );
          },
        );
      },
    );
  }
}
