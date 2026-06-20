import 'package:frantend/features/settings/data/models/app_setting_model.dart';

abstract final class SettingKeys {
  static const receiptFooterText = 'receipt.footer_text';
  static const receiptPaperSize = 'receipt.paper_size';
  static const receiptShowTax = 'receipt.show_tax';
  static const receiptShowLogo = 'receipt.show_logo';
  static const businessLogoUrl = 'business.logo_url';
}

abstract final class SettingsValueUtils {
  static String? extractValue(Map<String, dynamic>? settingValue) {
    if (settingValue == null) return null;
    final value = settingValue['value'];
    if (value == null) return null;
    return value.toString();
  }

  static Map<String, dynamic> wrapValue(dynamic value) => {'value': value};

  static String? valueForKey(
    List<AppSettingModel> settings,
    String key, {
    String? branchId,
  }) {
    if (branchId != null) {
      for (final s in settings) {
        if (s.settingKey == key && s.branchId == branchId) {
          return extractValue(s.settingValue);
        }
      }
    }
    for (final s in settings) {
      if (s.settingKey == key && s.branchId == null) {
        return extractValue(s.settingValue);
      }
    }
    return null;
  }

  static bool hasBranchOverride(
    List<AppSettingModel> settings,
    String key,
    String branchId,
  ) {
    return settings.any(
      (s) => s.settingKey == key && s.branchId == branchId,
    );
  }
}
