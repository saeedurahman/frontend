import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/subscription/data/subscription_status.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

import '../helpers/session_fixtures.dart';

AccessCubit accessFor(User user) => AccessCubit(
      fetchCurrentUser: () async => user,
      loadCachedUser: () async => user,
    )..apply(user);

SubscriptionCubit subscriptionWith(SubscriptionStatus? status) {
  final cubit = SubscriptionCubit(
    fetchStatus: () async => status ?? const SubscriptionStatus(status: 'active'),
  );
  return cubit;
}

Widget host({
  required AccessCubit access,
  required SubscriptionCubit subscription,
  required Widget child,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(value: access),
      BlocProvider.value(value: subscription),
    ],
    child: MaterialApp(home: Scaffold(body: Center(child: child))),
  );
}

void main() {
  final cashier = makeUser(role: 'cashier', keys: cashierKeys);

  testWidgets('hides the child when the permission is missing', (tester) async {
    await tester.pumpWidget(host(
      access: accessFor(cashier),
      subscription: subscriptionWith(null),
      child: const PermissionGate(
        permission: Perm.returnsCreate,
        child: Text('Process return'),
      ),
    ));
    expect(find.text('Process return'), findsNothing);
  });

  testWidgets('shows the child when the permission is held', (tester) async {
    await tester.pumpWidget(host(
      access: accessFor(cashier),
      subscription: subscriptionWith(null),
      child: const PermissionGate(
        permission: Perm.salesCreate,
        child: Text('Pay'),
      ),
    ));
    expect(find.text('Pay'), findsOneWidget);
  });

  testWidgets('owner passes every gate', (tester) async {
    await tester.pumpWidget(host(
      access: accessFor(makeUser(role: 'owner')),
      subscription: subscriptionWith(null),
      child: const PermissionGate(
        permission: Perm.salesVoid,
        child: Text('Void'),
      ),
    ));
    expect(find.text('Void'), findsOneWidget);
  });

  testWidgets('anyOf passes when any one key is held', (tester) async {
    await tester.pumpWidget(host(
      access: accessFor(cashier),
      subscription: subscriptionWith(null),
      child: const PermissionGate(
        anyOf: [Perm.returnsCreate, Perm.salesCreate],
        child: Text('Either'),
      ),
    ));
    expect(find.text('Either'), findsOneWidget);
  });

  testWidgets('disable mode keeps the child, blocks taps, explains why',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      access: accessFor(cashier),
      subscription: subscriptionWith(null),
      child: PermissionGate(
        permission: Perm.salesVoid,
        mode: GateMode.disable,
        child: ElevatedButton(
          onPressed: () => taps++,
          child: const Text('Void sale'),
        ),
      ),
    ));
    expect(find.text('Void sale'), findsOneWidget);
    await tester.tap(find.text('Void sale'), warnIfMissed: false);
    expect(taps, 0);

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
    expect(tooltip.message, 'Requires permission ${Perm.salesVoid}');
  });

  testWidgets('builder receives enabled=false so buttons can null onPressed',
      (tester) async {
    bool? seen;
    await tester.pumpWidget(host(
      access: accessFor(cashier),
      subscription: subscriptionWith(null),
      child: PermissionGate(
        permission: Perm.salesVoid,
        mode: GateMode.disable,
        builder: (context, enabled) {
          seen = enabled;
          return ElevatedButton(
            onPressed: enabled ? () {} : null,
            child: const Text('Void'),
          );
        },
      ),
    ));
    expect(seen, isFalse);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
  });

  testWidgets('updates live when permissions change mid-session',
      (tester) async {
    final access = accessFor(cashier);
    await tester.pumpWidget(host(
      access: access,
      subscription: subscriptionWith(null),
      child: const PermissionGate(
        permission: Perm.returnsCreate,
        child: Text('Process return'),
      ),
    ));
    expect(find.text('Process return'), findsNothing);

    access.apply(makeUser(
      role: 'cashier',
      keys: [...cashierKeys, Perm.returnsCreate],
      version: 2,
    ));
    await tester.pump();
    expect(find.text('Process return'), findsOneWidget);
  });

  group('read-only (grace) mode', () {
    Future<SubscriptionCubit> graceCubit() async {
      final cubit = subscriptionWith(const SubscriptionStatus(
        status: 'expired',
        inGrace: true,
        daysLeft: 0,
      ));
      await cubit.load();
      return cubit;
    }

    testWidgets('mutating actions are disabled with a tooltip', (tester) async {
      final sub = await graceCubit();
      expect(sub.state.isGraceReadOnly, isTrue);
      var taps = 0;
      await tester.pumpWidget(host(
        access: accessFor(makeUser(role: 'owner')),
        subscription: sub,
        child: PermissionGate(
          permission: Perm.productsCreate,
          mutating: true,
          child: ElevatedButton(
            onPressed: () => taps++,
            child: const Text('Add product'),
          ),
        ),
      ));
      expect(find.text('Add product'), findsOneWidget);
      await tester.tap(find.text('Add product'), warnIfMissed: false);
      expect(taps, 0);
      expect(tester.widget<Tooltip>(find.byType(Tooltip)).message,
          kReadOnlyTooltip);
    });

    testWidgets('read-only actions (not mutating) stay usable', (tester) async {
      final sub = await graceCubit();
      var taps = 0;
      await tester.pumpWidget(host(
        access: accessFor(makeUser(role: 'owner')),
        subscription: sub,
        child: PermissionGate(
          permission: Perm.reportsExport,
          child: ElevatedButton(
            onPressed: () => taps++,
            child: const Text('Export'),
          ),
        ),
      ));
      await tester.tap(find.text('Export'));
      expect(taps, 1);
    });

    testWidgets('a 402 grace response flips the app to read-only live',
        (tester) async {
      final sub = subscriptionWith(null);
      await sub.load();
      await tester.pumpWidget(host(
        access: accessFor(makeUser(role: 'owner')),
        subscription: sub,
        child: PermissionGate(
          permission: Perm.salesCreate,
          mutating: true,
          builder: (context, enabled) => ElevatedButton(
            onPressed: enabled ? () {} : null,
            child: const Text('Pay now'),
          ),
        ),
      ));
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull,
      );

      sub.onSubscriptionFailure(
        const SubscriptionFailure(code: SubscriptionFailure.codeGraceReadOnly),
      );
      await tester.pump();
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
    });
  });

  testWidgets('without any access scope nothing is hidden', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PermissionGate(
        permission: Perm.salesVoid,
        child: Text('Void'),
      ),
    ));
    expect(find.text('Void'), findsOneWidget);
  });
}
