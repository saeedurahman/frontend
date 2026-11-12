import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/offline/offline_policy.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';

/// Settings > Offline: how the counter behaves without the server.
class OfflineSettingsSection extends StatefulWidget {
  const OfflineSettingsSection({super.key});

  @override
  State<OfflineSettingsSection> createState() => _OfflineSettingsSectionState();
}

class _OfflineSettingsSectionState extends State<OfflineSettingsSection> {
  final _prefs = sl<PreferencesStorage>();
  bool _below = true;
  bool _details = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _details = _prefs.getShowSyncDetails();
    sl<OfflinePolicy>().allowSellBelowStock().then((v) {
      if (mounted) setState(() => _below = v);
    });
  }

  Future<void> _resync() async {
    final engine = sl<SyncEngine>();
    final counts = await sl<SyncStore>().counts();
    if (!mounted) return;
    if (counts.unfinished > 0) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          key: const Key('resync-blocked'),
          title: const Text("Can't resync yet"),
          content: Text(
            'You still have ${counts.unfinished} change(s) that have not been '
            'sent to the server. Sync them (or discard them) first - '
            'downloading everything again would replace this device\'s data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('resync-confirm'),
        title: const Text('Resync all data?'),
        content: const Text(
          'Products, prices, customers and stock are downloaded again. The '
          'POS is unavailable until it finishes, and needs an internet '
          'connection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Resync'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await engine.resyncAll();
    } on PendingWorkException {
      // Raced with a new sale: nothing was touched.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = sl<AccessCubit>().state.access.isOwner ||
        sl<AccessCubit>().state.can('settings.manage');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Offline', style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              SwitchListTile(
                key: const Key('allow-below-stock'),
                secondary: const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                title: const Text('Allow selling below stock'),
                subtitle: const Text(
                  'Warn instead of blocking when the recorded stock is too low. '
                  'Offline, stock numbers can be out of date.',
                ),
                value: _below,
                onChanged: canEdit
                    ? (v) async {
                        setState(() => _below = v);
                        await _prefs.setAllowBelowStock(v);
                      }
                    : null,
              ),
              SwitchListTile(
                key: const Key('show-sync-details'),
                secondary: const Icon(Icons.info_outline, color: AppColors.primary),
                title: const Text('Show sync details'),
                subtitle: const Text('Technical details on the Sync page'),
                value: _details,
                onChanged: (v) async {
                  setState(() => _details = v);
                  await _prefs.setShowSyncDetails(v);
                },
              ),
              ListTile(
                key: const Key('resync-all'),
                leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.primary),
                title: const Text('Resync all data'),
                subtitle: const Text('Download products, prices and customers again'),
                trailing: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: _busy ? null : _resync,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
