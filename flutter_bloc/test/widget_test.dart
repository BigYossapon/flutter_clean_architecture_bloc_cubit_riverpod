import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/exceptions/exception.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/entities/export_entities.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/domain/usecases/export_usecases.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/injector.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/bloc_cubit/users/export_users_bloc_cubit.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/pages/users/user_form_page.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/pages/users/users_page.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/widgets/global/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

Future<void> _registerBlocs(UsersUsecases usecases) async {
  await getIt.reset();
  getIt.registerLazySingleton<UsersUsecases>(() => usecases);
  getIt.registerFactory<CreateUserBloc>(
    () => CreateUserBloc(usersUseCases: getIt<UsersUsecases>()),
  );
  getIt.registerFactory<DeleteUserBloc>(
    () => DeleteUserBloc(usersUseCases: getIt<UsersUsecases>()),
  );
  getIt.registerFactory<GetUserBloc>(
    () => GetUserBloc(usersUseCases: getIt<UsersUsecases>()),
  );
  getIt.registerFactory<GetUsersCubit>(
    () => GetUsersCubit(usersUseCases: getIt<UsersUsecases>()),
  );
  getIt.registerFactory<UpdateUserCubit>(
    () => UpdateUserCubit(usersUseCases: getIt<UsersUsecases>()),
  );
}

Widget _wrapWithApp(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    child: MaterialApp(home: child),
  );
}

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  group('Common widgets', () {
    testWidgets('ErrorView shows message and invokes onRetry', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      await tester.tap(find.text('ลองใหม่'));
      await tester.pump();
      expect(retried, isTrue);
    });

    testWidgets('UserAvatar renders fallback person icon when url is empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UserAvatar(url: '')),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('confirmDelete returns false on cancel and true on confirm',
        (tester) async {
      bool? dialogResult;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  dialogResult = await confirmDelete(context, 'Alice');
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('ต้องการลบ "Alice" ใช่หรือไม่?'), findsOneWidget);
      await tester.tap(find.text('ยกเลิก'));
      await tester.pumpAndSettle();
      expect(dialogResult, isFalse);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ลบ'));
      await tester.pumpAndSettle();
      expect(dialogResult, isTrue);
    });
  });

  group('UsersPage widget tests', () {
    testWidgets('shows loading indicator while fetching users', (tester) async {
      final completer = Completer<Either<BaseException, List<UserEntity>>>();
      await _registerBlocs(
        FakeUsersUsecases(onGetUsers: () => completer.future),
      );

      await tester.pumpWidget(_wrapWithApp(const UsersPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Right([]));
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state message when user list is empty',
        (tester) async {
      await _registerBlocs(
        FakeUsersUsecases(onGetUsers: () async => const Right([])),
      );

      await tester.pumpWidget(_wrapWithApp(const UsersPage()));
      await tester.pumpAndSettle();

      expect(find.text('ยังไม่มีผู้ใช้'), findsOneWidget);
    });

    testWidgets('shows ErrorView on failure and reloads on retry',
        (tester) async {
      var fail = true;
      await _registerBlocs(
        FakeUsersUsecases(
          onGetUsers: () async {
            if (fail) {
              return const Left(NormalException(message: 'server down'));
            }
            return const Right([
              UserEntity(id: '1', name: 'Alice', avatar: ''),
            ]);
          },
        ),
      );

      await tester.pumpWidget(_wrapWithApp(const UsersPage()));
      await tester.pumpAndSettle();

      expect(find.text('ลองใหม่'), findsOneWidget);

      fail = false;
      await tester.tap(find.text('ลองใหม่'));
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('ID 1'), findsOneWidget);
    });
  });

  group('UserFormPage widget tests', () {
    testWidgets('validates required name and avatar URL format in create mode',
        (tester) async {
      var createCalled = false;
      await _registerBlocs(
        FakeUsersUsecases(
          onCreateUser: (u) async {
            createCalled = true;
            return Right(u);
          },
        ),
      );

      await tester.pumpWidget(_wrapWithApp(const UserFormPage()));
      await tester.pumpAndSettle();

      expect(find.text('เพิ่มผู้ใช้'), findsOneWidget);
      expect(find.text('สร้างผู้ใช้'), findsOneWidget);

      await tester.ensureVisible(find.text('สร้างผู้ใช้'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('สร้างผู้ใช้'));
      await tester.pump();
      expect(find.text('กรุณากรอกชื่อ'), findsOneWidget);
      expect(createCalled, isFalse);

      await tester.enterText(find.byType(TextFormField).first, 'Alice');
      await tester.enterText(find.byType(TextFormField).last, 'not-a-url');
      await tester.ensureVisible(find.text('สร้างผู้ใช้'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('สร้างผู้ใช้'));
      await tester.pump();
      expect(find.text('URL ไม่ถูกต้อง'), findsOneWidget);
      expect(createCalled, isFalse);
    });

    testWidgets('prefills existing user fields in edit mode', (tester) async {
      await _registerBlocs(FakeUsersUsecases());

      await tester.pumpWidget(
        _wrapWithApp(
          const UserFormPage(
            user: UserEntity(id: '1', name: 'Alice', avatar: ''),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('แก้ไขผู้ใช้'), findsOneWidget);
      expect(find.text('บันทึก'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
    });
  });
}
