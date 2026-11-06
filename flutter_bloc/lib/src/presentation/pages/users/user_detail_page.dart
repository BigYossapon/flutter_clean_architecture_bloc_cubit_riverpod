import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/export_entities.dart';
import '../../../injector.dart';
import '../../bloc_cubit/users/export_users_bloc_cubit.dart';
import '../../widgets/global/common_widgets.dart';

import 'user_form_page.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({
    super.key,
    required this.userId,
  });

  final String userId;

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
    return BlocListener<DeleteUserBloc, DeleteUserState>(
      bloc: deleteUserBloc,
      listener: (context, state) {
        if (state is DeleteUserSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<GetUserBloc, GetUserState>(
        bloc: getUserBloc,
        builder: (context, state) {
          final deleting = deleteUserBloc.state is DeleteUserLoading;

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
                        builder: (_) => UserFormPage(
                          user: state.user,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'ลบ',
                    icon: deleting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
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
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: UserAvatar(
                        url: user.avatar ?? '',
                        radius: 56,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        user.name ?? 'ไม่พบชื่อ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                          const Divider(height: 1),
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
      ),
    );
  }
}
