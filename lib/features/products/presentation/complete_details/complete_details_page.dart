import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/presentation/complete_details/complete_details_cubit.dart';
import 'package:go_router/go_router.dart';

/// "Complete details": one product at a time, with a progress counter.
class CompleteDetailsPage extends StatelessWidget {
  const CompleteDetailsPage({super.key, this.cubit});

  final CompleteDetailsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(value: cubit!, child: const _View());
    }
    return BlocProvider(
      create: (_) => CompleteDetailsCubit(
        repository: sl<ProductsRepository>(),
        imageUpload: sl<ImageUploadService>(),
      )..load(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteDetailsCubit, CompleteDetailsState>(
      builder: (context, state) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (state.finished) return _Finished(done: state.done);
        final item = state.current;
        if (item == null) return const SizedBox.shrink();
        final cubit = context.read<CompleteDetailsCubit>();
        final progress = state.total == 0 ? 0.0 : (state.index) / state.total;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Back to products',
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(true),
                    ),
                    Text('Complete details', style: Theme.of(context).textTheme.headlineSmall),
                    const Spacer(),
                    Text(
                      '${state.index + 1} of ${state.total}',
                      key: const ValueKey('complete-details-progress'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: progress, minHeight: 6),
                const SizedBox(height: 20),
                Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final m in item.missing)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(switch (m) {
                          'category' => 'No category',
                          'image' => 'No picture',
                          'price' => 'No price',
                          _ => m,
                        }),
                        backgroundColor: AppColors.warning.withValues(alpha: 0.15),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _ImageRow(url: state.imageUrl, uploading: state.uploading, onPick: cubit.pickImage),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey('cat-${item.id}-${state.categoryId}'),
                  initialValue: state.categories.any((c) => c.id == state.categoryId)
                      ? state.categoryId
                      : null,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    for (final c in state.categories)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: cubit.setCategory,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey('unit-${item.id}-${state.unitId}'),
                  initialValue:
                      state.units.any((u) => u.id == state.unitId) ? state.unitId : null,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: [
                    for (final u in state.units)
                      DropdownMenuItem(value: u.id, child: Text(u.name)),
                  ],
                  onChanged: cubit.setUnit,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: ValueKey('min-${item.id}-${state.detail?.id}'),
                  initialValue: state.minStock,
                  decoration: const InputDecoration(
                    labelText: 'Minimum stock',
                    helperText: 'You get a warning when stock falls below this.',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  onChanged: cubit.setMinStock,
                ),
                if (state.needsPrice) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    key: ValueKey('price-${item.id}'),
                    initialValue: state.price,
                    decoration: const InputDecoration(labelText: 'Sale price'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    onChanged: cubit.setPrice,
                  ),
                ],
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  Text(state.error!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(onPressed: state.saving ? null : cubit.skip, child: const Text('Skip')),
                    const Spacer(),
                    FilledButton(
                      onPressed: state.saving || state.uploading ? null : cubit.saveAndNext,
                      child: Text(state.saving ? 'Saving...' : 'Save and next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ImageRow extends StatelessWidget {
  const _ImageRow({required this.url, required this.uploading, required this.onPick});

  final String? url;
  final bool uploading;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: uploading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : (url == null || url!.isEmpty)
                  ? const Icon(Icons.image_outlined, color: AppColors.textSecondary)
                  : Image.network(url!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: uploading ? null : onPick,
          icon: const Icon(Icons.upload_outlined, size: 18),
          label: Text(url == null || url!.isEmpty ? 'Add picture' : 'Change picture'),
        ),
      ],
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({required this.done});

  final int done;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 56, color: AppColors.success),
          const SizedBox(height: 12),
          Text(
            done == 0 ? 'Nothing needs details' : 'All done: $done ${done == 1 ? 'product' : 'products'} completed',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.pop(true), child: const Text('Back to products')),
        ],
      ),
    );
  }
}
