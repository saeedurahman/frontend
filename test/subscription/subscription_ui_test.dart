import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/session/session_notice_host.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/subscription/data/subscription_status.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:frantend/features/subscription/presentation/pages/no_access_page.dart';
import 'package:frantend/features/subscription/presentation/pages/subscription_expired_page.dart';
import 'package:frantend/features/subscription/presentation/pages/subscription_settings_page.dart';
import 'package:frantend/features/subscription/presentation/widgets/subscription_banner.dart';
import 'package:go_router/go_router.dart';

import '../helpers/session_fixtures.dart';

const _contact = SubscriptionContact(
  phone: '+92 300 1234567',
  whatsapp: '+92 300 7654321',
  email: 'help@example.com',
);

SubscriptionCubit cubitFor(
  SubscriptionStatus Function() status, {
  void Function()? onFetch,
}) =>
    SubscriptionCubit(fetchStatus: () async {
      onFetch?.call();
      return status();
    });

Future<SubscriptionCubit> loaded(SubscriptionStatus status) async {
  final c = cubitFor(() => status);
  await c.load();
  return c;
}

/// The expired page scrolls on small windows; tests use a tall one.
void useTallWindow(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget hostFor(SubscriptionCubit cubit, Widget child) => BlocProvider.value(
      value: cubit,
      child: MaterialApp(home: child),
    );

void main() {
  group('subscriptionBannerText thresholds', () {
    Future<String?> textFor(SubscriptionStatus s) async =>
        subscriptionBannerText((await loaded(s)).state);

    test('hidden above 7 days', () async {
      expect(
        await textFor(const SubscriptionStatus(status: 'active', daysLeft: 8)),
        isNull,
      );
    });

    test('shown at 7, 2, 1 and 0 days with the exact wording', () async {
      Future<String?> t(int d) =>
          textFor(SubscriptionStatus(status: 'active', daysLeft: d));
      expect(await t(7),
          'Your subscription ends in 7 days. Contact us to renew.');
      expect(await t(2),
          'Your subscription ends in 2 days. Contact us to renew.');
      expect(await t(1),
          'Your subscription ends in 1 day. Contact us to renew.');
      expect(await t(0), 'Your subscription ends today. Contact us to renew.');
    });

    test('grace shows the read-only banner instead', () async {
      final text = await textFor(const SubscriptionStatus(
        status: 'expired',
        inGrace: true,
        daysLeft: 0,
      ));
      expect(text, startsWith('Read-only mode'));
    });

    test('blocked shows no banner (the expired page takes over)', () async {
      expect(
        await textFor(const SubscriptionStatus(status: 'expired')),
        isNull,
      );
    });
  });

  group('SubscriptionBanner widget', () {
    testWidgets('renders the expiry strip at 5 days', (tester) async {
      final c = await loaded(
          const SubscriptionStatus(status: 'active', daysLeft: 5));
      await tester.pumpWidget(hostFor(c, const Scaffold(body: SubscriptionBanner())));
      expect(find.byKey(const Key('banner-expiry')), findsOneWidget);
      expect(find.textContaining('ends in 5 days'), findsOneWidget);
    });

    testWidgets('renders nothing at 30 days', (tester) async {
      final c = await loaded(
          const SubscriptionStatus(status: 'active', daysLeft: 30));
      await tester.pumpWidget(hostFor(c, const Scaffold(body: SubscriptionBanner())));
      expect(find.byKey(const Key('banner-expiry')), findsNothing);
      expect(find.byKey(const Key('banner-read-only')), findsNothing);
    });

    testWidgets('renders the read-only strip in grace', (tester) async {
      final c = await loaded(const SubscriptionStatus(
        status: 'expired',
        inGrace: true,
        daysLeft: 0,
      ));
      await tester.pumpWidget(hostFor(c, const Scaffold(body: SubscriptionBanner())));
      expect(find.byKey(const Key('banner-read-only')), findsOneWidget);
      expect(find.textContaining('Read-only mode'), findsOneWidget);
    });
  });

  group('SubscriptionExpiredPage', () {
    SubscriptionStatus expired({SubscriptionContact contact = _contact}) =>
        SubscriptionStatus(
          status: 'expired',
          subscriptionEndsAt: DateTime.utc(2026, 3, 12, 12),
          contact: contact,
        );

    testWidgets('shows the date, the message and the big buttons',
        (tester) async {
      useTallWindow(tester);
      final c = cubitFor(() => expired());
      await c.load();
      c.onSubscriptionFailure(const SubscriptionFailure(
        code: SubscriptionFailure.codeExpired,
        message: 'Your subscription has expired.',
        contact: _contact,
      ));
      await tester.pumpWidget(hostFor(c, const SubscriptionExpiredPage()));

      expect(find.text('Your subscription has ended'), findsOneWidget);
      expect(find.text('Your subscription has expired.'), findsOneWidget);
      expect(find.byKey(const Key('expired-date')), findsOneWidget);
      expect(find.textContaining('12 March 2026'), findsOneWidget);
      expect(find.text('Call us'), findsOneWidget);
      expect(find.text('WhatsApp us'), findsOneWidget);
      expect(find.text('I have paid, refresh'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });

    testWidgets('Call and WhatsApp open tel: and wa.me links', (tester) async {
      useTallWindow(tester);
      final c = await loaded(expired());
      final opened = <Uri>[];
      await tester.pumpWidget(hostFor(
        c,
        SubscriptionExpiredPage(openUrl: (u) async {
          opened.add(u);
          return true;
        }),
      ));

      await tester.tap(find.byKey(const Key('call-button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('whatsapp-button')));
      await tester.pump();

      expect(opened.map((u) => u.toString()),
          ['tel:+923001234567', 'https://wa.me/923007654321']);
    });

    testWidgets('missing numbers hide the call buttons', (tester) async {
      useTallWindow(tester);
      final c = await loaded(expired(contact: SubscriptionContact.empty));
      await tester.pumpWidget(hostFor(c, const SubscriptionExpiredPage()));
      expect(find.byKey(const Key('call-button')), findsNothing);
      expect(find.byKey(const Key('whatsapp-button')), findsNothing);
      expect(find.byKey(const Key('refresh-button')), findsOneWidget);
    });

    testWidgets('refresh re-fetches; still unpaid -> stays blocked + hint',
        (tester) async {
      useTallWindow(tester);
      var fetches = 0;
      final c = cubitFor(() => expired(), onFetch: () => fetches++);
      await c.load();
      await tester.pumpWidget(hostFor(c, const SubscriptionExpiredPage()));

      await tester.tap(find.byKey(const Key('refresh-button')));
      await tester.pumpAndSettle();

      expect(fetches, 2);
      expect(c.state.isBlocked, isTrue);
      expect(find.textContaining('cannot see your payment yet'), findsOneWidget);
    });

    testWidgets('after payment, refresh unblocks the app', (tester) async {
      useTallWindow(tester);
      var paid = false;
      final c = cubitFor(
        () => paid
            ? const SubscriptionStatus(status: 'active', daysLeft: 30)
            : expired(),
      );
      await c.load();
      await tester.pumpWidget(hostFor(c, const SubscriptionExpiredPage()));
      expect(c.state.isBlocked, isTrue);

      paid = true;
      await tester.tap(find.byKey(const Key('refresh-button')));
      await tester.pumpAndSettle();

      // The router guard watches this flag and re-enters the app.
      expect(c.state.isBlocked, isFalse);
      expect(find.textContaining('cannot see your payment yet'), findsNothing);
    });

    testWidgets('Log out calls the logout handler', (tester) async {
      useTallWindow(tester);
      final c = await loaded(expired());
      var loggedOut = 0;
      await tester.pumpWidget(hostFor(
        c,
        SubscriptionExpiredPage(onLogout: () async => loggedOut++),
      ));
      await tester.tap(find.byKey(const Key('logout-button')));
      expect(loggedOut, 1);
    });

    testWidgets('suspended and cancelled get their own headline',
        (tester) async {
      useTallWindow(tester);
      for (final entry in {
        'subscription_suspended': 'Your account is suspended',
        'subscription_cancelled': 'Your subscription was cancelled',
      }.entries) {
        final c = cubitFor(() => expired());
        c.onSubscriptionFailure(SubscriptionFailure(code: entry.key));
        await tester.pumpWidget(hostFor(c, const SubscriptionExpiredPage()));
        expect(find.text(entry.value), findsOneWidget, reason: entry.key);
      }
    });
  });

  group('SubscriptionSettingsPage', () {
    testWidgets('shows status, plan, end date and contact details',
        (tester) async {
      final c = await loaded(SubscriptionStatus(
        status: 'active',
        planName: 'Standard',
        subscriptionEndsAt: DateTime.utc(2026, 12, 31, 12),
        daysLeft: 40,
        contact: _contact,
      ));
      await tester.pumpWidget(hostFor(
        c,
        const Scaffold(body: SubscriptionSettingsPage()),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Standard'), findsOneWidget);
      expect(find.text('31 December 2026'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);
      expect(find.text('+92 300 1234567'), findsOneWidget);
      expect(find.text('help@example.com'), findsOneWidget);
      expect(find.text('How to renew'), findsOneWidget);
    });
  });

  group('SessionNoticeHost', () {
    testWidgets('a refused write in grace shows a friendly snackbar, each time',
        (tester) async {
      final sub = await loaded(const SubscriptionStatus(
        status: 'expired',
        inGrace: true,
      ));
      final access = AccessCubit(
        fetchCurrentUser: () async => null,
        loadCachedUser: () async => null,
      );
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sub),
          BlocProvider.value(value: access),
        ],
        child: const MaterialApp(
          home: SessionNoticeHost(
            child: Scaffold(body: Text('app')),
          ),
        ),
      ));

      const grace =
          SubscriptionFailure(code: SubscriptionFailure.codeGraceReadOnly);
      sub.onSubscriptionFailure(grace);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(SubscriptionCubit.graceFriendlyMessage), findsOneWidget);

      sub.onSubscriptionFailure(grace);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(SubscriptionCubit.graceFriendlyMessage), findsOneWidget);
    });

    testWidgets('a permission change shows a short notice', (tester) async {
      final sub = await loaded(const SubscriptionStatus(status: 'active'));
      final access = AccessCubit(
        fetchCurrentUser: () async => null,
        loadCachedUser: () async => null,
      )..apply(makeUser(role: 'cashier', keys: cashierKeys, version: 1));
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sub),
          BlocProvider.value(value: access),
        ],
        child: const MaterialApp(
          home: SessionNoticeHost(child: Scaffold(body: Text('app'))),
        ),
      ));
      expect(find.text(AccessCubit.permissionsChangedNotice), findsNothing);

      access.apply(makeUser(
          role: 'cashier', keys: [...cashierKeys, 'sales.void'], version: 2));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(AccessCubit.permissionsChangedNotice), findsOneWidget);
    });
  });

  group('NoAccessPage', () {
    testWidgets('explains and offers a way back, without logging out',
        (tester) async {
      var home = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: NoAccessPage(onGoHome: () => home++)),
      ));
      expect(find.text('No access'), findsOneWidget);
      expect(find.textContaining('do not have permission'), findsOneWidget);
      expect(find.textContaining('Log out'), findsNothing);
      await tester.tap(find.byKey(const Key('no-access-home')));
      expect(home, 1);
    });

    testWidgets('default button navigates to the dashboard', (tester) async {
      final router = GoRouter(
        initialLocation: '/no-access',
        routes: [
          GoRoute(path: '/no-access', builder: (_, __) => const Scaffold(body: NoAccessPage())),
          GoRoute(path: '/dashboard', builder: (_, __) => const Scaffold(body: Text('DASH'))),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.tap(find.byKey(const Key('no-access-home')));
      await tester.pumpAndSettle();
      expect(find.text('DASH'), findsOneWidget);
    });
  });

  test('User import is used by fixtures', () {
    expect(const User(id: '1', email: 'e', name: 'n', role: 'r').id, '1');
  });
}
