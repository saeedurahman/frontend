import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';

import '../sync/sync_rig.dart';

/// The signed-in owner: allowed everything, working in [kBranch].
class OwnerAuth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => const UserModel(
        id: kUser,
        name: 'Owner',
        role: 'owner',
        roles: ['owner'],
        businessId: kBusiness,
        branchId: kBranch,
      );
}

class _Branch extends Fake implements BranchSelectorCubit {
  @override
  BranchSelectorState get state => const BranchSelectorState(
        isInitialized: true,
        selectedBranchId: kBranch,
      );

  @override
  Stream<BranchSelectorState> get stream => const Stream.empty();
}

/// Cubits that ask the service locator for the active branch get [kBranch].
void useActiveBranch() {
  setUp(() {
    if (sl.isRegistered<BranchSelectorCubit>()) {
      sl.unregister<BranchSelectorCubit>();
    }
    sl.registerSingleton<BranchSelectorCubit>(_Branch());
  });
  tearDown(() => sl.unregister<BranchSelectorCubit>());
}

/// A product cache that keeps nothing.
class NoProductCache extends Fake implements ProductsLocalDataSource {
  @override
  Future<void> cacheProducts(List<ProductListItemModel> products) async {}
  @override
  Future<List<ProductListItemModel>> getCachedProducts() async => const [];
  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {}
  @override
  Future<List<CategoryModel>> getCachedCategories() async => const [];
  @override
  Future<void> cacheBrands(List<BrandModel> brands) async {}
  @override
  Future<List<BrandModel>> getCachedBrands() async => const [];
  @override
  Future<void> cacheUnits(List<UnitModel> units) async {}
  @override
  Future<List<UnitModel>> getCachedUnits() async => const [];
}
