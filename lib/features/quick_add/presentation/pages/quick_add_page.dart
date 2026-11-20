import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/barcode_scanner_service.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/quick_add/data/feedback_sound.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_state.dart';
import 'package:frantend/features/quick_add/presentation/widgets/quick_add_dialogs.dart';
import 'package:frantend/features/quick_add/presentation/widgets/quick_add_grid.dart';
import 'package:frantend/features/quick_add/presentation/widgets/quick_add_header.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:go_router/go_router.dart';

/// Quick Add by Scan: scan barcodes, see a row per item, save everything at
/// once. [cubit], [scanner] and [sound] exist so tests can supply fakes.
class QuickAddPage extends StatelessWidget {
  const QuickAddPage({
    super.key,
    this.cubit,
    this.scanner,
    this.sound,
    this.startInPurchaseMode = false,
    this.clock,
  });

  final QuickAddCubit? cubit;
  final BarcodeScannerService? scanner;
  final FeedbackSoundService? sound;

  /// Opened from Purchases ("Receive by scanning").
  final bool startInPurchaseMode;

  /// Time source of the scanner-echo filter (tests pin it).
  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    final view = _QuickAddView(
      clock: clock ?? DateTime.now,
      scanner: scanner ??
          (sl.isRegistered<BarcodeScannerService>() ? sl<BarcodeScannerService>() : null),
      sound: sound ??
          (sl.isRegistered<FeedbackSoundService>()
              ? sl<FeedbackSoundService>()
              : const NoFeedbackSound()),
    );
    if (cubit != null) {
      return BlocProvider<QuickAddCubit>.value(value: cubit!, child: view);
    }
    return BlocProvider<QuickAddCubit>(
      create: (_) {
        final c = sl<QuickAddCubit>();
        unawaited(c.start().then((_) {
          if (startInPurchaseMode) c.setMode(QuickAddMode.purchase);
        }));
        return c;
      },
      child: view,
    );
  }
}

class _QuickAddView extends StatefulWidget {
  const _QuickAddView({required this.scanner, required this.sound, required this.clock});

  final DateTime Function() clock;
  final BarcodeScannerService? scanner;
  final FeedbackSoundService sound;

  @override
  State<_QuickAddView> createState() => _QuickAddViewState();
}

class _QuickAddViewState extends State<_QuickAddView> {
  final _registry = QuickAddFocusRegistry();
  final _scanController = TextEditingController();
  final _scanNode = FocusNode(debugLabel: 'quick-add-scan');
  StreamSubscription<String>? _scanSub;
  bool _allowPop = false;
  bool _resumeOpen = false;
  bool _summaryOpen = false;
  late bool _soundOn = widget.sound.enabled;

