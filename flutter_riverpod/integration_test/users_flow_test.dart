import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/datasources/export_datasources.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/data/models/remote/users/user_model.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/injector.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/pages/users/users_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// In-memory replacement for the Retrofit/Dio datasource so integration tests
/// exercise the full Clean Architecture stack (UI -> Riverpod Notifiers ->
/// Usecases -> UsersRepoImpl -> Datasource) without hitting the network.
class InMemoryUsersDatasource extends Fake implements UsersDatasource {
  InMemoryUsersDatasource(List<UserModel> seed) : _users = [...seed];

  final List<UserModel> _users;
  int _nextId = 100;

  String? failGetUsersWith;
  String? failCreateUserWith;

  void seedAdd(UserModel user) => _users.add(user);

  @override
  Future<List<UserModel>> getUsers() async {
    final error = failGetUsersWith;
    if (error != null) throw Exception(error);
    return List.unmodifiable(_users);
  }

  @override
  Future<UserModel> getUser(String id) async =>
      _users.firstWhere((u) => u.id == id);

  @override
  Future<UserModel> createUser(UserModel user) async {
    final error = failCreateUserWith;
    if (error != null) throw Exception(error);
    final created = user.copyWith(id: (_nextId++).toString());
    _users.add(created);
    return created;
  }

  @override
  Future<UserModel> updateUser(String id, UserModel user) async {
    final index = _users.indexWhere((u) => u.id == id);
    final updated = user.copyWith(id: id);
    _users[index] = updated;
    return updated;
  }

  @override
  Future<UserModel> deleteUser(String id) async {
    final index = _users.indexWhere((u) => u.id == id);
    return _users.removeAt(index);
  }
}

