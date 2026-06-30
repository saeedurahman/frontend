/// Request body for POST /sales/open-tab — mirrors backend OpenTabRequest.
class OpenTabRequest {
  const OpenTabRequest({
    required this.branchId,
    required this.tableId,
    this.registerShiftId,
    this.customerId,
    this.priceListId,
    this.notes,
  });

  final String branchId;
  final String tableId;
  final String? registerShiftId;
  final String? customerId;
  final String? priceListId;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'branch_id': branchId,
        'table_id': tableId,
        if (registerShiftId != null) 'register_shift_id': registerShiftId,
        if (customerId != null) 'customer_id': customerId,
        if (priceListId != null) 'price_list_id': priceListId,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

/// Single line for POST /sales/{id}/lines — mirrors TabSaleLineRequest.
class TabSaleLineRequest {
  const TabSaleLineRequest({
    required this.productId,
    required this.qty,
    required this.unitPrice,
    this.variationId,
    this.discountPct = '0',
    this.discountAmount = '0',
    this.taxRate = '0',
    this.notes,
    this.lineOrder = 0,
    this.modifierIds = const [],
  });

  final String productId;
  final String? variationId;
  final String qty;
  final String unitPrice;
  final String discountPct;
  final String discountAmount;
  final String taxRate;
  final String? notes;
  final int lineOrder;
  final List<String> modifierIds;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
        'qty': qty,
        'unit_price': unitPrice,
        'discount_pct': discountPct,
        'discount_amount': discountAmount,
        'tax_rate': taxRate,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
        'line_order': lineOrder,
        'modifier_ids': modifierIds,
      };
}

class AddTabLinesRequest {
  const AddTabLinesRequest({required this.lines});

  final List<TabSaleLineRequest> lines;

  Map<String, dynamic> toJson() => {
        'lines': lines.map((line) => line.toJson()).toList(),
      };
}

class FireTabRequest {
  const FireTabRequest({this.saleLineIds, this.notes});

  final List<String>? saleLineIds;
  final String? notes;

  Map<String, dynamic> toJson() => {
        if (saleLineIds != null) 'sale_line_ids': saleLineIds,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class CompleteTabRequest {
  const CompleteTabRequest({
    this.registerShiftId,
    this.payments = const [],
    this.soldAt,
  });

  final String? registerShiftId;
  final List<Map<String, dynamic>> payments;
  final String? soldAt;

  Map<String, dynamic> toJson() => {
        if (registerShiftId != null) 'register_shift_id': registerShiftId,
        'payments': payments,
        if (soldAt != null) 'sold_at': soldAt,
      };
}

class UpdateKotStatusRequest {
  const UpdateKotStatusRequest({required this.status});

  final String status;

  Map<String, dynamic> toJson() => {'status': status};
}
