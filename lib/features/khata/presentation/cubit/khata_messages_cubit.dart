import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/message_template.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_settings_text.dart';

enum TemplateKind { reminder, statement }

class KhataMessagesState {
  const KhataMessagesState({
    this.loading = true,
    this.error,
    this.saved = const KhataSettings(),
    this.reminder = MessageTemplate.defaultReminder,
    this.statement = MessageTemplate.defaultStatement,
    this.showItems = true,
    this.terms = '0',
    this.tab = TemplateKind.reminder,
    this.saving = false,
    this.revision = 0,
  });

  final bool loading;
  final String? error;

  /// What the server holds.
  final KhataSettings saved;
  final String reminder;
  final String statement;
  final bool showItems;
  final String terms;
  final TemplateKind tab;
  final bool saving;

  /// Grows when the app rewrites a template, so the field takes it.
  final int revision;

  String get template =>
      tab == TemplateKind.reminder ? reminder : statement;

  TemplateProblem? get problem => MessageTemplate.check(template);

  int? get termsDays {
    final days = int.tryParse(terms.trim());
    return days == null || days < 0 || days > 3650 ? null : days;
  }

  bool get isValid =>
      MessageTemplate.check(reminder) == null &&
      MessageTemplate.check(statement) == null &&
      termsDays != null;

  /// Only what differs from the saved settings.
  Map<String, Object?> get changes => {
        if (reminder != saved.reminderTemplate)
          KhataSettings.reminderTemplateKey: reminder,
        if (statement != saved.statementTemplate)
          KhataSettings.statementTemplateKey: statement,
        if (showItems != saved.showItems)
          KhataSettings.showItemsKey: showItems,
        if (termsDays != null && termsDays != saved.defaultTermsDays)
          KhataSettings.termsKey: termsDays,
      };

  bool get dirty => changes.isNotEmpty || termsDays != saved.defaultTermsDays;

  /// The message as a customer would receive it.
  String get preview {
    Decimal money(String v) => Decimal.parse(v);
    final facts = MessageFacts(
      partyType: PartyType.customer,
      party: KhataSettingsText.samplePartyName,
      business: saved.businessName.isEmpty
          ? KhataSettingsText.sampleBusinessName
          : saved.businessName,
      due: money('12500'),
      periodLabel: KhataSettingsText.samplePeriod,
      opening: money('8000'),
      charges: money('6500'),
      payments: money('2000'),
      bills: [
        (
          name: 'INV-0012',
          date: DateTime(2026, 10, 13),
          remaining: money('8000'),
          ageDays: 45,
        ),
        (
          name: 'INV-0031',
          date: DateTime(2026, 11, 20),
          remaining: money('4500'),
          ageDays: 7,
        ),
      ],
      payMethods: saved.paymentInstructions,
      businessPhone: saved.businessPhone,
    );
    return MessageTemplate.render(
      template,
      facts.values(link: KhataSettingsText.sampleLink),
    );
  }

  KhataMessagesState copyWith({
    KhataSettings? saved,
    String? reminder,
    String? statement,
    bool? showItems,
    String? terms,
    TemplateKind? tab,
    bool? saving,
    bool rewritten = false,
  }) =>
      KhataMessagesState(
        loading: false,
        saved: saved ?? this.saved,
        reminder: reminder ?? this.reminder,
        statement: statement ?? this.statement,
        showItems: showItems ?? this.showItems,
        terms: terms ?? this.terms,
        tab: tab ?? this.tab,
        saving: saving ?? this.saving,
        revision: rewritten ? revision + 1 : revision,
      );
}

class KhataMessagesCubit extends Cubit<KhataMessagesState> {
  KhataMessagesCubit(this._repository) : super(const KhataMessagesState());

  final KhataRepository _repository;

  bool get isOnline => _repository.isOnline;

  Future<void> load() async {
    emit(const KhataMessagesState());
    final result = await _repository.settingsForEdit();
    if (isClosed) return;
    emit(
      result.fold(
        (f) => KhataMessagesState(loading: false, error: f.message),
        (s) => KhataMessagesState(
          loading: false,
          saved: s,
          reminder: s.reminderTemplate,
          statement: s.statementTemplate,
          showItems: s.showItems,
          terms: '${s.defaultTermsDays}',
          revision: 1,
        ),
      ),
    );
  }

  void setTab(TemplateKind tab) {
    if (tab != state.tab) emit(state.copyWith(tab: tab, rewritten: true));
  }

  void editTemplate(String text) => emit(
        state.tab == TemplateKind.reminder
            ? state.copyWith(reminder: text)
            : state.copyWith(statement: text),
      );

  void resetTemplate() => emit(
        state.tab == TemplateKind.reminder
            ? state.copyWith(
                reminder: MessageTemplate.defaultReminder,
                rewritten: true,
              )
            : state.copyWith(
                statement: MessageTemplate.defaultStatement,
                rewritten: true,
              ),
      );

  void setShowItems(bool value) => emit(state.copyWith(showItems: value));

  void setTerms(String value) => emit(state.copyWith(terms: value));

  /// Null when saved, otherwise the sentence to show.
  Future<String?> save() async {
    final changes = state.changes;
    if (state.saving || !state.isValid || changes.isEmpty) return null;
    final sent = state;
    emit(state.copyWith(saving: true));
    final result = await _repository.saveSettings(changes);
    if (isClosed) return null;
    return result.fold(
      (f) {
        emit(state.copyWith(saving: false));
        return f.message;
      },
      (_) {
        emit(
          state.copyWith(
            saving: false,
            saved: KhataSettings(
              reminderTemplate: sent.reminder,
              statementTemplate: sent.statement,
              showItems: sent.showItems,
              showPoweredBy: sent.saved.showPoweredBy,
              defaultTermsDays: sent.termsDays!,
              paymentInstructions: sent.saved.paymentInstructions,
              businessName: sent.saved.businessName,
              businessPhone: sent.saved.businessPhone,
              countryCode: sent.saved.countryCode,
            ),
          ),
        );
        return null;
      },
    );
  }
}
