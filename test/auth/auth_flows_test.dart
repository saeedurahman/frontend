import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/exceptions.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/usecases/login_usecase.dart';
import 'package:frantend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frantend/features/auth/domain/usecases/pin_login_usecase.dart';
import 'package:frantend/features/auth/domain/usecases/register_business_usecase.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_state.dart';
import 'package:frantend/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:frantend/features/auth/presentation/widgets/pin_keypad.dart';
import 'package:frantend/features/users/data/datasources/users_remote_datasource.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/users/presentation/widgets/reset_pin_dialog.dart';

import '../helpers/fake_http.dart';

class _FakeAuthRepository implements AuthRepository {
  Either<Failure, User> loginResult = const Left(AuthFailure('Invalid credentials'));
  Either<Failure, void> changeResult = const Right(null);
  int loginCalls = 0;
  String? lastSlug;
  String? lastChangeCurrent;
  String? lastChangeNew;

  @override
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
    String? businessSlug,
  }) async {
    loginCalls++;
    lastSlug = businessSlug;
    return loginResult;
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    lastChangeCurrent = currentPassword;
    lastChangeNew = newPassword;
    return changeResult;
  }

  @override
  Future<Either<Failure, User>> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  }) async =>
      loginResult;

  @override
  Future<Either<Failure, User>> registerBusiness(Map<String, dynamic> data) async =>
      loginResult;

  @override
  Future<Either<Failure, void>> logout() async => const Right(null);

  @override
  Future<Either<Failure, User>> getCurrentUser() async => loginResult;

  @override
  Future<bool> isAuthenticated() async => false;
}

AuthCubit _cubit(_FakeAuthRepository repo) => AuthCubit(
      loginUseCase: LoginUseCase(repo),
      pinLoginUseCase: PinLoginUseCase(repo),
      registerBusinessUseCase: RegisterBusinessUseCase(repo),
      logoutUseCase: LogoutUseCase(repo),
      authRepository: repo,
      authGuard: AuthGuard(FakeSecureStorage()),
    );

