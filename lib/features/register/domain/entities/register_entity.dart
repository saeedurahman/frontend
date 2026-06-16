import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Aggregated registration data collected across all wizard steps.
class RegisterEntity extends Equatable {
  const RegisterEntity({
    this.businessName = '',
    this.city,
    this.currency = 'PKR',
    this.logoPath,
    this.businessType,
    this.branchName = '',
    this.address,
    this.branchPhone,
    this.ownerName = '',
    this.ownerPhone = '',
    this.password = '',
    this.confirmPassword = '',
    this.plan = RegisterPlan.growth,
  });

  final String businessName;
  final String? city;
  final String currency;
  final String? logoPath;
  final String? businessType;
  final String branchName;
  final String? address;
  final String? branchPhone;
  final String ownerName;
  final String ownerPhone;
  final String password;
  final String confirmPassword;
  final RegisterPlan plan;

  static const initial = RegisterEntity();

  RegisterEntity copyWith({
    String? businessName,
    String? city,
    String? currency,
    String? logoPath,
    String? businessType,
    String? branchName,
    String? address,
    String? branchPhone,
    String? ownerName,
    String? ownerPhone,
    String? password,
    String? confirmPassword,
    RegisterPlan? plan,
  }) {
    return RegisterEntity(
      businessName: businessName ?? this.businessName,
      city: city ?? this.city,
      currency: currency ?? this.currency,
      logoPath: logoPath ?? this.logoPath,
      businessType: businessType ?? this.businessType,
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      branchPhone: branchPhone ?? this.branchPhone,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      plan: plan ?? this.plan,
    );
  }

  Map<String, dynamic> toJson() => {
        'business_name': businessName,
        'city': city,
        'currency': currency,
        if (businessType != null) 'business_type_code': businessType,
        'branch_name': branchName,
        if (address != null) 'address': address,
        if (branchPhone != null) 'branch_phone': branchPhone,
        'owner_name': ownerName,
        'owner_phone': ownerPhone,
        'owner_password': password,
        'plan': plan.name,
      };

  @override
  List<Object?> get props => [
        businessName,
        city,
        currency,
        logoPath,
        businessType,
        branchName,
        address,
        branchPhone,
        ownerName,
        ownerPhone,
        password,
        confirmPassword,
        plan,
      ];
}

enum RegisterPlan { basic, growth, pro }

extension RegisterPlanX on RegisterPlan {
  String get label => switch (this) {
        RegisterPlan.basic => 'Basic',
        RegisterPlan.growth => 'Growth',
        RegisterPlan.pro => 'Pro',
      };

  String get price => switch (this) {
        RegisterPlan.basic => 'Rs. 3,000/mo',
        RegisterPlan.growth => 'Rs. 6,000/mo',
        RegisterPlan.pro => 'Rs. 10,000/mo',
      };

  String get branches => switch (this) {
        RegisterPlan.basic => '1 Branch',
        RegisterPlan.growth => '3 Branches',
        RegisterPlan.pro => '5 Branches',
      };

  String get users => switch (this) {
        RegisterPlan.basic => '1 User',
        RegisterPlan.growth => '5 Users',
        RegisterPlan.pro => 'Unlimited',
      };

  bool get isRecommended => this == RegisterPlan.growth;
}

class BusinessTypeOption {
  const BusinessTypeOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.recommended = false,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool recommended;
}

const kBusinessTypes = <BusinessTypeOption>[
  BusinessTypeOption(
    id: 'bakery',
    title: 'Bakery/Sweets',
    description: 'Inventory recipes, batch tracking, and weight-based pricing.',
    icon: Icons.bakery_dining_rounded,
  ),
  BusinessTypeOption(
    id: 'restaurant',
    title: 'Restaurant',
    description: 'KOT management, floor plans, modifiers, and table service.',
    icon: Icons.restaurant_rounded,
    recommended: true,
  ),
  BusinessTypeOption(
    id: 'mart',
    title: 'Mart/Grocery',
    description: 'Barcode scanning, SKU management, and expiry alerts.',
    icon: Icons.shopping_basket_rounded,
  ),
  BusinessTypeOption(
    id: 'retail',
    title: 'Retail',
    description: 'Stock variants (size/color), loyalty programs, and discounts.',
    icon: Icons.checkroom_rounded,
  ),
  BusinessTypeOption(
    id: 'hardware',
    title: 'Hardware',
    description: 'Bulk units, credit sales, and contractor project tracking.',
    icon: Icons.handyman_rounded,
  ),
  BusinessTypeOption(
    id: 'pharmacy',
    title: 'Pharmacy',
    description: 'DRAP standards, generic drug search, and batch expiries.',
    icon: Icons.medical_services_rounded,
  ),
  BusinessTypeOption(
    id: 'wholesale',
    title: 'Wholesale',
    description: 'Tiered pricing, carton vs piece stock, and credit cycles.',
    icon: Icons.inventory_2_rounded,
  ),
  BusinessTypeOption(
    id: 'other',
    title: 'Other',
    description: 'Custom setup for services or specialized trading models.',
    icon: Icons.more_horiz_rounded,
  ),
];

const kPakistaniCities = <String>[
  'Karachi',
  'Lahore',
  'Islamabad',
  'Rawalpindi',
  'Faisalabad',
  'Multan',
  'Peshawar',
  'Quetta',
  'Sialkot',
  'Gujranwala',
  'Hyderabad',
  'Abbottabad',
];
