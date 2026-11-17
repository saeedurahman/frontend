import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/domain/utils/line_price_breakdown.dart';
import 'package:frantend/features/pos/domain/utils/tax_rate_resolver.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

/// The "Tax" section of the product form: which tax rate this item uses (or
/// the business default), a tax-free switch and a small worked example.
class ProductTaxCard extends StatelessWidget {
  const ProductTaxCard({
    super.key,
    required this.state,
    required this.cubit,
    required this.rates,
  });

  final ProductFormState state;
  final ProductFormCubit cubit;
  final List<TaxRateModel> rates;

  static const useDefault = 'use-business-default';

  TaxRateModel? get _defaultRate =>
      TaxRateResolver.defaultRateOf(TaxSettingsHolder.current, rates);

  String _rateName(TaxRateModel r) =>
      '${r.name} (${LinePriceBreakdown.rateText(Decimal.tryParse(r.rate) ?? Decimal.zero)}%)';

  @override
  Widget build(BuildContext context) {
    final tax = TaxSettingsHolder.current;
    final def = _defaultRate;
    final selected = rates.where((r) => r.id == state.taxRateId).firstOrNull;
    final dropdownValue = selected?.id ?? useDefault;

    return Card(
      key: const Key('product-tax-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Tax', style: AppTextStyles.titleMedium),
            const SizedBox(height: 12),
            if (!tax.enabled)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Your business is set to not charge tax, so these choices will not change any bill.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            DropdownButtonFormField<String>(
              key: const Key('product-tax-rate'),
              isExpanded: true,
              initialValue: dropdownValue,
              decoration: const InputDecoration(labelText: 'Tax rate'),
              items: [
                DropdownMenuItem(
                  value: useDefault,
                  child: Text(
                    def == null
                        ? 'Use business default'
                        : 'Use business default (${_rateName(def)})',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final r in rates)
                  DropdownMenuItem(
                    value: r.id,
                    child: Text(_rateName(r), overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: state.isTaxExempt
                  ? null
                  : (v) => cubit.updateTaxRateId(v == useDefault ? null : v),
            ),
            SwitchListTile(
              key: const Key('product-tax-exempt'),
              contentPadding: EdgeInsets.zero,
              title: const Text('This item is tax-free'),
              subtitle: const Text('No tax is added or counted for this item.'),
              value: state.isTaxExempt,
              onChanged: cubit.updateIsTaxExempt,
            ),
            const SizedBox(height: 8),
            _Preview(state: state, rate: selected ?? def),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.state, required this.rate});

  final ProductFormState state;
  final TaxRateModel? rate;

  @override
  Widget build(BuildContext context) {
    final tax = TaxSettingsHolder.current;
    final typed = Decimal.tryParse(state.retailUnitPrice ?? '');
    final price =
        (typed != null && typed > Decimal.zero) ? typed : Decimal.fromInt(100);
    final rateValue = (rate == null || state.isTaxExempt || !tax.enabled)
        ? Decimal.zero
        : (Decimal.tryParse(rate!.rate) ?? Decimal.zero);
    final lines = LinePriceBreakdown.lines(
      qty: Decimal.one,
      unitPrice: price,
      taxRate: rateValue,
      tax: tax,
    );
    return Container(
      key: const Key('product-tax-preview'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Example for ${formatPKR(price)}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          if (lines.isEmpty)
            const Text('No tax on this item.')
          else
            for (final l in lines) Text(l),
        ],
      ),
    );
  }
}
