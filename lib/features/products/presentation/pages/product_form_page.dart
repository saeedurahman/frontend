import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/brands_state.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/products/presentation/cubit/units_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/units_state.dart';
import 'package:frantend/features/products/presentation/widgets/quick_add_brand_dialog.dart';
import 'package:frantend/features/products/presentation/widgets/quick_add_category_dialog.dart';
import 'package:frantend/features/products/presentation/widgets/quick_add_unit_dialog.dart';
import 'package:frantend/features/products/presentation/utils/category_utils.dart';
import 'package:frantend/features/products/presentation/utils/variation_utils.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key, this.productId});

  final String? productId;

  bool get isEdit => productId != null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = sl<ProductFormCubit>();
            if (productId != null) {
              cubit.loadForEdit(productId!);
            } else {
              cubit.initCreate();
            }
            return cubit;
          },
        ),
        BlocProvider(create: (_) => sl<CategoriesCubit>()..load()),
        BlocProvider(create: (_) => sl<BrandsCubit>()..load()),
        BlocProvider(create: (_) => sl<UnitsCubit>()..load()),
      ],
      child: _ProductFormView(isEdit: isEdit),
    );
  }
}

class _ProductFormView extends StatelessWidget {
  const _ProductFormView({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormCubit, ProductFormState>(
      listenWhen: (p, c) => c.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEdit ? 'Edit Product' : 'Add New Product',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      _BasicInfoCard(state: state),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _StockCard(state: state, isEdit: isEdit),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _VariationsCard(state: state),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _BarcodesCard(state: state),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(state: state, isEdit: isEdit),
            ),
          ],
        );
      },
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  const _BasicInfoCard({required this.state});

  final ProductFormState state;

  static const _productTypes = {
    'standard': 'Standard',
    'variant': 'Variant',
    'composite': 'Composite',
    'manufactured': 'Manufactured',
    'service': 'Service',
  };

  static const _trackingTypes = {
    'none': 'None',
    'batch': 'Batch',
    'serial': 'Serial',
    'expiry': 'Expiry',
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return _FormCard(
      title: 'Basic Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Product Name *',
              errorText: state.errors['name'],
            ),
            controller: TextEditingController(text: state.name)
              ..selection = TextSelection.collapsed(offset: state.name.length),
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'SKU',
              helperText: 'Leave empty to auto-generate later',
            ),
            controller: TextEditingController(text: state.sku ?? '')
              ..selection =
                  TextSelection.collapsed(offset: (state.sku ?? '').length),
            onChanged: (v) => cubit.updateSku(v.isEmpty ? null : v),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _CategoryDropdown(state: state)),
              const SizedBox(width: 12),
              Expanded(child: _BrandDropdown(state: state)),
            ],
          ),
          const SizedBox(height: 12),
          _BaseUnitDropdown(state: state),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: state.productType,
                  decoration: const InputDecoration(labelText: 'Product Type *'),
                  items: _productTypes.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) cubit.updateProductType(v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: state.trackingType,
                  decoration:
                      const InputDecoration(labelText: 'Tracking Type *'),
                  items: _trackingTypes.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) cubit.updateTrackingType(v);
                  },
                ),
              ),
            ],
          ),
          if (state.trackingType == 'expiry') ...[
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Shelf Life (days)',
                helperText: 'Used to calculate expiry alerts',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(
                text: state.shelfLifeDays?.toString() ?? '',
              ),
              onChanged: (v) =>
                  cubit.updateShelfLifeDays(int.tryParse(v)),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            controller: TextEditingController(text: state.description ?? '')
              ..selection = TextSelection.collapsed(
                offset: (state.description ?? '').length,
              ),
            onChanged: (v) => cubit.updateDescription(v.isEmpty ? null : v),
          ),
          const SizedBox(height: 12),
          _ImageUpload(state: state),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.state});

  final ProductFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, catState) {
        final categories = switch (catState) {
          CategoriesLoaded(:final categories) => categories,
          _ => <CategoryModel>[],
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Category', style: AppTextStyles.labelLarge),
                TextButton(
                  onPressed: () async {
                    final created = await QuickAddCategoryDialog.show(context);
                    if (created != null) {
                      cubit.updateCategoryId(created.id);
                    }
                  },
                  child: const Text('+ New'),
                ),
              ],
            ),
            DropdownButtonFormField<String?>(
              value: _resolveCategoryValue(categories, state.selectedCategoryId),
              decoration: const InputDecoration(hintText: 'Select category'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ...flattenCategories(categories).map(
                  (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                ),
              ],
              onChanged: cubit.updateCategoryId,
            ),
          ],
        );
      },
    );
  }
}

class _BrandDropdown extends StatelessWidget {
  const _BrandDropdown({required this.state});