  String? _lastCode;
  DateTime _lastAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    final scanner = widget.scanner;
    if (scanner != null) {
      scanner.start();
      _scanSub = scanner.scans.listen(_onScannerBurst);
    }
    // A draft found before this screen was on show (the cubit was started
    // early) would otherwise never be offered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<QuickAddCubit>();
      final waiting = cubit.state.restorable;
      if (waiting != null) _showResume(cubit, waiting);
    });
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _scanController.dispose();
    _scanNode.dispose();
    _registry.dispose();
    super.dispose();
  }

  /// The wedge scanner typed a whole code. While the scan field has the focus
  /// its own Enter handles it (so it is not counted twice); with the focus
  /// elsewhere the digits landed in a cell, which is told to forget them.
  void _onScannerBurst(String code) {
    if (_scanNode.hasFocus) return;
    _registry.notifyScanBurst();
    _scan(code);
  }

  void _scan(String raw) {
    final code = raw.trim();
    if (code.isEmpty) return;
    final now = widget.clock();
    if (code == _lastCode && now.difference(_lastAt) < const Duration(milliseconds: 400)) {
      return;
    }
    _lastCode = code;
    _lastAt = now;
    context.read<QuickAddCubit>().scan(code);
  }

  Future<void> _save() async {
    final cubit = context.read<QuickAddCubit>();
    // Let the cell being edited hand over its text first.
    FocusManager.instance.primaryFocus?.unfocus();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    if (!mounted) return;
    await cubit.save();
  }

  void _toggleSound() {
    final next = !_soundOn;
    setState(() => _soundOn = next);
    unawaited(widget.sound.setEnabled(next));
  }

  void _playFor(ScanTone tone) {
    widget.sound.play(tone == ScanTone.success ? FeedbackSound.success : FeedbackSound.error);
  }

  Future<void> _showResume(QuickAddCubit cubit, int items) async {
    if (_resumeOpen) return;
    _resumeOpen = true;
    final resume = await showQuickAddResume(context, items);
    _resumeOpen = false;
    if (!mounted) return;
    if (resume == true) {
      cubit.resumeDraft();
    } else {
      await cubit.discardDraft();
    }
  }

  Future<void> _showSummary(QuickAddCubit cubit, QuickAddSummary summary) async {
    if (_summaryOpen) return;
    _summaryOpen = true;
    final choice = await showQuickAddSummary(context, summary);
    _summaryOpen = false;
    if (!mounted) return;
    cubit.dismissSummary();
    if (choice == SummaryChoice.review) {
      setState(() => _allowPop = true);
      context.go(RouteNames.products);
    }
  }

  Future<void> _onPopBlocked(QuickAddCubit cubit) async {
    final rows = cubit.state.rows.length;
    final leave = await confirmLeaveQuickAdd(context, rows);
    if (!leave || !mounted) return;
    await cubit.flushDraft();
    if (!mounted) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuickAddCubit>();
    final canCreate = hasPermission(context, Perm.productsCreate);
    final canOpening = canCreate && hasPermission(context, Perm.inventoryAdjust);
    final canPurchase = canCreate &&
        hasPermission(context, Perm.purchasesCreate) &&
        hasPermission(context, Perm.purchasesReceive);
    final readOnly = isReadOnlyMode(context);

    if (!canOpening && !canPurchase) {
      return const _NoAccess();
    }

    // A mode the user may not use is never left selected (also covers a cubit
    // that finished loading before this screen appeared).
    final mode = cubit.state.mode;
    if ((mode == QuickAddMode.openingStock && !canOpening && canPurchase) ||
        (mode == QuickAddMode.purchase && !canPurchase && canOpening)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        cubit.setMode(canOpening ? QuickAddMode.openingStock : QuickAddMode.purchase);
      });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<QuickAddCubit, QuickAddState>(
          listenWhen: (a, b) => a.feedback?.token != b.feedback?.token && b.feedback != null,
          listener: (context, s) => _playFor(s.feedback!.tone),
        ),
        BlocListener<QuickAddCubit, QuickAddState>(
          listenWhen: (a, b) => a.undoToast != b.undoToast && b.undoToast != null,
          listener: (context, s) {
            final messenger = ScaffoldMessenger.maybeOf(context);
            messenger
              ?..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(s.undoToast!.message),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(label: 'Undo', onPressed: cubit.undo),
              ));
          },
        ),
        BlocListener<QuickAddCubit, QuickAddState>(
          listenWhen: (a, b) => a.restorable != b.restorable && b.restorable != null,
          listener: (context, s) => _showResume(cubit, s.restorable!),
        ),
        BlocListener<QuickAddCubit, QuickAddState>(
          listenWhen: (a, b) => a.summary != b.summary && b.summary != null,
          listener: (context, s) => _showSummary(cubit, s.summary!),
        ),
        // A mode the user may not use is never left selected.
        BlocListener<QuickAddCubit, QuickAddState>(
          listenWhen: (a, b) => a.loading != b.loading || a.mode != b.mode,
          listener: (context, s) {
            if (s.mode == QuickAddMode.openingStock && !canOpening && canPurchase) {
              cubit.setMode(QuickAddMode.purchase);
            } else if (s.mode == QuickAddMode.purchase && !canPurchase && canOpening) {
              cubit.setMode(QuickAddMode.openingStock);
            }
          },
        ),
      ],
      child: BlocBuilder<QuickAddCubit, QuickAddState>(
        buildWhen: (a, b) => a.rows.isEmpty != b.rows.isEmpty || a.loading != b.loading,
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return PopScope(
            canPop: state.rows.isEmpty || _allowPop,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) unawaited(_onPopBlocked(cubit));
            },
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
                    unawaited(_save()),
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TitleRow(onClear: () async {
                      final n = cubit.state.rows.length;
                      if (n == 0) return;
                      if (await confirmClearList(context, n)) await cubit.clearAll();
                    }),
                    const SizedBox(height: 8),
                    QuickAddHeader(
                      scanController: _scanController,
                      scanNode: _scanNode,
                      onScanText: _scan,
                      onSave: () => unawaited(_save()),
                      canOpeningStock: canOpening,
                      canPurchase: canPurchase,
                      canSave: !readOnly,
                      soundOn: _soundOn,
                      onToggleSound: _toggleSound,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: QuickAddGrid(registry: _registry, scanNode: _scanNode),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back to products',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(true);
            } else {
              context.go(RouteNames.products);
            }
          },
        ),
        const SizedBox(width: 4),
        Text('Quick Add (Scan)', style: Theme.of(context).textTheme.headlineSmall),
        const Spacer(),
        BlocSelector<QuickAddCubit, QuickAddState, bool>(
          selector: (s) => s.rows.isNotEmpty,
          builder: (context, any) => TextButton.icon(
            icon: const Icon(Icons.delete_sweep_outlined, size: 18),
            label: const Text('Clear list'),
            onPressed: any ? onClear : null,
          ),
        ),
      ],
    );
  }
}

class _NoAccess extends StatelessWidget {
  const _NoAccess();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text('You cannot use Quick Add', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text(
            'It needs permission to add products and to add stock. '
            'Ask the owner to give you access.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
