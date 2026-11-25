import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/quick_add/domain/expiry_parser.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_state.dart';

/// Fixed row height: lets the list build only what is on screen (100 scans
/// stay smooth) and lets us scroll to any row by arithmetic.
const double kQuickAddRowHeight = 54;

/// Who owns the focus nodes of the grid, so the cubit's "focus this cell"
/// requests can be carried out.
class QuickAddFocusRegistry {
  final Map<String, FocusNode> _nodes = {};
  final Map<String, FocusNode> _rowNodes = {};
  final ValueNotifier<int> scanBurst = ValueNotifier<int>(0);

  FocusNode cell(String rowId, QuickAddField field) =>
      _nodes.putIfAbsent('$rowId/${field.name}', () => FocusNode(debugLabel: '$rowId/${field.name}'));

  FocusNode row(String rowId) => _rowNodes.putIfAbsent(
      rowId, () => FocusNode(debugLabel: 'row $rowId', skipTraversal: true));

  FocusNode? existingCell(String rowId, QuickAddField field) => _nodes['$rowId/${field.name}'];

  /// A scanner burst landed in a cell: the cell must forget the typed digits.
  void notifyScanBurst() => scanBurst.value++;

  void prune(Set<String> liveRowIds) {
    _nodes.removeWhere((key, node) {
      final id = key.substring(0, key.indexOf('/'));
      if (liveRowIds.contains(id)) return false;
      node.dispose();
      return true;
    });
    _rowNodes.removeWhere((id, node) {
      if (liveRowIds.contains(id)) return false;
      node.dispose();
      return true;
    });
  }

  void dispose() {
    for (final n in _nodes.values) {
      n.dispose();
    }
    for (final n in _rowNodes.values) {
      n.dispose();
    }
    scanBurst.dispose();
  }
}

class _Cols {
  static const barcode = 150.0;
  static const name = 240.0;
  static const brand = 120.0;
  static const unit = 110.0;
  static const category = 150.0;
  static const qty = 84.0;
  static const cost = 96.0;
  static const price = 110.0;
  static const batch = 110.0;
  static const expiry = 112.0;
  static const status = 170.0;
  static const delete = 48.0;

  static double total(bool batchExpiry) =>
      barcode + name + brand + unit + category + qty + cost + price +
      (batchExpiry ? batch + expiry : 0) + status + delete + 24;
}

class QuickAddGrid extends StatefulWidget {
  const QuickAddGrid({super.key, required this.registry, required this.scanNode});

  final QuickAddFocusRegistry registry;
  final FocusNode scanNode;

  @override
  State<QuickAddGrid> createState() => _QuickAddGridState();
}

class _QuickAddGridState extends State<QuickAddGrid> {
  final ScrollController _vertical = ScrollController();
  final ScrollController _horizontal = ScrollController();

