import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';
import 'package:frantend/core/utils/json_num.dart';
import 'package:frantend/core/utils/phone_input.dart';
import 'package:frantend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';

import '../helpers/fake_http.dart';

// Shapes copied from the backend: app/schemas/auth.py (TokenResponse, UserInfo,
// MeResponse, RefreshTokenResponse, SubscriptionSummary) and the README
// ("permissions_version": "9f3c1a77d2b04e51", signed lease).
const _lease = {
  'v': 1,
  'business_id': '7d1c0a52-3b3e-4a0e-9a57-2a2c5f1b9e10',
  'valid_until': '2026-11-05T08:15:00Z',
  'server_time': '2026-10-29T08:15:00Z',
  'signature': 'c2lnbmF0dXJlLWJ5dGVz',
};
const _subscription = {'status': 'trial', 'days_left': 14};

Map<String, dynamic> _userInfo() => {
      'id': '0b5f3c3e-5d7e-4d57-8a43-0f2f5c1c9a11',
      'full_name': 'Ayesha Khan',
      'phone': '+923442259592',
      'business_id': '7d1c0a52-3b3e-4a0e-9a57-2a2c5f1b9e10',
      'branch_id': '5a9f0d0e-1b8c-4c64-9d0a-6b0d7a2d4e22',
      'business_name': 'Khan Traders',
      'business_type_code': 'retail',
      'business_slug': 'khan-traders',
      'roles': ['owner'],
      'permission_keys': ['sales.view', 'sales.create'],
      'permissions_version': '9f3c1a77d2b04e51',
    };

Map<String, dynamic> _tokenResponse() => {
      'access_token': 'aaa.bbb.ccc',
      'refresh_token': 'refresh-1',
      'token_type': 'bearer',
      'user': _userInfo(),
      'subscription': _subscription,
      'lease': _lease,
    };

