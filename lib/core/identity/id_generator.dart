import 'package:frantend/core/utils/uuid_utils.dart';

/// Central place that mints client-side identifiers.
///
/// Sales, payments, customers, expenses, shifts, returns and sync operation
/// ids are created on the device (UUIDv4) so a record keeps its identity
/// whether it reaches the server now or after a reconnect, and so a retry can
/// never create a duplicate.
abstract class IdGenerator {
  String newId();

  String saleId() => newId();
  String paymentId() => newId();
  String customerId() => newId();
  String expenseId() => newId();
  String shiftId() => newId();
  String returnId() => newId();
  String heldOrderId() => newId();

  /// Id of one queued operation (idempotency key for the later sync engine).
  String opId() => newId();
}

class UuidIdGenerator extends IdGenerator {
  UuidIdGenerator({String Function()? source}) : _source = source ?? UuidUtils.v4;

  final String Function() _source;

  @override
  String newId() => _source();
}

final RegExp _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

bool isUuidV4(String value) => _uuidV4.hasMatch(value);