  @override
  void dispose() {
    _vertical.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  void _applyFocus(QuickAddState state, FocusRequest request) {
    if (request.isScan) {
      widget.scanNode.requestFocus();
      return;
    }
    final index = state.rows.indexWhere((r) => r.id == request.rowId);
    if (index < 0) {
      widget.scanNode.requestFocus();
      return;
    }
    if (_vertical.hasClients) {
      final target = index * kQuickAddRowHeight;
      final pos = _vertical.position;
      if (target < pos.pixels || target + kQuickAddRowHeight > pos.pixels + pos.viewportDimension) {
        _vertical.jumpTo(target.clamp(0.0, pos.maxScrollExtent));
      }
    }
    // The row may not be built until the jump is laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final field = request.field;
      final node = field == null
          ? widget.registry.row(request.rowId!)
          : widget.registry.existingCell(request.rowId!, field);
      (node ?? widget.scanNode).requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuickAddCubit, QuickAddState>(
      listenWhen: (a, b) => a.focus != b.focus,
      listener: (context, state) => _applyFocus(state, state.focus),
      child: BlocBuilder<QuickAddCubit, QuickAddState>(
        buildWhen: (a, b) =>
            a.rows != b.rows ||
            a.settings != b.settings ||
            a.mode != b.mode ||
            a.options != b.options ||
            a.highlightRowId != b.highlightRowId ||
            a.validated != b.validated,
        builder: (context, state) {
          widget.registry.prune({for (final r in state.rows) r.id});
          if (state.rows.isEmpty) return const _EmptyGrid();
          final batchExpiry = state.showBatchExpiry;
          return LayoutBuilder(
            builder: (context, box) {
              final width = _Cols.total(batchExpiry) > box.maxWidth
                  ? _Cols.total(batchExpiry)
                  : box.maxWidth;
              return Scrollbar(
                controller: _horizontal,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: width,
                    child: Column(
                      children: [
                        _HeaderRow(batchExpiry: batchExpiry, purchase: state.mode == QuickAddMode.purchase),
                        Expanded(
                          child: ListView.builder(
                            controller: _vertical,
                            itemExtent: kQuickAddRowHeight,
                            itemCount: state.rows.length,
                            itemBuilder: (context, i) {
                              final row = state.rows[i];
                              return _RowView(
                                key: ValueKey(row.id),
                                row: row,
                                state: state,
                                registry: widget.registry,
                                batchExpiry: batchExpiry,
                                highlighted: state.highlightRowId == row.id,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyGrid extends StatelessWidget {
  const _EmptyGrid();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_scanner, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text('Scan your first item', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text(
            'Point the scanner at a barcode. Each scan adds a row here.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.batchExpiry, required this.purchase});

  final bool batchExpiry;
  final bool purchase;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textSecondary);
    Widget h(String text, double w) =>
        SizedBox(width: w, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(text, style: style)));
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          h('Barcode', _Cols.barcode),
          h('Name', _Cols.name),
          h('Brand', _Cols.brand),
          h('Unit', _Cols.unit),
          h('Category', _Cols.category),
          h('Qty', _Cols.qty),
          h(purchase ? 'Cost paid' : 'Cost', _Cols.cost),
          h('Sale price', _Cols.price),
          if (batchExpiry) ...[h('Batch', _Cols.batch), h('Expiry', _Cols.expiry)],
          h('Status', _Cols.status),
          const SizedBox(width: _Cols.delete),
        ],
      ),
    );
  }
}

class _RowView extends StatelessWidget {
  const _RowView({
    super.key,
    required this.row,
    required this.state,
    required this.registry,
    required this.batchExpiry,
    required this.highlighted,
  });

  final QuickAddRow row;
  final QuickAddState state;
  final QuickAddFocusRegistry registry;
  final bool batchExpiry;
  final bool highlighted;

  Color _tint() => switch (row.status) {
        RowStatus.known => AppColors.success.withValues(alpha: 0.10),
        RowStatus.newReady => AppColors.info.withValues(alpha: 0.09),
        RowStatus.needsName => const Color(0xFFF6AD55).withValues(alpha: 0.22),
        RowStatus.error => AppColors.error.withValues(alpha: 0.12),
      };

  Color _edge() => switch (row.status) {
        RowStatus.known => AppColors.success,
        RowStatus.newReady => AppColors.info,
        RowStatus.needsName => const Color(0xFFDD6B20),
        RowStatus.error => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuickAddCubit>();
    final errors = state.validated
        ? QuickAddValidator.validate(row, settings: state.settings, mode: state.mode, now: DateTime.now())
        : const <QuickAddField, String>{};
    String? errorFor(QuickAddField f) =>
        errors[f] ?? (row.error?.field == f ? row.error!.message : null);

    final known = row.isKnown;
    final purchase = state.mode == QuickAddMode.purchase;

    return TweenAnimationBuilder<double>(
      key: ValueKey('pulse-${row.pulse}'),
      tween: Tween(begin: row.pulse > 0 ? 1 : 0, end: 0),
      duration: const Duration(milliseconds: 700),
      builder: (context, pulse, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Color.alphaBlend(AppColors.accent.withValues(alpha: 0.55 * pulse), _tint()),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: _edge(), width: 4)),
          boxShadow: highlighted
              ? [BoxShadow(color: _edge().withValues(alpha: 0.35), blurRadius: 6)]
              : null,
        ),
        child: child,
      ),
      child: Focus(
        focusNode: registry.row(row.id),
        onKeyEvent: (node, event) => _rowKey(context, cubit, event),
        child: Row(
          children: [
            _TextCell(
              width: _Cols.barcode,
              registry: registry,
              rowId: row.id,
              field: QuickAddField.barcode,
              value: row.barcode,
              mono: true,
              warning: row.barcodeWarning ? 'The check digit of this barcode is not right. You can still use it.' : null,
              error: errorFor(QuickAddField.barcode),
              onCommit: (t) => cubit.setText(row.id, QuickAddField.barcode, t),
            ),
            _TextCell(
              width: _Cols.name,
              registry: registry,
              rowId: row.id,
              field: QuickAddField.name,
              value: row.name,
              hint: known ? '' : 'Item name',
              readOnly: known,
              error: errorFor(QuickAddField.name),
              onCommit: (t) => cubit.setText(row.id, QuickAddField.name, t),
              onEnter: () => cubit.enterPressed(row.id, QuickAddField.name),
            ),
            _TextCell(
              width: _Cols.brand,
              registry: registry,
              rowId: row.id,
              field: QuickAddField.brand,
              value: row.brand,
              readOnly: known,
              onCommit: (t) => cubit.setText(row.id, QuickAddField.brand, t),
            ),
            _PickCell(
              width: _Cols.unit,
              label: row.unitLabel,
              placeholder: state.options.defaultUnit?.label ?? 'Unit',
              options: state.options.units,
              readOnly: known,
              error: errorFor(QuickAddField.unit),
              onPick: (o) => cubit.setUnit(row.id, o),
              onCreate: (n) => cubit.setNewUnit(row.id, n),
              isNew: row.newUnitName != null,
              cellKey: ValueKey('qa-unit-${row.id}'),
            ),
            _PickCell(
              width: _Cols.category,
              label: row.categoryLabel,
              placeholder: 'Category',
              options: state.options.categories,
              readOnly: known,
              error: errorFor(QuickAddField.category),
              onPick: (o) => cubit.setCategory(row.id, o),
              onCreate: (n) => cubit.setNewCategory(row.id, n),
              isNew: row.newCategoryName != null,
              cellKey: ValueKey('qa-category-${row.id}'),
            ),
            _TextCell(
              width: _Cols.qty,
              registry: registry,
              rowId: row.id,
              field: QuickAddField.qty,
              value: row.qty.toString(),
              numeric: true,
              error: errorFor(QuickAddField.qty),
              onCommit: (t) => cubit.setText(row.id, QuickAddField.qty, t),
              onEnter: () => cubit.enterPressed(row.id, QuickAddField.qty),
            ),
            _TextCell(
              width: _Cols.cost,
              registry: registry,
              rowId: row.id,
              field: QuickAddField.cost,
              value: row.cost?.toString() ?? '',
              numeric: true,
              hint: purchase ? 'Paid' : '',
              error: errorFor(QuickAddField.cost),
              onCommit: (t) => cubit.setText(row.id, QuickAddField.cost, t),
              onEnter: () => cubit.enterPressed(row.id, QuickAddField.cost),
            ),
            _TextCell(
              width: _Cols.price,
              registry: registry,
              rowId: row.id,
              field: QuickAddField.salePrice,
              value: row.salePrice?.toString() ?? '',
              numeric: true,
              suggested: row.salePriceSuggested,
              error: errorFor(QuickAddField.salePrice),
              onCommit: (t) => cubit.setText(row.id, QuickAddField.salePrice, t),
              onEnter: () => cubit.enterPressed(row.id, QuickAddField.salePrice),
            ),
            if (batchExpiry) ...[
              _TextCell(
                width: _Cols.batch,
                registry: registry,
                rowId: row.id,
                field: QuickAddField.batch,
                value: row.batchNo,
                error: errorFor(QuickAddField.batch),
                onCommit: (t) => cubit.setText(row.id, QuickAddField.batch, t),
                onEnter: () => cubit.enterPressed(row.id, QuickAddField.batch),
              ),
              _TextCell(
                width: _Cols.expiry,
                registry: registry,
                rowId: row.id,
                field: QuickAddField.expiry,
                value: row.expiry == null ? '' : ExpiryParser.format(row.expiry!),
                hint: 'MM/YYYY',
                error: errorFor(QuickAddField.expiry),
                onCommit: (t) => cubit.setExpiryText(row.id, t),
                onEnter: () => cubit.enterPressed(row.id, QuickAddField.expiry),
              ),
            ],
            SizedBox(width: _Cols.status, child: _StatusChip(row: row)),
            SizedBox(
              width: _Cols.delete,
              child: IconButton(
                tooltip: 'Remove this item (Delete)',
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => cubit.deleteRow(row.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KeyEventResult _rowKey(BuildContext context, QuickAddCubit cubit, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    final rowNode = registry.row(row.id);
    // Plain Delete only when the row itself has the focus (not while typing
    // in a cell); Ctrl+Delete works from inside a cell too.
    if (key == LogicalKeyboardKey.delete && (rowNode.hasPrimaryFocus || ctrl)) {
      final rows = state.rows;
      final i = rows.indexWhere((r) => r.id == row.id);
      cubit.deleteRow(row.id);
      if (rows.length > 1) {
        final next = rows[i + 1 < rows.length ? i + 1 : i - 1];
        WidgetsBinding.instance.addPostFrameCallback((_) => registry.row(next.id).requestFocus());
      }
      return KeyEventResult.handled;
    }
    if (rowNode.hasPrimaryFocus) {
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
        final first = QuickAddFlow.firstStop(row, state.settings, state.mode) ?? QuickAddField.qty;
        registry.cell(row.id, first).requestFocus();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.arrowUp) {
        final rows = state.rows;
        final i = rows.indexWhere((r) => r.id == row.id);
        final j = key == LogicalKeyboardKey.arrowDown ? i + 1 : i - 1;
        if (j >= 0 && j < rows.length) {
          cubit.focusRow(rows[j].id);
        } else if (j < 0) {
          cubit.focusScan();
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.row});

  final QuickAddRow row;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (row.status) {
      RowStatus.known => (
          row.currentStock == null ? 'In your shop' : 'In shop · ${row.currentStock} in stock',
          AppColors.success,
          Icons.check_circle_outline,
        ),
      RowStatus.newReady => (
          row.suggestionSource == null ? 'New item' : 'New · filled in',
          AppColors.info,
          Icons.fiber_new_outlined,
        ),
      RowStatus.needsName => ('Type a name', const Color(0xFFDD6B20), Icons.edit_outlined),
      RowStatus.error => (row.error?.message ?? 'Needs a change', AppColors.error, Icons.error_outline),
    };
    return Tooltip(
      message: row.error?.message ?? label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            if (row.lookupPending)
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A text cell. The typed text is kept in the cell and applied when the cell
/// loses the focus or Enter is pressed; Esc puts the old value back and
/// returns to the scan field.
class _TextCell extends StatefulWidget {
  const _TextCell({
    required this.width,
    required this.registry,
    required this.rowId,
    required this.field,
    required this.value,
    required this.onCommit,
    this.onEnter,
    this.numeric = false,
    this.mono = false,
    this.readOnly = false,
    this.suggested = false,
    this.hint = '',
    this.error,
    this.warning,
  });

  final double width;
  final QuickAddFocusRegistry registry;
  final String rowId;
  final QuickAddField field;
  final String value;
  final void Function(String text) onCommit;
  final VoidCallback? onEnter;
  final bool numeric;
  final bool mono;
  final bool readOnly;
  final bool suggested;
  final String hint;
  final String? error;
  final String? warning;

  @override
  State<_TextCell> createState() => _TextCellState();
}

class _TextCellState extends State<_TextCell> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  late final FocusNode _node = widget.registry.cell(widget.rowId, widget.field);
  String _original = '';
  bool _skipCommit = false;

  @override
  void initState() {
    super.initState();
    _original = widget.value;
    _node.addListener(_onFocus);
    widget.registry.scanBurst.addListener(_onScanBurst);
  }

  @override
  void didUpdateWidget(_TextCell old) {
    super.didUpdateWidget(old);
    if (!_node.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    widget.registry.scanBurst.removeListener(_onScanBurst);
    _controller.dispose();
    super.dispose();
  }

  void _onScanBurst() {
    if (_node.hasFocus) _controller.text = widget.value;
  }

  void _onFocus() {
    if (_node.hasFocus) {
      _original = widget.value;
      _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else if (_skipCommit) {
      _skipCommit = false;
    } else {
      _commit();
    }
  }

  void _commit() {
    if (_controller.text != widget.value) widget.onCommit(_controller.text);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _skipCommit = true;
      _controller.text = _original;
      context.read<QuickAddCubit>().focusScan();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.error;
    final color = error != null
        ? AppColors.error
        : widget.warning != null
            ? AppColors.warning
            : null;
    final field = Focus(
      focusNode: null,
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: TextField(
        key: ValueKey('qa-cell-${widget.rowId}-${widget.field.name}'),
        controller: _controller,
        focusNode: _node,
        readOnly: widget.readOnly,
        keyboardType: widget.numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        inputFormatters: widget.numeric ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))] : null,
        style: TextStyle(
          fontSize: 13,
          fontFamily: widget.mono ? 'Consolas' : null,
          fontStyle: widget.suggested ? FontStyle.italic : null,
          color: widget.readOnly ? AppColors.textSecondary : null,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          filled: true,
          fillColor: widget.suggested ? AppColors.accent.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.7),
          suffixIcon: widget.suggested
              ? const Tooltip(
                  message: 'Suggested price. Press Enter to accept it, or type your own.',
                  child: Icon(Icons.auto_awesome, size: 14, color: AppColors.accentDark),
                )
              : (color != null ? Icon(Icons.warning_amber_rounded, size: 14, color: color) : null),
          suffixIconConstraints: const BoxConstraints(minWidth: 22, minHeight: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: color ?? AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: color ?? AppColors.border),
          ),
        ),
        onEditingComplete: () {},
        onSubmitted: (_) {
          _commit();
          _skipCommit = true;
          final enter = widget.onEnter;
          if (enter != null) {
            enter();
          } else {
            context.read<QuickAddCubit>().focusScan();
          }
        },
      ),
    );
    return SizedBox(
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Tooltip(
          message: error ?? widget.warning ?? '',
          waitDuration: const Duration(milliseconds: 300),
          child: field,
        ),
      ),
    );
  }
}

class _PickCell extends StatelessWidget {
  const _PickCell({
    required this.width,
    required this.label,
    required this.placeholder,
    required this.options,
    required this.onPick,
    this.onCreate,
    this.isNew = false,
    this.cellKey,
    this.readOnly = false,
    this.error,
  });

  final double width;
  final Key? cellKey;

  /// Typing a name the shop does not have offers "Create 'name'".
  final void Function(String name)? onCreate;

  /// The label is a name the server will create when saving.
  final bool isNew;
  final String? label;
  final String placeholder;
  final List<PickOption> options;
  final bool readOnly;
  final String? error;
  final void Function(PickOption? option) onPick;

  @override
  Widget build(BuildContext context) {
    final text = (label == null || label!.isEmpty) ? placeholder : label!;
    final isPlaceholder = label == null || label!.isEmpty;
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          key: cellKey,
          borderRadius: BorderRadius.circular(6),
          onTap: readOnly || (options.isEmpty && onCreate == null)
              ? null
              : () async {
                  final picked = await showQuickAddPicker(
                    context,
                    title: placeholder,
                    options: options,
                    allowClear: !isPlaceholder,
                    createNoun: onCreate == null ? null : placeholder.toLowerCase(),
                  );
                  if (picked == null) return;
                  if (picked.newName != null) {
                    onCreate?.call(picked.newName!);
                  } else {
                    onPick(picked.option);
                  }
                },
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: error != null ? AppColors.error : AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isNew ? '$text (new)' : text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isPlaceholder || readOnly ? AppColors.textSecondary : null,
                    ),
                  ),
                ),
                if (!readOnly) const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PickResult {
  const PickResult(this.option, {this.newName});
  final PickOption? option;

  /// "Create 'Strip'": a name the shop does not have yet.
  final String? newName;
}

/// A searchable list. Enter picks the first match, so it works from the keyboard.
Future<PickResult?> showQuickAddPicker(
  BuildContext context, {
  required String title,
  required List<PickOption> options,
  bool allowClear = false,

  /// "unit" / "category": typing a name that is not in the list then offers
  /// "Create 'name'". Null: pick from the list only.
  String? createNoun,
}) {
  return showDialog<PickResult>(
    context: context,
    builder: (_) => _PickerDialog(
      title: title,
      options: options,
      allowClear: allowClear,
      createNoun: createNoun,
    ),
  );
}

class _PickerDialog extends StatefulWidget {
  const _PickerDialog({
    required this.title,
    required this.options,
    required this.allowClear,
    this.createNoun,
  });

  final String? createNoun;
  final String title;
  final List<PickOption> options;
  final bool allowClear;

  @override
  State<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends State<_PickerDialog> {
  String _query = '';

  List<PickOption> get _matches {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.options;
    return widget.options.where((o) => o.label.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final typed = _query.trim();
    // "Create 'Strip'" appears for a name that is not in the list yet.
    final canCreate = widget.createNoun != null &&
        typed.isNotEmpty &&
        !widget.options.any((o) => o.label.toLowerCase() == typed.toLowerCase());
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 380,
        height: 380,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search'),
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: (text) {
                // Read the latest text, not the last build's (Enter can arrive
                // before the next frame).
                _query = text;
                final now = _matches;
                final name = text.trim();
                if (now.isNotEmpty) {
                  Navigator.pop(context, PickResult(now.first));
                } else if (widget.createNoun != null && name.isNotEmpty) {
                  Navigator.pop(context, PickResult(null, newName: name));
                }
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  if (canCreate)
                    ListTile(
                      key: const ValueKey('quick-add-create-option'),
                      dense: true,
                      leading: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                      title: Text("Create '$typed'"),
                      subtitle: Text('Adds this new ${widget.createNoun} when you save'),
                      onTap: () => Navigator.pop(context, PickResult(null, newName: typed)),
                    ),
                  if (matches.isEmpty && !canCreate)
                    const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Nothing found'))),
                  for (final m in matches)
                    ListTile(
                      dense: true,
                      title: Text(m.label),
                      onTap: () => Navigator.pop(context, PickResult(m)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.allowClear)
          TextButton(onPressed: () => Navigator.pop(context, const PickResult(null)), child: const Text('Clear')),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ],
    );
  }
}
