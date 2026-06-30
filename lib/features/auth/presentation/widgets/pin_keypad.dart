import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';

class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.pinLength,
    required this.onDigit,
    required this.onBackspace,
    this.maxLength = 6,
    this.enabled = true,
  });

  final int pinLength;
  final int maxLength;
  final bool enabled;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PinDots(length: pinLength, maxLength: maxLength),
        const SizedBox(height: AppDimensions.spacingLg),
        _KeypadGrid(
          enabled: enabled,
          onDigit: onDigit,
          onBackspace: onBackspace,
        ),
      ],
    );
  }
}

class _PinDots extends StatelessWidget {
  const _PinDots({required this.length, required this.maxLength});

  final int length;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final filled = index < length;
        return Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: filled ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

class _KeypadGrid extends StatelessWidget {
  const _KeypadGrid({
    required this.enabled,
    required this.onDigit,
    required this.onBackspace,
  });

  final bool enabled;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key.isEmpty) {
                return const SizedBox(width: 72, height: 56);
              }
              if (key == '⌫') {
                return _KeyButton(
                  label: key,
                  enabled: enabled,
                  onPressed: onBackspace,
                );
              }
              return _KeyButton(
                label: key,
                enabled: enabled,
                onPressed: () => onDigit(key),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.onPressed,
    required this.enabled,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: SizedBox(
            width: 72,
            height: 56,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: label == '⌫' ? 22 : 24,
                  fontWeight: FontWeight.w600,
                  color: enabled
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool isValidPinLength(int length) => length >= 4 && length <= 6;

bool isValidPin(String pin) =>
    isValidPinLength(pin.length) && RegExp(r'^\d+$').hasMatch(pin);
