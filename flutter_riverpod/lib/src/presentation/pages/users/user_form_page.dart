import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/export_entities.dart';
import '../../riverpod/users/create_user/create_user_notifier.dart';
import '../../riverpod/users/create_user/create_user_state.dart';
import '../../riverpod/users/get_user/get_user_notifier.dart';
import '../../riverpod/users/get_users/get_users_notifier.dart';
import '../../riverpod/users/update_user/update_user_notifier.dart';
import '../../riverpod/users/update_user/update_user_state.dart';
import '../../widgets/global/common_widgets.dart';

/// ใช้ร่วมกันทั้ง Create (user == null) และ Update (ส่ง user เข้ามา)
class UserFormPage extends ConsumerStatefulWidget {
  const UserFormPage({super.key, this.user});

  final UserEntity? user;

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.user?.name);
  late final _avatarCtrl = TextEditingController(text: widget.user?.avatar);

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    // เคลียร์ state เก่าจากการสร้าง/แก้ไขครั้งก่อน
    // Future.microtask(() {
    //   ref.read(createUserProvider.notifier)
    //   ref.read(updateUserProvider.notifier).reset();
    // });
    // _avatarCtrl.addListener(() => setState(() {})); // อัปเดต preview
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final avatar = _avatarCtrl.text.trim();

    if (_isEdit) {
      ref.read(updateUserProvider.notifier).updateUser(
          widget.user?.id ?? '', UserEntity(name: name, avatar: avatar));
    } else {
      ref
          .read(createUserProvider.notifier)
          .createUser(UserEntity(name: name, avatar: avatar));
    }
  }

  void _onSuccess(String message) {
    showSnack(context, message);
    ref.read(getUsersProvider.notifier).getUsers(); // refresh list
    if (_isEdit) {
      ref.read(getUserProvider.notifier).getUser(widget.user?.id ?? '');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CreateUserState>(createUserProvider, (_, next) {
      switch (next) {
        case CreateUserSuccess():
          _onSuccess('เพิ่มผู้ใช้สำเร็จ');
        case CreateUserFailure(:final message):
          showSnack(context, message, error: true);
        default:
          break;
      }
    });
    ref.listen<UpdateUserState>(updateUserProvider, (_, next) {
      switch (next) {
        case UpdateUserSuccess():
          _onSuccess('บันทึกการแก้ไขสำเร็จ');
        case UpdateUserFailure(:final message):
          showSnack(context, message, error: true);
        default:
          break;
      }
    });

    final loading = ref.watch(createUserProvider) is CreateUserLoading ||
        ref.watch(updateUserProvider) is UpdateUserLoading;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'แก้ไขผู้ใช้' : 'เพิ่มผู้ใช้')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(24.sp),
            children: [
              Center(
                child: UserAvatar(url: _avatarCtrl.text.trim(), radius: 48.sp),
              ),
              SizedBox(height: 24.sp),
              TextFormField(
                controller: _nameCtrl,
                enabled: !loading,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'กรุณากรอกชื่อ' : null,
              ),
              SizedBox(height: 16.sp),
              TextFormField(
                controller: _avatarCtrl,
                enabled: !loading,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Avatar URL',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null; // ไม่บังคับ
                  final uri = Uri.tryParse(t);
                  return (uri != null && uri.hasScheme && uri.host.isNotEmpty)
                      ? null
                      : 'URL ไม่ถูกต้อง';
                },
                onFieldSubmitted: (_) => loading ? null : _submit(),
              ),
              SizedBox(height: 32.sp),
              FilledButton.icon(
                onPressed: loading ? null : _submit,
                icon: loading
                    ? SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: CircularProgressIndicator(strokeWidth: 2.sp))
                    : Icon(_isEdit ? Icons.save : Icons.add),
                label: Text(_isEdit ? 'บันทึก' : 'สร้างผู้ใช้'),
                style:
                    FilledButton.styleFrom(minimumSize: Size.fromHeight(48.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
