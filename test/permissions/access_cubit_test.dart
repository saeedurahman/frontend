import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';

import '../helpers/session_fixtures.dart';

void main() {
  late User server;
  late int fetches;
  late DateTime clock;

  AccessCubit build({Duration minGap = const Duration(seconds: 20)}) =>
      AccessCubit(
        fetchCurrentUser: () async {
          fetches++;
          return server;
        },
        loadCachedUser: () async => makeUser(role: 'cashier', keys: cashierKeys),
        minGap: minGap,
        now: () => clock,
      );

  setUp(() {
    server = makeUser(role: 'cashier', keys: cashierKeys, version: 1);
    fetches = 0;
    clock = DateTime(2026, 1, 1, 9);
  });

  test('startSession shows the cached user at once, then the fresh one',
      () async {
    final c = build();
    final seen = <bool>[];
    c.stream.listen((s) => seen.add(s.can(Perm.returnsView)));

    await c.startSession();
    expect(c.state.user, isNotNull);
    expect(c.state.permissionsVersion, 1);
    expect(fetches, 1);
    await c.close();
  });

  test('a changed permission set raises one notice and updates the UI',
      () async {
    final c = build();
    await c.startSession();
    expect(c.state.can(Perm.returnsView), isFalse);
    expect(c.state.noticeSeq, 0);

    server = makeUser(
      role: 'cashier',
      keys: [...cashierKeys, Perm.returnsView],
      version: 2,
    );
    clock = clock.add(const Duration(minutes: 11));
    await c.refresh(force: true);

    expect(c.state.can(Perm.returnsView), isTrue);
    expect(c.state.noticeSeq, 1);
    expect(c.state.notice, AccessCubit.permissionsChangedNotice);
    await c.close();
  });

  test('an unchanged refresh stays silent', () async {
    final c = build();
    await c.startSession();
    await c.refresh(force: true);
    expect(c.state.noticeSeq, 0);
    await c.close();
  });

  test('revoking a permission takes effect and is announced', () async {
    final c = build();
    await c.startSession();
    server = makeUser(
      role: 'cashier',
      keys: cashierKeys.where((k) => k != Perm.salesCreate).toList(),
      version: 2,
    );
    await c.refresh(force: true);
    expect(c.state.can(Perm.salesCreate), isFalse);
    expect(c.state.noticeSeq, 1);
    await c.close();
  });

  test('a role change alone is also announced', () async {
    final c = build();
    await c.startSession();
    server = makeUser(role: 'manager', keys: cashierKeys, version: 1);
    await c.refresh(force: true);
    expect(c.state.noticeSeq, 1);
    await c.close();
  });

  test('403s are throttled: a burst costs one /auth/me call', () async {
    final c = build();
    await c.startSession();
    expect(fetches, 1);

    clock = clock.add(const Duration(seconds: 5));
    c.onForbidden();
    c.onForbidden();
    c.onForbidden();
    await Future<void>.delayed(Duration.zero);
    expect(fetches, 1, reason: 'inside the 20s window');

    clock = clock.add(const Duration(seconds: 30));
    c.onForbidden();
    await Future<void>.delayed(Duration.zero);
    expect(fetches, 2);
    await c.close();
  });

  test('app resume refreshes (subject to the same throttle)', () async {
    final c = build();
    await c.startSession();
    clock = clock.add(const Duration(minutes: 3));
    c.onResumed();
    await Future<void>.delayed(Duration.zero);
    expect(fetches, 2);
    await c.close();
  });

  test('a new permissions_version triggers an immediate refresh', () async {
    final c = build();
    await c.startSession();
    c.onPermissionsVersion(1); // same version: nothing
    await Future<void>.delayed(Duration.zero);
    expect(fetches, 1);

    server = makeUser(role: 'cashier', keys: cashierKeys, version: 2);
    c.onPermissionsVersion(2);
    await Future<void>.delayed(Duration.zero);
    expect(fetches, 2);
    expect(c.state.permissionsVersion, 2);
    await c.close();
  });

  test('a failed refresh keeps the last known permissions', () async {
    final c = AccessCubit(
      fetchCurrentUser: () async => throw Exception('offline'),
      loadCachedUser: () async => makeUser(role: 'cashier', keys: cashierKeys),
    );
    await c.startSession();
    expect(c.state.can(Perm.salesCreate), isTrue);
    await c.close();
  });

  test('stopSession (logout) drops every permission', () async {
    final c = build();
    await c.startSession();
    c.stopSession();
    expect(c.state.user, isNull);
    expect(c.state.can(Perm.salesCreate), isFalse);
    await c.close();
  });

  testWidgets('refreshes every 10 minutes while signed in', (tester) async {
    final c = AccessCubit(
      fetchCurrentUser: () async {
        fetches++;
        return server;
      },
      loadCachedUser: () async => null,
    );
    await c.startSession();
    expect(fetches, 1);

    await tester.pump(const Duration(minutes: 10));
    expect(fetches, 2);
    await tester.pump(const Duration(minutes: 10));
    expect(fetches, 3);

    c.stopSession();
    await tester.pump(const Duration(minutes: 30));
    expect(fetches, 3);
    await c.close();
  });

  test('branch scope comes from the user', () async {
    server = makeUser(
      role: 'manager',
      keys: managerKeys,
      branchIds: const ['b1', 'b2'],
    );
    final c = build();
    await c.startSession();
    expect(c.state.branchIds, ['b1', 'b2']);
    await c.close();
  });
}
