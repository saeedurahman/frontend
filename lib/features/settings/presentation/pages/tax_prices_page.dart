import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/settings/data/tax_preview_remote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/tax/tax_settings_store.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/features/pos/domain/utils/line_price_breakdown.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/cubit/tax_prices_cubit.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/core/utils/currency_label.dart';

/// Settings > Tax & Prices, in plain words for shop owners.
class TaxPricesPage extends StatelessWidget {
  const TaxPricesPage({
    super.key,
    this.cubit,
    this.probe,
  });

  /// Tests pass their own cubit; the app builds it from the service locator.
  final TaxPricesCubit? cubit;
  final ConnectivityProbe? probe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaxPricesCubit>(
      create: (_) =>
          (cubit ??
              TaxPricesCubit(
                getTaxRates: sl<GetTaxRatesUseCase>(),
                bulkUpdate: sl<BulkUpdateSettingsUseCase>(),
                store: sl<TaxSettingsStore>(),
                previewFetcher: TaxPreviewRemote(sl<DioClient>()).fetch,
              ))
            ..load(),
      child: TaxPricesView(probe: probe),
    );
  }
}

class TaxPricesView extends StatefulWidget {
  const TaxPricesView({super.key, this.probe});

  final ConnectivityProbe? probe;

  @override
  State<TaxPricesView> createState() => _TaxPricesViewState();
}

class _TaxPricesViewState extends State<TaxPricesView> {
  late final TextEditingController _label;