void main() {
  AuthRemoteDataSourceImpl sourceFor(Object? body, {int status = 200}) {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dio.httpClientAdapter =
        FakeAdapter((_) => jsonResponse(body, status: status));
    return AuthRemoteDataSourceImpl(dio);
  }

  void expectOwner(UserModel u) {
    expect(u.name, 'Ayesha Khan');
    expect(u.phone, '+923442259592');
    expect(u.permissionsVersion, '9f3c1a77d2b04e51');
    expect(u.roles, ['owner']);
    expect(u.toEntity().permissionsVersion, '9f3c1a77d2b04e51');
  }

  test('register (201 TokenResponse) parses', () async {
    final token = await sourceFor(_tokenResponse(), status: 201)
        .registerBusiness({'owner_phone': '+923442259592'});
    expect(token.accessToken, 'aaa.bbb.ccc');
    expectOwner(token.user!);
  });

  test('login (TokenResponse with subscription + lease) parses', () async {
    final token = await sourceFor(_tokenResponse())
        .login(phone: '+923442259592', password: 'x');
    expect(token.refreshToken, 'refresh-1');
    expectOwner(token.user!);
  });

  test('pin login parses', () async {
    final token = await sourceFor(_tokenResponse())
        .pinLogin(businessSlug: 'khan-traders', userId: 'u', pinCode: '1234');
    expectOwner(token.user!);
  });

  test('me (MeResponse = UserInfo + subscription + lease) parses', () async {
    final user = await sourceFor({
      ..._userInfo(),
      'subscription': _subscription,
      'lease': _lease,
    }).getCurrentUser();
    expectOwner(user);
  });

  test('me with null branch, lease, subscription and empty version', () async {
    final user = await sourceFor({
      ..._userInfo(),
      'branch_id': null,
      'permissions_version': '',
      'subscription': null,
      'lease': null,
    }).getCurrentUser();
    expect(user.branchId, isNull);
    expect(user.permissionsVersion, isNull);
  });

  test('refresh (RefreshTokenResponse with subscription + lease) rotates',
      () async {
    final storage =
        FakeSecureStorage(access: 'old', refresh: 'r1', tenant: 't');
    final dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dio.httpClientAdapter = FakeAdapter((o) {
      if (o.path == '/auth/refresh') {
        return jsonResponse({
          'access_token': 'new',
          'refresh_token': 'r2',
          'token_type': 'bearer',
          'subscription': _subscription,
          'lease': _lease,
        });
      }
      return o.headers['Authorization'] == 'Bearer new'
          ? jsonResponse({'ok': true})
          : jsonResponse({'detail': 'expired'}, status: 401);
    });
    dio.interceptors.add(
      AuthInterceptor(storage, dio: dio, onSessionExpired: () async {}),
    );

    final r = await dio.get<dynamic>('/products');
    expect(r.statusCode, 200);
    expect(await storage.getRefreshToken(), 'r2');
  });

  test('a legacy numeric permissions_version is tolerated', () {
    final u = UserModel.fromJson({..._userInfo(), 'permissions_version': 7});
    expect(u.permissionsVersion, '7');
  });

  group('unreadable payloads never escape as raw cast errors', () {
    test('wrong type for a required field names the field', () async {
      final bad = _tokenResponse()..['user'] = {..._userInfo(), 'id': 42};
      await expectLater(
        sourceFor(bad).login(phone: '+923442259592', password: 'x'),
        throwsA(
          isA<ResponseParseException>().having(
            (e) => e.detail,
            'detail',
            contains('user.id expected string got int'),
          ),
        ),
      );
    });

    test('ErrorHandler maps it to a clear ServerFailure', () {
      final f = const ErrorHandler().mapExceptionToFailure(
        const ResponseParseException('/auth/login', 'x'),
      );
      expect(f, isA<ServerFailure>());
      expect(f.message, contains('could not read'));
    });

    test('non-object body is rejected cleanly', () async {
      await expectLater(
        sourceFor(null).getCurrentUser(),
        throwsA(isA<ResponseParseException>()),
      );
    });

    test('log body masks tokens and lease', () {
      final red = ApiParse.redactBody(_tokenResponse())! as Map;
      expect(red['access_token'], '[REDACTED]');
      expect(red['refresh_token'], '[REDACTED]');
      expect(red['lease'], '[REDACTED]');
      expect((red['user'] as Map)['full_name'], 'Ayesha Khan');
    });
  });

  group('JsonNum', () {
    test('ints', () {
      expect(JsonNum.intOrNull('3'), 3);
      expect(JsonNum.intOrNull('3.0'), 3);
      expect(JsonNum.intOrNull(3.9), 3);
      expect(JsonNum.intOrNull(null), isNull);
      expect(JsonNum.intOrNull('abc'), isNull);
      expect(JsonNum.intOr('', 5), 5);
    });
    test('doubles (Decimal strings)', () {
      expect(JsonNum.doubleOrNull('12.50'), 12.5);
      expect(JsonNum.doubleOrNull(12), 12.0);
      expect(JsonNum.doubleOrNull(null), isNull);
      expect(JsonNum.doubleOr('x', 1), 1);
    });
  });

  group('phone E.164', () {
    test('typed with trunk 0 keeps every digit', () {
      final n = PhoneInput.nationalDigits('03442259592',
          dialCode: '92', trunkPrefix: '0');
      expect(n, '3442259592');
      expect(PhoneInput.toE164('92', n), '+923442259592');
    });
    test('pasted +92 number is not truncated or doubled', () {
      final n = PhoneInput.nationalDigits('+923442259592',
          dialCode: '92', trunkPrefix: '0');
      expect(PhoneInput.toE164('92', n), '+923442259592');
    });
    test('0092 prefix and separators', () {
      final n = PhoneInput.nationalDigits('0092 344-2259592',
          dialCode: '92', trunkPrefix: '0');
      expect(PhoneInput.toE164('92', n), '+923442259592');
    });
    test('formatter keeps the national digits only', () {
      const f = NationalPhoneFormatter(dialCode: '92', trunkPrefix: '0');
      final out = f.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '03442259592'),
      );
      expect(out.text, '3442259592');
    });
    test('cleanE164', () {
      expect(PhoneInput.cleanE164('+92 344 2259592'), '+923442259592');
      expect(PhoneInput.cleanE164(''), '');
    });
  });
}
