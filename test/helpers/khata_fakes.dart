import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/last_payment_source_store.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/domain/shift_guard.dart';

/// A [ShiftGuard] whose open shift the test controls.
class FakeShiftGuard extends Fake implements ShiftGuard {
  FakeShiftGuard({this.shiftId, this.openResult});

  /// The user's open shift; null means "no shift open".
  String? shiftId;

  /// What [openNow] answers; when null it opens `opened-shift`.
  Either<Failure, String>? openResult;

  int openCalls = 0;
  int checkCalls = 0;

  @override
  Future<String?> currentShiftId() async {
    checkCalls++;
    return shiftId;
  }

  /// The branch the last [openNow] asked for.
  String? openedIn;

  @override
  Future<Either<Failure, String>> openNow({
    Decimal? openingFloat,
    String? branchId,
  }) async {
    openCalls++;
    openedIn = branchId;
    final result = openResult ?? const Right('opened-shift');
    result.fold((_) {}, (id) => shiftId = id);
    return result;
  }
}

/// An [ActiveBranchResolver] that answers a fixed branch.
class FakeBranchResolver extends Fake implements ActiveBranchResolver {
  FakeBranchResolver([this.branchId = 'branch-1']);

  String? branchId;

  @override
  Future<String?> resolve() async => branchId;
}

/// Remembers the last payment source in memory.
class MemoryPaymentSourceStore implements LastPaymentSourceStore {
  MemoryPaymentSourceStore([this.value]);

  PaymentSource? value;

  @override
  PaymentSource? read() => value;

  @override
  Future<void> write(PaymentSource source) async => value = source;
}

/// A [KhataEvents] that counts the changes it was told about.
class CountingKhataEvents extends KhataEvents {
  int notified = 0;

  @override
  void notifyChanged() {
    notified++;
    super.notifyChanged();
  }
}
