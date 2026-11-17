// Real purchases stack over a real Dio, next to the products stack.
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_form_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import 'live_backend.dart';
import 'products_rig.dart';

class _Auth extends Fake implements AuthLocalDataSource {
  _Auth(this.branchId);
  final String branchId;
  @override
  Future<UserModel?> getCachedUser() async =>
      UserModel(id: 'u', name: 'Owner', branchId: branchId, role: 'owner');
}

class PurchasesRig {
  PurchasesRig(this.tenant, this.products) {
    final client = tenant.client;
    final suppliers = SuppliersRepositoryImpl(
      remoteDataSource: SuppliersRemoteDataSourceImpl(client),
      errorHandler: const ErrorHandler(),
    );
    final getProductById = GetProductByIdUseCase(products.repo);
    final repo = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(client),
      errorHandler: const ErrorHandler(),
      lineEnricher: PurchaseOrderLineEnricher(getProductById),
    );
    final auth = _Auth(tenant.branchId);
    form = PurchaseOrderFormCubit(
      authLocalDataSource: auth,
      getSuppliersUseCase: GetSuppliersUseCase(suppliers),
      getProductsUseCase: GetProductsUseCase(products.repo),
      getProductByIdUseCase: getProductById,
      createPurchaseOrderUseCase: CreatePurchaseOrderUseCase(repo),
      updatePurchaseOrderStatusUseCase: UpdatePurchaseOrderStatusUseCase(repo),
    );
    list = PurchaseOrdersListCubit(
      getPurchaseOrdersUseCase: GetPurchaseOrdersUseCase(repo),
      getSuppliersUseCase: GetSuppliersUseCase(suppliers),
    );
    detail = PurchaseOrderDetailCubit(
      getPurchaseOrderUseCase: GetPurchaseOrderUseCase(repo),
      updatePurchaseOrderStatusUseCase: UpdatePurchaseOrderStatusUseCase(repo),
    );
    receipt = GoodsReceiptCubit(
      authLocalDataSource: auth,
      getPurchaseOrderUseCase: GetPurchaseOrderUseCase(repo),
      createPurchaseReceiptUseCase: CreatePurchaseReceiptUseCase(repo),
      getProductByIdUseCase: getProductById,
    );
  }

  final LiveTenant tenant;
  final ProductsRig products;
  late final PurchaseOrderFormCubit form;
  late final PurchaseOrdersListCubit list;
  late final PurchaseOrderDetailCubit detail;
  late final GoodsReceiptCubit receipt;

  Future<void> dispose() async {
    await form.close();
    await list.close();
    await detail.close();
    await receipt.close();
  }
}
