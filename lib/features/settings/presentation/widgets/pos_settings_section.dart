import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/storage/preferences_storage.dart';

/// Settings > POS: how the counter screen behaves on this device.
class PosSettingsSection extends StatefulWidget {
  const PosSettingsSection({super.key, this.preferences});

  /// Defaults to the registered [PreferencesStorage].
  final PreferencesStorage? preferences;

  @override
  State<PosSettingsSection> createState() => _PosSettingsSectionState();
}

class _PosSettingsSectionState extends State<PosSettingsSection> {
  late final PreferencesStorage _prefs =
      widget.preferences ?? sl<PreferencesStorage>();
  late bool _askQuantity = _prefs.getAskQuantityOnTap();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('POS', style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          child: SwitchListTile(
            key: const Key('pos-ask-quantity'),
            secondary: const Icon(Icons.calculate_outlined, color: AppColors.primary),
            title: const Text('Ask quantity on product tap'),
            subtitle: const Text(
              'Tapping a product opens the quantity calculator. When off, a '
              'tap adds one unit. Barcode scans always add one unit.',
            ),
            value: _askQuantity,
            onChanged: (value) async {
              setState(() => _askQuantity = value);
              await _prefs.setAskQuantityOnTap(value);
            },
          ),
        ),
      ],
    );
  }
}
