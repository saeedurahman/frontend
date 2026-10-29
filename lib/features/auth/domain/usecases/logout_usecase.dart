import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

/// Signs the user out, unless that would destroy unsent work.
///
/// Returns [PendingWorkFailure] (and changes nothing) while the
/// [PendingWorkGuard] reports local changes the server has not received.
@injectable
class LogoutUseCase {
  LogoutUseCase(this._repository, this._pendingWork);

  final AuthRepository _repository;
  final PendingWorkGuard _pendingWork;

  Future<Either<Failure, void>> call() async {
    final pending = await _pendingWork.pendingCount();
    if (pending > 0) return Left(PendingWorkFailure(pending));
    return _repository.logout();
  }
}
