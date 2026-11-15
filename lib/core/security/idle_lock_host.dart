import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/security/pin_security_service.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/session/session_services.dart';
import 'package:frantend/shared/widgets/layout/sign_out_flow.dart' show pendingWorkMessage;
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/presentation/widgets/pin_keypad.dart';

/// Wraps the whole app: reports user activity and draws the lock screen on
/// top of the router. The router/navigator below stays mounted while locked,
/// so cart and held-order state is untouched.
class IdleLockHost extends StatelessWidget {
  const IdleLockHost({super.key, required this.service, required this.child});

  final IdleLockService service;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => service.recordActivity(),
      onPointerMove: (_) => service.recordActivity(),
      onPointerSignal: (_) => service.recordActivity(),
      child: ValueListenableBuilder<bool>(
        valueListenable: service.locked,
        builder: (context, isLocked, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // While locked nothing underneath may receive pointer or
              // keyboard (scanner) input.
              ExcludeFocus(
                excluding: isLocked,
                child: IgnorePointer(ignoring: isLocked, child: child),
              ),
              if (isLocked)
                Positioned.fill(child: IdleLockScreen(service: service)),
            ],
          );
        },
      ),
    );
  }
}

/// PIN prompt shown while [IdleLockService.locked] is true. Unlocking reuses
/// the PIN login endpoint for the current user.
class IdleLockScreen extends StatefulWidget {
  const IdleLockScreen({super.key, required this.service});

  final IdleLockService service;

  @override
  State<IdleLockScreen> createState() => _IdleLockScreenState();
}

