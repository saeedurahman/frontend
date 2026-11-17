import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:go_router/go_router.dart';

/// Settings > Devices (owner only): the short code each counter puts in front
/// of its receipt numbers, e.g. `C1` makes `C1-0042`.
class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key, this.api});

  final DevicesApi? api;

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late final DevicesApi _api = widget.api ?? sl<DevicesApi>();
  List<Map<String, dynamic>> _devices = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await _api.list();
      if (!mounted) return;
      setState(() {
        _devices = rows;
        _loading = false;
      });
    } on ReceiptApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.offline ? 'You are offline. Devices can only be seen while online.' : e.message;
      });
    }
  }

  Future<void> _edit(Map<String, dynamic> device) async {
    final controller = TextEditingController(text: '${device['short_code'] ?? ''}');
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Counter code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This code starts every receipt number made on this counter, '
              'for example C1 gives C1-0042. Each counter needs its own code.',
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('short-code-field'),
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Code (letters and numbers)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            key: const Key('short-code-save'),
            onPressed: () => Navigator.pop(ctx, controller.text.trim().toUpperCase()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (code == null || code.isEmpty || !mounted) return;
    if (!RegExp(r'^[A-Z0-9]{1,6}$').hasMatch(code)) {
      _snack('Use only letters and numbers, up to 6 characters.');
      return;
    }
    try {
      await _api.setShortCode('${device['id']}', code);
      _snack('Saved. New receipts on that counter use $code.');
      await _load();
    } on ReceiptApiException catch (e) {
      if (e.code == 'short_code_taken' || e.status == 409) {
        _snack('Another counter already uses "$code". Please choose a different code.');
      } else {
        _snack(e.message);
      }
    }
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Devices'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, key: const Key('devices-error')),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _load, child: const Text('Try again')),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      'Each counter (computer) has a short code that appears in its receipt numbers.',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    if (_devices.isEmpty)
                      const Card(child: ListTile(title: Text('No devices yet.'))),
                    for (final d in _devices)
                      Card(
                        key: Key('device-${d['id']}'),
                        child: ListTile(
                          leading: const Icon(Icons.point_of_sale),
                          title: Text('${d['name'] ?? d['label'] ?? 'Counter'}'),
                          subtitle: Text(
                            'Code: ${d['short_code'] ?? '—'}'
                            '${d['revoked_at'] != null ? ' · removed' : ''}',
                          ),
                          trailing: TextButton(
                            key: Key('edit-code-${d['id']}'),
                            onPressed: d['revoked_at'] != null ? null : () => _edit(d),
                            child: const Text('Change code'),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
