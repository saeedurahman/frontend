import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/quick_add/data/feedback_sound.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_settings_cubit.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// Settings > Quick Add, in plain words.
class QuickAddSettingsPage extends StatelessWidget {
  const QuickAddSettingsPage({super.key, this.cubit, this.sound});

  final QuickAddSettingsCubit? cubit;
  final FeedbackSoundService? sound;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuickAddSettingsCubit>(
      create: (_) =>
          (cubit ??
              QuickAddSettingsCubit(
                repository: sl<QuickAddRepository>(),
                bulkUpdate: sl<BulkUpdateSettingsUseCase>(),
              ))
            ..load(),
      child: _View(
        sound: sound ??
            (sl.isRegistered<FeedbackSoundService>()
                ? sl<FeedbackSoundService>()
                : const NoFeedbackSound()),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View({required this.sound});

  final FeedbackSoundService sound;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _margin = TextEditingController();
  bool _marginSeeded = false;
  late bool _soundOn = widget.sound.enabled;

  @override
  void dispose() {
    _margin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuickAddSettingsCubit>();
    final canEdit = hasPermission(context, Perm.settingsManage);
    return BlocConsumer<QuickAddSettingsCubit, QuickAddSettingsState>(
      listener: (context, state) {
        if (state.justSaved) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(content: Text('Quick Add settings saved')),
          );
        }
      },
      builder: (context, state) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (!_marginSeeded) {
          _margin.text = state.marginText;
          _marginSeeded = true;
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('Quick Add', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                const Text(
                  'How the "Quick Add (Scan)" screen behaves when you add stock by scanning.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                if (!canEdit)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'Only the owner can change these. You can see what is set.',
                      style: TextStyle(color: AppColors.warning),
                    ),
                  ),
                const SizedBox(height: 16),
                SwitchListTile(
                  key: const ValueKey('qa-ask-cost'),
                  title: const Text('Ask for the cost price'),
                  subtitle: const Text(
                    'After the name, Enter jumps to the price you paid. Switch off to go straight to the sale price.',
                  ),
                  value: state.draft.askCost,
                  onChanged: canEdit ? cubit.setAskCost : null,
                ),
                SwitchListTile(
                  key: const ValueKey('qa-ask-expiry'),
                  title: const Text('Ask for batch and expiry date'),
                  subtitle: const Text(
                    'For medicines and food. Items that expire always ask, even when this is off.',
                  ),
                  value: state.draft.askExpiry,
                  onChanged: canEdit ? cubit.setAskExpiry : null,
                ),
                const Divider(height: 32),
                Text('Suggested sale price', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                const Text(
                  'When you type a cost, the sale price is filled in for you: the cost plus your margin. '
                  'You can always change it.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: TextField(
                        key: const ValueKey('qa-margin'),
                        controller: _margin,
                        enabled: canEdit,
                        decoration: InputDecoration(
                          labelText: 'Margin',
                          suffixText: '%',
                          errorText: state.marginValid ? null : 'Type a number from 0 to 1000',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        onChanged: cubit.setMargin,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 240,
                      child: DropdownButtonFormField<String>(
                        key: const ValueKey('qa-rounding'),
                        isExpanded: true,
                        initialValue: state.draft.rounding,
                        decoration: const InputDecoration(labelText: 'Round the price to'),
                        items: const [
                          DropdownMenuItem(value: 'none', child: Text('Exact (no rounding)')),
                          DropdownMenuItem(value: 'nearest_1', child: Text('Nearest 1')),
                          DropdownMenuItem(value: 'nearest_5', child: Text('Nearest 5')),
                          DropdownMenuItem(value: 'nearest_10', child: Text('Nearest 10')),
                        ],
                        onChanged: canEdit ? (v) => cubit.setRounding(v ?? 'nearest_1') : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calculate_outlined, size: 18, color: AppColors.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.example,
                          key: const ValueKey('qa-example'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                SwitchListTile(
                  key: const ValueKey('qa-sound'),
                  title: const Text('Beep after each scan'),
                  subtitle: const Text('Only on this computer. Turn it off in a quiet shop.'),
                  value: _soundOn,
                  onChanged: (v) {
                    setState(() => _soundOn = v);
                    widget.sound.setEnabled(v);
                  },
                ),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(state.error!, style: const TextStyle(color: AppColors.error)),
                  ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    key: const ValueKey('qa-save'),
                    onPressed: canEdit && state.dirty && state.marginValid && !state.saving
                        ? cubit.save
                        : null,
                    child: Text(state.saving ? 'Saving...' : 'Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
