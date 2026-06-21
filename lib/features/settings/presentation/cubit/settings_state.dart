import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

part 'settings_state.freezed.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = SettingsInitial;

  const factory SettingsState.loading() = SettingsLoading;

  const factory SettingsState.loaded({
    required BusinessProfileModel business,
    required List<AppSettingModel> businessSettings,
    required List<TaxRateModel> taxRates,
    required String footerText,
    required String paperSize,
    @Default(true) bool showTaxOnReceipt,
    @Default(true) bool showLogoOnReceipt,
    String? branchOverrideId,
    String? branchOverrideFooter,
    @Default(false) bool branchFooterIsOverride,
    @Default(false) bool isSavingBusiness,
    @Default(false) bool isSavingReceipt,
    @Default(false) bool isSavingBranchOverride,
    @Default(false) bool isSavingTaxRate,
    String? defaultTaxRateId,
    @Default(false) bool isSavingDefaultTaxRate,
    String? errorMessage,
  }) = SettingsLoaded;

  const factory SettingsState.error(String message) = SettingsError;
}
