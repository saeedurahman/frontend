import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/core/utils/currency_label.dart';

/// The sample sale the layout editor previews: Urdu names, a batch with
/// expiry, tax, a discount and cash change.
abstract final class ReceiptSamples {
  static SaleResponseModel sale({
    int extraLines = 0,
    bool synced = true,
  }) {
    final lines = <Map<String, dynamic>>[
      {
        'id': 'l1',
        'product_id': 'p1',
        'qty': '2.00',
        'unit_price': '45.00',
        'tax_rate': '17',
        'tax_amount': '15.30',
        'net_amount': '90.00',
        'line_total': '105.30',
        'product_name': 'Panadol Extra',
        'variation_name': 'Default',
        'batches': [
          {'batch_no': 'B2407', 'expiry_date': '2027-05-31', 'qty': '2'},
        ],
      },
      {
        'id': 'l2',
        'product_id': 'p2',
        'qty': '1.500',
        'unit_price': '320.00',
        'discount_amount': '30.00',
        'tax_rate': '17',
        'tax_amount': '76.50',
        'net_amount': '450.00',
        'line_total': '526.50',
        'product_name': 'باسمتی چاول',
      },
      {
        'id': 'l3',
        'product_id': 'p3',
        'qty': '1',
        'unit_price': '120.00',
        'tax_rate': '17',
        'tax_amount': '20.40',
        'net_amount': '120.00',
        'line_total': '140.40',
        'product_name': 'Vitamin C',
        'variation_name': '500 mg',
      },
      for (var i = 0; i < extraLines; i++)
        {
          'id': 'x$i',
          'product_id': 'px$i',
          'qty': '${(i % 4) + 1}',
          'unit_price': '10.00',
          'tax_rate': '0',
          'tax_amount': '0',
          'net_amount': '10.00',
          'line_total': '${((i % 4) + 1) * 10}.00',
          'product_name': i.isEven ? 'Sample item ${i + 1}' : 'نمونہ آئٹم ${i + 1}',
        },
    ];
    return SaleResponseModel.fromJson({
      'id': 'sample-sale-0001',
      'sale_number': 'INV-0042',
      'client_receipt_no': 'C1-0042',
      'branch_id': 'branch-1',
      'sale_type': 'pos',
      'sale_status': 'completed',
      'subtotal': '690.00',
      'total_discount': '30.00',
      'total_tax': '112.20',
      'net_amount': '660.00',
      'rounding_amount': '0',
      'tax_inclusive': false,
      'tax_label': 'GST',
      'total_amount': '772.20',
      'total_paid': '772.20',
      'sold_at': '2026-11-17T10:30:00',
      'customer': {
        'id': 'c1',
        'business_id': 'b1',
        'name': 'احمد علی',
        'phone': '03001234567',
      },
      'lines': lines,
      'payments': [
        {
          'id': 'pay1',
          'payment_method': 'cash',
          'amount': '772.20',
          'tendered_amount': '800.00',
          'change_given': '27.80',
        },
      ],
      'offline': !synced,
    });
  }

  static ReceiptContext context({bool synced = true}) => ReceiptContext(
        business: const ReceiptBusiness(
          name: 'Al-Shifa Pharmacy',
          address: 'Shop 4, Main Boulevard, Lahore',
          phone: '0423-1234567',
          taxId: '1234567-8',
        ),
        registerNumber: 'C1-0042',
        officialNumber: synced ? 'INV-0042' : null,
        synced: synced,
        publicLink: synced ? 'https://pakpos.example/r/sample0042' : null,
        cashierName: 'Bilal',
        branchName: 'Main branch',
        registerName: 'Counter 1',
        customerPhone: '03001234567',
        previousBalance: '$currencyLabel 500.00',
        balanceAfter: '$currencyLabel 500.00',
        products: const {
          'p1': ReceiptProductInfo(sku: 'PAN-01', unitSymbol: 'pc'),
          'p2': ReceiptProductInfo(sku: 'RICE-5', unitSymbol: 'kg', allowsDecimal: true),
          'p3': ReceiptProductInfo(sku: 'VIT-C', unitSymbol: 'pc'),
        },
      );
}
