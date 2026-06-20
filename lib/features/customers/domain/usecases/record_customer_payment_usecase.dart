import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RecordCustomerPaymentUseCase {
  const RecordCustomerPaymentUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, CustomerPaymentResponseModel>> call(
    String customerId, {
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
    String? registerShiftId,
  }) =>
      _repository.recordPayment(
        customerId,
        amount: amount,
        paymentMethod: paymentMethod,
        referenceNo: referenceNo,
        notes: notes,
        registerShiftId: registerShiftId,
      );
}