/// Pumps the real UsersPage overriding only the lowest-level datasource
/// provider so UsersRepoImpl, UsersUsecases, and all Riverpod notifiers run
/// for real.
Future<void> pumpUsersPage(
  WidgetTester tester,
  InMemoryUsersDatasource datasource,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userdatasourceProvider.overrideWithValue(datasource),
      ],
      child: const ScreenUtilInit(
        designSize: Size(360, 690),
        child: MaterialApp(home: UsersPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Users flow (flutter_riverpod, full-stack)', () {
    testWidgets('shows seeded users returned by the datasource',
        (tester) async {
      await pumpUsersPage(
        tester,
        InMemoryUsersDatasource([
          UserModel(id: '1', name: 'Alpha', avatar: ''),
          UserModel(id: '2', name: 'Beta', avatar: ''),
        ]),
      );

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('ID 1'), findsOneWidget);
    });

    testWidgets('shows empty state when list is empty', (tester) async {
      await pumpUsersPage(tester, InMemoryUsersDatasource([]));

      expect(find.text('ยังไม่มีผู้ใช้'), findsOneWidget);
    });

    testWidgets(
      'create with validation, view detail, edit, cancel swipe, then swipe-to-delete',
      (tester) async {
        final datasource = InMemoryUsersDatasource([
          UserModel(id: '1', name: 'Alpha', avatar: ''),
          UserModel(id: '2', name: 'Beta', avatar: ''),
        ]);
        await pumpUsersPage(tester, datasource);

        // 1. Open create form and verify required-name validation.
        await tester.tap(find.text('เพิ่มผู้ใช้'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('สร้างผู้ใช้'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('สร้างผู้ใช้'));
        await tester.pump();
        expect(find.text('กรุณากรอกชื่อ'), findsOneWidget);

        // 2. Fill in the name and create the user.
        await tester.enterText(find.byType(TextFormField).first, 'Gamma');
        await tester.ensureVisible(find.text('สร้างผู้ใช้'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('สร้างผู้ใช้'));
        await tester.pumpAndSettle();

        expect(find.text('เพิ่มผู้ใช้สำเร็จ'), findsOneWidget);
        expect(find.text('Gamma'), findsOneWidget);

        // 3. Open detail page and edit the user.
        await tester.tap(find.text('Gamma'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('แก้ไข'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).first,
          'Gamma Edited',
        );
        await tester.ensureVisible(find.text('บันทึก'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('บันทึก'));
        await tester.pumpAndSettle();

        expect(find.text('บันทึกการแก้ไขสำเร็จ'), findsOneWidget);
        expect(find.text('Gamma Edited'), findsWidgets);

        // 4. Return to list and verify edited name is reflected.
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Gamma Edited'), findsOneWidget);

        // 5. Swipe left and cancel delete -> user must remain.
        final row = find.ancestor(
          of: find.text('Gamma Edited'),
          matching: find.byType(Dismissible),
        );
        await tester.drag(row, const Offset(-400, 0));
        await tester.pumpAndSettle();
        expect(find.text('ต้องการลบ "Gamma Edited" ใช่หรือไม่?'), findsOneWidget);
        await tester.tap(find.text('ยกเลิก'));
        await tester.pumpAndSettle();
        expect(find.text('Gamma Edited'), findsOneWidget);

        // 6. Swipe left and confirm delete -> user is removed.
        await tester.drag(row, const Offset(-400, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('ลบ'));
        await tester.pumpAndSettle();

        expect(find.text('ลบผู้ใช้สำเร็จ'), findsOneWidget);
        expect(find.text('Gamma Edited'), findsNothing);
        expect(find.text('Alpha'), findsOneWidget);
      },
    );

    testWidgets(
      'delete last user from detail page returns to list and shows empty state',
      (tester) async {
        await pumpUsersPage(
          tester,
          InMemoryUsersDatasource([
            UserModel(id: '1', name: 'Solo', avatar: ''),
          ]),
        );

        await tester.tap(find.text('Solo'));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('ลบ'));
        await tester.pumpAndSettle();
        expect(find.text('ต้องการลบ "Solo" ใช่หรือไม่?'), findsOneWidget);
        await tester.tap(find.text('ลบ'));
        await tester.pumpAndSettle();

        expect(find.text('ลบผู้ใช้สำเร็จ'), findsOneWidget);
        expect(find.text('Solo'), findsNothing);
        expect(find.text('ยังไม่มีผู้ใช้'), findsOneWidget);
      },
    );

    testWidgets('shows error view on load failure and recovers on retry',
        (tester) async {
      final datasource = InMemoryUsersDatasource([
        UserModel(id: '1', name: 'Alpha', avatar: ''),
      ])
        ..failGetUsersWith = 'server down';
      await pumpUsersPage(tester, datasource);

      expect(find.text('ลองใหม่'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);

      datasource.failGetUsersWith = null;
      await tester.tap(find.text('ลองใหม่'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('refresh button reloads updated users from datasource',
        (tester) async {
      final datasource = InMemoryUsersDatasource([
        UserModel(id: '1', name: 'Alpha', avatar: ''),
      ]);
      await pumpUsersPage(tester, datasource);

      expect(find.text('Delta'), findsNothing);
      datasource.seedAdd(UserModel(id: '2', name: 'Delta', avatar: ''));

      await tester.tap(find.byTooltip('รีเฟรช'));
      await tester.pumpAndSettle();

      expect(find.text('Delta'), findsOneWidget);
    });

    testWidgets('shows error snackbar and stays on form when create fails',
        (tester) async {
      final datasource = InMemoryUsersDatasource([
        UserModel(id: '1', name: 'Alpha', avatar: ''),
      ])
        ..failCreateUserWith = 'create failed';
      await pumpUsersPage(tester, datasource);

      await tester.tap(find.text('เพิ่มผู้ใช้'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Broken');
      await tester.ensureVisible(find.text('สร้างผู้ใช้'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('สร้างผู้ใช้'));
      await tester.pumpAndSettle();

      expect(find.textContaining('create failed'), findsOneWidget);
      expect(find.text('สร้างผู้ใช้'), findsOneWidget);
    });
  });
}