class _IdleLockScreenState extends State<IdleLockScreen> {
  String _pin = '';
  String? _error;
  bool _busy = false;
  String _userName = '';
  String _userPhone = '';
  String _userId = '';
  String _slug = '';
  bool _hasPin = true;
  bool _usePassword = false;
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();
  int _cooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_loadUser());
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await sl<AuthLocalDataSource>().getCachedUser();
    final userId = user?.id ?? await sl<SecureStorage>().getUserId();
    final cache = sl.isRegistered<PinDeviceCache>()
        ? await sl<PinDeviceCache>().read()
        : null;
    final slug = cache?.businessSlug.trim() ?? user?.businessSlug ?? '';

    bool hasPin = false;
    if (userId != null &&
        userId.isNotEmpty &&
        sl.isRegistered<PinSecurityService>()) {
      hasPin =
          await sl<PinSecurityService>().hasPin(userId: userId, slug: slug);
    }

    if (mounted) {
      setState(() {
        _userName = user?.name ?? '';
        _userPhone = user?.phone ?? '';
        _userId = userId ?? '';
        _slug = slug;
        _hasPin = hasPin;
        if (!hasPin) {
          _usePassword = true;
        }
      });
    }
  }

  void _onDigit(String digit) {
    if (_busy || _cooldown > 0 || _pin.length >= kMaxPinLength) return;
    setState(() {
      _pin += digit;
      _error = null;
    });
    if (_pin.length == kMaxPinLength) unawaited(_submit());
  }

  void _onBackspace() {
    if (_busy || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    if (!isValidPin(_pin) || _busy || _cooldown > 0) return;
    setState(() => _busy = true);

    final userId = _userId.isNotEmpty
        ? _userId
        : await sl<SecureStorage>().getUserId();
    final slug = _slug.isNotEmpty
        ? _slug
        : (await sl<PinDeviceCache>().read())?.businessSlug.trim() ?? '';
    if (userId == null || slug.isEmpty) {
      _fail('PIN unlock is not available. Sign out and sign in again.');
      return;
    }

    final result = await sl<AuthRepository>().pinLogin(
      businessSlug: slug,
      userId: userId,
      pinCode: _pin,
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        if (failure is RateLimitFailure) {
          _startCooldown(failure.retryAfterSeconds);
        }
        _fail(failure.message);
      },
      (_) => widget.service.unlock(),
    );
  }

  Future<void> _submitPassword() async {
    final password = _passwordController.text;
    if (password.isEmpty || _busy || _cooldown > 0) return;
    setState(() => _busy = true);

    bool verified = false;
    String? errorMessage;

    // 1. Try online login via AuthRepository
    if (sl.isRegistered<AuthRepository>()) {
      try {
        final phone = _userPhone.isNotEmpty ? _userPhone : _userName;
        final result = await sl<AuthRepository>().login(
          phone: phone,
          password: password,
          businessSlug: _slug.isNotEmpty ? _slug : null,
        );
        result.fold(
          (failure) {
            if (failure is NetworkFailure) {
              // Server unreachable, fall back to offline verifier below
            } else if (failure is RateLimitFailure) {
              _startCooldown(failure.retryAfterSeconds);
              errorMessage = failure.message;
            } else {
              errorMessage = failure.message;
            }
          },
          (_) {
            verified = true;
          },
        );
      } catch (_) {
        // Fall back to offline
      }
    }

    // 2. If online did not succeed and wasn't explicitly rejected by server:
    if (!verified &&
        errorMessage == null &&
        sl.isRegistered<OfflineCredentialVerifier>()) {
      final verifier = sl<OfflineCredentialVerifier>();
      var offlineResult = await verifier.verify(
        kind: OfflineCredentialKind.password,
        identity: _userPhone,
        secret: password,
        tenantKey: _slug.isNotEmpty ? _slug : null,
      );
      if (offlineResult is OfflineNotEnrolled && _userId.isNotEmpty) {
        offlineResult = await verifier.verify(
          kind: OfflineCredentialKind.password,
          identity: _userId,
          secret: password,
          tenantKey: _slug.isNotEmpty ? _slug : null,
        );
      }

      if (offlineResult is OfflineVerified) {
        verified = true;
      } else if (offlineResult is OfflineWrongSecret) {
        errorMessage =
            'Incorrect password. ${offlineResult.attemptsLeft} attempts remaining.';
      } else if (offlineResult is OfflineLockedOut) {
        errorMessage = 'Account locked due to too many failed attempts.';
      } else if (offlineResult is OfflineNotEnrolled) {
        errorMessage = 'Offline password verification is not available.';
      }
    }

    if (!mounted) return;
    if (verified) {
      widget.service.unlock();
    } else {
      _fail(errorMessage ?? 'Invalid password');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _pin = '';
      _error = message;
    });
  }

  void _startCooldown(int seconds) {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = seconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _cooldown = _cooldown > 0 ? _cooldown - 1 : 0);
      if (_cooldown <= 0) timer.cancel();
    });
  }

  Future<void> _signOut() async {
    final blocked = await SessionServices.logout();
    if (blocked != null && mounted) {
      setState(() => _error = pendingWorkMessage(blocked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.loginBackground,
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded,
                    size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  '${AppBrand.current.shortName} is locked',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  _usePassword
                      ? (_hasPin
                          ? 'Enter your password to continue'
                          : 'No PIN set. Enter your password to continue')
                      : (_userName.isEmpty
                          ? 'Enter your PIN to continue'
                          : '$_userName, enter your PIN to continue'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                if (_usePassword) ...[
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Account Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    onSubmitted: (_) => _submitPassword(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed:
                          _busy || _cooldown > 0 ? null : _submitPassword,
                      child: const Text('Unlock'),
                    ),
                  ),
                  if (_hasPin) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => setState(() {
                                _usePassword = false;
                                _error = null;
                              }),
                      child: const Text('Unlock with PIN instead'),
                    ),
                  ],
                ] else ...[
                  PinKeypad(
                    pinLength: _pin.length,
                    enabled: !_busy && _cooldown == 0,
                    onDigit: _onDigit,
                    onBackspace: _onBackspace,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _usePassword = true;
                              _error = null;
                            }),
                    child: const Text('Unlock with password instead'),
                  ),
                ],
                const SizedBox(height: 16),
                if (_cooldown > 0)
                  Text(
                    'Too many attempts, try again in $_cooldown seconds',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  )
                else if (_error != null)
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                if (_busy) ...[
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _busy ? null : _signOut,
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
