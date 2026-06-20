import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/inventory/presentation/cubit/stock_movements_cubit.dart';
import 'package:frantend/features/inventory/presentation/cubit/stock_movements_state.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class StockMovementsPage extends StatelessWidget {
  const StockMovementsPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StockMovementsCubit>()..load(productId: productId),
      child: _StockMovementsView(productId: productId),
    );
  }
}

class _StockMovementsView extends StatefulWidget {
  const _StockMovementsView({required this.productId});

  final String productId;

  @override
  State<_StockMovementsView> createState() => _StockMovementsViewState();
}

class _StockMovementsViewState extends State<_StockMovementsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (max > 0 && offset / max >= 0.8) {
      context.read<StockMovementsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StockMovementsCubit, StockMovementsState>(
      listener: (context, state) {
        if (state is StockMovementsError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Stock Movements', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text('Product ID: ${widget.productId}', style: AppTextStyles.bodySmall),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                StockMovementsInitial() || StockMovementsLoading() =>
                  const _ShimmerTable(),
                StockMovementsLoaded(:final rows) when rows.isEmpty =>
                  const Center(child: Text('No movements found')),
                StockMovementsLoaded loaded => _MovementsTable(
                    state: loaded,
                    scrollController: _scrollController,
                  ),
                StockMovementsError(:final message) =>
                  Center(child: Text(message)),
              },
            ),
          ],
        );
      },
    );
  }
}

class _MovementsTable extends StatelessWidget {
  const _MovementsTable({
    required this.state,
    required this.scrollController,
  });

  final StockMovementsLoaded state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(child: Text('Date', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Type', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Qty', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Cost', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Reference', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Balance', style: AppTextStyles.labelLarge)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.rows.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.rows.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final row = state.rows[index];
                final movement = row.movement;
                final qty = double.tryParse(movement.qty) ?? 0;
                final qtyColor = qty >= 0 ? AppColors.success : AppColors.error;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          movement.movementAt.split('T').first,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Text(movement.movementType, style: AppTextStyles.bodySmall),
                      ),
                      Expanded(
                        child: Text(
                          movement.qty,
                          style: AppTextStyles.bodySmall.copyWith(color: qtyColor),
                        ),
                      ),
                      Expanded(
                        child: Text(movement.costPerUnit, style: AppTextStyles.bodySmall),
                      ),
                      Expanded(
                        child: Text(
                          '${movement.referenceType} #${movement.referenceId.substring(0, 8)}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.runningBalance.toStringAsFixed(4),
                          style: AppTextStyles.titleMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerTable extends StatelessWidget {
  const _ShimmerTable();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: List.generate(
            5,
            (_) => Container(
              height: 64,
              margin: const EdgeInsets.all(12),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
