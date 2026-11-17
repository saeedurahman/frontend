import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text field whose text lives in a cubit/state, without the classic bug of
/// rebuilding the controller from state on every emit.
///
/// The `TextEditingController` is owned by this widget's State: created once in
/// `initState`, disposed in `dispose`, never replaced in `build`. When the
/// widget is rebuilt with a new [value] it only writes to the controller if
/// the text really differs **and the user is not typing in it**, and then it
/// puts the cursor at the end. So typing "730" gives "7", "73", "730" no matter
/// how often the state is emitted in between. A field that is not focused
/// (a row that was removed, a form that was reloaded or cleared) follows the
/// state; a field that loses focus is normalised to the state's value.
class SyncedTextField extends StatefulWidget {
  const SyncedTextField({
    super.key,
    required this.value,
    this.onChanged,
    this.onSubmitted,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.style,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
  });

  /// The text the state holds for this field.
  final String value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool? enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final TextAlign textAlign;
  final TextStyle? style;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  @override
  State<SyncedTextField> createState() => _SyncedTextFieldState();
}

class _SyncedTextFieldState extends State<SyncedTextField> {
  late final TextEditingController _controller;
  FocusNode? _ownFocus;

  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _write(widget.value);
    _focus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant SyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocus)?.removeListener(_onFocusChange);
      _focus.addListener(_onFocusChange);
    }
    if (widget.value != _controller.text && !_focus.hasFocus) {
      _write(widget.value);
    }
  }

  void _onFocusChange() {
    if (!_focus.hasFocus && widget.value != _controller.text) {
      setState(() => _write(widget.value));
    }
  }

  void _write(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _ownFocus?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focus,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      textAlign: widget.textAlign,
      style: widget.style,
      textCapitalization: widget.textCapitalization,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}

/// Keeps only the characters of a number: digits, an optional single decimal
/// point (up to [decimals] places) and, if allowed, a leading minus. Removes
/// leading-zero artefacts ("007" becomes "7", "00.5" becomes "0.5") and turns
/// a lone "." into "0.".
class NumberInputFormatter extends TextInputFormatter {
  const NumberInputFormatter({
    this.allowDecimal = true,
    this.allowNegative = false,
    this.decimals = 4,
  });

  final bool allowDecimal;
  final bool allowNegative;
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text;
    final buf = StringBuffer();
    var seenDot = false;
    var negative = false;
    for (var i = 0; i < raw.length; i++) {
      final c = raw[i];
      if (c == '-' && allowNegative && buf.isEmpty && !negative) {
        negative = true;
        buf.write(c);
      } else if (c == '.' && allowDecimal && !seenDot) {
        seenDot = true;
        buf.write(c);
      } else if (c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57) {
        buf.write(c);
      }
    }
    var text = buf.toString();
    var sign = '';
    if (text.startsWith('-')) {
      sign = '-';
      text = text.substring(1);
    }
    var intPart = text;
    var frac = '';
    final dot = text.indexOf('.');
    if (dot >= 0) {
      intPart = text.substring(0, dot);
      frac = text.substring(dot + 1);
      if (frac.length > decimals) frac = frac.substring(0, decimals);
    }
    // No leading zeros ("007" -> "7"), but keep a single "0" before a point.
    intPart = intPart.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    if (dot >= 0 && intPart.isEmpty) intPart = '0';
    final out = '$sign$intPart${dot >= 0 ? '.$frac' : ''}';
    if (out == raw) return newValue;
    // The caret stays after what the user just typed (at the end when the
    // change was a plain append, which is the case for typing).
    final fromEnd = raw.length - newValue.selection.end.clamp(0, raw.length);
    final offset = (out.length - fromEnd).clamp(0, out.length);
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

/// A numeric [SyncedTextField]: number keyboard and [NumberInputFormatter].
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    required this.value,
    this.onChanged,
    this.onSubmitted,
    this.decoration = const InputDecoration(),
    this.allowDecimal = true,
    this.allowNegative = false,
    this.decimals = 4,
    this.enabled,
    this.readOnly = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.style,
    this.focusNode,
    this.textInputAction,
  });

  final String value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final InputDecoration decoration;
  final bool allowDecimal;
  final bool allowNegative;
  final int decimals;
  final bool? enabled;
  final bool readOnly;
  final bool autofocus;
  final TextAlign textAlign;
  final TextStyle? style;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return SyncedTextField(
      value: value,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: decoration,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal, signed: allowNegative),
      inputFormatters: [
        NumberInputFormatter(allowDecimal: allowDecimal, allowNegative: allowNegative, decimals: decimals),
      ],
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      textAlign: textAlign,
      style: style,
      focusNode: focusNode,
      textInputAction: textInputAction,
    );
  }
}
