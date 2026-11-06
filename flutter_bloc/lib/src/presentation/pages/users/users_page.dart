import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injector.dart';
import '../../bloc_cubit/users/export_users_bloc_cubit.dart';
import '../../widgets/global/common_widgets.dart';
import 'user_detail_page.dart';
import 'user_form_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetUsersCubit>()..getUsers(),
        ),
        BlocProvider(
          create: (_) => getIt<DeleteUserBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<CreateUserBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<GetUserBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<UpdateUserCubit>(),
        ),
      ],
      child: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteUserBloc, DeleteUserState>(
      listener: (context, state) {
        switch (state) {
          case DeleteUserSuccess():
            showSnack(context, 'ลบผู้ใช้สำเร็จ');
            context.read<GetUsersCubit>().getUsers();

          case DeleteUserFailure(:final message):
            showSnack(context, message, error: true);

          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: [
            IconButton(
              tooltip: 'รีเฟรช',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<GetUsersCubit>().getUsers();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UserFormPage(),
            ),
          ),
          icon: const Icon(Icons.person_add),
          label: const Text('เพิ่มผู้ใช้'),
        ),
        body: BlocBuilder<GetUsersCubit, GetUsersState>(
          builder: (context, state) {
            switch (state) {
              case GetUsersInitial():
              case GetUsersLoading():
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case GetUsersFailure(:final message):
                return ErrorView(
                  message: message,
                  onRetry: () {
                    context.read<GetUsersCubit>().getUsers();
                  },
                );

              case GetUsersSuccess(:final users):
                if (users.isEmpty) {
                  return const Center(
                    child: Text('ยังไม่มีผู้ใช้'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () {
                    return context.read<GetUsersCubit>().getUsers();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final user = users[i];

                      return Dismissible(
                        key: ValueKey(user.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (_) async {
                          final ok = await confirmDelete(
                            context,
                            user.name ?? 'ไม่พบชื่อ',
                          );

                          if (ok && context.mounted) {
                            context.read<DeleteUserBloc>().add(
                                  DeleteUser(
                                    user.id ?? '',
                                  ),
                                );
                          }

                          return false;
                        },
                        child: ListTile(
                          leading: UserAvatar(
                            url: user.avatar ?? '',
                            radius: 24,
                          ),
                          title: Text(
                            user.name ?? 'ไม่พบชื่อ',
                          ),
                          subtitle: Text(
                            'ID ${user.id ?? 'ไม่พบ ID'}',
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDetailPage(
                                  userId: user.id ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
