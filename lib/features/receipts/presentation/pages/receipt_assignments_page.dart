import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// Which layout each kind of receipt uses (printed, WhatsApp, public link),
/// for the whole business, with an optional different choice per branch.
class ReceiptAssignmentsPage extends StatelessWidget {
  const ReceiptAssignmentsPage({
    super.key,
    this.store,
    this.api,
    this.isOnline,
    this.branches,
  });

  final ReceiptLayoutStore? store;
  final ReceiptLayoutApi? api;
  final bool Function()? isOnline;

  /// Branches as `{id, name}`; defaults to the pulled `branch` entities.
  final Future<List<Map<String, String>>> Function()? branches;

  @override
  Widget build(BuildContext context) {
    if (!hasPermission(context, Perm.settingsManage)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Where each layout is used')),
        body: const Center(
          child: Text("You don't have permission to change receipt layouts."),
        ),
      );
    }
    return BlocProvider(
      create: (_) => ReceiptLayoutsCubit(
        store: store ?? sl<ReceiptLayoutStore>(),
        api: api ?? sl<ReceiptLayoutApi>(),
        isOnline: isOnline ?? () => sl<ConnectivityProbe>().isReachable,
      )..load(),
      child: _AssignmentsView(branches: branches ?? _localBranches),
    );
  }

  static Future<List<Map<String, String>>> _localBranches() async {
    final rows = await sl<SyncStore>().entities('branch');
    return [
      for (final r in rows)
        {'id': '${r['id']}', 'name': '${r['name'] ?? r['id']}'},
    ];
  }
}

class _AssignmentsView extends StatefulWidget {
  const _AssignmentsView({required this.branches});

  final Future<List<Map<String, String>>> Function() branches;

  @override
  State<_AssignmentsView> createState() => _AssignmentsViewState();
}

class _AssignmentsViewState extends State<_AssignmentsView> {
  List<Map<String, String>> _branches = const [];

  @override
  void initState() {
    super.initState();
    widget.branches().then((b) {
      if (mounted) setState(() => _branches = b);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiptLayoutsCubit, ReceiptLayoutsState>(
      listenWhen: (a, b) => a.error != b.error || a.notice != b.notice,
      listener: (context, state) {
        final text = state.error ?? state.notice;
        if (text != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
          context.read<ReceiptLayoutsCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReceiptLayoutsCubit>();
        final active = [for (final l in state.layouts) if (l.isActive) l];
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Where each layout is used')),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (!state.online)
                      Card(
                        key: const Key('assignments-offline-notice'),
                        color: Colors.amber.shade100,
                        child: const ListTile(
                          leading: Icon(Icons.cloud_off),
                          title: Text(ReceiptLayoutsCubit.offlineMessage),
                        ),
                      ),
                    Text(
                      'Pick the layout each kind of receipt uses. '
                      'A branch can use a different layout from the rest of the business.',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    for (final channel in ReceiptChannel.values) ...[
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(channel.title, style: AppTextStyles.titleMedium),
                              Text(_help(channel), style: AppTextStyles.bodySmall),
                              const SizedBox(height: 12),
                              _Picker(
                                key: Key('assign-${channel.code}'),
                                label: 'Whole business',
                                value: state.defaultFor(channel)?.id,
                                layouts: active,
                                allowNone: false,
                                enabled: state.online && !state.busy,
                                onChanged: (id) => cubit.assign(channel, id),
                              ),
                              for (final b in _branches) ...[
                                const SizedBox(height: 8),
                                _Picker(
                                  key: Key('assign-${channel.code}-${b['id']}'),
                                  label: 'Branch: ${b['name']}',
                                  value: state.overrideFor(channel, b['id']!)?.id,
                                  layouts: active,
                                  allowNone: true,
                                  enabled: state.online && !state.busy,
                                  onChanged: (id) =>
                                      cubit.assign(channel, id, branchId: b['id']),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }

  static String _help(ReceiptChannel c) => switch (c) {
        ReceiptChannel.print => 'Used when you print a receipt or save it as a PDF.',
        ReceiptChannel.whatsapp => 'Used for the text sent on WhatsApp.',
        ReceiptChannel.link => 'Used for the receipt page a customer opens from a link.',
      };
}

class _Picker extends StatelessWidget {
  const _Picker({
    super.key,
    required this.label,
    required this.value,
    required this.layouts,
    required this.allowNone,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<ReceiptLayout> layouts;
  final bool allowNone;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final known = layouts.any((l) => l.id == value);
    return DropdownButtonFormField<String?>(
      initialValue: known ? value : null,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: [
        if (allowNone || !known)
          DropdownMenuItem<String?>(
            value: null,
            child: Text(allowNone ? 'Same as the business' : 'Choose a layout'),
          ),
        for (final l in layouts) DropdownMenuItem<String?>(value: l.id, child: Text(l.name)),
      ],
      onChanged: enabled
          ? (id) {
              if (id == value) return;
              if (id == null && !allowNone) return;
              onChanged(id);
            }
          : null,
    );
  }
}
