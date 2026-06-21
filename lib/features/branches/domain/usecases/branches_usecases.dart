import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/branches/domain/repositories/branches_repository.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BranchesUseCases {
  BranchesUseCases(this._repository);

  final BranchesRepository _repository;

  Future<Either<Failure, List<BranchModel>>> getBranches() =>
      _repository.getBranches();

  Future<Either<Failure, BranchModel>> getBranchById(String branchId) =>
      _repository.getBranchById(branchId);
}
