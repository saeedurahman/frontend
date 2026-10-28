import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/branches/domain/repositories/branches_repository.dart';
import 'package:frantend/features/branches/domain/usecases/branches_usecases.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';

import '../helpers/session_fixtures.dart';

BranchModel branch(String id, {bool isDefault = false}) => BranchModel(
      id: id,
      businessId: 'biz',
      name: 'Branch $id',
      isDefault: isDefault,
    );

class _FakeBranches implements BranchesRepository {
  _FakeBranches(this.all);

  final List<BranchModel> all;

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() async => Right(all);

  @override
  Future<Either<Failure, BranchModel>> getBranchById(String branchId) async =>
      Right(all.firstWhere((b) => b.id == branchId));
}

class _FakeAuthLocal implements AuthLocalDataSource {
  _FakeAuthLocal(this.user);

  final UserModel user;

  @override
  Future<UserModel?> getCachedUser() async => user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final all = [branch('b1', isDefault: true), branch('b2'), branch('b3')];

  group('allowedBranches', () {
    test('no restriction -> every branch', () {
      expect(BranchSelectorCubit.allowedBranches(all, const []), all);
    });

    test('restriction -> only the named branches', () {
      final allowed = BranchSelectorCubit.allowedBranches(all, ['b2', 'b3']);
      expect(allowed.map((b) => b.id), ['b2', 'b3']);
    });
  });

  group('canListBranches', () {
    test('owner lists all; cashier is fixed to its branch', () {
      expect(BranchSelectorCubit.canListBranches(ownerAccess, const []), isTrue);
      expect(BranchSelectorCubit.canListBranches(cashierAccess, const []),
          isFalse);
    });

    test('a role with branch + report rights lists all (manager)', () {
      expect(BranchSelectorCubit.canListBranches(managerAccess, const []),
          isTrue);
    });

    test('a restriction to one branch means no switching', () {
      expect(BranchSelectorCubit.canListBranches(managerAccess, ['b1']),
          isFalse);
      expect(BranchSelectorCubit.canListBranches(managerAccess, ['b1', 'b2']),
          isTrue);
    });

    test('no branches.view -> fixed branch', () {
      const noView = UserAccess(role: 'x', permissionKeys: [Perm.reportsView]);
      expect(BranchSelectorCubit.canListBranches(noView, const []), isFalse);
    });
  });

  group('selector', () {
    BranchSelectorCubit build(UserModel user) {
      final cubit = BranchSelectorCubit(
        BranchesUseCases(_FakeBranches(all)),
        _FakeAuthLocal(user),
      );
      return cubit;
    }

    test('limited user only sees allowed branches', () async {
      const user = UserModel(
        id: 'u',
        name: 'n',
        role: 'manager',
        branchId: 'b2',
        permissionKeys: managerKeys,
      );
      final cubit = build(user)
        ..scopeProvider = () => (
              access: const UserAccess(
                role: 'manager',
                permissionKeys: managerKeys,
              ),
              branchIds: ['b2', 'b3'],
            );
      await cubit.startSession();

      expect(cubit.state.availableBranches.map((b) => b.id), ['b2', 'b3']);
      expect(cubit.state.selectedBranchId, 'b2');
      expect(cubit.state.canSwitch, isTrue);

      // A foreign branch cannot be selected.
      cubit.selectBranch('b1');
      expect(cubit.state.selectedBranchId, 'b2');
      cubit.selectBranch('b3');
      expect(cubit.state.selectedBranchId, 'b3');
      await cubit.close();
    });

    test('unrestricted owner sees every branch', () async {
      const user = UserModel(id: 'u', name: 'n', role: 'owner', branchId: 'b1');
      final cubit = build(user);
      await cubit.startSession();
      expect(cubit.state.availableBranches, hasLength(3));
      await cubit.close();
    });

    test('403 for the selected branch drops it and tells the user once',
        () async {
      const user = UserModel(id: 'u', name: 'n', role: 'owner', branchId: 'b1');
      final cubit = build(user);
      await cubit.startSession();
      expect(cubit.state.selectedBranchId, 'b1');

      cubit.handleForbiddenBranch('b1');
      expect(cubit.state.selectedBranchId, 'b2');
      expect(cubit.state.availableBranches.map((b) => b.id), ['b2', 'b3']);
      expect(cubit.state.noticeSeq, 1);
      expect(cubit.state.notice, contains("don't have access"));

      // A 403 for some other branch id changes nothing.
      cubit.handleForbiddenBranch('b9');
      expect(cubit.state.noticeSeq, 1);
      await cubit.close();
    });
  });
}
