import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/message_template.dart';

/// The `khata.*` settings and the payment details, with the server's defaults.
class KhataSettings {
  const KhataSettings({
    this.statementTemplate = MessageTemplate.defaultStatement,
    this.reminderTemplate = MessageTemplate.defaultReminder,
    this.showItems = true,
    this.showPoweredBy = true,
    this.defaultTermsDays = 0,
    this.paymentInstructions = const [],
    this.businessName = '',
    this.businessPhone,
    this.countryCode,
  });

  static const paymentsKey = 'business.payment_instructions';
  static const statementTemplateKey = 'khata.statement_template';
  static const reminderTemplateKey = 'khata.reminder_template';
  static const showItemsKey = 'khata.statement_show_items';
  static const showPoweredByKey = 'khata.statement_show_powered_by';
  static const termsKey = 'khata.default_customer_terms_days';

  static const maxPaymentInstructions = 10;

  /// [settings] maps a setting key to its value, plain or `{"value": ...}`.
  factory KhataSettings.fromMap(
    Map<String, dynamic> settings, {
    String businessName = '',
    String? businessPhone,
    String? countryCode,
  }) {
    Object? read(String key) {
      final raw = settings[key];
      return raw is Map && raw.containsKey('value') ? raw['value'] : raw;
    }

    String template(String key, String fallback) {
      final v = read(key);
      return v is String && v.trim().isNotEmpty ? v : fallback;
    }

    bool flag(String key) {
      final v = read(key);
      if (v is bool) return v;
      return '$v'.toLowerCase() != 'false';
    }

    return KhataSettings(
      statementTemplate: template(
        statementTemplateKey,
        MessageTemplate.defaultStatement,
      ),
      reminderTemplate: template(
        reminderTemplateKey,
        MessageTemplate.defaultReminder,
      ),
      showItems: flag(showItemsKey),
      showPoweredBy: flag(showPoweredByKey),
      defaultTermsDays: int.tryParse('${read(termsKey) ?? 0}') ?? 0,
      paymentInstructions: PaymentInstruction.list(read(paymentsKey)),
      businessName: businessName,
      businessPhone: businessPhone,
      countryCode: countryCode,
    );
  }

  final String statementTemplate;
  final String reminderTemplate;

  /// Show line items in statements.
  final bool showItems;
  final bool showPoweredBy;

  /// Days a customer has to pay (0: due on the bill date).
  final int defaultTermsDays;
  final List<PaymentInstruction> paymentInstructions;
  final String businessName;
  final String? businessPhone;
  final String? countryCode;
}