  final ProductFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocBuilder<BrandsCubit, BrandsState>(
      builder: (context, brandState) {
        final brands = switch (brandState) {
          BrandsLoaded(:final brands) => brands,
          _ => <BrandModel>[],
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Brand', style: AppTextStyles.labelLarge),
                TextButton(
                  onPressed: () async {
                    final created = await QuickAddBrandDialog.show(context);
                    if (created != null) {
                      cubit.updateBrandId(created.id);
                    }
                  },
                  child: const Text('+ New'),
                ),
              ],
            ),
            DropdownButtonFormField<String?>(
              value: _resolveBrandValue(brands, state.selectedBrandId),
              decoration: const InputDecoration(hintText: 'Select brand'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ...brands.map(
                  (b) => DropdownMenuItem(value: b.id, child: Text(b.name)),
                ),
              ],
              onChanged: cubit.updateBrandId,
            ),
          ],
        );
      },
    );
  }
}

class _BaseUnitDropdown extends StatelessWidget {
  const _BaseUnitDropdown({required this.state});

  final ProductFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocBuilder<UnitsCubit, UnitsState>(
      builder: (context, unitState) {
        final units = switch (unitState) {
          UnitsLoaded(:final units) => units,
          _ => <UnitModel>[],
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Base Unit *', style: AppTextStyles.labelLarge),
                TextButton(
                  onPressed: () async {
                    final created = await QuickAddUnitDialog.show(context);
                    if (created != null) {
                      cubit.updateBaseUnitId(created.id);
                    }
                  },
                  child: const Text('+ New Unit'),
                ),
              ],
            ),
            DropdownButtonFormField<String?>(
              value: _resolveUnitValue(units, state.selectedBaseUnitId),
              decoration: InputDecoration(
                hintText: 'Select base unit',
                errorText: state.errors['base_unit_id'],
              ),
              items: units
                  .map(
                    (u) => DropdownMenuItem(
                      value: u.id,
                      child: Text('${u.name} (${u.symbol})'),
                    ),
                  )
                  .toList(),
              onChanged: cubit.updateBaseUnitId,
            ),
          ],
        );
      },
    );
  }
}

class _ImageUpload extends StatelessWidget {
  const _ImageUpload({required this.state});

