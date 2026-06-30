import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/presentation/cubit/return_detail_cubit.dart';
import 'package:frantend/features/returns/presentation/cubit/return_detail_state.dart';
import 'package:frantend/features/returns/presentation/utils/return_display_utils.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class ReturnDetailPage extends StatelessWidget {
  const ReturnDetailPage({super.key, required this.returnId});

  final String returnId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReturnDetailCubit>()..load(returnId),
      child: _ReturnDetailView(returnId: returnId),
    );
  }
}

class _ReturnDetailView extends StatelessWidget {
  const _ReturnDetailView({required this.returnId});

  final String returnId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnDetailCubit, ReturnDetailState>(
      listener: (context, state) {
        if (state is ReturnDetailError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          ReturnDetailInitial() || ReturnDetailLoading() =>
            const Center(child: CircularProgressIndicator()),
          ReturnDetailAccessDenied() => const EmptyState(
              icon: Icons.lock_outline,
              message: "You don't have permission to view this return",
            ),
          ReturnDetailError(:final message) => Center(
              child: Text(message, style: AppTextStyles.bodyMedium),
            ),
          ReturnDetailLoaded(:final item) => _LoadedContent(item: item),
        };
      },
    );
  }
}

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({required this.item});

  final SaleReturnResponseModel item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.returnNumber,
                      style: AppTextStyles.headlineMedium,
                    ),
                  ),
                  if (item.saleId != null)
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.push(RouteNames.saleDetailPath(item.saleId!)),
                      icon: const Icon(Icons.receipt_long_outlined, size: 18),
                      label: const Text('View original sale'),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              _InfoCard(item: item),
              const SizedBox(height: AppDimensions.spacingMd),
              _SectionCard(
                title: 'Returned items',
                child: item.lines.isEmpty
                    ? const Text(
                        'No line items',
                        style: TextStyle(color: AppColors.textSecondary),
                      )
                    : Column(
                        children: [
                          for (final line in item.lines)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Product ${line.productId}'),
                              subtitle: Text('Qty: ${line.qty}'),
                              trailing: Text(
                                formatReturnAmount(
                                  lineSubtotal(
                                    line.qty,
                                    line.unitPrice,
                                    line.taxAmount,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              _SectionCard(
                title: 'Refund payments',
                child: item.payments.isEmpty
                    ? const Text(
                        'No refund payments recorded',
                        style: TextStyle(color: AppColors.textSecondary),
                      )
                    : Column(
                        children: [
                          for (final payment in item.payments)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(payment.paymentMethod.toUpperCase()),
                              subtitle: Text('Status: ${payment.status}'),
                              trailing: Text(
                                formatReturnAmount(payment.amount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const Divider(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total refunded: ${formatRefundTotal(item)}',
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.item});

  final SaleReturnResponseModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Wrap(
          spacing: 32,
          runSpacing: 12,
          children: [
            _InfoTile(
              label: 'Date',
              value: formatReturnDate(item.returnedAt ?? item.createdAt),
            ),
            _InfoTile(
              label: 'Customer',
              value: item.customerId ?? 'Walk-in',
            ),
            _InfoTile(
              label: 'Reason',
              value: item.reason?.trim().isNotEmpty == true
                  ? item.reason!.trim()
                  : '—',
            ),
            _InfoTile(
              label: 'Refund total',
              value: formatRefundTotal(item),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppTextStyles.titleMedium),
            const SizedBox(height: AppDimensions.spacingMd),
            child,
          ],
        ),
      ),
    );
  }
}
