import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/presentation/cubit/close_shift_cubit.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class CloseShiftPage extends StatelessWidget {
  const CloseShiftPage({
    super.key,
    required this.shiftId,
    required this.summary,
    required this.registerName,
  });

  final String shiftId;
  final ShiftSummaryModel summary;
  final String registerName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CloseShiftCubit>()
        ..init(
          shiftId: shiftId,
          summary: summary,
          registerName: registerName,
        ),
      child: const _CloseShiftView(),
    );
  }
}

class _CloseShiftView extends StatelessWidget {
  const _CloseShiftView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CloseShiftCubit, CloseShiftState>(
      listener: (context, state) {
        if (state.closedSummary != null) {
          AppAlerts.showSuccessMessage(
            context,
            'Shift closed — ${ShiftFormatUtils.varianceLabel(state.closedSummary!.cashDifferenceDecimal)}',
          );
        }
      },
      builder: (context, state) {
        if (state.closedSummary != null) {
          return _ClosedSummaryView(summary: state.closedSummary!);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        'Close Shift — ${state.registerName ?? ''}',
                        style: AppTextStyles.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Expected Cash'),
                        Text(
                          ShiftFormatUtils.formatMoneyDecimal(state.expectedCash),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    autofocus: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Closing Cash Count *',
                      border: OutlineInputBorder(),
                      helperText:
                          'Count all cash in the drawer and enter the total here',
                    ),
                    onChanged: context.read<CloseShiftCubit>().setActualCash,
                  ),
                  const SizedBox(height: 16),
                  VarianceDisplay(variance: state.variance, large: true),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: const OutlineInputBorder(),
                      helperText: state.hasVariance
                          ? 'Recommended — explain the discrepancy'
                          : 'Optional',
                      enabledBorder: state.hasVariance
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.warning),
                            )
                          : null,
                    ),
                    onChanged: context.read<CloseShiftCubit>().setNotes,
                  ),
                  if (state.hasVariance && !state.confirmedVariance) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "There's a ${ShiftFormatUtils.varianceLabel(state.variance)} variance. "
                            'Close shift anyway?',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  context.read<CloseShiftCubit>().confirmVariance(),
                              child: const Text('Yes, close with variance'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state.submitError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      state.submitError!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      SecondaryButton(
                        label: 'Cancel',
                        onPressed: state.isSubmitting ? null : () => context.pop(),
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: 'Confirm & Close Shift',
                        fullWidth: false,
                        isLoading: state.isSubmitting,
                        onPressed: state.canSubmit
                            ? () => _submit(context)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    final response = await context.read<CloseShiftCubit>().submit();
    if (!context.mounted || response == null) return;
  }
}

class _ClosedSummaryView extends StatelessWidget {
  const _ClosedSummaryView({required this.summary});

  final ShiftSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Shift Closed', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          VarianceDisplay(
            variance: summary.cashDifferenceDecimal,
            large: true,
          ),
          const SizedBox(height: 16),
          ShiftSummaryBreakdown(summary: summary, showExpectedBreakdown: false),
          const SizedBox(height: 24),
          Row(
            children: [
              SecondaryButton(
                label: 'Back to Cash Register',
                onPressed: () => context.go(RouteNames.cashRegister),
              ),
              const SizedBox(width: 12),
              PrimaryButton(
                label: 'View Full Shift Report',
                fullWidth: false,
                onPressed: () {
                  final shiftId = summary.shiftId;
                  if (shiftId != null) {
                    context.go(RouteNames.shiftDetailPath(shiftId));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
