import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';

/// A repository that holds returns the server does not have yet.
abstract interface class PendingReturnsSource {
  /// Newest first.
  Future<List<SaleReturnResponseModel>> pendingReturns({String? branchId});
}
