import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_state.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetBusinessProfileUseCase getBusinessProfileUseCase,
    required UpdateBusinessProfileUseCase updateBusinessProfileUseCase,
    required GetSettingsUseCase getSettingsUseCase,
    required BulkUpdateSettingsUseCase bulkUpdateSettingsUseCase,
    required DeleteSettingUseCase deleteSettingUseCase,
    required GetTaxRatesUseCase getTaxRatesUseCase,
    required CreateTaxRateUseCase createTaxRateUseCase,
    required UpdateTaxRateUseCase updateTaxRateUseCase,
  })  : _getBusiness = getBusinessProfileUseCase,
        _updateBusiness = updateBusinessProfileUseCase,
        _getSettings = getSettingsUseCase,
        _bulkUpdateSettings = bulkUpdateSettingsUseCase,
        _deleteSetting = deleteSettingUseCase,
        _getTaxRates = getTaxRatesUseCase,
        _createTaxRate = createTaxRateUseCase,
        _updateTaxRate = updateTaxRateUseCase,
        super(const SettingsState.initial());

  final GetBusinessProfileUseCase _getBusiness;
  final UpdateBusinessProfileUseCase _updateBusiness;
  final GetSettingsUseCase _getSettings;
  final BulkUpdateSettingsUseCase _bulkUpdateSettings;
  final DeleteSettingUseCase _deleteSetting;
  final GetTaxRatesUseCase _getTaxRates;
  final CreateTaxRateUseCase _createTaxRate;
  final UpdateTaxRateUseCase _updateTaxRate;

  Future<void> loadAll() async {
    emit(const SettingsState.loading());

    final businessResult = await _getBusiness();
    final settingsResult = await _getSettings();
    final taxResult = await _getTaxRates();

    businessResult.fold(
      (f) => emit(SettingsState.error(f.message)),
      (business) {
        settingsResult.fold(
          (f) => emit(SettingsState.error(f.message)),
          (settings) {
            taxResult.fold(
              (f) => emit(SettingsState.error(f.message)),
              (taxRates) {
                emit(
                  SettingsLoaded(
                    business: business,
                    businessSettings: settings,
                    taxRates: taxRates,
                    footerText: _footerFromSettings(settings),
                    paperSize: _paperFromSettings(settings),
                    showTaxOnReceipt: _boolFromSettings(
                      settings,
                      SettingKeys.receiptShowTax,
                      defaultValue: true,
                    ),
                    showLogoOnReceipt: _boolFromSettings(
                      settings,
                      SettingKeys.receiptShowLogo,
                      defaultValue: true,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _footerFromSettings(List<AppSettingModel> settings) {
    return SettingsValueUtils.valueForKey(
          settings,
          SettingKeys.receiptFooterText,
        ) ??
        'Thank you for shopping with us!';
  }

  String _paperFromSettings(List<AppSettingModel> settings) {
    return SettingsValueUtils.valueForKey(
          settings,
          SettingKeys.receiptPaperSize,
        ) ??
        '80mm';
  }

  bool _boolFromSettings(
    List<AppSettingModel> settings,
    String key, {
    required bool defaultValue,
  }) {
    final raw = SettingsValueUtils.valueForKey(settings, key);
    if (raw == null) return defaultValue;
    return raw.toLowerCase() == 'true' || raw == '1';
  }

  void updateFooterText(String value) => _mutateLoaded(
        (s) => s.copyWith(footerText: value, errorMessage: null),
      );

  void updatePaperSize(String value) => _mutateLoaded(
        (s) => s.copyWith(paperSize: value, errorMessage: null),
      );

  void updateShowTaxOnReceipt(bool value) => _mutateLoaded(
        (s) => s.copyWith(showTaxOnReceipt: value, errorMessage: null),
      );

  void updateShowLogoOnReceipt(bool value) => _mutateLoaded(
        (s) => s.copyWith(showLogoOnReceipt: value, errorMessage: null),
      );

  void patchBusiness(
    BusinessProfileModel Function(BusinessProfileModel business) patch,
  ) {
    _mutateLoaded(
      (s) => s.copyWith(business: patch(s.business), errorMessage: null),
    );
  }

  void updateBusinessField({
    String? name,
    String? legalName,
    String? email,
    String? city,
  }) {
    _mutateLoaded((s) {
      final business = s.business;
      return s.copyWith(
        business: business.copyWith(
          name: name ?? business.name,
          legalName: legalName ?? business.legalName,
          email: email ?? business.email,
          city: city ?? business.city,
        ),
        errorMessage: null,
      );
    });
  }

  Future<bool> saveBusinessProfile() async {
    final current = state;
    if (current is! SettingsLoaded) return false;

    emit(current.copyWith(isSavingBusiness: true, errorMessage: null));

    final body = <String, dynamic>{
      'name': current.business.name,
      if (current.business.legalName != null)
        'legal_name': current.business.legalName,
      if (current.business.email != null) 'email': current.business.email,
      if (current.business.city != null) 'city': current.business.city,
      if (current.business.phone != null && current.business.phone!.isNotEmpty)
        'phone': current.business.phone,
      if (current.business.taxId != null && current.business.taxId!.isNotEmpty)
        'tax_id': current.business.taxId,
      if (current.business.addressLine1 != null &&
          current.business.addressLine1!.isNotEmpty)
        'address_line1': current.business.addressLine1,
      if (current.business.logoUrl != null &&
          current.business.logoUrl!.isNotEmpty)
        'logo_url': current.business.logoUrl,
    };

    final result = await _updateBusiness(body);
    return result.fold(
      (f) {
        emit(current.copyWith(isSavingBusiness: false, errorMessage: f.message));
        return false;
      },
      (business) {
        emit(
          current.copyWith(
            business: business,
            isSavingBusiness: false,
            errorMessage: null,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> saveReceiptSettings() async {
    final current = state;
    if (current is! SettingsLoaded) return false;

    emit(current.copyWith(isSavingReceipt: true, errorMessage: null));

    final settings = [
      {
        'setting_key': SettingKeys.receiptFooterText,
        'setting_value': SettingsValueUtils.wrapValue(current.footerText),
      },
      {
        'setting_key': SettingKeys.receiptPaperSize,
        'setting_value': SettingsValueUtils.wrapValue(current.paperSize),
      },
      {
        'setting_key': SettingKeys.receiptShowTax,
        'setting_value':
            SettingsValueUtils.wrapValue(current.showTaxOnReceipt),
      },
      {
        'setting_key': SettingKeys.receiptShowLogo,
        'setting_value':
            SettingsValueUtils.wrapValue(current.showLogoOnReceipt),
      },
    ];

    final result = await _bulkUpdateSettings(settings);
    return result.fold(
      (f) {
        emit(current.copyWith(isSavingReceipt: false, errorMessage: f.message));
        return false;
      },
      (updated) {
        emit(
          current.copyWith(
            businessSettings: updated,
            isSavingReceipt: false,
            errorMessage: null,
          ),
        );
        return true;
      },
    );
  }

  Future<void> selectBranchForOverrides(String? branchId) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    if (branchId == null) {
      emit(
        current.copyWith(
          branchOverrideId: null,
          branchOverrideFooter: null,
          branchFooterIsOverride: false,
        ),
      );
      return;
    }

    final settingsResult = await _getSettings(branchId: branchId);
    settingsResult.fold(
      (f) => emit(current.copyWith(errorMessage: f.message)),
      (settings) {
        final footer = SettingsValueUtils.valueForKey(
              settings,
              SettingKeys.receiptFooterText,
              branchId: branchId,
            ) ??
            _footerFromSettings(settings);
        emit(
          current.copyWith(
            branchOverrideId: branchId,
            branchOverrideFooter: footer,
            branchFooterIsOverride: SettingsValueUtils.hasBranchOverride(
              settings,
              SettingKeys.receiptFooterText,
              branchId,
            ),
            errorMessage: null,
          ),
        );
      },
    );
  }

  void updateBranchOverrideFooter(String value) => _mutateLoaded(
        (s) => s.copyWith(branchOverrideFooter: value, errorMessage: null),
      );

  Future<bool> saveBranchOverride() async {
    final current = state;
    if (current is! SettingsLoaded || current.branchOverrideId == null) {
      return false;
    }

    emit(current.copyWith(isSavingBranchOverride: true, errorMessage: null));

    final result = await _bulkUpdateSettings([
      {
        'setting_key': SettingKeys.receiptFooterText,
        'setting_value':
            SettingsValueUtils.wrapValue(current.branchOverrideFooter ?? ''),
        'branch_id': current.branchOverrideId,
      },
    ]);

    return await result.fold(
      (f) async {
        emit(
          current.copyWith(
            isSavingBranchOverride: false,
            errorMessage: f.message,
          ),
        );
        return false;
      },
      (_) async {
        await selectBranchForOverrides(current.branchOverrideId);
        final updated = state;
        if (updated is SettingsLoaded) {
          emit(updated.copyWith(isSavingBranchOverride: false));
        }
        return true;
      },
    );
  }

  Future<bool> removeBranchOverride() async {
    final current = state;
    if (current is! SettingsLoaded || current.branchOverrideId == null) {
      return false;
    }

    emit(current.copyWith(isSavingBranchOverride: true, errorMessage: null));

    final result = await _deleteSetting(
      SettingKeys.receiptFooterText,
      branchId: current.branchOverrideId,
    );

    return await result.fold(
      (f) async {
        emit(
          current.copyWith(
            isSavingBranchOverride: false,
            errorMessage: f.message,
          ),
        );
        return false;
      },
      (_) async {
        await selectBranchForOverrides(current.branchOverrideId);
        final updated = state;
        if (updated is SettingsLoaded) {
          emit(updated.copyWith(isSavingBranchOverride: false));
        }
        return true;
      },
    );
  }

  Future<bool> createTaxRate({
    required String name,
    required String rate,
    bool isCompound = false,
  }) async {
    final current = state;
    if (current is! SettingsLoaded) return false;

    emit(current.copyWith(isSavingTaxRate: true, errorMessage: null));

    final result = await _createTaxRate({
      'name': name,
      'rate': rate,
      'is_compound': isCompound,
    });

    return result.fold(
      (f) {
        emit(current.copyWith(isSavingTaxRate: false, errorMessage: f.message));
        return false;
      },
      (created) {
        emit(
          current.copyWith(
            taxRates: [...current.taxRates, created],
            isSavingTaxRate: false,
            errorMessage: null,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> updateTaxRateActive(String id, bool isActive) async {
    final current = state;
    if (current is! SettingsLoaded) return false;

    emit(current.copyWith(isSavingTaxRate: true, errorMessage: null));

    final result = await _updateTaxRate(id, {'is_active': isActive});
    return result.fold(
      (f) {
        emit(current.copyWith(isSavingTaxRate: false, errorMessage: f.message));
        return false;
      },
      (updated) {
        final taxRates = current.taxRates
            .map((t) => t.id == updated.id ? updated : t)
            .toList();
        emit(
          current.copyWith(
            taxRates: taxRates,
            isSavingTaxRate: false,
            errorMessage: null,
          ),
        );
        return true;
      },
    );
  }

  void clearError() => _mutateLoaded((s) => s.copyWith(errorMessage: null));

  void _mutateLoaded(SettingsLoaded Function(SettingsLoaded) mutate) {
    final current = state;
    if (current is SettingsLoaded) {
      emit(mutate(current));
    }
  }
}