  @override
  void initState() {
    super.initState();
    _label = TextEditingController(
      text: context.read<TaxPricesCubit>().state.draft.label,
    );
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  static List<(String, String, String)> get _roundingOptions => [
    ('none', 'Exact amount', 'Charge the exact amount, with paisa. $currencyLabel 1,234.56'),
    ('nearest_1', 'Nearest $currencyLabel 1', 'Round the bill to the nearest rupee. 1,234.56 becomes 1,235'),
    ('nearest_5', 'Nearest $currencyLabel 5', 'Round the bill to the nearest 5 rupees. 1,234.56 becomes 1,235'),
    ('nearest_10', 'Nearest $currencyLabel 10', 'Round the bill to the nearest 10 rupees. 1,234.56 becomes 1,230'),
  ];

  Future<void> _save(BuildContext context) async {
    final cubit = context.read<TaxPricesCubit>();
    if (cubit.labelError != null) return;
    if (cubit.state.needsWarning) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          key: const Key('tax-change-warning'),
          title: const Text('Change how prices work?'),
          content: const Text(
            'This applies to NEW sales only. Old sales and reports will not change.',
          ),
          actions: [
            TextButton(
              key: const Key('tax-warning-cancel'),
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('tax-warning-confirm'),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes, change it'),
            ),
          ],
        ),
      );
      if (ok != true || !context.mounted) return;
    }
    final saved = await cubit.save();
    if (!context.mounted) return;
    if (saved) {
      AppAlerts.showSuccessMessage(context, 'Tax & price settings saved');
    } else if (cubit.state.error != null) {
      AppAlerts.showErrorMessage(context, cubit.state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OfflineAwareBuilder(
      probe: widget.probe,
      builder: (context, offline) => PermissionGate(
        permission: Perm.settingsManage,
        mode: GateMode.disable,
        mutating: true,
        builder: (context, allowed) {
          final editable = allowed && !offline;
          return BlocBuilder<TaxPricesCubit, TaxPricesState>(
            builder: (context, state) {
              final cubit = context.read<TaxPricesCubit>();
              if (state.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              final d = state.draft;
              return ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  if (offline) ...[
                    const OnlineOnlyBanner(
                      message: OfflineMessages.editingNotice,
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text('Tax & Prices', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose how tax works in your shop. Changes apply to new sales.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    key: const Key('tax-enabled'),
                    title: const Text('My business charges tax'),
                    value: d.enabled,
                    onChanged: editable ? cubit.setEnabled : null,
                  ),
                  if (d.enabled) ...[
                    const Divider(),
                    Text('How are your prices set?',
                        style: AppTextStyles.titleMedium),
                    RadioGroup<bool>(
                      groupValue: d.includeTax,
                      onChanged: (v) {
                        if (editable && v != null) cubit.setIncludeTax(v);
                      },
                      child: const Column(
                        children: [
                          RadioListTile<bool>(
                            key: Key('tax-mode-inclusive'),
                            value: true,
                            title: Text('Prices include tax'),
                            subtitle: Text(
                              'The price on the shelf is what the customer pays. Tax is already inside it.',
                            ),
                          ),
                          RadioListTile<bool>(
                            key: Key('tax-mode-exclusive'),
                            value: false,
                            title: Text('Tax is added on top'),
                            subtitle: Text(
                              'The customer pays the shelf price plus tax.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ExampleCard(example: state.example, label: d.label),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        key: const Key('tax-label'),
                        controller: _label,
                        enabled: editable,
                        maxLength: 30,
                        decoration: InputDecoration(
                          labelText: 'Tax name on bills',
                          helperText: 'For example GST or Sales Tax',
                          errorText: cubit.labelError,
                        ),
                        onChanged: cubit.setLabel,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String?>(
                        key: const Key('tax-default-rate'),
                        isExpanded: true,
                        initialValue: state.rates.any((r) => r.id == d.defaultRateId)
                            ? d.defaultRateId
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Tax rate for items without their own rate',
                        ),
                        items: [
                          for (final r in state.rates)
                            DropdownMenuItem<String?>(
                              value: r.id,
                              child: Text(
                                '${r.name} (${LinePriceBreakdown.rateText((Decimal.tryParse(r.rate) ?? Decimal.zero))}%)',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: editable ? cubit.setDefaultRate : null,
                      ),
                    ),
                    SwitchListTile(
                      key: const Key('tax-show-breakdown'),
                      title: const Text('Show tax on the receipt'),
                      value: d.showBreakdown,
                      onChanged: editable ? cubit.setShowBreakdown : null,
                    ),
                  ],
                  const Divider(),
                  Text('Rounding the bill', style: AppTextStyles.titleMedium),
                  RadioGroup<String>(
                    groupValue: d.roundingMode,
                    onChanged: (v) {
                      if (editable && v != null) cubit.setRounding(v);
                    },
                    child: Column(
                      children: [
                        for (final o in _roundingOptions)
                          RadioListTile<String>(
                            key: Key('tax-rounding-${o.$1}'),
                            value: o.$1,
                            title: Text(o.$2),
                            subtitle: Text(o.$3),
                          ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    key: const Key('tax-hide-zero'),
                    title: const Text('Hide .00 on whole amounts'),
                    subtitle: Text('$currencyLabel 6.00 shows as $currencyLabel 6. '
                        '$currencyLabel 7.02 stays $currencyLabel 7.02.'),
                    value: d.hideZeroDecimals,
                    onChanged: editable ? cubit.setHideZero : null,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      key: const Key('tax-save'),
                      onPressed: editable && state.dirty && !state.saving
                          ? () => _save(context)
                          : null,
                      child: Text(state.saving ? 'Saving...' : 'Save'),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example, required this.label});

  final TaxExample? example;
  final String label;

  @override
  Widget build(BuildContext context) {
    final e = example;
    if (e == null) return const SizedBox.shrink();
    final rate = LinePriceBreakdown.rateText(e.rate);
    final lines = e.inclusive
        ? [
            'Item price: ${formatPKR(e.price)}',
            'Customer pays: ${formatPKR(e.total)}',
            '(includes $label $rate%: ${formatPKR(e.tax)})',
          ]
        : [
            'Item price: ${formatPKR(e.price)}',
            '$label $rate%: ${formatPKR(e.tax)}',
            'Customer pays: ${formatPKR(e.total)}',
          ];
    return Container(
      key: const Key('tax-example'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Example', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          for (final l in lines) Text(l),
        ],
      ),
    );
  }
}
