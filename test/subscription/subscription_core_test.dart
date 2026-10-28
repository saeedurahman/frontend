import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';
import 'package:frantend/core/network/interceptors/forbidden_interceptor.dart';
import 'package:frantend/core/network/interceptors/subscription_interceptor.dart';
import 'package:frantend/features/subscription/data/subscription_repository.dart';
import 'package:frantend/features/subscription/data/subscription_status.dart';
import 'package:frantend/features/subscription/presentation/contact_launcher.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';

import '../helpers/fake_http.dart';

const _body = {
  'code': 'subscription_expired',
  'message': 'Your subscription has expired.',
  'expired_at': '2026-03-12T00:00:00Z',
  'contact': {
    'phone': '+92 300 1234567',
    'whatsapp': '+92 300 7654321',
    'email': 'help@example.com',
  },
};

void main() {
  group('SubscriptionFailure', () {
    test('parses the 402 body', () {
      final f = SubscriptionFailure.fromBody(_body);
      expect(f.code, SubscriptionFailure.codeExpired);
      expect(f.message, 'Your subscription has expired.');
      expect(f.expiredAt, DateTime.utc(2026, 3, 12));
      expect(f.contact.phone, '+92 300 1234567');
      expect(f.contact.whatsapp, '+92 300 7654321');
      expect(f.contact.email, 'help@example.com');
      expect(f.isGraceReadOnly, isFalse);
    });

    test('also accepts the body wrapped in FastAPI "detail"', () {
      final f = SubscriptionFailure.fromBody(const {'detail': _body});
      expect(f.code, SubscriptionFailure.codeExpired);
      expect(f.contact.phone, isNotNull);
    });

    test('grace read-only code is recognised', () {
      final f = SubscriptionFailure.fromBody(const {
        'code': 'subscription_grace_readonly',
        'message': 'Read only',
      });
      expect(f.isGraceReadOnly, isTrue);
      expect(f.contact.isEmpty, isTrue);
    });

    test('garbage bodies fall back to a safe default', () {
      for (final data in [null, 'oops', 42, <String, dynamic>{}]) {
        final f = SubscriptionFailure.fromBody(data);
        expect(f.code, SubscriptionFailure.codeExpired);
        expect(f.message, isNotEmpty);
      }
    });

    test('ErrorHandler maps 402 to SubscriptionFailure', () {
      final failure = const ErrorHandler().mapStatus(402, _body);
      expect(failure, isA<SubscriptionFailure>());
      expect((failure as SubscriptionFailure).code, 'subscription_expired');
    });
  });

  group('SubscriptionStatus', () {
    test('parses /subscription/status', () {
      final s = SubscriptionStatus.fromJson(const <String, dynamic>{
        'plan_name': 'Standard',
        'status': 'active',
        'trial_ends_at': null,
        'subscription_ends_at': '2026-12-31T00:00:00Z',
        'days_left': 12,
        'in_grace': false,
        'contact': {'phone': '0300'},
      });
      expect(s.planName, 'Standard');
      expect(s.daysLeft, 12);
      expect(s.endsAt, DateTime.utc(2026, 12, 31));
      expect(s.isHardBlocked, isFalse);
      expect(s.contact.phone, '0300');
    });

    test('expired outside grace is a hard block, inside grace is read-only',
        () {
      expect(const SubscriptionStatus(status: 'expired').isHardBlocked, isTrue);
      const grace = SubscriptionStatus(status: 'expired', inGrace: true);
      expect(grace.isHardBlocked, isFalse);
      expect(grace.isGrace, isTrue);
      for (final s in ['suspended', 'cancelled']) {
        expect(SubscriptionStatus(status: s).isHardBlocked, isTrue, reason: s);
      }
    });
  });

  group('interceptors', () {
    Dio build(FakeHandler handler, {
      required void Function(SubscriptionFailure) onSub,
      void Function(RequestOptions)? onForbidden,
      required FakeSecureStorage storage,
      required void Function() onExpired,
    }) {
      final dio = Dio(BaseOptions(baseUrl: 'http://test'));
      dio.httpClientAdapter = FakeAdapter(handler);
      dio.interceptors.addAll([
        AuthInterceptor(
          storage,
          dio: dio,
          onSessionExpired: () async {
            onExpired();
            await storage.clearAuthSession();
          },
        ),
        SubscriptionInterceptor(onFailure: onSub),
        ForbiddenInterceptor(onForbidden: onForbidden ?? (_) {}),
      ]);
      return dio;
    }

    test('402 is reported, surfaces as a failure and never clears tokens',
        () async {
      final storage = FakeSecureStorage(access: 'a', refresh: 'r', tenant: 't');
      final seen = <SubscriptionFailure>[];
      var expired = 0;
      final dio = build(
        (o) => jsonResponse(_body, status: 402),
        onSub: seen.add,
        storage: storage,
        onExpired: () => expired++,
      );

      await expectLater(
        dio.get<dynamic>('/products'),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 402)
              .having((e) => e.error, 'error', isA<SubscriptionFailure>()),
        ),
      );

      expect(seen, hasLength(1));
      expect(seen.single.code, 'subscription_expired');
      expect(expired, 0);
      expect(await storage.getAccessToken(), 'a');
      expect(await storage.getRefreshToken(), 'r');
      expect(await storage.getTenantId(), 't');
      // No refresh attempt was made for a 402.
      expect((dio.httpClientAdapter as FakeAdapter).requests, hasLength(1));
    });

    test('a 402 on login is not reported as a session event', () async {
      final storage = FakeSecureStorage();
      final seen = <SubscriptionFailure>[];
      final dio = build(
        (o) => jsonResponse(_body, status: 402),
        onSub: seen.add,
        storage: storage,
        onExpired: () {},
      );
      await expectLater(
        dio.post<dynamic>('/auth/login', data: {}),
        throwsA(isA<DioException>()),
      );
      expect(seen, isEmpty);
    });

    test('403 notifies the permission refresher, but never /auth/me',
        () async {
      final storage = FakeSecureStorage(access: 'a', refresh: 'r');
      final forbidden = <String>[];
      final dio = build(
        (o) => jsonResponse({'detail': 'no'}, status: 403),
        onSub: (_) {},
        onForbidden: (r) => forbidden.add(r.path),
        storage: storage,
        onExpired: () {},
      );
      await expectLater(
          dio.get<dynamic>('/products'), throwsA(isA<DioException>()));
      await expectLater(
          dio.get<dynamic>('/auth/me'), throwsA(isA<DioException>()));
      expect(forbidden, ['/products']);
      expect(await storage.getAccessToken(), 'a');
    });

    test('repository turns 402 from /subscription/status into a failure',
        () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test'));
      dio.httpClientAdapter =
          FakeAdapter((o) => jsonResponse(_body, status: 402));
      await expectLater(
        SubscriptionRepository(dio).fetchStatus(),
        throwsA(isA<SubscriptionFailure>()),
      );
    });
  });

  group('SubscriptionCubit', () {
    SubscriptionCubit cubit(Future<SubscriptionStatus> Function() fetch,
            {Duration every = const Duration(hours: 6)}) =>
        SubscriptionCubit(fetchStatus: fetch, refreshInterval: every);

    test('active subscription: not blocked, daysLeft exposed', () async {
      final c = cubit(() async => const SubscriptionStatus(
            status: 'active',
            daysLeft: 20,
          ));
      expect(await c.load(), isTrue);
      expect(c.state.isBlocked, isFalse);
      expect(c.state.isGraceReadOnly, isFalse);
      expect(c.state.daysLeft, 20);
      expect(c.state.showExpiryBanner, isFalse);
    });

    test('expired status blocks; paying and refreshing unblocks', () async {
      var status = const SubscriptionStatus(status: 'expired', daysLeft: 0);
      final c = cubit(() async => status);
      expect(await c.load(), isFalse);
      expect(c.state.isBlocked, isTrue);

      status = const SubscriptionStatus(status: 'active', daysLeft: 30);
      expect(await c.load(), isTrue);
      expect(c.state.isBlocked, isFalse);
    });

    test('a 402 on any request blocks until a fresh status says otherwise',
        () async {
      var status = const SubscriptionStatus(status: 'active', daysLeft: 3);
      final c = cubit(() async => status);
      await c.load();
      c.onSubscriptionFailure(SubscriptionFailure.fromBody(_body));
      expect(c.state.isBlocked, isTrue);
      expect(c.state.expiredAt, DateTime.utc(2026, 3, 12));
      expect(c.state.contact.phone, isNotNull);

      await c.load();
      expect(c.state.isBlocked, isFalse);
    });

    test('grace: read-only, not blocked, and each refused write bumps the '
        'notice', () async {
      final c = cubit(() async => const SubscriptionStatus(
            status: 'expired',
            inGrace: true,
            daysLeft: 0,
          ));
      await c.load();
      expect(c.state.isGraceReadOnly, isTrue);
      expect(c.state.isBlocked, isFalse);
      expect(c.state.showExpiryBanner, isFalse);

      const grace =
          SubscriptionFailure(code: SubscriptionFailure.codeGraceReadOnly);
      c.onSubscriptionFailure(grace);
      c.onSubscriptionFailure(grace);
      expect(c.state.graceNoticeSeq, 2);
      expect(c.state.graceNotice, SubscriptionCubit.graceFriendlyMessage);
      expect(c.state.isBlocked, isFalse);
    });

    test('a failed status read never locks anyone out', () async {
      final c = cubit(() async => throw Exception('offline'));
      expect(await c.load(), isTrue);
      expect(c.state.isBlocked, isFalse);
    });

    test('402 from the status endpoint itself blocks', () async {
      final c = cubit(
          () async => throw SubscriptionFailure.fromBody(_body));
      expect(await c.load(), isFalse);
      expect(c.state.isBlocked, isTrue);
    });

    test('concurrent loads share one request', () async {
      var calls = 0;
      final c = cubit(() async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return const SubscriptionStatus(status: 'active');
      });
      await Future.wait([c.load(), c.load(), c.load()]);
      expect(calls, 1);
    });

    test('stopSession (logout) forgets the previous business', () async {
      final c = cubit(() async => const SubscriptionStatus(status: 'expired'));
      await c.load();
      expect(c.state.isBlocked, isTrue);
      c.stopSession();
      expect(c.state.isBlocked, isFalse);
      expect(c.state.status, isNull);
    });

    testWidgets('reloads every 6 hours while the session runs', (tester) async {
      var calls = 0;
      final c = cubit(() async {
        calls++;
        return const SubscriptionStatus(status: 'active');
      });
      await c.startSession();
      expect(calls, 1);

      await tester.pump(const Duration(hours: 6));
      expect(calls, 2);
      await tester.pump(const Duration(hours: 6));
      expect(calls, 3);

      c.stopSession();
      await tester.pump(const Duration(hours: 12));
      expect(calls, 3);
      await c.close();
    });

    test('refreshIfStale skips a recent read', () async {
      var calls = 0;
      final c = cubit(() async {
        calls++;
        return const SubscriptionStatus(status: 'active');
      });
      await c.load();
      await c.refreshIfStale();
      expect(calls, 1);
      await c.refreshIfStale(maxAge: Duration.zero);
      expect(calls, 2);
    });

    test('expiry banner threshold is 7 days', () async {
      Future<bool> shows(int days) async {
        final c = cubit(() async =>
            SubscriptionStatus(status: 'active', daysLeft: days));
        await c.load();
        return c.state.showExpiryBanner;
      }

      expect(await shows(8), isFalse);
      expect(await shows(7), isTrue);
      expect(await shows(1), isTrue);
      expect(await shows(0), isTrue);
      expect(await shows(-1), isFalse);
    });
  });

  group('ContactLinks', () {
    test('wa.me uses digits only and prefers the WhatsApp number', () {
      const contact = SubscriptionContact(
        phone: '+92 300 1234567',
        whatsapp: '+92 (300) 7654321',
      );
      expect(ContactLinks.whatsapp(contact).toString(),
          'https://wa.me/923007654321');
    });

    test('WhatsApp falls back to the phone number', () {
      const contact = SubscriptionContact(phone: '+92 300 1234567');
      expect(ContactLinks.whatsapp(contact).toString(),
          'https://wa.me/923001234567');
    });

    test('call uses tel: and keeps the plus sign', () {
      const contact = SubscriptionContact(phone: '+92 300 1234567');
      expect(ContactLinks.call(contact).toString(), 'tel:+923001234567');
    });

    test('missing numbers give no link', () {
      expect(ContactLinks.call(SubscriptionContact.empty), isNull);
      expect(ContactLinks.whatsapp(SubscriptionContact.empty), isNull);
      expect(ContactLinks.email(SubscriptionContact.empty), isNull);
    });
  });
}
