import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/domain/repositories/register_repository.dart';
import 'package:frantend/features/register/presentation/cubit/register_state.dart';
import 'package:injectable/injectable.dart';
import 'package:intl_phone_field/phone_number.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository, this._authGuard)
      : super(const RegisterFormState(data: RegisterEntity.initial));

  final RegisterRepository _repository;
  final AuthGuard _authGuard;

  final step1FormKey = GlobalKey<FormState>();
  final step3FormKey = GlobalKey<FormState>();
  final step4FormKey = GlobalKey<FormState>();

  final businessNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final addressController = TextEditingController();
  final branchPhoneController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  PhoneNumber? ownerPhoneNumber;
  String? selectedCity;
  String? logoPath;

  RegisterEntity get data => switch (state) {
        RegisterFormState(:final data) => data,
        RegisterLoading(:final data) => data,
        RegisterSuccess(:final data) => data,
        RegisterFailure(:final data) => data ?? RegisterEntity.initial,
        _ => RegisterEntity.initial,
      };

  void _emitData(RegisterEntity updated) {
    emit(RegisterFormState(data: updated));
  }

  void setCity(String? city) {
    selectedCity = city;
    _emitData(data.copyWith(city: city));
  }

  void setBusinessType(String type) {
    _emitData(data.copyWith(businessType: type));
  }

  void setPlan(RegisterPlan plan) {
    _emitData(data.copyWith(plan: plan));
  }

  void setLogoPath(String? path) {
    logoPath = path;
    _emitData(data.copyWith(logoPath: path));
  }

  RegisterEntity _collectFormData() {
    return data.copyWith(
      businessName: businessNameController.text.trim(),
      city: selectedCity,
      logoPath: logoPath,
      branchName: branchNameController.text.trim(),
      address: addressController.text.trim().isEmpty
          ? null
          : addressController.text.trim(),
      branchPhone: branchPhoneController.text.trim().isEmpty
          ? null
          : branchPhoneController.text.trim(),
      ownerName: ownerNameController.text.trim(),
      ownerPhone: ownerPhoneNumber?.completeNumber ??
          ownerPhoneController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
  }

  Future<void> submitRegistration() async {
    final payload = _collectFormData();

    emit(RegisterLoading(data: payload));
    final result = await _repository.register(payload);
    result.fold(
      (failure) => emit(RegisterFailure(failure.message, data: payload)),
      (_) {
        _authGuard.setAuthenticated(true);
        emit(RegisterSuccess(data: payload));
      },
    );
  }

  @override
  Future<void> close() {
    businessNameController.dispose();
    branchNameController.dispose();
    addressController.dispose();
    branchPhoneController.dispose();
    ownerNameController.dispose();
    ownerPhoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
