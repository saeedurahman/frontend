import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

/// A calculator keypad that edits [controller]. Digits, a decimal point,
/// + − × ÷, backspace, clear and "=" (turns a sum into the amount).
class MoneyKeypad extends StatelessWidget {
  const MoneyKeypad({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onEquals,
  });

  final TextEditingController controller;

  /// Called after every key with the new text.
  final ValueChanged<String> onChanged;

  /// "=" pressed: the owner wants a sum worked out.
  final VoidCallback onEquals;

  void _set(String text) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    onChanged(text);
  }

  void _digit(String d) {
    final text = controller.text;
    if (d == '.') {
      // One point per number.
      final lastNumber = text.split(RegExp(r'[+\-×÷]')).last;
      if (lastNumber.contains('.')) return;
      _set(lastNumber.isEmpty ? '${text}0.' : '$text.');
      return;
    }
    _set('$text$d');
  }

  void _operator(String op) {
    final text = controller.text;
    if (text.isEmpty) return;
    final last = text[text.length - 1];
    if ('+-×÷'.contains(last)) {
      _set('${text.substring(0, text.length - 1)}$op');
    } else {
      _set('$text$op');
    }
  }

  void _back() {
    final text = controller.text;
    if (text.isEmpty) return;
    _set(text.substring(0, text.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    Widget key(
      String label, {
      VoidCallback? onTap,
      Color? color,
      Color? textColor,
      IconData? icon,
      String? semantic,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Semantics(
            button: true,
            label: semantic ?? label,
            child: Material(
              color: color ?? AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Container(
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: icon != null
                      ? Icon(icon, size: 20, color: textColor ?? AppColors.textPrimary)
                      : Text(
                          label,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: textColor ?? AppColors.textPrimary,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget digit(String d) => key(d, onTap: () => _digit(d));
    Widget op(String o) => key(
          o,
          onTap: () => _operator(o),
          color: AppColors.primary.withValues(alpha: 0.08),
          textColor: AppColors.primary,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [digit('7'), digit('8'), digit('9'), op('÷')]),
        Row(children: [digit('4'), digit('5'), digit('6'), op('×')]),
        Row(children: [digit('1'), digit('2'), digit('3'), op('-')]),
        Row(children: [digit('0'), digit('.'), key('Backspace', icon: Icons.backspace_outlined, onTap: _back), op('+')]),
        Row(
          children: [
            key('Clear', onTap: () => _set(''), textColor: AppColors.error),
            key(
              '=',
              onTap: onEquals,
              color: AppColors.primary,
              textColor: AppColors.textOnPrimary,
            ),
          ],
        ),
      ],
    );
  }
}
