import 'package:frantend/features/pos/presentation/models/add_to_cart_result.dart';

class AddToCartOutcome {
  const AddToCartOutcome({
    required this.result,
    this.pendingPrice,
    this.message,
  });

  final AddToCartResult result;
  final PendingPricePrompt? pendingPrice;
  final String? message;

  static const added = AddToCartOutcome(result: AddToCartResult.added);
}