  final ProductFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();
    final previewUrl = state.imageUrl;
    final localPath = state.localImagePath;
    final hasPreview = (previewUrl != null && previewUrl.startsWith('http')) ||
        localPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: state.isUploadingImage ? null : cubit.pickAndUploadImage,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
              color: AppColors.inputFill,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasPreview)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                    child: previewUrl != null && previewUrl.startsWith('http')
                        ? Image.network(previewUrl, fit: BoxFit.contain)
                        : Image.file(File(localPath!), fit: BoxFit.contain),
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.upload_file_rounded,
                          color: AppColors.primary, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Click to upload product image',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'PNG or JPG — uploaded to cloud storage',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                if (state.isUploadingImage)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (state.imageUploadError != null) ...[
          const SizedBox(height: 8),
          Text(
            state.imageUploadError!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: state.isUploadingImage ? null : cubit.pickAndUploadImage,
            child: const Text('Retry upload'),
          ),
        ],
      ],
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.state, required this.isEdit});

  final ProductFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return _FormCard(
      title: 'Stock & Availability',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 24,
            children: [
              _ToggleRow(
                label: 'Is Sellable',
                value: state.isSellable,
                onChanged: cubit.updateIsSellable,
              ),
              _ToggleRow(
                label: 'Is Purchasable',
                value: state.isPurchasable,
                onChanged: cubit.updateIsPurchasable,
              ),
              if (isEdit)
                _ToggleRow(
                  label: 'Is Active',
                  value: state.isActive,
                  onChanged: cubit.updateIsActive,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min Stock Level',
                    helperText: 'Used for low stock alerts',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller:
                      TextEditingController(text: state.minStockLevel ?? ''),
                  onChanged: (v) =>
                      cubit.updateMinStockLevel(v.isEmpty ? null : v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Stock Level',
                    helperText: 'Used for low stock alerts',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller:
                      TextEditingController(text: state.maxStockLevel ?? ''),
                  onChanged: (v) =>
                      cubit.updateMaxStockLevel(v.isEmpty ? null : v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: value,
          activeThumbColor: AppColors.primary,
          onChanged: onChanged,
        ),
        Text(label, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _VariationsCard extends StatelessWidget {
  const _VariationsCard({required this.state});

  final ProductFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return _FormCard(
      title: 'Variations',
      trailing: TextButton.icon(
        onPressed: cubit.addVariationRow,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Variation'),
      ),
      child: Column(
        children: [
          if (state.variations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'A default variation will be created automatically if you skip this',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ...state.variations.asMap().entries.map((entry) {
            final i = entry.key;
            final v = entry.value;
            return _VariationRow(index: i, item: v, canRemove: state.variations.length > 1);
          }),
        ],
      ),
    );
  }
}

class _VariationRow extends StatelessWidget {
  const _VariationRow({
    required this.index,
    required this.item,
    required this.canRemove,
  });

  final int index;
  final VariationFormItem item;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();
    final units = switch (context.watch<UnitsCubit>().state) {
      UnitsLoaded(:final units) => units,
      _ => <UnitModel>[],
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: item.name)
                ..selection = TextSelection.collapsed(offset: item.name.length),
              onChanged: (v) =>
                  cubit.updateVariationRow(index, item.copyWith(name: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'SKU'),
              controller: TextEditingController(text: item.sku ?? '')
                ..selection =
                    TextSelection.collapsed(offset: (item.sku ?? '').length),
              onChanged: (v) => cubit.updateVariationRow(
                index,
                item.copyWith(sku: v.isEmpty ? null : v),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String?>(
              initialValue: item.unitId,
              decoration: const InputDecoration(labelText: 'Unit'),
              items: units
                  .map(
                    (u) => DropdownMenuItem(
                      value: u.id,
                      child: Text(u.symbol),
                    ),
                  )
                  .toList(),
              onChanged: (v) =>
                  cubit.updateVariationRow(index, item.copyWith(unitId: v)),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Weight (g)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: TextEditingController(text: item.weightGrams ?? ''),
              onChanged: (v) => cubit.updateVariationRow(
                index,
                item.copyWith(weightGrams: v.isEmpty ? null : v),
              ),
            ),
          ),
          Checkbox(
            value: item.isDefault,
            onChanged: (_) => cubit.setDefaultVariation(index),
          ),
          const Text('Default', style: AppTextStyles.bodySmall),
          IconButton(
            onPressed: canRemove ? () => cubit.removeVariationRow(index) : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _BarcodesCard extends StatelessWidget {
  const _BarcodesCard({required this.state});

  final ProductFormState state;

  static const _barcodeTypes = ['EAN13', 'UPC', 'CODE128', 'QR', 'Custom'];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return _FormCard(
      title: 'Barcodes',
      trailing: TextButton.icon(
        onPressed: cubit.addBarcodeRow,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Barcode'),
      ),
      child: Column(
        children: state.barcodes.asMap().entries.map((entry) {
          final i = entry.key;
          final b = entry.value;
          return _BarcodeRow(index: i, item: b, barcodeTypes: _barcodeTypes);
        }).toList(),
      ),
    );
  }
}

class _BarcodeRow extends StatelessWidget {
  const _BarcodeRow({
    required this.index,
    required this.item,
    required this.barcodeTypes,
  });

  final int index;
  final BarcodeFormItem item;
  final List<String> barcodeTypes;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();
    final formState = context.watch<ProductFormCubit>().state;

    final namedVariations = formState.variations
        .asMap()
        .entries
        .where((e) => e.value.name.trim().isNotEmpty)
        .toList();

    final selectedVariationKey = resolveVariationDropdownValue(
      formState.variations,
      item.variationId,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Barcode',
                errorText: formState.errors['barcode_$index'],
                suffixIcon: Tooltip(
                  message: 'Click here then scan with USB scanner',
                  child: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {},
                  ),
                ),
              ),
              controller: TextEditingController(text: item.barcode)
                ..selection =
                    TextSelection.collapsed(offset: item.barcode.length),
              onChanged: (v) =>
                  cubit.updateBarcodeRow(index, item.copyWith(barcode: v)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: item.barcodeType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: barcodeTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  cubit.updateBarcodeRow(index, item.copyWith(barcodeType: v));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String?>(
              value: selectedVariationKey,
              decoration: const InputDecoration(labelText: 'Variation'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All variations'),
                ),
                ...namedVariations.map(
                  (e) => DropdownMenuItem(
                    value: variationDropdownValue(e.value, e.key),
                    child: Text(e.value.name),
                  ),
                ),
              ],
              onChanged: (v) =>
                  cubit.updateBarcodeRow(index, item.copyWith(variationId: v)),
            ),
          ),
          Checkbox(
            value: item.isPrimary,
            onChanged: (_) => cubit.setPrimaryBarcode(index),
          ),
          const Text('Primary', style: AppTextStyles.bodySmall),
          IconButton(
            onPressed: () => cubit.removeBarcodeRow(index),
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.isEdit});

  final ProductFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 140,
            child: SecondaryButton(
              label: 'Cancel',
              onPressed: state.isSubmitting ? null : () => context.pop(),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 180,
            child: PrimaryButton(
              label: isEdit ? 'Update Product' : 'Save Product',
              isLoading: state.isSubmitting,
              onPressed: state.isSubmitting
                  ? null
                  : () async {
                      final id = await cubit.submit();
                      if (!context.mounted || id == null) return;
                      AppAlerts.showSuccessMessage(
                        context,
                        isEdit ? 'Product updated' : 'Product created',
                      );
                      context.pop(true);
                    },
            ),
          ),
        ],
      ),
    );
  }
}

String? _resolveCategoryValue(
  List<CategoryModel> categories,
  String? selectedId,
) {
  if (selectedId == null) return null;
  return flattenCategories(categories).any((c) => c.id == selectedId)
      ? selectedId
      : null;
}

String? _resolveBrandValue(List<BrandModel> brands, String? selectedId) {
  if (selectedId == null) return null;
  return brands.any((b) => b.id == selectedId) ? selectedId : null;
}

String? _resolveUnitValue(List<UnitModel> units, String? selectedId) {
  if (selectedId == null) return null;
  return units.any((u) => u.id == selectedId) ? selectedId : null;
}
