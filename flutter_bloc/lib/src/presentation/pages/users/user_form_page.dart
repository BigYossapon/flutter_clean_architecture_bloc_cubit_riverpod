import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/export_entities.dart';
import '../../../injector.dart';
import '../../bloc_cubit/users/export_users_bloc_cubit.dart';
import '../../widgets/global/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ใช้ร่วมกันทั้ง Create (user == null) และ Update (ส่ง user เข้ามา)
class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key, this.user});

  final UserEntity? user;

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final _nameCtrl = TextEditingController(
    text: widget.user?.name,
  );

  late final _avatarCtrl = TextEditingController(
    text: widget.user?.avatar,
  );

  late final CreateUserBloc createUserBloc;
  late final UpdateUserCubit updateUserCubit;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();

    createUserBloc = getIt<CreateUserBloc>();
    updateUserCubit = getIt<UpdateUserCubit>();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _avatarCtrl.dispose();

    createUserBloc.close();
    updateUserCubit.close();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final avatar = _avatarCtrl.text.trim();

    if (_isEdit) {
      updateUserCubit.updateUser(
        widget.user?.id ?? '',
        UserEntity(
          name: name,
          avatar: avatar,
        ),
      );
    } else {
      createUserBloc.add(
        CreateUser(
          UserEntity(
            name: name,
            avatar: avatar,
          ),
        ),
      );
    }
  }

  void _onSuccess(String message) {
    showSnack(context, message);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateUserBloc, CreateUserState>(
      bloc: createUserBloc,
      listener: (context, state) {
        switch (state) {
          case CreateUserSuccess():
            _onSuccess('เพิ่มผู้ใช้สำเร็จ');

          case CreateUserFailure(:final message):
            showSnack(context, message, error: true);

          default:
            break;
        }
      },
      child: BlocListener<UpdateUserCubit, UpdateUserState>(
        bloc: updateUserCubit,
        listener: (context, state) {
          switch (state) {
            case UpdateUserSuccess():
              _onSuccess('บันทึกการแก้ไขสำเร็จ');

            case UpdateUserFailure(:final message):
              showSnack(context, message, error: true);

            default:
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              _isEdit ? 'แก้ไขผู้ใช้' : 'เพิ่มผู้ใช้',
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<CreateUserBloc, CreateUserState>(
              bloc: createUserBloc,
              builder: (context, createState) {
                return BlocBuilder<UpdateUserCubit, UpdateUserState>(
                  bloc: updateUserCubit,
                  builder: (context, updateState) {
                    final loading = createState is CreateUserLoading ||
                        updateState is UpdateUserLoading;

                    return Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.all(24.sp),
                        children: [
                          Center(
                            child: UserAvatar(
                              url: _avatarCtrl.text.trim(),
                              radius: 48.sp,
                            ),
                          ),
                          SizedBox(height: 24.sp),
                          TextFormField(
                            controller: _nameCtrl,
                            enabled: !loading,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'ชื่อ',
                              prefixIcon: Icon(
                                Icons.person_outline,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'กรุณากรอกชื่อ'
                                : null,
                          ),
                          SizedBox(height: 16.sp),
                          TextFormField(
                            controller: _avatarCtrl,
                            enabled: !loading,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Avatar URL',
                              prefixIcon: Icon(
                                Icons.image_outlined,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final t = v?.trim() ?? '';

                              if (t.isEmpty) return null;

                              final uri = Uri.tryParse(t);

                              return (uri != null &&
                                      uri.hasScheme &&
                                      uri.host.isNotEmpty)
                                  ? null
                                  : 'URL ไม่ถูกต้อง';
                            },
                            onFieldSubmitted: (_) {
                              if (!loading) _submit();
                            },
                          ),
                          SizedBox(height: 32.sp),
                          FilledButton.icon(
                            onPressed: loading ? null : _submit,
                            icon: loading
                                ? SizedBox(
                                    width: 18.sp,
                                    height: 18.sp,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.sp,
                                    ),
                                  )
                                : Icon(
                                    _isEdit ? Icons.save : Icons.add,
                                  ),
                            label: Text(
                              _isEdit ? 'บันทึก' : 'สร้างผู้ใช้',
                            ),
                            style: FilledButton.styleFrom(
                              minimumSize: Size.fromHeight(48.sp),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
