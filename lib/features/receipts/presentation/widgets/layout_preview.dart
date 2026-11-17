import 'package:flutter/material.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_samples.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_view.dart';

/// The model a layout produces for the built-in sample sale (Urdu names, tax,
/// a batch with expiry, a discount, cash change). The layout editor, the list
/// thumbnails, "Test print" and "Save as PDF" all use it, so they always
/// agree. [business] replaces the sample shop details with the real ones.
abstract final class LayoutPreviewModel {
  static ReceiptModel build(
    ReceiptLayout layout, {
    ReceiptBusiness? business,
    ReceiptChannel channel = ReceiptChannel.print,
    int extraLines = 0,
    bool synced = true,
  }) {
    final base = ReceiptSamples.context(synced: synced);
    final context = business == null
        ? base
        : base.copyWith(
            business: ReceiptBusiness(
              name: business.name ?? base.business.name,
              address: business.address ?? base.business.address,
              phone: business.phone ?? base.business.phone,
              taxId: business.taxId ?? base.business.taxId,
              logoBytes: business.logoBytes,
              logoUrl: business.logoUrl,
            ),
          );
    return ReceiptModelBuilder.build(
      ReceiptSamples.sale(extraLines: extraLines, synced: synced),
      layout,
      channel,
      context: context,
      now: DateTime(2026, 11, 17, 10, 30),
    );
  }
}

/// The live preview: the same [ReceiptView] the cashier sees after a sale.
class LayoutPreview extends StatelessWidget {
  const LayoutPreview({super.key, required this.layout, this.business, this.maxWidth});

  final ReceiptLayout layout;
  final ReceiptBusiness? business;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) => ReceiptView(
        key: const Key('layout-live-preview'),
        model: LayoutPreviewModel.build(layout, business: business),
        maxWidth: maxWidth,
      );
}

/// A small picture of a layout for the list (top of the receipt, scaled).
class LayoutThumbnail extends StatelessWidget {
  const LayoutThumbnail({super.key, required this.layout, this.width = 120, this.height = 150});

  final ReceiptLayout layout;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final model = LayoutPreviewModel.build(layout);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: IgnorePointer(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          child: ReceiptView(model: model),
        ),
      ),
    );
  }
}
