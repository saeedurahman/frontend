import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Signs the user out, unless that would destroy unsent work.
///
/// Returns [PendingWorkFailure] (and changes nothing) while the
/// [PendingWorkGuard] reports unsynced, failed or parked work. [force] signs
/// out anyway (the owner confirmed they accept losing it).
@injectable
class LogoutUseCase {
  LogoutUseCase(this._repository, this._pendingWork);

  final AuthRepository _repository;
  final PendingWorkGuard _pendingWork;

  Future<Either<Failure, void>> call({bool force = false}) async {
    if (!force) {
      final pending = await _pendingWork.summary();
      if (pending.total > 0) {
        return Left(PendingWorkFailure(
          pending.total,
          unsynced: pending.unsynced,
          failed: pending.failed,
          held: pending.held,
        ));
      }
    }
    return _repository.logout();
  }
}
