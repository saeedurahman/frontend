import 'package:frantend/features/receipts/domain/receipt_layout.dart';

/// One on/off choice in the layout editor, with the plain-language help that
/// is shown right under it (shop owners are not technical).
class ReceiptSwitchSpec {
  const ReceiptSwitchSpec(this.section, this.key, this.title, this.help);

  final String section;
  final String key;
  final String title;
  final String help;
}

/// The editor's groups, in order. Keys are exactly the backend config keys.
abstract final class ReceiptSwitches {
  static const header = 'Header';
  static const details = 'Receipt details';
  static const items = 'Items';
  static const totals = 'Totals';
  static const footer = 'Footer';

  static const groups = <String, List<ReceiptSwitchSpec>>{
    header: [
      ReceiptSwitchSpec('header', 'show_logo', 'Shop logo',
          'Prints your logo at the top. Add the logo in Settings > Business Profile.'),
      ReceiptSwitchSpec('header', 'show_business_name', 'Shop name',
          'Your shop name in big letters at the top.'),
      ReceiptSwitchSpec('header', 'show_address', 'Shop address',
          'The address from your Business Profile.'),
      ReceiptSwitchSpec('header', 'show_phone', 'Shop phone',
          'The phone number from your Business Profile.'),
      ReceiptSwitchSpec('header', 'show_ntn', 'NTN',
          'Prints your NTN number (the tax number from your Business Profile). Customers who need a tax invoice look for this.'),
    ],
    details: [
      ReceiptSwitchSpec('meta', 'show_number', 'Receipt number',
          'The number of this bill. Handy when a customer comes back with a question.'),
      ReceiptSwitchSpec('meta', 'show_datetime', 'Date and time',
          'When the sale was made.'),
      ReceiptSwitchSpec('meta', 'show_cashier', 'Cashier name',
          'Who served the customer.'),
      ReceiptSwitchSpec('meta', 'show_branch', 'Branch name',
          'Useful if you have more than one shop.'),
      ReceiptSwitchSpec('meta', 'show_register', 'Counter name',
          'Which counter (register) made the sale.'),
      ReceiptSwitchSpec('meta', 'show_customer', 'Customer name',
          'Prints the customer name when one was chosen. Walk-in sales print nothing unless you set a walk-in label.'),
      ReceiptSwitchSpec('meta', 'show_customer_phone', 'Customer phone',
          "The customer's phone number, when they have one saved."),
    ],
    items: [
      ReceiptSwitchSpec('items', 'show_name', 'Item name',
          'The product name. Turn off only for very short receipts.'),
      ReceiptSwitchSpec('items', 'show_variation', 'Size / variation',
          'Prints the size or colour next to the name, only when the item has a real one.'),
      ReceiptSwitchSpec('items', 'show_sku', 'Item code (SKU)',
          'Your own product code.'),
      ReceiptSwitchSpec('items', 'show_barcode', 'Barcode number',
          'The number under the product barcode.'),
      ReceiptSwitchSpec('items', 'show_unit', 'Unit',
          'kg, pcs, litre... printed after the quantity.'),
      ReceiptSwitchSpec('items', 'show_qty', 'Quantity',
          'How many of each item were sold.'),
      ReceiptSwitchSpec('items', 'show_unit_price', 'Price of one',
          'The price of a single item.'),
      ReceiptSwitchSpec('items', 'show_line_discount', 'Discount on item',
          'Shows the discount given on an item, when there is one.'),
      ReceiptSwitchSpec('items', 'show_line_total', 'Item amount',
          'Quantity times price for each item.'),
      ReceiptSwitchSpec('items', 'show_batch', 'Batch number',
          'For medicines: the batch the item was taken from.'),
      ReceiptSwitchSpec('items', 'show_expiry', 'Expiry date',
          'For medicines: when the batch expires (month/year).'),
    ],
    totals: [
      ReceiptSwitchSpec('totals', 'show_subtotal', 'Subtotal',
          'The amount before discount and tax.'),
      ReceiptSwitchSpec('totals', 'show_discount', 'Discount',
          'The total discount given on the bill.'),
      ReceiptSwitchSpec('totals', 'show_tax_breakdown', 'Tax lines',
          'Shows how much tax was charged. Turn off if you do not want tax shown.'),
      ReceiptSwitchSpec('totals', 'show_rounding', 'Rounding',
          'The small rounding adjustment, when the bill was rounded.'),
      ReceiptSwitchSpec('totals', 'show_includes_tax_note', '"Prices include tax" note',
          'A short note when your prices already include tax.'),
      ReceiptSwitchSpec('totals', 'show_payments', 'How the customer paid',
          'Cash, card, credit... and the amounts.'),
      ReceiptSwitchSpec('totals', 'show_change', 'Change given',
          'The cash handed back to the customer.'),
      ReceiptSwitchSpec('totals', 'show_previous_balance', 'Previous balance',
          'What the customer owed before this bill (credit customers).'),
      ReceiptSwitchSpec('totals', 'show_balance_after', 'Balance now',
          'What the customer owes after this bill (credit customers).'),
    ],
    footer: [
      ReceiptSwitchSpec('footer', 'show_qr', 'QR code',
          'A code the customer can scan to see the receipt online. Only printed once the sale has reached the server.'),
      ReceiptSwitchSpec('footer', 'show_powered_by', '"Powered by PakPOS"',
          'A small line at the very bottom.'),
    ],
  };

