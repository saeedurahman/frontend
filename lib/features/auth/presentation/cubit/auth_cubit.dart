import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/usecases/login_usecase.dart';
import 'package:frantend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frantend/features/auth/domain/usecases/pin_login_usecase.dart';
import 'package:frantend/features/auth/domain/usecases/register_business_usecase.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_state.dart';
import 'package:injectable/injectable.dart';
import 'package:intl_phone_field/phone_number.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUseCase loginUseCase,
    required PinLoginUseCase pinLoginUseCase,
    required RegisterBusinessUseCase registerBusinessUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository authRepository,
    required AuthGuard authGuard,
  })  : _loginUseCase = loginUseCase,
        _pinLoginUseCase = pinLoginUseCase,
        _registerBusinessUseCase = registerBusinessUseCase,
        _logoutUseCase = logoutUseCase,
        _authRepository = authRepository,
        _authGuard = authGuard,
        super(const AuthState.initial());

  final LoginUseCase _loginUseCase;
  final PinLoginUseCase _pinLoginUseCase;
  final RegisterBusinessUseCase _registerBusinessUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;
  final AuthGuard _authGuard;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  /// Optional until the backend makes login business-scoped.
  final businessSlugController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNumber;
  bool rememberMe = false;

  void setRememberMe(bool value) => rememberMe = value;

  /// Seconds left of a 429 cool-down; login/PIN buttons are disabled while > 0.
  final ValueNotifier<int> cooldownSeconds = ValueNotifier<int>(0);
  Timer? _cooldownTimer;

  bool get isCoolingDown => cooldownSeconds.value > 0;

  @visibleForTesting
  void startCooldown(int seconds) {
    _cooldownTimer?.cancel();
    cooldownSeconds.value = seconds;
    if (seconds <= 0) return;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = cooldownSeconds.value - 1;
      cooldownSeconds.value = next < 0 ? 0 : next;
      if (next <= 0) timer.cancel();
    });
  }

  void _onFailure(Failure failure) {
    if (failure is RateLimitFailure) startCooldown(failure.retryAfterSeconds);
    emit(AuthState.error(failure.message));
  }

  Future<void> checkAuthStatus() async {
    final isAuth = await _authRepository.isAuthenticated();
    if (isAuth) {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (_) => emit(const AuthState.unauthenticated()),
        (user) {
          _authGuard.setAuthenticated(true);
          emit(AuthState.authenticated(user));
        },
      );
    } else {
      _authGuard.setAuthenticated(false);
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login() async {
    if (isCoolingDown) return;
    emit(const AuthState.loading());
    final phone = _resolvePhoneForLogin();
    final password = passwordController.text;

    final result = await _loginUseCase(
      phone: phone,
      password: password,
      businessSlug: businessSlugController.text,
    );
    result.fold(
      _onFailure,
      (user) {
        _authGuard.setAuthenticated(true);
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> loginWithPhone() => login();

  /// E.164 phone with leading `+`, matching registration (`owner_phone`).
  String _resolvePhoneForLogin() {
    final complete = phoneNumber?.completeNumber;
    if (complete != null && complete.isNotEmpty) {
      return complete;
    }

    final raw = phoneController.text.trim();
    if (raw.isEmpty) return raw;
    if (raw.startsWith('+')) return raw;
    if (raw.startsWith('0')) return '+92${raw.substring(1)}';
    if (raw.startsWith('92')) return '+$raw';
    return '+92$raw';
  }

  Future<void> pinLogin({
    required String businessSlug,
    required String userId,
    required String pin,
  }) async {
    if (isCoolingDown) return;
    emit(const AuthState.loading());
    final result = await _pinLoginUseCase(
      businessSlug: businessSlug,
      userId: userId,
      pinCode: pin,
    );
    result.fold(
      _onFailure,
      (user) {
        _authGuard.setAuthenticated(true);
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> registerBusiness(Map<String, dynamic> data) async {
    emit(const AuthState.loading());
    final result = await _registerBusinessUseCase(data);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) {
        _authGuard.setAuthenticated(true);
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) {
        _authGuard.setAuthenticated(false);
        emit(const AuthState.unauthenticated());
      },
    );
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    cooldownSeconds.dispose();
    phoneController.dispose();
    passwordController.dispose();
    businessSlugController.dispose();
    return super.close();
  }
}
