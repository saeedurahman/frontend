import 'package:dlibphonenumber/dlibphonenumber.dart' as dlib;
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/phone_input.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

/// Reusable phone field with country picker and inline validation.
class AppPhoneNoField extends StatefulWidget {
  const AppPhoneNoField({
    super.key,
    this.controller,
    this.initialCountryCode = 'PK',
    this.initialFullNumber,
    this.onChanged,
    this.validator,
    this.disableLengthCheck = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.labelText,
    this.borderRadius,
    this.borderColor,
  });

  final TextEditingController? controller;
  final String? initialCountryCode;
  final String? initialFullNumber;
  final ValueChanged<PhoneNumber>? onChanged;
  final String? Function(PhoneNumber?)? validator;
  final bool disableLengthCheck;
  final AutovalidateMode? autovalidateMode;
  final String? labelText;
  final double? borderRadius;
  final Color? borderColor;

  @override
  State<AppPhoneNoField> createState() => _AppPhoneNoFieldState();
}

class _AppPhoneNoFieldState extends State<AppPhoneNoField> {
  late final TextEditingController _controller;
  late String _countryCode;
  String? _hintText;
  String _dialCode = '92';
  String? _trunkPrefix = '0';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _countryCode = widget.initialCountryCode ?? 'PK';
    _loadExampleHint(_countryCode);
    _loadDialInfo(_countryCode);
    _parseInitialNumber();
  }

  void _parseInitialNumber() {
    final full = widget.initialFullNumber;
    if (full == null || full.isEmpty) return;

    try {
      final util = dlib.PhoneNumberUtil.instance;
      final parsed = util.parse(full, _countryCode);
      _countryCode = util.getRegionCodeForCountryCode(parsed.countryCode);
      _loadDialInfo(_countryCode);
      _controller.text = parsed.nationalNumber.toString();
      _loadExampleHint(_countryCode);
    } catch (_) {
      // Keep defaults if parsing fails.
    }
  }

  void _loadDialInfo(String iso) {
    try {
      final util = dlib.PhoneNumberUtil.instance;
      _dialCode = util.getCountryCodeForRegion(iso).toString();
      final ndd = util.getNddPrefixForRegion(iso, true);
      _trunkPrefix = (ndd == null || ndd.isEmpty) ? null : ndd;
    } catch (_) {
      // Keep the previous dial code / trunk prefix.
    }
  }

  void _loadExampleHint(String iso) {
    try {
      final util = dlib.PhoneNumberUtil.instance;
      final example = util.getExampleNumber(iso);
      if (example != null) {
        _hintText = example.nationalNumber.toString();
      }
    } catch (_) {
      _hintText = null;
    }
  }

  String? _lengthError(PhoneNumber? phone) {
    final n = phone?.number ?? '';
    final max = PhoneInput.maxE164Digits - _dialCode.length;
    return n.length >= 7 && n.length <= max ? null : 'Invalid Mobile Number';
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppDimensions.radiusMd;
    final borderColor = widget.borderColor ?? AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        FormField<PhoneNumber>(
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
                  controller: _controller,
                  initialCountryCode: _countryCode,
                  // The library cap counts a typed 0 / pasted +92 and cut the
                  // last digit; length is checked on normalised digits below.
                  disableLengthCheck: true,
                  inputFormatters: [
                    NationalPhoneFormatter(
                      dialCode: _dialCode,
                      trunkPrefix: _trunkPrefix,
                    ),
                  ],
                  validator: widget.disableLengthCheck ? null : _lengthError,
                  autovalidateMode: widget.autovalidateMode,
                  dropdownIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.transparent,
                    size: 0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.inputFill,
                    hintText: _hintText ?? '300 1234567',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: AppTextStyles.bodyMedium,
                  onCountryChanged: (country) {
                    setState(() {
                      _countryCode = country.code;
                      _loadExampleHint(_countryCode);
                      _loadDialInfo(_countryCode);
                    });
                  },
                  onChanged: (phone) {
                    widget.onChanged?.call(phone);
                    state.didChange(phone);
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 6),
                    child: Text(
                      state.errorText!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
