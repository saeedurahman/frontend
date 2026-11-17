import 'package:flutter/material.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';

/// "Does the price on your items already include tax?" asked right after the
/// business type, in plain words.
class TaxPricingQuestion extends StatelessWidget {
  const TaxPricingQuestion({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaxPricingChoice value;
  final ValueChanged<TaxPricingChoice> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('tax-pricing-question'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Does the price on your items already include tax?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          'You can change this later in Settings > Tax & Prices.',
          style: TextStyle(fontSize: 12.5),
        ),
        RadioGroup<TaxPricingChoice>(
          groupValue: value,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          child: Column(
            children: [
              for (final choice in TaxPricingChoice.values)
                RadioListTile<TaxPricingChoice>(
                  key: Key('tax-choice-${choice.name}'),
                  value: choice,
                  title: Text(choice.label),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
