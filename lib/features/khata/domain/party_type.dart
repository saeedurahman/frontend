import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';

/// The two sides of the khata: customers owe us, we owe suppliers.
enum PartyType {
  customer('customer', 'customers'),
  supplier('supplier', 'suppliers');

  const PartyType(this.apiValue, this.collection);

  /// `party_type` on the wire.
  final String apiValue;

  /// `/customers/...` or `/suppliers/...`.
  final String collection;

  bool get isCustomer => this == PartyType.customer;

  static PartyType parse(String? value) =>
      value == supplier.apiValue || value == supplier.collection
          ? supplier
          : customer;

  /// Opening balances, manual entries and their reversal.
  String get ledgerManagePermission => isCustomer
      ? Perm.customersLedgerManage
      : Perm.suppliersLedgerManage;

  /// Taking money from a customer / paying a supplier.
  String get paymentPermission =>
      isCustomer ? Perm.customersUpdate : Perm.suppliersPaymentsCreate;

  /// The party's own account page.
  String detailRoute(String id) => isCustomer
      ? RouteNames.customerDetail(id)
      : '${RouteNames.suppliers}/$id';

  String statementRoute(String id) => RouteNames.statement(apiValue, id);
}
