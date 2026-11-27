/// The balance filters on the customer and supplier lists.
abstract final class ListFilterText {
  static const owesMe = 'Owes me';
  static const owesMeHelp = 'Customers who still have to pay you';
  static const iOwe = 'I owe';
  static const iOweHelp = 'Suppliers you still have to pay';
  static const advance = 'Advance';
  static const customerAdvanceHelp = 'Customers who paid you in advance';
  static const supplierAdvanceHelp = 'Suppliers you paid in advance';

  static const sortTooltip = 'Order by balance';
  static const sortDefault = 'Usual order';
  static const sortHighest = 'Highest balance first';
  static const sortLowest = 'Lowest balance first';

  static const statement = 'Statement';
  static const nobodyMatches = 'Nobody matches this filter';
}