  /// Labels worth editing, in the order the editor shows them.
  static const editableLabels = <String>[
    'receipt',
    'tax_invoice',
    'number',
    'date',
    'cashier',
    'customer',
    'item',
    'qty',
    'price',
    'amount',
    'batch',
    'expiry',
    'subtotal',
    'discount',
    'tax',
    'rounding',
    'total',
    'paid',
    'change',
    'balance_due',
    'previous_balance',
    'balance_after',
    'includes_tax',
  ];
}

/// Ready-made starting points shown when creating a layout.
class ReceiptPreset {
  const ReceiptPreset(this.id, this.title, this.description, this.design, this.build);

  final String id;
  final String title;
  final String description;
  final ReceiptDesign design;
  final ReceiptLayoutConfig Function() build;

  static final simple = ReceiptPreset(
    'simple',
    'Simple customer receipt',
    'Short and friendly: shop name, items, total and a thank-you line. No tax numbers.',
    ReceiptDesign.thermalClassic,
    () {
      var c = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.thermalClassic);
      for (final k in ['show_ntn', 'show_logo']) {
        c = c.withValue('header', k, false);
      }
      for (final k in ['show_cashier', 'show_branch', 'show_register', 'show_customer_phone']) {
        c = c.withValue('meta', k, false);
      }
      for (final k in ['show_sku', 'show_barcode', 'show_unit', 'show_batch', 'show_expiry']) {
        c = c.withValue('items', k, false);
      }
      c = c.withValue('totals', 'show_tax_breakdown', false);
      c = c.withValue('footer', 'text_en', 'Thank you for shopping with us!');
      c = c.withValue('footer', 'text_ur', 'خریداری کا شکریہ!');
      return c.withValue('footer', 'show_qr', false);
    },
  );

  static final detailedTax = ReceiptPreset(
    'detailed_tax',
    'Detailed tax invoice',
    'A4 page with your NTN, an item table, tax summary and a signature line.',
    ReceiptDesign.a4TaxInvoice,
    () {
      var c = ReceiptLayoutConfig.defaultsFor(ReceiptDesign.a4TaxInvoice);
      c = c.withValue('header', 'show_ntn', true);
      c = c.withValue('meta', 'number_source', 'official');
      c = c.withValue('meta', 'show_customer_phone', true);
      c = c.withValue('totals', 'show_tax_breakdown', true);
      return c;
    },
  );

  static final all = [simple, detailedTax];
}
