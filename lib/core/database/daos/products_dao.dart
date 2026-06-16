import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/tables/products_table.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [ProductsTable])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Future<List<ProductsTableData>> getAllProducts() =>
      select(productsTable).get();

  Future<ProductsTableData?> getProductById(String id) =>
      (select(productsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertProduct(ProductsTableCompanion product) =>
      into(productsTable).insertOnConflictUpdate(product);

  Future<void> upsertProducts(List<ProductsTableCompanion> products) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(productsTable, products);
    });
  }

  Future<void> deleteProduct(String id) =>
      (delete(productsTable)..where((t) => t.id.equals(id))).go();

  Stream<List<ProductsTableData>> watchAllProducts() =>
      select(productsTable).watch();
}