AuthRemoteDataSourceImpl _remote(FakeAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test'))
    ..httpClientAdapter = adapter;
  return AuthRemoteDataSourceImpl(dio);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('login: business slug', () {
    test('slug is sent as business_slug when provided', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({
          'access_token': 'a',
          'refresh_token': 'r',
          'token_type': 'bearer',
        }),
      );
      await _remote(adapter).login(
        phone: '+923001234567',
        password: 'pw',
        businessSlug: '  my-shop ',
      );
      expect(adapter.requests.single.data, {
        'phone': '+923001234567',
        'password': 'pw',
        'business_slug': 'my-shop',
      });
    });

    test('slug is omitted while optional and empty', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({
          'access_token': 'a',
          'refresh_token': 'r',
          'token_type': 'bearer',
        }),
      );
      await _remote(adapter).login(phone: '+92300', password: 'pw');
      await _remote(adapter)
          .login(phone: '+92300', password: 'pw', businessSlug: '   ');
      for (final request in adapter.requests) {
        expect((request.data as Map).containsKey('business_slug'), isFalse);
      }
    });

    test('cubit forwards the typed slug to the use case', () async {
      final repo = _FakeAuthRepository();
      final cubit = _cubit(repo);
      cubit.businessSlugController.text = 'my-shop';
      await cubit.login();
      expect(repo.lastSlug, 'my-shop');
      await cubit.close();
    });

    test('409 without a slug asks for the Business ID and focuses the field',
        () async {
      final repo = _FakeAuthRepository()
        ..loginResult = const Left(ConflictFailure('multiple businesses'));
      final cubit = _cubit(repo);
      await cubit.login();
      expect(
        cubit.state,
        const AuthState.error(AuthCubit.businessSlugRequiredMessage),
      );
      expect(cubit.isCoolingDown, isFalse);
      await cubit.close();
    });

    test('409 with a slug already typed shows the server message', () async {
      final repo = _FakeAuthRepository()
        ..loginResult = const Left(ConflictFailure('slug mismatch'));
      final cubit = _cubit(repo);
      cubit.businessSlugController.text = 'my-shop';
      await cubit.login();
      expect(cubit.state, const AuthState.error('slug mismatch'));
      await cubit.close();
    });
  });

  group('wrong password', () {
    test('401 on login becomes "Invalid credentials"', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({'detail': 'whatever the server says'}, status: 401),
      );
      await expectLater(
        _remote(adapter).login(phone: '+92300', password: 'bad'),
        throwsA(
          isA<AuthException>()
              .having((e) => e.message, 'message', 'Invalid credentials'),
        ),
      );
    });

    test('401 on PIN login becomes "Invalid credentials"', () async {
      final adapter = FakeAdapter((o) => jsonResponse({}, status: 401));
      await expectLater(
        _remote(adapter)
            .pinLogin(businessSlug: 's', userId: 'u', pinCode: '000000'),
        throwsA(isA<AuthException>()),
      );
    });

    test('429 is rethrown so it maps to a RateLimitFailure', () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse(
          {'detail': 'slow'},
          status: 429,
          headers: {
            'retry-after': ['30'],
          },
        ),
      );
      try {
        await _remote(adapter).login(phone: '+92300', password: 'pw');
        fail('should throw');
      } on DioException catch (e) {
        final failure = const ErrorHandler().mapExceptionToFailure(e);
        expect(failure, isA<RateLimitFailure>());
        expect((failure as RateLimitFailure).retryAfterSeconds, 30);
      }
    });

    test('network error stays a network error (not "Invalid credentials")',
        () async {
      final adapter = FakeAdapter((o) {
        throw DioException(
          requestOptions: o,
          type: DioExceptionType.connectionError,
        );
      });
      try {
        await _remote(adapter).login(phone: '+92300', password: 'pw');
        fail('should throw');
      } on DioException catch (e) {
        expect(const ErrorHandler().mapExceptionToFailure(e),
            isA<NetworkFailure>());
      }
    });
  });

  group('429 cool-down', () {
    test('login is disabled for Retry-After seconds, then re-enabled', () {
      fakeAsync((async) {
        final repo = _FakeAuthRepository()
          ..loginResult = const Left(RateLimitFailure(retryAfterSeconds: 30));
        final cubit = _cubit(repo);

        cubit.login();
        async.flushMicrotasks();

        expect(repo.loginCalls, 1);
        expect(cubit.cooldownSeconds.value, 30);
        expect(cubit.isCoolingDown, isTrue);
        expect(
          cubit.state,
          const AuthState.error('Too many attempts, try again in 30 seconds'),
        );

        // Attempts during the cool-down never reach the server.
        cubit.login();
        async.flushMicrotasks();
        expect(repo.loginCalls, 1);

        async.elapse(const Duration(seconds: 12));
        expect(cubit.cooldownSeconds.value, 18);

        async.elapse(const Duration(seconds: 18));
        expect(cubit.cooldownSeconds.value, 0);
        expect(cubit.isCoolingDown, isFalse);

        cubit.login();
        async.flushMicrotasks();
        expect(repo.loginCalls, 2);
        cubit.close();
      });
    });

    test('non-429 failures do not start a cool-down', () async {
      final repo = _FakeAuthRepository();
      final cubit = _cubit(repo);
      await cubit.login();
      expect(cubit.isCoolingDown, isFalse);
      expect(cubit.state, const AuthState.error('Invalid credentials'));
      await cubit.close();
    });
  });

  group('PIN rules', () {
    test('new PINs need at least 6 digits', () {
      expect(validateNewPin('12345'), 'PIN must be at least 6 digits');
      expect(validateNewPin('1234'), isNotNull);
      expect(validateNewPin('123456'), isNull);
      expect(validateNewPin('12345a'), 'PIN must contain digits only');
      expect(validateNewPin('1234567'), isNotNull);
    });

    test('login still accepts legacy 4-6 digit PINs', () {
      expect(isValidPin('1234'), isTrue);
      expect(isValidPin('123456'), isTrue);
      expect(isValidPin('123'), isFalse);
    });

    testWidgets('reset dialog demands current password and a 6-digit PIN',
        (tester) async {
      ResetPinResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  result = await ResetPinDialog.show(context),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      Future<void> submit() async {
        await tester.tap(find.text('Reset PIN').last);
        await tester.pump();
      }

      await submit();
      expect(find.text('Enter your current password'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextField, 'Your current password'), 'pw');
      await tester.enterText(
          find.widgetWithText(TextField, 'New PIN (min 6 digits)'), '1234');
      await tester.enterText(
          find.widgetWithText(TextField, 'Confirm PIN'), '1234');
      await submit();
      expect(find.text('PIN must be at least 6 digits'), findsOneWidget);
      expect(result, isNull);

      await tester.enterText(
          find.widgetWithText(TextField, 'New PIN (min 6 digits)'), '123456');
      await tester.enterText(
          find.widgetWithText(TextField, 'Confirm PIN'), '123456');
      await submit();
      await tester.pumpAndSettle();

      expect(result?.newPin, '123456');
      expect(result?.currentPassword, 'pw');
      expect(result?.currentPin, isNull);
    });

    testWidgets('changing your OWN pin also asks for the current PIN',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => ResetPinDialog.show(context, askCurrentPin: true),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Your current PIN'), findsOneWidget);
    });

    test('reset PIN request carries the re-authentication fields', () async {
      final adapter = FakeAdapter((o) => jsonResponse({}));
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))
        ..httpClientAdapter = adapter;
      final remote = UsersRemoteDataSourceImpl(_StubDioClient(dio));

      await remote.resetUserPin(
        id: 'u1',
        pinCode: '654321',
        currentPassword: 'pw',
        currentPin: '111111',
      );

      expect(adapter.requests.single.path, '/users/u1/pin');
      expect(adapter.requests.single.data, {
        'pin_code': '654321',
        'current_password': 'pw',
        'current_pin': '111111',
      });
    });
  });

  group('change password', () {
    test('validation: current required, strength, match, differs', () {
      expect(
        ChangePasswordCubit.validate(current: '', next: 'Abcdefg1', confirm: 'Abcdefg1'),
        containsPair('current_password', isNotEmpty),
      );
      expect(
        ChangePasswordCubit.validate(current: 'old', next: 'short', confirm: 'short'),
        containsPair('new_password', contains('at least 8')),
      );
      expect(
        ChangePasswordCubit.validate(current: 'old', next: 'alllowercase', confirm: 'alllowercase'),
        containsPair('new_password', contains('uppercase')),
      );
      expect(
        ChangePasswordCubit.validate(current: 'Abcdefg1', next: 'Abcdefg1', confirm: 'Abcdefg1'),
        containsPair('new_password', contains('differ')),
      );
      expect(
        ChangePasswordCubit.validate(current: 'old', next: 'Abcdefg1', confirm: 'Nope'),
        containsPair('confirm_password', 'Passwords do not match'),
      );
      expect(
        ChangePasswordCubit.validate(current: 'old', next: 'Abcdefg1', confirm: 'Abcdefg1'),
        isEmpty,
      );
    });

    test('does not call the server when invalid', () async {
      final repo = _FakeAuthRepository();
      final cubit = ChangePasswordCubit(repo);
      await cubit.submit(current: '', next: 'x', confirm: 'y');
      expect(repo.lastChangeNew, isNull);
      expect(cubit.state.fieldErrors, isNotEmpty);
      await cubit.close();
    });

    test('sends current + new password and reports success', () async {
      final repo = _FakeAuthRepository();
      final cubit = ChangePasswordCubit(repo);
      await cubit.submit(current: 'old', next: 'Abcdefg1', confirm: 'Abcdefg1');
      expect(repo.lastChangeCurrent, 'old');
      expect(repo.lastChangeNew, 'Abcdefg1');
      expect(cubit.state.succeeded, isTrue);
      await cubit.close();
    });

    test('wrong current password is surfaced', () async {
      final repo = _FakeAuthRepository()
        ..changeResult = const Left(AuthFailure('Current password is incorrect'));
      final cubit = ChangePasswordCubit(repo);
      await cubit.submit(current: 'bad', next: 'Abcdefg1', confirm: 'Abcdefg1');
      expect(cubit.state.succeeded, isFalse);
      expect(cubit.state.error, 'Current password is incorrect');
      await cubit.close();
    });

    test('server 422 field errors are mapped to the right inputs', () async {
      final repo = _FakeAuthRepository()
        ..changeResult = const Left(
          ValidationFailure('New password: too weak', {'new_password': 'too weak'}),
        );
      final cubit = ChangePasswordCubit(repo);
      await cubit.submit(current: 'old', next: 'Abcdefg1', confirm: 'Abcdefg1');
      expect(cubit.state.fieldErrors, {'new_password': 'too weak'});
      await cubit.close();
    });

    test('remote datasource posts the right body', () async {
      final adapter = FakeAdapter((o) => jsonResponse({}));
      await _remote(adapter)
          .changePassword(currentPassword: 'old', newPassword: 'new');
      expect(adapter.requests.single.path, '/auth/change-password');
      expect(adapter.requests.single.data,
          {'current_password': 'old', 'new_password': 'new'});
    });

    test('remote datasource maps a bad current password to AuthException',
        () async {
      final adapter = FakeAdapter(
        (o) => jsonResponse({'detail': 'Current password is incorrect'},
            status: 401),
      );
      await expectLater(
        _remote(adapter)
            .changePassword(currentPassword: 'bad', newPassword: 'new'),
        throwsA(
          isA<AuthException>().having(
              (e) => e.message, 'message', 'Current password is incorrect'),
        ),
      );
    });
  });
}

class _StubDioClient implements DioClient {
  _StubDioClient(this._dio);

  final Dio _dio;

  @override
  Dio get dio => _dio;
}
