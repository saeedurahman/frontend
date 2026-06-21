import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';

abstract class BranchesRepository {
  Future<Either<Failure, List<BranchModel>>> getBranches();

  Future<Either<Failure, BranchModel>> getBranchById(String branchId);
}
