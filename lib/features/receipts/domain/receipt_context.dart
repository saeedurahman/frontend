/// Everything a receipt needs besides the sale and the layout. Loaded from
/// the device's own data (never the network) by `ReceiptContextLoader`; tests
/// build it by hand.
class ReceiptContext {
  const ReceiptContext({
    this.business = const ReceiptBusiness(),
    this.registerNumber,
    this.officialNumber,
    this.synced = false,
    this.publicLink,
    this.cashierName,
    this.branchName,
    this.registerName,
    this.customerPhone,
    this.products = const {},
    this.previousBalance,
    this.balanceAfter,
    this.accentColor,
    this.isReturn = false,
  });

  final ReceiptBusiness business;

  /// Device number, e.g. `C1-0042` (`client_receipt_no`).
  final String? registerNumber;

  /// Number the server gave once the sale was accepted (`INV-0042`).
  final String? officialNumber;

  /// The server has accepted this sale. The QR code needs this.
  final bool synced;

  /// Public receipt link, when one exists.
  final String? publicLink;
  final String? cashierName;
  final String? branchName;
  final String? registerName;
  final String? customerPhone;

  /// Per product id: what the receipt may print besides the sale line.
  final Map<String, ReceiptProductInfo> products;
  final String? previousBalance;
  final String? balanceAfter;

  /// ARGB colour for the A4 elegant banner (business setting).
  final int? accentColor;

  /// Prints "Return" instead of "Receipt" in the title.
  final bool isReturn;

  ReceiptContext copyWith({
    ReceiptBusiness? business,
    String? registerNumber,
    String? officialNumber,
    bool? synced,
    String? publicLink,
    bool clearPublicLink = false,
    String? cashierName,
    String? branchName,
    String? registerName,
    String? customerPhone,
    Map<String, ReceiptProductInfo>? products,
    String? previousBalance,
    String? balanceAfter,
    int? accentColor,
  }) =>
      ReceiptContext(
        business: business ?? this.business,
        registerNumber: registerNumber ?? this.registerNumber,
        officialNumber: officialNumber ?? this.officialNumber,
        synced: synced ?? this.synced,
        publicLink: clearPublicLink ? null : (publicLink ?? this.publicLink),
        cashierName: cashierName ?? this.cashierName,
        branchName: branchName ?? this.branchName,
        registerName: registerName ?? this.registerName,
        customerPhone: customerPhone ?? this.customerPhone,
        products: products ?? this.products,
        previousBalance: previousBalance ?? this.previousBalance,
        balanceAfter: balanceAfter ?? this.balanceAfter,
        accentColor: accentColor ?? this.accentColor,
        isReturn: isReturn,
      );
}

class ReceiptBusiness {
  const ReceiptBusiness({
    this.name,
    this.address,
    this.phone,
    this.taxId,
    this.logoUrl,
    this.logoBytes,
  });

  final String? name;
  final String? address;
  final String? phone;

  /// The business NTN (`business.tax_id`). Never a tax rate or label.
  final String? taxId;
  final String? logoUrl;
  final List<int>? logoBytes;
}

class ReceiptProductInfo {
  const ReceiptProductInfo({
    this.nameSecondary,
    this.sku,
    this.barcode,
    this.unitSymbol,
    this.allowsDecimal = false,
  });

  /// The product's Urdu (second-language) name.
  final String? nameSecondary;
  final String? sku;
  final String? barcode;
  final String? unitSymbol;
  final bool allowsDecimal;
}
