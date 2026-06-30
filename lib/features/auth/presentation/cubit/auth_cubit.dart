import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNumber;
  bool rememberMe = false;

  void setRememberMe(bool value) => rememberMe = value;

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
    emit(const AuthState.loading());
    final phone = _resolvePhoneForLogin();
    final password = passwordController.text;

    final result = await _loginUseCase(phone: phone, password: password);
    result.fold(
      (failure) {
        emit(AuthState.error(failure.message));
      },
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
    emit(const AuthState.loading());
    final result = await _pinLoginUseCase(
      businessSlug: businessSlug,
      userId: userId,
      pinCode: pin,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
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
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
